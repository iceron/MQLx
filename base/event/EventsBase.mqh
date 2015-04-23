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
class JEventsBase : public CArrayObj
  {
protected:
   bool              m_activate;
   string            m_sound_file;
   string            m_ftp_file;
   string            m_ftp_path;
   JStrategy        *m_strategy;
   JEventRegistry   *m_standard;
   JEventRegistry   *m_error;
   JEventRegistry   *m_custom;
public:
                     JEventsBase(void);
                    ~JEventsBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT);}
   //--- initialization   
   virtual void      InitRegister(ENUM_EVENT_CLASS event_class,CArrayInt *print,CArrayInt *sound,CArrayInt *popup,CArrayInt *email,CArrayInt *push,CArrayInt *ftp);
   virtual void      InitRegister(ENUM_EVENT_CLASS event_class,int &print[],int &sound[],int &popup[],int &email[],int &push[],int &ftp[]);
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   //--- setters and getters
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}   
   virtual bool      Run(void);
   //--- processing
   virtual void      Register(ENUM_EVENT_CLASS event_class,ENUM_ALERT_MODE alert_mode,int id);   
   virtual void      DebugMode(bool debug=true);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
   virtual JEventStandard *CreateStandardEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventError *CreateErrorEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventCustom *CreateCustomEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventStandard *CreateStandardEvent(const ENUM_ACTION action,string message_add);
   virtual JEventError *CreateErrorEvent(const ENUM_ACTION action,string message_add);
   virtual JEventCustom *CreateCustomEvent(const ENUM_ACTION action,string message_add);
