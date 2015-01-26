//+------------------------------------------------------------------+
//|                                            EventStandardBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_ALERT_MODE.mqh"
#include "..\..\common\enum\ENUM_EVENT_TYPE.mqh"
#include "..\..\common\enum\ENUM_EVENT_CLASS.mqh"
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventStandardBase : public JEvent
  {
public:
                     JEventStandardBase(void);
                     JEventStandardBase(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL);
                    ~JEventStandardBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT_STANDARD);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::JEventStandardBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::JEventStandardBase(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL)
  {
   Init(id,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::~JEventStandardBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventStandard.mqh"
#else
#include "..\..\mql4\event\EventStandard.mqh"
#endif
//+------------------------------------------------------------------+
