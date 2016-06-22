//+------------------------------------------------------------------+
//|                                            CandleManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "CandleBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCandleManagerBase : public CArrayObj
  {
protected:
   bool              m_active;
   CSymbolManager   *m_symbol_man;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CCandleManagerBase(void);
                    ~CCandleManagerBase(void);
   virtual bool      Init(CSymbolManager*,CEventAggregator*);
   virtual bool      Add(const string,const int);
   virtual CObject*  GetContainer(void) {return m_container;}
   virtual void      SetContainer(CObject *container) {m_container=container;}
   bool              Active(){return m_active;}
   void              Active(bool active){m_active=active;}
   virtual void      Check(void) const;
   virtual bool      IsNewCandle(const string,const int) const;
   virtual CCandle *Get(const string,const int) const;
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
CCandleManagerBase::~CCandleManagerBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::Init(CSymbolManager *symbol_man,CEventAggregator *event_man=NULL)
  {
   m_symbol_man=symbol_man;
   m_event_man=event_man;
   for (int i=0;i<Total();i++)
   {
      CCandle *candle = At(i);
      if (CheckPointer(candle))
         candle.Init(m_event_man);
   }
   return CheckPointer(m_symbol_man);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::Add(const string symbol,const int period)
  {
   if (CheckPointer(m_symbol_man))
     {
      CSymbolInfo *instrument=m_symbol_man.Get(symbol);
      if (CheckPointer(instrument))
        {
         instrument.Name(symbol);
         instrument.Refresh();
         CCandle *candle=new CCandle();
         candle.Init(instrument,period);
         return Add(instrument);
        }
     }
   return false;
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
   if (CheckPointer(candle))
      return candle.IsNewCandle();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCandleManagerBase::TradeProcessed(const string symbol,const int timeframe) const
  {
   CCandle *candle=Get(symbol,timeframe);
   if (CheckPointer(candle))
      return candle.TradeProcessed();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CCandleManagerBase::TradeProcessed(const string symbol,const int timeframe,const bool processed) const
  {
   CCandle *candle=Get(symbol,timeframe);
   if (CheckPointer(candle))
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
      if (CheckPointer(candle))
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