protected:      
   //--- event checking 
   virtual bool      IsEventAllowed(const ENUM_EVENT_CLASS type,const ENUM_ACTION action);
   virtual bool      IsEventStandardAllowed(const ENUM_ACTION action);
   virtual bool      IsEventErrorAllowed(const ENUM_ACTION action);
   virtual bool      IsEventCustomAllowed(const ENUM_ACTION action);   
   //--- events   
   virtual bool      SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info);  
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::JEventsBase(void) : m_activate(true),
                                 m_sound_file("alert.wav"),
                                 m_ftp_file(NULL),
                                 m_ftp_path(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::~JEventsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::IsEventStandardAllowed(const ENUM_ACTION action)
  {
   return(CheckPointer(m_standard)?m_standard.IsAllowed(action):false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::IsEventErrorAllowed(const ENUM_ACTION action)
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::IsEventCustomAllowed(const ENUM_ACTION action)
  {
   return(CheckPointer(m_custom)?m_custom.IsAllowed(action):false);
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
   PrintFormat("unknown event");
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   JEvent *event=NULL;
   switch(type)
     {
      case EVENT_CLASS_STANDARD:
        {
         if(IsEventStandardAllowed(action))
           {
            event=CreateStandardEvent(action,object1,object2,object3);
            if(event.Instant())
               event.Run(CheckPointer(m_standard)?GetPointer(m_standard):NULL,m_sound_file,m_ftp_file,m_ftp_path);
           }
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         event=CreateErrorEvent(action,object1,object2,object3);
         if(event.Instant())
            event.Run(CheckPointer(m_error)?GetPointer(m_error):NULL,m_sound_file,m_ftp_file,m_ftp_path);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         if(IsEventCustomAllowed(action))
           {
            event=CreateCustomEvent(action,object1,object2,object3);
            if(event.Instant())
               event.Run(CheckPointer(m_custom)?GetPointer(m_custom):NULL,m_sound_file,m_ftp_file,m_ftp_path);
           }
         break;
        }
      default:
        {
         PrintFormat("unknown event");
         return;
        }
     }
   if(CheckPointer(event)==POINTER_DYNAMIC)
      Add(event);
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
               event.Run(CheckPointer(m_standard)?GetPointer(m_standard):NULL,m_sound_file,m_ftp_file,m_ftp_path);
           }
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         event=CreateErrorEvent(action,message_add);
         if(CheckPointer(event)==POINTER_DYNAMIC)
            if(event.Instant())
               event.Run(CheckPointer(m_error)?GetPointer(m_error):NULL,m_sound_file,m_ftp_file,m_ftp_path);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         if(IsEventCustomAllowed(action))
            event=CreateCustomEvent(action,message_add);
         if(CheckPointer(event)==POINTER_DYNAMIC)
            if(event.Instant())
               event.Run(CheckPointer(m_custom)?GetPointer(m_custom):NULL,m_sound_file,m_ftp_file,m_ftp_path);
         break;
        }
      default:
        {
         PrintFormat("unknown event");
         break;
        }
     }
   if(CheckPointer(event)==POINTER_DYNAMIC)
      Add(event);
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
   if(!CheckPointer(m_standard))
      m_standard=new JEventRegistry();
   if(!CheckPointer(m_error))
      m_error=new JEventRegistry();
   if(!CheckPointer(m_custom))
      m_custom=new JEventRegistry();
   m_standard.DebugMode(debug);
   m_error.DebugMode(debug);
   m_custom.DebugMode(debug);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::Run(void)
  {
   int total= Total();
   for(int i=total-1;i>=0;i--)
     {
      JEvent *event=Detach(i);
      if(event!=NULL)
        {
         if(!event.Instant())
           {
            switch(event.Type())
              {
               case CLASS_TYPE_EVENT_STANDARD:
                 {
                  event.Run(CheckPointer(m_standard)?GetPointer(m_standard):NULL);
                  break;
                 }
               case CLASS_TYPE_EVENT_ERROR:
                 {
                  event.Run(CheckPointer(m_error)?GetPointer(m_error):NULL);
                  break;
                 }
               case CLASS_TYPE_EVENT_CUSTOM:
                 {
                  event.Run(CheckPointer(m_custom)?GetPointer(m_custom):NULL);
                  break;
                 }
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
void JEventsBase::Register(ENUM_EVENT_CLASS event_class,ENUM_ALERT_MODE alert_mode,int id)
  {
   switch(event_class)
     {
      case EVENT_CLASS_STANDARD:
        {
         if(CheckPointer(m_standard)==POINTER_INVALID)
            m_standard=new JEventRegistry();
         m_standard.Register(alert_mode,id);
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         if(CheckPointer(m_error)==POINTER_INVALID)
            m_error=new JEventRegistry();
         m_error.Register(alert_mode,id);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         if(CheckPointer(m_custom)==POINTER_INVALID)
            m_custom=new JEventRegistry();
         m_custom.Register(alert_mode,id);
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JEventsBase::InitRegister(ENUM_EVENT_CLASS event_class,CArrayInt *print,CArrayInt *sound,CArrayInt *popup,CArrayInt *email,CArrayInt *push,CArrayInt *ftp)
  {
   switch(event_class)
     {
      case EVENT_CLASS_STANDARD:
        {
         if(CheckPointer(m_standard)==POINTER_INVALID)
            m_standard=new JEventRegistry();
         m_standard.Init(print,sound,popup,email,push,ftp);
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         if(CheckPointer(m_error)==POINTER_INVALID)
            m_error=new JEventRegistry();
         m_error.Init(print,sound,popup,email,push,ftp);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         if(CheckPointer(m_custom)==POINTER_INVALID)
            m_custom=new JEventRegistry();
         m_custom.Init(print,sound,popup,email,push,ftp);
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JEventsBase::InitRegister(ENUM_EVENT_CLASS event_class,int &print[],int &sound[],int &popup[],int &email[],int &push[],int &ftp[])
  {
   switch(event_class)
     {
      case EVENT_CLASS_STANDARD:
        {
         if(CheckPointer(m_standard)==POINTER_INVALID)
            m_standard=new JEventRegistry();
         m_standard.Init(print,sound,popup,email,push,ftp);
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         if(CheckPointer(m_error)==POINTER_INVALID)
            m_error=new JEventRegistry();
         m_error.Init(print,sound,popup,email,push,ftp);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         if(CheckPointer(m_custom)==POINTER_INVALID)
            m_custom=new JEventRegistry();
         m_custom.Init(print,sound,popup,email,push,ftp);
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
