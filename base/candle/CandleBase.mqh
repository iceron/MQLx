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
   bool              m_wait_for_new;
   bool              m_trade_processed;
   MqlRates          m_last;
   CSymbolInfo      *m_symbol;
public:
                     JCandleBase(void);
                    ~JCandleBase(void);
   virtual double    LastTime() const {return(m_last.time);}
   virtual double    LastOpen() const {return(m_last.open);}
   virtual double    LastHigh() const {return(m_last.high);}
   virtual double    LastLow() const {return(m_last.low);}
   virtual double    LastClose() const {return(m_last.close);}
   virtual bool      TradeProcessed() const {return(m_trade_processed);}
   virtual void      TradeProcessed(bool processed) {m_trade_processed=processed;}
   virtual bool      IsNewCandle(CSymbolInfo *symbol,const ENUM_TIMEFRAMES period);
   virtual bool      Compare(MqlRates &rates) const;
  };
//+------------------------------------------------------------------+
JCandleBase::JCandleBase(void) : m_wait_for_new(false),
                                 m_trade_processed(false)
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
   bool result=false;
   if(symbol!=NULL)
     {
      if(CheckPointer(m_symbol)==POINTER_INVALID)
         m_symbol=symbol;
      MqlRates rates[];
      if(CopyRates(symbol.Name(),period,1,1,rates)==-1)
         return(false);
      if(m_wait_for_new && m_last.time==0)
         m_last=rates[0];
      else if(Compare(rates[0]))
        {         
         result=true;
         m_trade_processed=false;
         m_last=rates[0];
        }
     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Compare(MqlRates &rates) const
  {
   return(m_last.time==0 || m_last.time!=rates.time ||
          (m_last.close/m_symbol.TickSize())!=(rates.close/m_symbol.TickSize()) || 
          (m_last.open/m_symbol.TickSize())!=(rates.open/m_symbol.TickSize()));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\candle\Candle.mqh"
#else
#include "..\..\mql4\candle\Candle.mqh"
#endif
//+------------------------------------------------------------------+
