//+------------------------------------------------------------------+
//|                                                   CandleBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
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
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CCandleBase(void);
                    ~CCandleBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_CANDLE);}
   virtual bool      Init(CSymbolInfo*,const int);
   virtual bool      Init(CEventAggregator*);
   CObject          *GetContainer(void);
   void              SetContainer(CObject*);
   //--- setters and getters
   void              Active(bool);
   bool              Active(void) const;
   datetime          LastTime(void) const;
   double            LastOpen(void) const;
   double            LastHigh(void) const;
   double            LastLow(void) const;
   double            LastClose(void) const;
   string            SymbolName(void) const;
   int               Timeframe(void) const;
   void              WaitForNew(bool);
   bool              WaitForNew(void) const;
   //--- processing
   virtual bool      TradeProcessed(void) const;
   virtual void      TradeProcessed(bool);
   virtual void      Check(void);
   virtual void      IsNewCandle(bool);
   virtual bool      IsNewCandle(void) const;
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
   return CheckPointer(m_symbol);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Init(CEventAggregator *event_man=NULL)
  {
   m_event_man=event_man;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CCandleBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleBase::Active(bool active)
  {
   m_active=active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CCandleBase::LastTime(void) const
  {
   return m_last.time;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CCandleBase::LastOpen(void) const
  {
   return m_last.open;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CCandleBase::LastHigh(void) const
  {
   return m_last.high;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CCandleBase::LastLow(void) const
  {
   return m_last.low;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CCandleBase::LastClose(void) const
  {
   return m_last.close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::TradeProcessed(void) const
  {
   return m_trade_processed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleBase::TradeProcessed(bool value)
  {
   m_trade_processed=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleBase::IsNewCandle(bool value)
  {
   m_new=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::IsNewCandle(void) const
  {
   return m_new;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleBase::WaitForNew(bool value)
  {
   m_wait_for_new=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::WaitForNew(void) const
  {
   return m_wait_for_new;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CCandleBase::SymbolName(void) const
  {
   if(CheckPointer(m_symbol))
      return m_symbol.Name();
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CCandleBase::Timeframe(void) const
  {
   return m_period;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCandleBase::Check(void)
  {
   if(!Active())
      return;
   IsNewCandle(false);
   MqlRates rates[];
   if(CopyRates(m_symbol.Name(),(ENUM_TIMEFRAMES)m_period,1,1,rates)==-1)
      return;
   if(Compare(rates[0]))
     {
      IsNewCandle(true);
      TradeProcessed(false);
      m_last=rates[0];
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Compare(MqlRates &rates) const
  {
   return (m_last.time!=rates.time ||
           (m_last.open/m_symbol.TickSize())!=(rates.open/m_symbol.TickSize()) || 
           (m_wait_for_new && m_last.time==0));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Save(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleBase::Load(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Candle\Candle.mqh"
#else
#include "..\..\MQL4\Candle\Candle.mqh"
#endif
//+------------------------------------------------------------------+
