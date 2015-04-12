//+------------------------------------------------------------------+
//|                                                   CandleBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Files\FileBin.mqh>
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
   JEvents          *m_events;
public:
                     JCandleBase(void);
                    ~JCandleBase(void);
   virtual bool      Init(CSymbolInfo *symbol,JEvents *events);
   virtual datetime  LastTime() const {return(m_last.time);}
   virtual double    LastOpen() const {return(m_last.open);}
   virtual double    LastHigh() const {return(m_last.high);}
   virtual double    LastLow() const {return(m_last.low);}
   virtual double    LastClose() const {return(m_last.close);}
   virtual bool      TradeProcessed() const {return(m_trade_processed);}
   virtual void      TradeProcessed(bool processed) {m_trade_processed=processed;}
   virtual bool      IsNewCandle(const ENUM_TIMEFRAMES period);
   virtual bool      Compare(MqlRates &rates) const;
   //---recovery
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
protected:
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
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
bool JCandleBase::Init(CSymbolInfo *symbol,JEvents *events)
  {
   m_symbol = symbol;
   m_events = events;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::IsNewCandle(const ENUM_TIMEFRAMES period)
  {
   bool result=false;
   if(m_symbol!=NULL)
     {
      MqlRates rates[];
      if(CopyRates(m_symbol.Name(),period,1,1,rates)==-1)
         return(false);
      if(m_wait_for_new && m_last.time==0)
         m_last=rates[0];
      else if(Compare(rates[0]))
        {
         result=true;
         m_trade_processed=false;
         m_last=rates[0];
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_CANDLE);
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
//|                                                                  |
//+------------------------------------------------------------------+
void JCandleBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JCandleBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Save(const int handle)
  {
   ADT::WriteBool(handle,m_trade_processed);
   ADT::WriteStruct(handle,m_last);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Load(const int handle)
  {
   ADT::ReadBool(handle,m_trade_processed);
   ADT::ReadStruct(handle,m_last);
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\candle\Candle.mqh"
#else
#include "..\..\mql4\candle\Candle.mqh"
#endif
//+------------------------------------------------------------------+
