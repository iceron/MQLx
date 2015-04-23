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
class JEventBase : public CObject
  {
protected:
   bool              m_activate;
   bool              m_instant;
   int               m_action;
   datetime          m_timestamp;
   string            m_subject;
   string            m_message;
   string            m_message_add;
   CArrayObj        *m_objects;
   JEvents          *m_events;
public:
                     JEventBase(void);
                     JEventBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
                     JEventBase(const ENUM_ACTION action,string message_add);
                    ~JEventBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT);}
   virtual void      SetContainer(JEvents *e){m_events=e;}
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   virtual int       Action() {return(m_action);}
   virtual int       ID(void) const {return(m_action);}
   virtual void      ID(ENUM_ACTION action) {m_action=action;}
   virtual void      Init(const ENUM_ACTION id,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      Init(const ENUM_ACTION action,string message_add);
   virtual bool      Instant() {return(m_instant);}
   virtual void      CheckInstant();
   virtual datetime  TimeStamp() {return(m_timestamp);}
   virtual void      AddObject(CObject *object);
   virtual CObject  *GetObject(ENUM_CLASS_TYPE type);
   virtual CObject  *GetObject(ENUM_CLASS_TYPE type,int &idx);
   virtual bool      Run(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL);
   virtual bool      Execute(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(void) : m_activate(true),
                               m_action(-1),
                               m_timestamp(TimeCurrent()),
                               m_subject(NULL),
                               m_message(NULL),
                               m_message_add(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,
                       CObject *object3=NULL) :
                       m_activate(true),
                       m_instant(false),
                       m_action(-1),
                       m_timestamp(TimeCurrent()),
                       m_subject(NULL),
                       m_message(NULL),
                       m_message_add(NULL)
  {
   Init(action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(const ENUM_ACTION action,string message_add) : m_activate(true),
                                                                      m_instant(false),
                                                                      m_action(-1),
                                                                      m_timestamp(TimeCurrent()),
                                                                      m_subject(NULL),
                                                                      m_message(NULL),
                                                                      m_message_add(NULL)
  {
   Init(action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::~JEventBase(void)
  {
   ADT::Delete(m_objects);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::Init(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,
                 CObject *object3=NULL)
  {
   m_action=action;
   m_objects=new CArrayObj();
   m_objects.FreeMode(false);
   AddObject(object1);
   AddObject(object2);
   AddObject(object3);
   CheckInstant();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::Init(const ENUM_ACTION action,string message_add)
  {
   m_action=action;
   m_message_add=message_add;
   CheckInstant();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::CheckInstant(void)
{
   if((Type()==CLASS_TYPE_EVENT_STANDARD && StringFind(EnumToString((ENUM_ACTION)m_action),"DONE")<0) || Type()==CLASS_TYPE_EVENT_ERROR)
      m_instant=true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::AddObject(CObject *object)
  {
   if(object!=NULL)
     {
      if(object.Type()==0x7778)
         m_objects.AddArray(GetPointer(object));
      else m_objects.Add(GetPointer(object));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventBase::Run(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL)
  {
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventBase::Execute(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL)
  {
   if(registry.IsPrint(m_action))
      Print(m_message+" "+m_message_add);
   if(registry.IsSound(m_action))
      PlaySound(sound_file);
   if(registry.IsPopup(m_action))
      Alert(m_message+" "+m_message_add);
   if(registry.IsEmail(m_action))
      SendMail(m_subject,m_message+" "+m_message_add);
   if(registry.IsPush(m_action))
      SendNotification(m_message+" "+m_message_add);
   if(registry.IsFTP(m_action))
      SendFTP(file_name,ftp_path);
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *JEventBase::GetObject(ENUM_CLASS_TYPE type)
  {
   if(CheckPointer(m_objects)==POINTER_DYNAMIC)
     {
      for(int i=0;i<m_objects.Total();i++)
        {
         CObject *object = m_objects.At(i);
         if(object.Type()==type)
            return(object);
        }
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *JEventBase::GetObject(ENUM_CLASS_TYPE type,int &idx)
  {
   if(CheckPointer(m_objects)==POINTER_DYNAMIC)
     {
      for(int i=idx;i<m_objects.Total();i++)
        {
         CObject *object = m_objects.At(i);
         if(object.Type()==type)
           {
            idx=i;
            return(object);
           }
        }
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\Event.mqh"
#else
#include "..\..\mql4\event\Event.mqh"
#endif
//+------------------------------------------------------------------+
