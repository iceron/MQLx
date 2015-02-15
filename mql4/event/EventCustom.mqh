//+------------------------------------------------------------------+
//|                                                  JEventCustom.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventCustom : public JEventCustomBase
  {
public:
                     JEventCustom(void);
                     JEventCustom(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
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
JEventCustom::JEventCustom(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   Init(action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustom::~JEventCustom(void)
  {
  }
//+------------------------------------------------------------------+
