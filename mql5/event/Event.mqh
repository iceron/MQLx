//+------------------------------------------------------------------+
//|                                                        Event.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEvent : public JEventBase
  {
public:
                     JEvent(void);
                     JEvent(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL);
                    ~JEvent(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEvent::JEvent(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEvent::JEvent(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL)
  {
   Init(id,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEvent::~JEvent(void)
  {
  }
//+------------------------------------------------------------------+
