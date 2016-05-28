//+------------------------------------------------------------------+
//|                                            CandleManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "CandleBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCandleManagerBase : public CArrayObj
  {
protected:
public:
                     CCandleManagerBase(void);
                    ~CCandleManagerBase(void);
                    virtual bool IsNewBar(string symbol,int timeframe);
                    virtual JCandle* Get(string symbol,int timeframe);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleManagerBase::CCandleManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleManagerBase::~CCandleManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::IsNewBar(string symbol,int timeframe)
  {
   JCandle *candle = Get(symbol,timeframe);
   return candle.IsNewCandle();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCandle *CCandleManagerBase::Get(string symbol,int timeframe)
  {
   for(int i=0;i<Total();i++)
     {
      JCandle *candle=At(i);
      if(StringCompare(symbol,candle.SymbolName())==0 && timeframe==candle.TimeFrame())
        return candle;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\candle\CandleManager.mqh"
#else
#include "..\..\mql4\candle\CandleManager.mqh"
#endif
//+------------------------------------------------------------------+
