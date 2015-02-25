//+------------------------------------------------------------------+
//|                                                    OrderBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "..\event\EventBase.mqh"
#include "OrderStopsBase.mqh"
class JOrders;
class JStops;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderBase : public CObject
  {
protected:
   bool              m_activate;
   bool              m_closed;
   bool              m_clean;
   int               m_magic;
   double            m_price;
   ulong             m_ticket;
   ENUM_ORDER_TYPE   m_type;
   double            m_volume;
   double            m_volume_initial;
   JOrderStops      *m_order_stops;
   JOrderStop       *m_main_stop;
   JOrders          *m_orders;
   JEvents          *m_events;
public:
                     JOrderBase(void);
                    ~JOrderBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_ORDER);}
   //--- initialization
   virtual void      SetContainer(JOrders *orders){m_orders=orders;}
   //--- getters and setters       
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual bool      Clean(void) const {return(m_clean);}
   virtual void      Clean(const bool clean) {m_clean=clean;}
   virtual void      CreateStops(JStops *stops);
   virtual void      CheckStops(void);
   virtual bool      EventHandler(JEvents *events);
   virtual void      IsClosed(const bool closed) {m_closed=closed;}
   virtual bool      IsClosed(void) const {return(false);}
   virtual void      Magic(const int magic){m_magic=magic;}
   virtual int       Magic(void) const {return(m_magic);}
   virtual void      Price(const double price){m_price=price;}
   virtual double    Price(void) const {return(m_price);}
   virtual void      OrderType(const ENUM_ORDER_TYPE type){m_type=type;}
   virtual ENUM_ORDER_TYPE OrderType(void) const {return(m_type);}
   virtual void      Ticket(const ulong ticket) {m_ticket=ticket;}
   virtual ulong     Ticket(void) const {return(m_ticket);}
   virtual void      Volume(const double volume){m_volume=volume;}
   virtual double    Volume(void) const {return(m_volume);}
   virtual void      VolumeInitial(const double volume){m_volume_initial=volume;}
   virtual double    VolumeInitial(void) const {return(m_volume_initial);}
   //--events
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
   //--- archiving
   virtual bool      CloseStops(void);
   virtual int       Compare(const CObject *node,const int mode=0) const {return(0);}
   //--- static methods
   static bool       IsOrderTypeLong(const ENUM_ORDER_TYPE type);
   static bool       IsOrderTypeShort(const ENUM_ORDER_TYPE type);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderBase::JOrderBase(void) : m_activate(true),
                               m_closed(false),
                               m_clean(false),
                               m_magic(0),
                               m_price(0.0),
                               m_ticket(0),
                               m_type(0),
                               m_volume(0.0),
                               m_volume_initial(0.0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderBase::~JOrderBase(void)
  {
   ADT::Delete(m_order_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CreateStops(JStops *stops)
  {
   if(CheckPointer(stops)==POINTER_INVALID)
      return;
   if(CheckPointer(m_order_stops)==POINTER_INVALID)
      m_order_stops=new JOrderStops();
   int total= stops.Total();
   for(int i=0;i<total;i++)
     {
      JStop *stop=stops.At(i);
      if(!CheckPointer(stop)) continue;
      JOrderStop *order_stop=new JOrderStop();
      order_stop.Init(GetPointer(this),stop);
      order_stop.EventHandler(m_events);
      order_stop.SetContainer(GetPointer(m_order_stops));
      if(stop.Main())
         m_main_stop=order_stop;
      m_order_stops.Add(order_stop);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CheckStops(void)
  {
   m_order_stops.Check(m_volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderBase::CloseStops(void)
  {
   return(m_order_stops.Close());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderBase::EventHandler(JEvents *events)
  {
   if(events!=NULL)
      m_events=events;
   return(m_events!=NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderBase::IsOrderTypeLong(const ENUM_ORDER_TYPE type)
  {
   return(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_LIMIT || type==ORDER_TYPE_BUY_STOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderBase::IsOrderTypeShort(const ENUM_ORDER_TYPE type)
  {
   return(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_LIMIT || type==ORDER_TYPE_SELL_STOP);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\Order.mqh"
#else
#include "..\..\mql4\order\Order.mqh"
#endif
//+------------------------------------------------------------------+
