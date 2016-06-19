//+------------------------------------------------------------------+
//|                                         OrderStopVirtualBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "OrderStopBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopVirtualBase : public COrderStop
  {
public:
                     COrderStopVirtualBase(void);
                    ~COrderStopVirtualBase(void);
   virtual bool      Update(void);
   virtual bool      UpdateOrderStop(const double,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopVirtualBase::COrderStopVirtualBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopVirtualBase::~COrderStopVirtualBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopVirtualBase::Update(void)
  {
   if (!CheckPointer(m_stop))
      return true;
   if(m_order.IsClosed() || m_order.IsSuspended())
      return false;
   double stoploss=0.0,takeprofit=0.0;
   bool result=false;
   bool dragged=false;
   if (CheckPointer(m_objsl))
     {
      double sl_line=m_objsl.GetPrice();
      if(sl_line!=StopLoss())
         dragged=true;
     }
   if (CheckPointer(m_objtp))
     {
      double tp_line=m_objtp.GetPrice();
      if(tp_line!=TakeProfit())
         dragged=true;
     }   
   result=UpdateOrderStop(stoploss,takeprofit);
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopVirtualBase::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   if(stoploss>0)
      StopLoss(stoploss);
   if(takeprofit>0)
      TakeProfit(takeprofit);
   return stoploss>0||takeprofit>0;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStopVirtual.mqh"
#else
#include "..\..\MQL4\Order\OrderStopVirtual.mqh"
#endif
//+------------------------------------------------------------------+
