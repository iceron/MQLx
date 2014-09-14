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
   int               m_magic;
   double            m_price;
   ulong             m_ticket;
   ENUM_ORDER_TYPE   m_type;
   double            m_volume;
   double            m_volume_initial;
   JOrderStops       m_order_stops;
   JOrderStop       *m_main_stop;
   JOrders          *m_orders;
public:
                     JOrderBase(void);
                    ~JOrderBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_ORDER);}
   //--- initialization
   virtual void      SetContainer(JOrders *orders){m_orders=orders;}   
   //--- getters and setters       
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}           
   virtual void      CreateStops(JStops *stops);
   virtual void      CheckStops(void);
   virtual void      IsClosed(bool closed) {m_closed=closed;}
   virtual bool      IsClosed(void) const {return(false);}
   virtual void      Magic(int magic){m_magic=magic;}
   virtual int       Magic(void) const {return(m_magic);}
   virtual void      Price(double price){m_price=price;}
   virtual double    Price(void) const {return(m_price);}
   virtual void      OrderType(ENUM_ORDER_TYPE type){m_type=type;}
   virtual ENUM_ORDER_TYPE OrderType(void) const {return(m_type);}
   virtual void      Ticket(ulong ticket) {m_ticket=ticket;}
   virtual ulong     Ticket(void) const {return(m_ticket);}
   virtual void      Volume(double volume){m_volume=volume;}
   virtual double    Volume(void) const {return(m_volume);}
   virtual void      VolumeInitial(double volume){m_volume_initial=volume;}
   virtual double    VolumeInitial(void) const {return(m_volume_initial);}
   //--- archiving
   virtual bool      CloseStops(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderBase::JOrderBase(void) : m_activate(true),
                               m_closed(false),
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderBase::CreateStops(JStops *stops)
  {
   int total= stops.Total();
   for(int i=0;i<total;i++)
     {
      JStop *stop=stops.At(i);
      if(!CheckPointer(stop)) continue;
      JOrderStop *order_stop=new JOrderStop();
      order_stop.Init(GetPointer(this),stop);
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
#ifdef __MQL5__
#include "..\..\mql5\order\Order.mqh"
#else
#include "..\..\mql4\order\Order.mqh"
#endif
//+------------------------------------------------------------------+
