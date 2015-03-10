//+------------------------------------------------------------------+
//|                                                   CandleBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
#include "..\lib\SymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JCandleBase : public CObject
  {
protected:
   MqlRates          m_last;
   bool              m_wait_for_new;
public:
                     JCandleBase(void);
                    ~JCandleBase(void);
   virtual bool      IsNewCandle(CSymbolInfo *symbol,const ENUM_TIMEFRAMES period);
   virtual bool      Compare(MqlRates &rates);
  };
//+------------------------------------------------------------------+
JCandleBase::JCandleBase(void) : m_wait_for_new(false)
  {
   m_last.time = 0;
   m_last.open = 0;
   m_last.high = 0;
   m_last.low=0;
   m_last.close=0;
   m_last.tick_volume=0;
   m_last.spread=0;
   m_last.real_volume=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCandleBase::~JCandleBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::IsNewCandle(CSymbolInfo *symbol,const ENUM_TIMEFRAMES period)
  {
   MqlRates rates[];
   ResetLastError();
   if(CopyRates(symbol.Name(),period,0,1,rates)==-1)
      return(false);
   bool result=false;
   rates[0].open /= symbol.TickSize();
   if(m_wait_for_new && m_last.time==0)
      m_last=rates[0];
   else if(Compare(rates[0]))
     {
      result= true;
      m_last=rates[0];
     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Compare(MqlRates &rates)
  {
   return(m_last.time==0 || (m_last.time!=rates.time && m_last.open!=rates.open));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\candle\Candle.mqh"
#else
#include "..\..\mql4\candle\Candle.mqh"
#endif
//+------------------------------------------------------------------+
