//+------------------------------------------------------------------+
//|                                                     TimeBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Object.mqh>
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
class CTimes;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimeBase : public CObject
  {
protected:
   bool              m_activate;
   bool              m_reverse;
   datetime          m_time_start;
   CTimes           *m_times;
public:
                     CTimeBase(void);
                    ~CTimeBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TIME;}
   virtual bool      Validate(void) {return true;}
   //--- initialization
   virtual bool      Init(CTimes *);
   virtual void      SetContainer(CTimes *times){m_times=times;}
   //--- setters and getters
   bool              Active(void) const {return m_activate;}
   void              Active(const bool activate) {m_activate=activate;}
   bool              Reverse(void) {return m_reverse;}
   void              Reverse(bool reverse) {m_reverse = reverse;}
   datetime          TimeStart(void) const {return m_time_start;}
   void              TimeStart(const datetime st){m_time_start=st;}
   //--- checking
   virtual bool      Evaluate(void) {return false;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeBase::CTimeBase(void) : m_activate(true),
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
bool CTimeBase::Init(CTimes *times)
  {
   SetContainer(times);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\Time.mqh"
#else
#include "..\..\MQL4\Time\Time.mqh"
#endif
//+------------------------------------------------------------------+
