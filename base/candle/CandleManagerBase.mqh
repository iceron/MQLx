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
   bool              m_active;
public:
                     CCandleManagerBase(void);
                    ~CCandleManagerBase(void);
   bool              Active(){return m_active;}
   void              Active(bool active){m_active = active;}                    
   virtual void      Check(void) const;
   virtual bool      IsNewCandle(const string,const int) const;
   virtual CCandle  *Get(const string,const int) const;
   virtual bool      TradeProcessed(const string,const int) const;
   virtual void      TradeProcessed(const string,const int,const bool) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleManagerBase::CCandleManagerBase(void) : m_active(true)
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
void CCandleManagerBase::Check(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CCandle *candle=At(i);
      candle.Check();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::IsNewCandle(const string symbol,const int timeframe) const
  {
   CCandle *candle=Get(symbol,timeframe);
   if(candle!=NULL)
      return candle.IsNewCandle();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::TradeProcessed(const string symbol,const int timeframe) const
  {
   CCandle *candle=Get(symbol,timeframe);
   if(candle!=NULL)
      return candle.TradeProcessed();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CCandleManagerBase::TradeProcessed(const string symbol,const int timeframe,const bool processed) const
  {
   CCandle *candle=Get(symbol,timeframe);
   if(candle!=NULL)
      candle.TradeProcessed(processed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandle *CCandleManagerBase::Get(const string symbol,const int timeframe) const
  {
   for(int i=0;i<Total();i++)
     {
      CCandle *candle=At(i);
      if(candle!=NULL)
         if(StringCompare(symbol,candle.SymbolName())==0 && timeframe==candle.Timeframe())
            return candle;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Candle\CandleManager.mqh"
#else
#include "..\..\MQL4\Candle\CandleManager.mqh"
#endif
//+------------------------------------------------------------------+
