//+------------------------------------------------------------------+
//|                                          OrderStopBrokerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBrokerBase : public COrderStop
  {
public:
                     COrderStopBrokerBase();
                    ~COrderStopBrokerBase();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBrokerBase::COrderStopBrokerBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBrokerBase::~COrderStopBrokerBase()
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStopBroker.mqh"
#else
#include "..\..\MQL4\Order\OrderStopBroker.mqh"
#endif
//+------------------------------------------------------------------+