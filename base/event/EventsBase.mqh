//+------------------------------------------------------------------+
//|                                                   EventsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
#include "..\..\common\enum\ENUM_ALERT_MODE.mqh"
#include "..\..\common\enum\ENUM_EVENT_TYPE.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventBase : public CObject
  {
protected:
   bool              m_activate;
   ENUM_ALERT_MODE   m_order_sent;
   ENUM_ALERT_MODE   m_order_entry;
   ENUM_ALERT_MODE   m_order_modify;
   ENUM_ALERT_MODE   m_order_exit;
   ENUM_ALERT_MODE   m_order_reverse;
   ENUM_ALERT_MODE   m_error;
   JStrategy        *m_strategy;
public:
                     JEventBase(void);
                    ~JEventBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT);}
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Add(ENUM_EVENT_TYPE type,string func,string action,string info);
   virtual bool      SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info);
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventBase::JEventBase(void) : m_activate(true),
                               m_order_sent(0),
                               m_order_entry(0),
                               m_order_modify(0),
                               m_order_exit(0),
                               m_order_reverse(0),
                               m_error(0)
  {
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
bool JEventBase::Add(ENUM_EVENT_TYPE type,string func,string action,string info)
  {
   if(!Activate()) return(true);
   ENUM_ALERT_MODE mode=0;
   switch(type)
     {
      case EVENT_TYPE_ORDER_SENT:
        {
         mode=m_order_sent;
         break;
        }
      case EVENT_TYPE_ORDER_ENTRY:
        {
         mode=m_order_entry;
         break;
        }
      case EVENT_TYPE_ORDER_MODIFY:
        {
         mode=m_order_modify;
         break;
        }
      case EVENT_TYPE_ORDER_EXIT:
        {
         mode=m_order_exit;
         break;
        }
      case EVENT_TYPE_ORDER_REVERSE:
        {
         mode=m_order_reverse;
         break;
        }
      case EVENT_TYPE_ERROR:
        {
         mode=m_error;
         break;
        }
     }
   SendAlert(mode,func,action,info);
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventBase::SendAlert(ENUM_ALERT_MODE mode,string func,string action,string info)
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
#ifdef __MQL5__
#include "..\..\mql5\event\Events.mqh"
#else
#include "..\..\mql4\event\Events.mqh"
#endif
//+------------------------------------------------------------------+
