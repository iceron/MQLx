//+------------------------------------------------------------------+
//|                                                    OrderBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include <Files\FileBin.mqh>
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
   virtual bool      Init(int magic,JOrders *orders,JEvents *events,JStops *m_stops);
   virtual void      IsClosed(const bool closed) {m_closed=closed;}
   virtual bool      IsClosed(void) const {return(false);}
   virtual void      Magic(const int magic){m_magic=magic;}
   virtual int       Magic(void) const {return(m_magic);}
   virtual void      MainStop(JOrderStop *order_stop){m_main_stop=order_stop;}
   virtual JOrderStop *MainStop(void) const {return(m_main_stop);}
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
   virtual int       Compare(const CObject *node,const int mode=0) const;
   //--- output
   virtual string    OrderTypeToString() const;
   //--- static methods
   static bool       IsOrderTypeLong(const ENUM_ORDER_TYPE type);
   static bool       IsOrderTypeShort(const ENUM_ORDER_TYPE type);
   //--- recovery
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
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
bool JOrderBase::Init(int magic,JOrders *orders,JEvents *events,JStops *m_stops)
  {
   m_magic=magic;
   SetContainer(GetPointer(orders));
   EventHandler(GetPointer(events));
   CreateStops(GetPointer(m_stops));
   CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SEND_DONE,GetPointer(this));
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CreateStops(JStops *stops)
  {
   if(CheckPointer(stops)==POINTER_INVALID)
      return;
   int total=stops.Total();
   if(total>0)
     {
      if(CheckPointer(m_order_stops)==POINTER_INVALID)
         m_order_stops=new JOrderStops();
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOPS_CREATE,GetPointer(this),stops);
      for(int i=0;i<total;i++)
        {
         JStop *stop=stops.At(i);
         if(CheckPointer(stop)==POINTER_INVALID)
            continue;
         m_order_stops.NewOrderStop(GetPointer(this),stop,m_order_stops,m_events);
        }
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOPS_CREATE_DONE,GetPointer(this),m_order_stops);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CheckStops(void)
  {
   if(m_order_stops!=NULL)
      m_order_stops.Check(m_volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderBase::CloseStops(void)
  {
   if(m_order_stops!=NULL)
      return(m_order_stops.Close());
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JOrderBase::Compare(const CObject *node,const int mode=0) const
  {
   const JOrder *order=node;
   if(Ticket()>order.Ticket())
      return(1);
   if(Ticket()<order.Ticket())
      return(-1);
   return(0);
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
string JOrderBase::OrderTypeToString(void) const
  {
   switch(OrderType())
     {
      case ORDER_TYPE_BUY: return("BUY");
      case ORDER_TYPE_SELL: return("SELL");
      case ORDER_TYPE_BUY_LIMIT: return("BUY LIMIT");
      case ORDER_TYPE_BUY_STOP: return("BUY STOP");
      case ORDER_TYPE_SELL_LIMIT: return("SELL LIMIT");
      case ORDER_TYPE_SELL_STOP: return("SELL STOP");
     }
   return(NULL);
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
