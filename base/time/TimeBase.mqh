//+------------------------------------------------------------------+
//|                                                     TimeBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <traderjet-cross\common\enum\ENUM_TIME_FILTER_TYPE.mqh>
#include <Object.mqh>
class JTimes;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimeBase : public CObject
  {
protected:
   bool              m_activate;
   datetime          m_time_start;
   ENUM_TIME_FILTER_TYPE m_filter_type;
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
   virtual ENUM_TIME_FILTER_TYPE FilterType(void) const {return(m_filter_type);}
   virtual void      FilterType(const ENUM_TIME_FILTER_TYPE type){m_filter_type=type;}
   virtual datetime  TimeStart(void) const {return(m_time_start);}
   virtual void      TimeStart(const datetime start){m_time_start=start;}
   //--- checking
   virtual bool      Evaluate(void) {return(true);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeBase::JTimeBase(void) : m_activate(true),
                             m_time_start(0),
                             m_filter_type(TIME_FILTER_INCLUDE)
  {
   m_time_start=TimeCurrent();
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
