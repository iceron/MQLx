//+------------------------------------------------------------------+
//|                                               OrderStopsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "..\event\EventBase.mqh"
#include "OrderStopBase.mqh"
class JOrder;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderStopsBase : public CArrayObj
  {
protected:
   JOrder           *m_order;
   JEvents          *m_events;
public:
                     JOrderStopsBase(void);
                    ~JOrderStopsBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_ORDERSTOPS);}
   //--- initialization
   virtual void      SetContainer(JOrder *order){m_order=order;}
   virtual bool      EventHandler(JEvents *events);
   virtual bool      NewOrderStop(JOrder *order,JStop *stop,JOrderStops *order_stops,JEvents *events=NULL);
   virtual void      Deinit();
   //--- checking
   virtual void      Check(double &volume);
   virtual bool      CheckNewTicket(JOrderStop *orderstop) {return(true);}
   virtual bool      Close(void);
   //--events
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
   //--- recovery
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::JOrderStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::~JOrderStopsBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::Deinit(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::NewOrderStop(JOrder *order,JStop *stop,JOrderStops *order_stops,JEvents *events=NULL)
  {
   JOrderStop *order_stop=new JOrderStop();
   order_stop.Init(order,stop,order_stops,events);
   return(Add(order_stop));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::Check(double &volume)
  {
   int total=Total();
   if(total>0)
     {
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOPS_CHECK,GetPointer(this));
      for(int i=0;i<Total();i++)
        {
         JOrderStop *order_stop=At(i);
         if(CheckPointer(order_stop))
           {
            order_stop.CheckTrailing();
            order_stop.Update();
            order_stop.Check(volume);
            if(!CheckNewTicket(order_stop)) return;
           }
        }
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOPS_CHECK_DONE,GetPointer(this));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::Close(void)
  {
   bool res=true;
   int total=Total();
   if(total>0)
     {
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOPS_CLOSE,GetPointer(this));
      for(int i=0;i<total;i++)
        {
         JOrderStop *order_stop=At(i);
         if(CheckPointer(order_stop))
           {
            if(!order_stop.Close())
               res=false;
           }
        }
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOPS_CLOSE_DONE,GetPointer(this));
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::EventHandler(JEvents *events)
  {
   if(events!=NULL)
      m_events=events;
   return(m_events!=NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopsBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopsBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::Backup(CFileBin *file)
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::Restore(CFileBin *file)
  {
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\OrderStops.mqh"
#else
#include "..\..\mql4\order\OrderStops.mqh"
#endif
//+------------------------------------------------------------------+
