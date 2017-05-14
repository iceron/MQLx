//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Indicators\Indicators.mqh>
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CMD
  {
   CMD_VOID=-1,
   CMD_NEUTRAL,
   CMD_LONG,
   CMD_SHORT
  };
class CSignal;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSignalBase : public CObject
  {
protected:
   bool              m_active;
   bool              m_use_open;
   bool              m_use_close;
   ENUM_CMD          m_signal_open;
   ENUM_CMD          m_signal_close;
   bool              m_invert;
   CIndicators       m_indicators;
   CSymbolManager   *m_symbol_man;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CSignalBase(void);
                    ~CSignalBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_SIGNAL);}
   virtual bool      Init(CSymbolManager*,CEventAggregator*);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   virtual bool      Validate(void);
   virtual bool      Calculate(void)=0;
   virtual void      Check(void);
   virtual bool      CheckFilters(void);
   virtual double    GetDirection(void);
   virtual bool      LongCondition(void)=0;
   virtual bool      ShortCondition(void)=0;
   virtual void      Update(void)=0;
   bool              Active(void);
   void              Active(const bool);
   bool              Entry(void);
   void              Entry(const bool);
   bool              Exit(void);
   void              Exit(const bool);
   bool              Invert(void);
   void              Invert(const bool);
   static void       SignalInvert(ENUM_CMD&);
   int               ThresholdOpen(void) const;
   int               ThresholdClose(void)const;
   virtual bool      CheckOpenVoid(void);
   virtual bool      CheckOpenNeutral(void);
   virtual bool      CheckOpenLong(void);
   virtual bool      CheckOpenShort(void);
   virtual bool      CheckCloseVoid(void);
   virtual bool      CheckCloseNeutral(void);
   virtual bool      CheckCloseLong(void);
   virtual bool      CheckCloseShort(void);
   virtual ENUM_CMD  SignalOpen(void);
   virtual ENUM_CMD  SignalClose(void);
   virtual bool      Refresh(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalBase::CSignalBase(void) : m_active(true),
                                 m_use_open(true),
                                 m_use_close(false),
                                 m_signal_open(CMD_NEUTRAL),
                                 m_signal_close(CMD_NEUTRAL),
                                 m_invert(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalBase::~CSignalBase(void)
  {
   m_indicators.Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Init(CSymbolManager *symbol_man,CEventAggregator *event_man=NULL)
  {
   m_symbol_man= symbol_man;
   m_event_man = event_man;
   if(!CheckPointer(m_symbol_man))
      return false;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CSignalBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Validate(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Refresh(void)
  {
   for(int i=0;i<m_indicators.Total();i++)
     {
      CSeries *indicator=m_indicators.At(i);
      if(indicator!=NULL)
         indicator.Refresh(OBJ_ALL_PERIODS);
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::Check(void)
  {
   if(!Active())
      return;
   if(!Refresh())
      return;
   if(!Calculate())
      return;
   int res=CMD_NEUTRAL;
   if(LongCondition())
     {
      if (Entry())
         m_signal_open=CMD_LONG;
      if (Exit())
         m_signal_close=CMD_LONG;
     }
   else if(ShortCondition())
     {
      if (Entry())
         m_signal_open=CMD_SHORT;
      if (Exit())
         m_signal_close=CMD_SHORT;
     }
   else
   {
      if (Entry())
         m_signal_open=CMD_NEUTRAL;
      if (Exit())
         m_signal_close=CMD_NEUTRAL;
   }
   if(m_invert)
     {
      SignalInvert(m_signal_open);
      SignalInvert(m_signal_close);
     }
   Update();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::SignalInvert(ENUM_CMD &cmd)
  {
   if(cmd==CMD_LONG)
      cmd= CMD_SHORT;
   else if(cmd==CMD_SHORT)
      cmd=CMD_LONG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Active(void)
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::Active(const bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Entry(void)
  {
   return m_use_open;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::Entry(const bool value)
  {
   m_use_open=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Exit(void)
  {
   return m_use_close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::Exit(const bool value)
  {
   m_use_close=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Invert(void)
  {
   return m_invert;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::Invert(const bool value)
  {
   m_invert=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckOpenVoid(void)
  {
   return m_signal_open==CMD_VOID;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckOpenNeutral(void)
  {
   return m_signal_open==CMD_NEUTRAL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckOpenLong(void)
  {
   return m_signal_open==CMD_LONG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckOpenShort(void)
  {
   return m_signal_open==CMD_SHORT;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckCloseVoid(void)
  {
   return m_signal_close==CMD_VOID;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckCloseNeutral(void)
  {
   return m_signal_close==CMD_NEUTRAL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckCloseLong(void)
  {
   return m_signal_close==CMD_SHORT;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckCloseShort(void)
  {
   return m_signal_close==CMD_LONG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CMD CSignalBase::SignalOpen(void)
  {
   return m_signal_open;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CMD CSignalBase::SignalClose(void)
  {
   return m_signal_close;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Signal\Signal.mqh"
#else
#include "..\..\MQL4\Signal\Signal.mqh"
#endif
//+------------------------------------------------------------------+
