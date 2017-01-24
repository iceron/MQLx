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
   virtual bool      Update(void);
protected:
   virtual bool      ModifyStops(const double,const double);
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
   if(stoploss>0 && takeprofit>0)
     {
      modify=m_stop.Move(m_order.Ticket(),stoploss,takeprofit);
      if(modify)
        {
         StopLoss(stoploss);
         TakeProfit(takeprofit);
        }
     }
   else if(stoploss>0)
     {
      modify_sl=m_stop.MoveStopLoss(m_order.Ticket(),stoploss);
      if(modify_sl)
         StopLoss(stoploss);
     }
   else if(takeprofit>0)
     {
      modify_tp=m_stop.MoveTakeProfit(m_order.Ticket(),takeprofit);
      if(modify_tp)
         TakeProfit(takeprofit);
     }
   return modify && modify_sl && modify_tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::Update(void)
  {
   if(!CheckPointer(m_stop))
      return true;
   if(m_order.IsClosed() || m_order.IsSuspended())
      return true;
   bool result=false;
   if(!CheckPointer(m_objsl) && !CheckPointer(m_objtp))
     {
      if(!OrderSelect((int)m_order.Ticket(),SELECT_BY_TICKET))
         return false;
      double ticksize=SymbolInfoDouble(OrderSymbol(),SYMBOL_TRADE_TICK_SIZE);
      if(MathAbs(OrderStopLoss()-StopLoss())>=ticksize)
         StopLoss(OrderStopLoss());
      if(MathAbs(OrderTakeProfit()-TakeProfit())>=ticksize)
         TakeProfit(OrderTakeProfit());
      return true;
     }
   double sl_line = 0;
   double tp_line = 0;
   if(CheckPointer(m_objsl))
      sl_line=m_objsl.GetPrice();
   if(CheckPointer(m_objtp))
      tp_line=m_objtp.GetPrice();
   if((sl_line>0 && sl_line!=StopLoss()) || (tp_line>0 && tp_line!=TakeProfit()))
     {
      Sleep(m_stop.Delay());
      double stoploss=0,takeprofit=0;
      if(CheckPointer(m_objsl))
         stoploss=m_objsl.GetPrice();
      if(CheckPointer(m_objtp))
         takeprofit=m_objtp.GetPrice();
      if(stoploss==StopLoss())
         stoploss= 0;
      if(takeprofit==TakeProfit())
         takeprofit= 0;
      result=UpdateOrderStop(stoploss,takeprofit);
     }
   return result;
  }
//+------------------------------------------------------------------+
