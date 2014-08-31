//+------------------------------------------------------------------+
//|                                                        JOrder.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "OrderStops.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrder : public CObject
  {
protected:
   bool              m_activate;
   double            m_price;
   ulong             m_ticket;
   ENUM_ORDER_TYPE   m_type;
   double            m_volume;
   double            m_volume_initial;
   JOrderStops       m_order_stops;
public:
                     JOrder();
                     JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price);
                    ~JOrder();
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- order functions                    
   virtual void      CreateStops(JStops *stops);
   virtual void      CheckStops();
   virtual void      Price(double price){m_price=price;}
   virtual double    Price(){return(m_price);}
   virtual void      OrderType(ENUM_ORDER_TYPE type){m_type=type;}
   virtual ENUM_ORDER_TYPE OrderType(){return(m_type);}
   virtual void      Ticket(ulong ticket) {m_ticket=ticket;}
   virtual ulong     Ticket() {return(m_ticket);}
   virtual void      Volume(double volume){m_volume=volume;}
   virtual double    Volume(){return(m_volume);}
   //--- archiving
   virtual void      CloseStops();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder() : m_activate(true),
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
JOrder::JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price)
  {
   m_ticket=ticket;
   m_type=type;
   m_volume_initial=volume;
   m_volume= m_volume_initial;
   m_price = price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::~JOrder()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrder::CreateStops(JStops *stops)
  {
   int total= stops.Total();
   for(int i=0;i<total;i++)
     {
      JStop *stop=stops.At(i);
      if(!CheckPointer(stop)) continue;
      JOrderStop *order_stop=new JOrderStop();
      order_stop.Init(m_ticket,m_type,m_price,m_volume,stop);
      m_order_stops.Add(order_stop);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrder::CheckStops()
  {
   int total= m_order_stops.Total();
   for(int i=0;i<total;i++)
      m_order_stops.Check(m_volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrder::CloseStops()
  {
   int total= m_order_stops.Total();
   for(int i=0;i<total;i++)
      m_order_stops.Close();
  }
//+------------------------------------------------------------------+
