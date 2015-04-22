//+------------------------------------------------------------------+
//|                                                     TimeBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
class JStrategy;
class JTimes;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimeBase : public CObject
  {
protected:
   bool              m_activate;
   bool              m_reverse;
   datetime          m_time_start;
   JTimes           *m_times;
public:
                     JTimeBase(void);
                    ~JTimeBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_TIME);}
   virtual bool      Validate() {return(true);}
   //--- initialization
   virtual bool      Init(JStrategy *s,JTimes *times);
   virtual void      SetContainer(JTimes *times){m_times=times;}
   //--- setters and getters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual bool      Reverse() {return(m_reverse);}
   virtual void      Reverse(bool reverse) {m_reverse = reverse;}
   virtual datetime  TimeStart(void) const {return(m_time_start);}
   virtual void      TimeStart(const datetime start){m_time_start=start;}
   //--- checking
   virtual bool      Evaluate(void) {return(true);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeBase::JTimeBase(void) : m_activate(true),
                             m_reverse(false),
                             m_time_start(TimeCurrent())
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeBase::~JTimeBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeBase::Init(JStrategy *s,JTimes *times)
  {
   SetContainer(times);
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\Time.mqh"
#else
#include "..\..\mql4\time\Time.mqh"
#endif
//+------------------------------------------------------------------+
