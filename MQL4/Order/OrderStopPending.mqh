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
   virtual bool      Update(void);
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
bool COrderStopPending::Update(void)
  {
   if(!CheckPointer(m_stop))
      return true;
   if(m_order.IsClosed() || m_order.IsSuspended())
      return true;
   bool result=false;
   if(!CheckPointer(m_objsl) && !CheckPointer(m_objtp))
     {
      double order_stoploss=0,order_takeprofit=0;
      double ticksize=SymbolInfoDouble(m_order.Symbol(),SYMBOL_TRADE_TICK_SIZE);
      if(OrderSelect((int)m_stoploss_ticket,SELECT_BY_TICKET))
        {
         order_stoploss=OrderGetDouble(ORDER_PRICE_OPEN);
         if(MathAbs(order_stoploss-StopLoss())>=ticksize)
            StopLoss(order_stoploss);
        }
      if(OrderSelect((int)m_takeprofit_ticket,SELECT_BY_TICKET))
        {
         order_takeprofit=OrderGetDouble(ORDER_PRICE_OPEN);
         if(MathAbs(order_takeprofit-TakeProfit())>=ticksize)
            TakeProfit(order_takeprofit);
        }
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
      result=UpdateOrderStop(stoploss,takeprofit);
     }
   return result;
  }
//+------------------------------------------------------------------+
