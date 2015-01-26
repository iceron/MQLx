//+------------------------------------------------------------------+
//|                                                  EventCustom.mqh |
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
class EventCustom : public EventCustomBase
  {
public:
                     EventCustom(void);
                     EventCustom(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL);
                    ~EventCustom(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT_ERROR);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EventCustom::EventCustom(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EventCustom::EventCustom(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL)
  {
   Init(id,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
EventCustom::~EventCustom(void)
  {
  }
//+------------------------------------------------------------------+
