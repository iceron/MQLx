//+------------------------------------------------------------------+
//|                                             OrderStopPending.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopPending : public COrderStopPendingBase
  {
public:
                     COrderStopPending(void);
                    ~COrderStopPending(void);
   virtual void      Check(double &);
protected:
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPending::COrderStopPending(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPending::~COrderStopPending(void)
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopPending::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      if(!m_stop.Main())
        {
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
            delete_sl=DeleteStopLoss();
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
            delete_tp=DeleteTakeProfit();
        }
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(m_stop.Main())
     {
      if(OrderSelect((int)m_order.Ticket(),SELECT_BY_TICKET))
        {
         if(OrderCloseTime()>0)
           {
            m_stoploss_closed=true;
            m_takeprofit_closed=true;
           }
        }
     }
   if(CheckPointer(m_objsl))
      m_stoploss_closed=m_stop.CheckStopOrder(volume,m_stoploss_ticket);
   if(CheckPointer(m_objtp))
      m_takeprofit_closed=m_stop.CheckStopOrder(volume,m_takeprofit_ticket);
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
      DeleteStopLines();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPending::ModifyStopLoss(const double stoploss)
  {
   bool modify=m_stop.OrderModify(m_stoploss_ticket,stoploss);
   if(modify)
      MoveStopLoss(stoploss);
   return modify;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPending::ModifyTakeProfit(const double takeprofit)
  {
   bool modify=m_stop.OrderModify(m_takeprofit_ticket,takeprofit);
   if(modify)
      MoveTakeProfit(takeprofit);
   return modify;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPending::ModifyStops(const double stoploss,const double takeprofit)
  {
   return ModifyStopLoss(stoploss) && ModifyTakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
