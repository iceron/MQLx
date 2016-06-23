//+------------------------------------------------------------------+
//|                                                     TimeBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
class CTimes;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimeBase : public CObject
  {
protected:
   bool              m_active;
   bool              m_reverse;
   datetime          m_time_start;
   CSymbolManager   *m_symbol_man;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CTimeBase(void);
                    ~CTimeBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TIME;}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CEventAggregator*);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   virtual bool      Validate(void);
   //--- setters and getters
   bool              Active(void) const;
   void              Active(const bool);
   bool              Reverse(void);
   void              Reverse(const bool);
   datetime          TimeStart(void) const;
   void              TimeStart(const datetime);
   //--- checking
   virtual bool      Evaluate(void)=0;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeBase::CTimeBase(void) : m_active(true),
                             m_reverse(false),
                             m_time_start(TimeCurrent())
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeBase::~CTimeBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CTimeBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeBase::Validate(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeBase::Active(const bool activate)
  {
   m_active=activate;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeBase::Reverse(void)
  {
   return m_reverse;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeBase::Reverse(const bool reverse)
  {
   m_reverse=reverse;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CTimeBase::TimeStart(void) const
  {
   return m_time_start;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeBase::TimeStart(const datetime st)
  {
   m_time_start=st;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeBase::Init(CSymbolManager *symbol_man,CEventAggregator *event_man=NULL)
  {
   m_symbol_man= symbol_man;
   m_event_man = event_man;
   return CheckPointer(m_symbol_man);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\Time.mqh"
#else
#include "..\..\MQL4\Time\Time.mqh"
#endif
//+------------------------------------------------------------------+
