//+------------------------------------------------------------------+
//|                                                  SignalsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "SignalBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSignalsBase : public CArrayObj
  {
protected:
   bool              m_active;
   ENUM_CMD          m_signal_open;
   ENUM_CMD          m_signal_close;
   ENUM_CMD          m_signal_open_last;
   ENUM_CMD          m_signal_close_last;
   bool              m_invert;
   bool              m_new_signal;
   CSymbolManager   *m_symbol_man;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CSignalsBase(void);
                    ~CSignalsBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_SIGNALS);}
   virtual bool      Init(CSymbolManager*,CEventAggregator*);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   bool              Invert(void);
   void              Invert(const bool);
   bool              NewSignal(void);
   void              NewSignal(const bool);
   virtual bool      Validate(void);
   virtual void      Check(void);
   virtual bool      CheckOpenVoid(void);
   virtual bool      CheckOpenNeutral(void);
   virtual bool      CheckOpenLong(void);
   virtual bool      CheckOpenShort(void);
   virtual bool      CheckCloseVoid(void);
   virtual bool      CheckCloseNeutral(void);
   virtual bool      CheckCloseLong(void);
   virtual bool      CheckCloseShort(void);
   virtual bool      CheckOpenVoidLast(void);
   virtual bool      CheckOpenNeutralLast(void);
   virtual bool      CheckOpenLongLast(void);
   virtual bool      CheckOpenShortLast(void);
   virtual bool      CheckCloseVoidLast(void);
   virtual bool      CheckCloseNeutralLast(void);
   virtual bool      CheckCloseLongLast(void);
   virtual bool      CheckCloseShortLast(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalsBase::CSignalsBase(void) : m_active(true),
                                   m_signal_open(CMD_NEUTRAL),
                                   m_signal_close(CMD_NEUTRAL),
                                   m_signal_open_last(CMD_NEUTRAL),
                                   m_signal_close_last(CMD_NEUTRAL),
                                   m_new_signal(true),
                                   m_invert(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalsBase::~CSignalsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::Init(CSymbolManager *symbol_man,CEventAggregator *aggregator)
  {
   m_symbol_man= symbol_man;
   m_event_man = aggregator;
   if(!CheckPointer(m_symbol_man))
      return false;
   for(int i=0;i<Total();i++)
     {
      CSignal *signal=At(i);
      if(!signal.Init(symbol_man,aggregator))
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalsBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CSignalsBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::Validate(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalsBase::Check(void)
  {
   if(m_signal_open>0)
      m_signal_open_last=m_signal_open;
   if(m_signal_close>0)
      m_signal_close_last=m_signal_close;
   m_signal_open=CMD_NEUTRAL;
   m_signal_close=CMD_NEUTRAL;
   for(int i=0;i<Total();i++)
     {
      CSignal *signal=At(i);      
      signal.Check();
      if(signal.Entry())
        {
         if(m_signal_open>CMD_VOID)
           {
            ENUM_CMD signal_open=signal.SignalOpen();
            if(m_signal_open==CMD_NEUTRAL)
              {    
               m_signal_open=signal_open;
              }
            else if(m_signal_open!=signal_open)
              {               
               m_signal_open=CMD_VOID;
              }
           }
        }
      if(signal.Exit())
        {
         if(m_signal_close>CMD_VOID)
           {
            ENUM_CMD signal_close=signal.SignalClose();
            if(m_signal_close==CMD_NEUTRAL)
              {
               m_signal_close=signal_close;
              }
            else if(m_signal_close!=signal_close)
              {
               m_signal_close=CMD_VOID;
              }
           }
        }
     }
   if(m_invert)
     {
      CSignal::SignalInvert(m_signal_open);
      CSignal::SignalInvert(m_signal_close);
     }
   if(m_new_signal)
     {
      if(m_signal_open==m_signal_open_last)
         m_signal_open = CMD_NEUTRAL;
      if(m_signal_close==m_signal_close_last)
         m_signal_close= CMD_NEUTRAL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckOpenVoid(void)
  {
   return m_signal_open==CMD_VOID;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckOpenNeutral(void)
  {
   return m_signal_open==CMD_NEUTRAL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckOpenLong(void)
  {
   return m_signal_open==CMD_LONG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckOpenShort(void)
  {
   return m_signal_open==CMD_SHORT;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckCloseVoid(void)
  {
   return m_signal_close==CMD_VOID;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckCloseNeutral(void)
  {
   return m_signal_close==CMD_NEUTRAL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckCloseLong(void)
  {
   return m_signal_close==CMD_SHORT;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckCloseShort(void)
  {
   return m_signal_close==CMD_LONG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::Invert(void)
  {
   return m_invert;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalsBase::NewSignal(const bool value)
  {
   m_new_signal=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::NewSignal(void)
  {
   return m_new_signal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalsBase::Invert(const bool value)
  {
   m_invert=value;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Signal\Signals.mqh"
#else
#include "..\..\MQL4\Signal\Signals.mqh"
#endif
//+------------------------------------------------------------------+
