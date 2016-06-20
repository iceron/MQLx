//+------------------------------------------------------------------+
//|                                              OrderStopBroker.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBroker : public COrderStopBrokerBase
  {
public:
                     COrderStopBroker(void);
                    ~COrderStopBroker(void);
   virtual void      Check(double &);
protected:
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   virtual bool      UpdateOrderStop(const double,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBroker::COrderStopBroker(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBroker::~COrderStopBroker(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBroker::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stoploss_ticket>0 && !m_stoploss_closed)
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
           {
            m_stoploss_closed=true;
            delete_sl=DeleteStopLoss();
           }
      if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
           {
            m_takeprofit_closed=true;
            delete_tp=DeleteTakeProfit();
           }
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(CheckPointer(m_objsl) && !m_stoploss_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_stoploss_ticket))
         m_stoploss_closed=true;
     }
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC && !m_takeprofit_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_takeprofit_ticket))
         m_takeprofit_closed=true;
     }
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      if(m_stop.OCO())
        {
         if(m_stoploss_closed && !m_takeprofit_closed)
           {
            if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
               m_takeprofit_closed=true;
           }

         if(m_takeprofit_closed && !m_stoploss_closed)
           {
            if(m_stop.DeleteStopOrder(m_stoploss_ticket))
               m_stoploss_closed=true;
           }
        }
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if(((m_stoploss_closed || !CheckPointer(m_objsl)) && (m_takeprofit_closed || !CheckPointer(m_objtp))) || volume<=0)
     {
      DeleteStopLines();
      if(m_stop.Main())
         m_order.IsSuspended(true);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyStopLoss(const double stoploss)
  {
   return MoveStopLoss(stoploss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyTakeProfit(const double takeprofit)
  {
   return MoveTakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   bool modify_sl=true,modify_tp=true;
   if(stoploss>0)
      modify_sl = m_stop.MoveStopLoss(StopLossTicket(),stoploss);
   if(takeprofit>0)
      modify_tp = m_stop.MoveTakeProfit(TakeProfitTicket(),takeprofit);
   return modify_sl && modify_tp;
  }
//+------------------------------------------------------------------+
