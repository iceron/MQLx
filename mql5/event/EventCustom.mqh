//+------------------------------------------------------------------+
//|                                                  JEventCustom.mqh |
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
class JEventCustom : public EventCustomBase
  {
public:
                     JEventCustom(void);
                     JEventCustom(const int id,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
                    ~JEventCustom(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT_ERROR);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustom::JEventCustom(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustom::JEventCustom(const int id,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   Init(id,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustom::~JEventCustom(void)
  {
  }
//+------------------------------------------------------------------+
