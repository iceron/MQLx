//+------------------------------------------------------------------+
//|                                                   OrderStops.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "OrderStop.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderStops : public CArrayObj
  {
public:
                     JOrderStops();
                    ~JOrderStops();
   virtual void      Check(double &volume);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStops::JOrderStops()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStops::~JOrderStops()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStops::Check(double &volume)
  {
   for(int i=0;i<Total();i++)
     {
      JOrderStop *order_stop=At(i);
      if(CheckPointer(order_stop))
        {
         order_stop.CheckTrailing();
         order_stop.Update();
         order_stop.Check(volume);
        }
     }
  }
//+------------------------------------------------------------------+
