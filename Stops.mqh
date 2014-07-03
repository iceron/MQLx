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
private:
protected:
public:
                     JStops();
                     JStops(string name,string sl=".sl.",string tp=".tp.");
                    ~JStops();
   virtual void      AddStops(JStop *stops);
   virtual void      CreateStops(const MqlTradeTransaction &trans);
   virtual void      DeinitStops();
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
JStops::AddStops(JStop *stops)
  {
   Add(stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::CreateStops(const MqlTradeTransaction &trans)
  {
//if(trans.type!=TRADE_TRANSACTION_REQUEST) return;
//if(!(trans.order_state==ORDER_STATE_PARTIAL || trans.order_state==ORDER_STATE_FILLED)) return;
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(stop==NULL) continue;
      stop.Create(trans);
     }
  }
//+------------------------------------------------------------------+
JStops::DeinitStops()
  {
//if(trans.type!=TRADE_TRANSACTION_REQUEST) return;
//if(!(trans.order_state==ORDER_STATE_PARTIAL || trans.order_state==ORDER_STATE_FILLED)) return;
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(stop==NULL) continue;
      stop.Deinit();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::CheckStops(JOrders &orders)
  {
//if(trans.type!=TRADE_TRANSACTION_REQUEST) return;
//if(!(trans.order_state==ORDER_STATE_PARTIAL || trans.order_state==ORDER_STATE_FILLED)) return;
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(stop==NULL) continue;
      stop.Check(orders);
     }
  }
//+------------------------------------------------------------------+
