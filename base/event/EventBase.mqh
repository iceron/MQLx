//+------------------------------------------------------------------+
//|                                                    EventBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_ALERT_MODE.mqh"
#include "..\..\common\enum\ENUM_ACTION.mqh"
#include "..\..\common\enum\ENUM_EVENT_CLASS.mqh"
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
#include <Arrays\ArrayObj.mqh>
#include "EventRegistryBase.mqh"
class JEvents;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventBase : public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_action;
   datetime          m_timestamp;
   string            m_subject;
   string            m_message;
   JEvents          *m_events;
public:
                     JEventBase(void);
                     JEventBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
                    ~JEventBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT);}
   virtual void      SetContainer(JEvents *e){m_events=e;}
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   virtual int       Action() {return(m_action);}
   virtual int       ID(void) const {return(m_action);}
   virtual void      ID(ENUM_ACTION action) {m_action=action;}
   virtual void      Init(const ENUM_ACTION id,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual datetime  TimeStamp() {return(m_timestamp);}
   virtual void      AddObject(CObject *object);
   virtual bool      Run(JEventRegistry *registry);
   virtual bool      Execute(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(void) : m_activate(true),
                               m_action(-1),
                               m_timestamp(TimeCurrent())
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,
                       CObject *object3=NULL) :
                       m_activate(true),
                       m_action(-1),
                       m_timestamp(TimeCurrent())
  {
   Init(action,object1,object2,object3);
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
JEventBase::Init(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,
                 CObject *object3=NULL)
  {
   m_action=action;
   AddObject(object1);
   AddObject(object2);
   AddObject(object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::AddObject(CObject *object)
  {
   if(object!=NULL)
     {
      if(object.Type()==0x7778)
         AddArray(GetPointer(object));
      else Add(GetPointer(object));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventBase::Run(JEventRegistry *registry)
  {
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventBase::Execute(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL)
  {
   if (registry.IsPrint(m_action))
      Print(m_message);
   if (registry.IsSound(m_action))
      PlaySound(sound_file);
   if (registry.IsPopup(m_action))
      Alert(m_message);
   if (registry.IsEmail(m_action))
      SendMail(m_subject,m_message);
   if (registry.IsPush(m_action))
      SendNotification(m_message);
   if (registry.IsFTP(m_action))
      SendFTP(file_name,ftp_path);     
   return(false);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\Event.mqh"
#else
#include "..\..\mql4\event\Event.mqh"
#endif
//+------------------------------------------------------------------+
