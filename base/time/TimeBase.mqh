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
   virtual bool      Validate() const {return(true);}
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
   virtual bool      Evaluate(void) const {return(true);}
   //--- recovery
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
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
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeBase::Backup(CFileBin *file)
  {
   file.WriteChar(m_activate);
   file.WriteInteger(m_time_start);
   file.WriteInteger(m_filter_type);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeBase::Restore(CFileBin *file)
  {
   int temp_enum = 0;
   file.ReadChar(m_activate);
   file.ReadInteger(temp_enum);
   m_time_start = (datetime) temp_enum;
   file.ReadInteger(temp_enum);
   m_filter_type = (ENUM_TIME_FILTER_TYPE) temp_enum;
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\Time.mqh"
#else
#include "..\..\mql4\time\Time.mqh"
#endif
//+------------------------------------------------------------------+
