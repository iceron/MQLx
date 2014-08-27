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
protected:
   bool              m_activate;
public:
                     JStops();
                     JStops(string name,string sl=".sl.",string tp=".tp.");
                    ~JStops();
   virtual void      CreateStops(ulong order_ticket,int order_type,double volume,double price);
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::JStops() : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStops::~JStops()
  {
  }
//+------------------------------------------------------------------+
