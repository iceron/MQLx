//+------------------------------------------------------------------+
//|                                              EventCustomBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "EventBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventCustomBase : public JEvent
  {
public:
                     JEventCustomBase(void);
                     JEventCustomBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
                     JEventCustomBase(const ENUM_ACTION action,string message_add);
                    ~JEventCustomBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT_CUSTOM);}
   virtual bool      Run(JEventRegistry *registry);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustomBase::JEventCustomBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustomBase::JEventCustomBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   Init(action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustomBase::JEventCustomBase(const ENUM_ACTION action,string message_add)
  {
   Init(action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustomBase::~JEventCustomBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventCustomBase::Run(JEventRegistry *registry)
  {
   return(false);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventCustom.mqh"
#else
#include "..\..\mql4\event\EventCustom.mqh"
#endif
//+------------------------------------------------------------------+
