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
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   virtual bool      UpdateOrderStop(const double,const double)
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
      delete_sl=DeleteStopLoss();
      delete_tp=DeleteTakeProfit();
      if(delete_sl && delete_tp)
         DeleteEntry();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyStops(const double stoploss,const double takeprofit)
  {
   if(m_stop.Move(m_order.Ticket(),stoploss,takeprofit))
      return MoveStopLoss(stoploss) && MoveTakeProfit(takeprofit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyStopLoss(const double stoploss)
  {
   if(m_stop.MoveStopLoss(m_order.Ticket(),stoploss))
      return MoveStopLoss(stoploss);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyTakeProfit(const double takeprofit)
  {
   if(m_stop.MoveTakeProfit(m_order.Ticket(),takeprofit))
      return MoveTakeProfit(takeprofit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   bool modify=true,modify_sl=true,modify_tp=true;
   if (stoploss>0 && takeprofit>0)
      modify = m_stop.Move(m_order.Ticket(),stoploss,takeprofit);
   if(stoploss>0)
      modify_sl = m_stop.MoveStopLoss(m_order.Ticket(),stoploss);
   if(takeprofit>0)
      modify_tp = m_stop.MoveTakeProfit(m_order.Ticket(),takeprofit);
   return modify && modify_sl && modify_tp;
  }
//+------------------------------------------------------------------+
