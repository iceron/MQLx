//+------------------------------------------------------------------+
//|                                                   EventsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "..\..\common\enum\ENUM_ALERT_MODE.mqh"
#include "EventBase.mqh"
#include "EventStandardBase.mqh"
#include "EventErrorBase.mqh"
#include "EventCustomBase.mqh"
#include "EventRegistryBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventsBase : public CObject
  {
protected:
   bool              m_activate;
   string            m_sound_file;
   string            m_ftp_file;
   string            m_ftp_path;
   JStrategy        *m_strategy;
   CArrayObj        *m_current;
   JEventRegistry    m_standard;
   JEventRegistry    m_error;
   JEventRegistry    m_custom;
public:
                     JEventsBase(void);
                    ~JEventsBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT);}
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   virtual bool      Run(void);
   virtual void      Register(ENUM_EVENT_CLASS event_class,ENUM_ALERT_MODE alert_mode,int id);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
   virtual void      DebugMode(bool debug=true);
protected:
   virtual bool      SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info);
   virtual bool      Deinit(void);
   virtual void      Send();
   virtual bool      IsEventAllowed(const ENUM_EVENT_CLASS type,const ENUM_ACTION action);
   virtual bool      IsEventStandardAllowed(const ENUM_ACTION action);
   virtual bool      IsEventErrorAllowed(const ENUM_ACTION action);
   virtual bool      IsEventCustomAllowed(const ENUM_ACTION action);
   virtual JEventStandard *CreateStandardEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventError *CreateErrorEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventCustom *CreateCustomEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventStandard *CreateStandardEvent(const ENUM_ACTION action,string message_add);
   virtual JEventError *CreateErrorEvent(const ENUM_ACTION action,string message_add);
   virtual JEventCustom *CreateCustomEvent(const ENUM_ACTION action,string message_add);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::JEventsBase(void) : m_activate(true),
                                 m_sound_file("alert.wav"),
                                 m_ftp_file(NULL),
                                 m_ftp_path(NULL)
  {
   m_current=new CArrayObj();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::~JEventsBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::IsEventStandardAllowed(const ENUM_ACTION action)
  {
   return(m_standard.IsAllowed(action));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::IsEventErrorAllowed(const ENUM_ACTION action)
  {
//return(m_error.IsAllowed(action));
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::IsEventCustomAllowed(const ENUM_ACTION action)
  {
   return(m_custom.IsAllowed(action));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::IsEventAllowed(const ENUM_EVENT_CLASS type,const ENUM_ACTION action)
  {
   switch(type)
     {
      case EVENT_CLASS_STANDARD: return(IsEventStandardAllowed(action));
      case EVENT_CLASS_ERROR:    return(IsEventErrorAllowed(action));
      case EVENT_CLASS_CUSTOM:   return(IsEventCustomAllowed(action));
     }
   Print("unknown event");
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   switch(type)
     {
      case EVENT_CLASS_STANDARD:
        {
         if(IsEventStandardAllowed(action))
            m_current.Add(CreateStandardEvent(action,object1,object2,object3));
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         m_current.Add(CreateErrorEvent(action,object1,object2,object3));
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         if(IsEventStandardAllowed(action))
            m_current.Add(CreateCustomEvent(action,object1,object2,object3));
         break;
        }
      default:
        {
         Print("unknown event");
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandard *JEventsBase::CreateStandardEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   return(new JEventStandard(action,object1,object2,object3));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventError *JEventsBase::CreateErrorEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   return(new JEventError(action,object1,object2,object3));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustom *JEventsBase::CreateCustomEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   return(new JEventCustom(action,object1,object2,object3));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   JEvent *event=NULL;
   switch(type)
     {
      case EVENT_CLASS_STANDARD:
        {
         if(IsEventStandardAllowed(action))
           {
            event=CreateStandardEvent(action,message_add);
            if(event.Instant())
               event.Run(GetPointer(m_standard),m_sound_file,m_ftp_file,m_ftp_path);
           }
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         event=CreateErrorEvent(action,message_add);
         if(CheckPointer(event)==POINTER_DYNAMIC)
            if(event.Instant())
               event.Run(GetPointer(m_error),m_sound_file,m_ftp_file,m_ftp_path);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         if(IsEventCustomAllowed(action))
            event=CreateCustomEvent(action,message_add);
         if(CheckPointer(event)==POINTER_DYNAMIC)
            if(event.Instant())
               event.Run(GetPointer(m_custom),m_sound_file,m_ftp_file,m_ftp_path);
         break;
        }
      default:
        {
         Print("unknown event");
         break;
        }
     }
   if(CheckPointer(event)==POINTER_DYNAMIC)
      m_current.Add(event);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandard *JEventsBase::CreateStandardEvent(const ENUM_ACTION action,string message_add)
  {
   return(new JEventStandard(action,message_add));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventError *JEventsBase::CreateErrorEvent(const ENUM_ACTION action,string message_add)
  {
   return(new JEventError(action,message_add));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventCustom *JEventsBase::CreateCustomEvent(const ENUM_ACTION action,string message_add)
  {
   return(new JEventCustom(action,message_add));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::DebugMode(bool debug=true)
  {
   m_standard.DebugMode(debug);
   m_error.DebugMode(debug);
   m_custom.DebugMode(debug);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::Run(void)
  {
   for(int i=0;i<m_current.Total();i++)
     {
      JEvent *event=m_current.Detach(i);
      if(!event.Instant())
        {
         switch(event.Type())
           {
            case CLASS_TYPE_EVENT_STANDARD:
              {
               event.Run(GetPointer(m_standard));
               break;
              }
            case CLASS_TYPE_EVENT_ERROR:
              {
               event.Run(GetPointer(m_error));
               break;
              }
            case CLASS_TYPE_EVENT_CUSTOM:
              {
               event.Run(GetPointer(m_custom));
               break;
              }
           }
        }
      delete event;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::Deinit()
  {
   ADT::Delete(m_current);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JEventsBase::Register(ENUM_EVENT_CLASS event_class,ENUM_ALERT_MODE alert_mode,int id)
  {
   switch(event_class)
     {
      case EVENT_CLASS_STANDARD:
        {
         m_standard.Register(alert_mode,id);
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         m_error.Register(alert_mode,id);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         m_custom.Register(alert_mode,id);
         break;
        }
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\Events.mqh"
#else
#include "..\..\mql4\event\Events.mqh"
#endif
//+------------------------------------------------------------------+
