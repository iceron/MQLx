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
   virtual void      Check(void);
   virtual bool      IsNewCandle(string symbol,int timeframe);
   virtual JCandle *Get(string symbol,int timeframe);
   virtual bool      TradeProcessed(string symbol,int timeframe);
   virtual void      TradeProcessed(string symbol,int timeframe,bool processed);
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
void CCandleManagerBase::Check(void)
  {
   for(int i=0;i<Total();i++)
     {
      JCandle *candle=At(i);
      candle.Check();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::IsNewCandle(string symbol,int timeframe)
  {
   JCandle *candle=Get(symbol,timeframe);
   if(candle!=NULL)
      return candle.IsNewCandle();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::TradeProcessed(string symbol,int timeframe)
  {
   JCandle *candle=Get(symbol,timeframe);
   if(candle!=NULL)
      return candle.TradeProcessed();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CCandleManagerBase::TradeProcessed(string symbol,int timeframe,bool processed)
  {
   JCandle *candle=Get(symbol,timeframe);
   if(candle!=NULL)
      candle.TradeProcessed(processed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCandle *CCandleManagerBase::Get(string symbol,int timeframe)
  {
   for(int i=0;i<Total();i++)
     {
      JCandle *candle=At(i);
      if(candle!=NULL)
         if(StringCompare(symbol,candle.SymbolName())==0 && timeframe==candle.Timeframe())
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
