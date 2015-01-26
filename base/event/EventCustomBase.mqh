//+------------------------------------------------------------------+
//|                                              EventCustomBase.mqh |
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
class EventCustomBase : public JEvent
  {
public:
                     EventCustomBase(void);
                     EventCustomBase(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL);
                    ~EventCustomBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT_ERROR);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EventCustomBase::EventCustomBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EventCustomBase::EventCustomBase(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL)
  {
   Init(id,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EventCustomBase::~EventCustomBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventError.mqh"
#else
#include "..\..\mql4\event\EventError.mqh"
#endif
//+------------------------------------------------------------------+
