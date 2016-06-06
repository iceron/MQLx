//+------------------------------------------------------------------+
//|                                                     TimeBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
class CExpert;
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
   virtual bool      Validate() {return true;}
   //--- initialization
   virtual bool      Init(CExpert *s,CTimes *times);
   virtual void      SetContainer(CTimes *times){m_times=times;}
   //--- setters and getters
   bool              Active(void) const {return m_activate;}
   void              Active(const bool activate) {m_activate=activate;}
   bool              Reverse() {return m_reverse;}
   void              Reverse(bool reverse) {m_reverse = reverse;}
   datetime          TimeStart(void) const {return m_time_start;}
   void              TimeStart(const datetime st){m_time_start=st;}
   //--- checking
   virtual bool      Evaluate(void) {return true;}
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
bool CTimeBase::Init(CExpert *s,CTimes *times)
  {
   SetContainer(times);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\Time.mqh"
#else
#include "..\..\mql4\time\Time.mqh"
#endif
//+------------------------------------------------------------------+
