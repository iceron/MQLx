//+------------------------------------------------------------------+
//|                                                   OrdersBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "OrderBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrdersBase : public CArrayObj
  {
protected:
   bool              m_activate;
   bool              m_clean;
   int               m_magic;
   JStops           *m_stops;
   JEvents          *m_events;
   JStrategy        *m_strategy;
public:
                     JOrdersBase(void);
                    ~JOrdersBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_ORDERS);}
   //--- initialization
   virtual bool      Init(const int magic=0,JStrategy *s=NULL,JStops *stops=NULL,JEvents *events=NULL);
   virtual void      SetContainer(JStrategy *s);
   virtual void      SetStops(JStops *stops);
   //--- getters and setters
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(const bool activate) {m_activate=activate;}
   virtual bool      Clean(void) const {return(m_clean);}
   virtual void      Clean(const bool clean) {m_clean=clean;}
   virtual bool      EventHandler(JEvents *events);
   virtual void      Magic(int magic) {m_magic=magic;}
   virtual int       Magic() {return(m_magic);}
   //--- events                  
   virtual void      OnTick(void);
   //--- order creation
   virtual bool      NewOrder(const int ticket,const ENUM_ORDER_TYPE type,const double volume,const double price);
   //--- archiving
   virtual bool      CloseStops(void);
   //--- events
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::JOrdersBase(void) : m_activate(true),
                                 m_clean(false),
                                 m_magic(0)
  {
   if(!IsSorted())
      Sort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::~JOrdersBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::Init(const int magic=0,JStrategy *s=NULL,JStops *stops=NULL,JEvents *events=NULL)
  {
   m_magic=magic;
   SetContainer(s);
   SetStops(stops);
   EventHandler(events);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::SetContainer(JStrategy *s)
  {
   if(s!=NULL)
      m_strategy=s;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::SetStops(JStops *stops)
  {
   if(stops!=NULL)
      m_stops=stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::EventHandler(JEvents *events)
  {
   if(events!=NULL)
      m_events=events;
   return(m_events!=NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::NewOrder(const int ticket,const ENUM_ORDER_TYPE type,const double volume,const double price)
  {
   JOrder *order=new JOrder(ticket,type,volume,price);
   if(CheckPointer(order)==POINTER_DYNAMIC)
      if(InsertSort(GetPointer(order)))
         return(order.Init(m_magic,GetPointer(this),m_events,m_stops));
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrdersBase::OnTick(void)
  {
   for(int i=0;i<Total();i++)
     {
      JOrder *order=At(i);
      if(CheckPointer(order))
         order.CheckStops();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::CloseStops(void)
  {
   bool res=true;
   for(int i=0;i<Total();i++)
     {
      JOrder *order=At(i);
      if(CheckPointer(order))
         if(!order.CloseStops())
            res=false;
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrdersBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrdersBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,message_add);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\Orders.mqh"
#else
#include "..\..\mql4\order\Orders.mqh"
#endif
//+------------------------------------------------------------------+
