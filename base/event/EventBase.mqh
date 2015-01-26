//+------------------------------------------------------------------+
//|                                                    EventBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_ALERT_MODE.mqh"
#include "..\..\common\enum\ENUM_EVENT_TYPE.mqh"
#include "..\..\common\enum\ENUM_EVENT_CLASS.mqh"
#include <Object.mqh>
class JEvents;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventBase : public CObject
  {
protected:
   bool              m_activate;
   int               m_id;
   datetime          m_timestamp;
   const CObject    *m_obj1;
   const CObject    *m_obj2;
   const CObject    *m_obj3;
   JEvents          *m_events;
public:
                     JEventBase(void);
                     JEventBase(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL);
                    ~JEventBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT);}
   virtual void      SetContainer(JEvents *e){m_events=e;}
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   virtual int       ID(void) const {return(m_id);}
   virtual void      ID(int id) {m_id=id;}
   virtual void      Init(const int id,const CObject *object1=NULL,const CObject *object2=NULL,const CObject *object3=NULL);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(void) : m_activate(true),
                               m_id(-1),
                               m_timestamp(TimeCurrent())
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(int id,const CObject *object1=NULL,const CObject *object2=NULL,
                       const CObject *object3=NULL) :
                       m_activate(true),
                       m_id(-1),
                       m_timestamp(TimeCurrent())
  {
   Init(id,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::~JEventBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::Init(int id,const CObject *object1=NULL,const CObject *object2=NULL,
                 const CObject *object3=NULL)
  {
   m_id=id;
   if(object1!=NULL)
      m_obj1=object1;
   if(object2!=NULL)
      m_obj2=object2;
   if(object3!=NULL)
      m_obj3=object3;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\Event.mqh"
#else
#include "..\..\mql4\event\Event.mqh"
#endif
//+------------------------------------------------------------------+
