//+------------------------------------------------------------------+
//|                                                   EventError.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventError : public JEventErrorBase
  {
public:
                     JEventError(void);
                     JEventError(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
                     JEventError(const ENUM_ACTION action,string message_add);
                    ~JEventError(void);
   virtual int       Type(void) {return CLASS_TYPE_EVENT_ERROR;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventError::JEventError(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventError::JEventError(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   Init(action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventError::JEventError(const ENUM_ACTION action,string message_add)
  {
   Init(action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventError::~JEventError(void)
  {
  }
//+------------------------------------------------------------------+
