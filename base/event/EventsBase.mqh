//+------------------------------------------------------------------+
//|                                                   EventsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "..\..\common\deleteobject.mqh"
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
   int               m_archive_max;
   string            m_ftp_file;
   string            m_ftp_path;
   JStrategy        *m_strategy;
   CArrayObj        *m_current;
   CArrayObj        *m_archive;

   JEventRegistry   *m_standard;
   JEventRegistry   *m_error;
   JEventRegistry   *m_custom;
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
   virtual JEventStandard *CreateStandardEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventError *CreateErrorEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual JEventCustom *CreateCustomEvent(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
protected:
   virtual void      EventCustom(JEventCustom *event);
   virtual void      EventError(JEventError *event);
   virtual void      EventStandard(JEventStandard *event);
   virtual bool      SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info);
   virtual bool      Execute(JEvent *event);
   virtual bool      Deinit(void);
   virtual void      Send();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::JEventsBase(void) : m_activate(true),
                                 m_archive_max(0),
                                 m_ftp_file(NULL),
                                 m_ftp_path(NULL)
  {
   m_current=new CArrayObj();
   if(m_archive_max>0)
      m_archive=new CArrayObj();
   //m_current.FreeMode(false);
   //m_archive.FreeMode(false);
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
JEventsBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   JEvent *event;
   switch(type)
     {
      case EVENT_CLASS_STANDARD:
        {
         event=CreateStandardEvent(action,object1,object2,object3);
         break;
        }
      case EVENT_CLASS_ERROR:
        {
         event=CreateErrorEvent(action,object1,object2,object3);
         break;
        }
      case EVENT_CLASS_CUSTOM:
        {
         event=CreateCustomEvent(action,object1,object2,object3);
         break;
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
bool JEventsBase::SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info)
  {
   if(!mode) return(true);
   string message;
   StringConcatenate(message,func,": ",action," [",info,"]");
   if((bool)(mode  &ALERT_MODE_PRINT))
     {
      Print(message);
      return(true);
     }
   if((bool)(mode  &ALERT_MODE_EMAIL))
     {
      return(SendMail(action,message));
     }
   if((bool)(mode  &ALERT_MODE_POPUP))
     {
      Alert(message);
      return(true);
     }
   if((bool)(mode  &ALERT_MODE_PUSH))
     {
      return(SendNotification(message));
     }
   if((bool)(mode  &ALERT_MODE_FTP))
     {
      return(SendFTP(message));
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::EventCustom(JEventCustom *event)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::EventError(JEventError *event)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventsBase::EventStandard(JEventStandard *event)
  {
   int action=event.Action();
   switch(action)
     {
      case ACTION_PROGRAM_INIT:
        {

         break;
        }
      case ACTION_PROGRAM_DEINIT:
        {

         break;
        }
      case ACTION_CLASS_VALIDATE:
        {

         break;
        }
      case ACTION_CLASS_VALIDATE_DONE:
        {

         break;
        }
      case ACTION_CANDLE:
        {

         break;
        }
      case ACTION_TICK:
        {

         break;
        }
      case ACTION_ORDER_SEND:
        {

         break;
        }
      case ACTION_ORDER_SEND_DONE:
        {

         break;
        }
      case ACTION_ORDER_ENTRY_MODIFY:
        {

         break;
        }
      case ACTION_ORDER_ENTRY_MODIFY_DONE:
        {

         break;
        }
      case ACTION_ORDER_SL_MODIFY:
        {

         break;
        }
      case ACTION_ORDER_SL_MODIFY_DONE:
        {

         break;
        }
      case ACTION_ORDER_TP_MODIFY:
        {

         break;
        }
      case ACTION_ORDER_TP_MODIFY_DONE:
        {

         break;
        }
      case ACTION_ORDER_ME_MODIFY:
        {

         break;
        }
      case ACTION_ORDER_ME_MODIFY_DONE:
        {

         break;
        }
      case ACTION_ORDER_CLOSE:
        {

         break;
        }
      case ACTION_ORDER_CLOSE_DONE:
        {

         break;
        }
      case ACTION_ORDER_STOPS_CLOSE_DONE:
        {

         break;
        }
      case ACTION_ORDER_STOPLOSS_TRAIL:
        {

         break;
        }
      case ACTION_ORDER_STOPLOSS_TRAIL_DONE:
        {

         break;
        }
      case ACTION_ORDER_TAKEPROFIT_TRAIL:
        {

         break;
        }
      case ACTION_ORDER_TAKEPROFIT_TRAIL_DONE:
        {

         break;
        }
      case ACTION_TRADE_ENABLED:
        {

         break;
        }
      case ACTION_TRADE_DISABLED:
        {

         break;
        }
      case ACTION_TRADE_TIME_START:
        {

         break;
        }
      case ACTION_TRADE_TIME_END:
        {

         break;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::Run(void)
  {
   for(int i=0;i<m_current.Total();i++)
     {
      JEvent *event=m_current.Detach(i);
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
      //event.Run();
      //Execute(event);
      if(m_archive_max>0)
        {
         m_archive.Add(event);
        }
      else delete event;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::Execute(JEvent *event)
  {
   switch(event.Type())
     {
      case CLASS_TYPE_EVENT_STANDARD:
        {
         EventStandard(GetPointer(event));
         break;
        }
      case CLASS_TYPE_EVENT_ERROR:
        {
         EventError(GetPointer(event));
         break;
        }
      case CLASS_TYPE_EVENT_CUSTOM:
        {
         EventCustom(GetPointer(event));
         break;
        }
      default:
        {
         Print("unknown event type");
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventsBase::Deinit()
  {
   DeleteObject(m_current);
   DeleteObject(m_archive);
   DeleteObject(m_standard);
   DeleteObject(m_error);
   DeleteObject(m_custom);
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
