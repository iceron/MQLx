//+------------------------------------------------------------------+
//|                                                     TimeBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
#include "..\Symbol\SymbolManagerBase.mqh"
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
   CObject          *m_container;   
public:
                     CTimeBase(void);
                    ~CTimeBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TIME;}   
   //--- initialization
   virtual bool      Init(CSymbolManager*);
   virtual void      SetContainer(CObject *container) {m_container=container;}
   virtual bool      Validate(void) {return true;}
   //--- setters and getters
   bool              Active(void) const {return m_active;}
   void              Active(const bool activate) {m_active=activate;}
   bool              Reverse(void) {return m_reverse;}
   void              Reverse(bool reverse) {m_reverse = reverse;}
   datetime          TimeStart(void) const {return m_time_start;}
   void              TimeStart(const datetime st){m_time_start=st;}
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
bool CTimeBase::Init(CSymbolManager* symbol_man)
  {
   m_symbol_man = symbol_man;
   return CheckPointer(m_symbol_man);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\Time.mqh"
#else
#include "..\..\MQL4\Time\Time.mqh"
#endif
//+------------------------------------------------------------------+
