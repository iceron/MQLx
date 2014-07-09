//+------------------------------------------------------------------+
//|                                                        Stops.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Arrays\ArrayObj.mqh>
#include "Stop.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStops : public CArrayObj
  {
public:
                     JStops();
                     JStops(string name,string sl=".sl.",string tp=".tp.");
                    ~JStops();
   virtual void      AddStops(JStop *stops);
   virtual void      CreateStops(ulong order_ticket,int order_type,double volume,double price);
   virtual void      CheckStops(JOrders &orders);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::JStops()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::~JStops()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::AddStops(JStop *stops)
  {
   Add(stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::CreateStops(ulong order_ticket,int order_type,double volume,double price)
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(stop==NULL) continue;
      stop.Create(order_ticket,order_type,volume,price);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::CheckStops(JOrders &orders)
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(stop==NULL) continue;
      stop.Check(orders);
     }
  }
//+------------------------------------------------------------------+
