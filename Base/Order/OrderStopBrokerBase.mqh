//+------------------------------------------------------------------+
//|                                          OrderStopBrokerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "OrderStopBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBrokerBase : public COrderStop
  {
public:
                     COrderStopBrokerBase(void);
                    ~COrderStopBrokerBase(void);
   virtual bool      Update(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBrokerBase::COrderStopBrokerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBrokerBase::~COrderStopBrokerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBrokerBase::Update(void)
  {
   if (!CheckPointer(m_stop))
      return true;
   if(m_order.IsClosed() || m_order.IsSuspended())
      return true;
   bool result=false;
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
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStopBroker.mqh"
#else
#include "..\..\MQL4\Order\OrderStopBroker.mqh"
#endif
//+------------------------------------------------------------------+
