//+------------------------------------------------------------------+
//|                                             TradeManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeManagerBase : public CArrayObj
  {
protected:
public:
                     CTradeManagerBase(void);
                    ~CTradeManagerBase(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeManagerBase::CTradeManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeManagerBase::~CTradeManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\trademanager\TradeManager.mqh"
#else
#include "..\..\mql4\trademanager\TradeManager.mqh"
#endif
//+------------------------------------------------------------------+