//+------------------------------------------------------------------+
//|                                                   CandleBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\Symbol\SymbolManagerBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCandleBase : public CObject
  {
protected:
   bool              m_new;
   bool              m_wait_for_new;
   bool              m_trade_processed;
   int               m_period;
   bool              m_active;
   MqlRates          m_last;
   CSymbolInfo      *m_symbol;
   CObject          *m_container;
public:
                     CCandleBase(void);
                    ~CCandleBase(void);
   virtual bool      Init(CSymbolInfo*,const int);
   virtual void      SetContainer(CObject *container) {m_container=container;}
   //--- setters and getters
   bool              Active(){return m_active;}
   void              Active(bool active){m_active=active;}
   datetime          LastTime(void) const {return m_last.time;}
   double            LastOpen(void) const {return m_last.open;}
   double            LastHigh(void) const {return m_last.high;}
   double            LastLow(void) const {return m_last.low;}
   double            LastClose(void) const {return m_last.close;}
   string            SymbolName(void) const {return m_symbol.Name();}
   int               Timeframe(void) const {return m_period;}
   //--- processing
   virtual bool      TradeProcessed(void) const {return m_trade_processed;}
   virtual void      TradeProcessed(bool processed) {m_trade_processed=processed;}
   virtual void      Check(void);
   virtual bool      IsNewCandle(void) {return m_new;}
   virtual bool      Compare(MqlRates &) const;
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);
  };
//+------------------------------------------------------------------+
CCandleBase::CCandleBase(void) : m_new(false),
                                 m_wait_for_new(false),
                                 m_trade_processed(false),
                                 m_period(0),
                                 m_active(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleBase::~CCandleBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Init(CSymbolInfo *symbol,const int timeframe)
  {
   m_symbol = symbol;
   m_period = timeframe;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CCandleBase::Check(void)
  {
   if(!Active())
      return;
   m_new=false;
   if(m_symbol!=NULL)
     {
      MqlRates rates[];
      if(CopyRates(m_symbol.Name(),(ENUM_TIMEFRAMES)m_period,1,1,rates)==-1)
         return;
      if(Compare(rates[0]))
        {
         m_new=true;
         m_trade_processed=false;
         m_last=rates[0];
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Compare(MqlRates &rates) const
  {
   return ((m_wait_for_new && m_last.time==0) ||
            m_last.time!=rates.time ||
           (m_last.open/m_symbol.TickSize())!=(rates.open/m_symbol.TickSize()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Save(const int handle)
  {
//ADT::WriteBool(handle,m_trade_processed);
//ADT::WriteStruct(handle,m_last);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Load(const int handle)
  {
//ADT::ReadBool(handle,m_trade_processed);
//ADT::ReadStruct(handle,m_last);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Candle\Candle.mqh"
#else
#include "..\..\MQL4\Candle\Candle.mqh"
#endif
//+------------------------------------------------------------------+
