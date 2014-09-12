//+------------------------------------------------------------------+
//|                                                   OrderStops.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
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
public:
                     JOrderStopsBase();
                    ~JOrderStopsBase();
   virtual void      Check(double &volume);
   virtual bool      CheckNewTicket(JOrderStop *orderstop) {return(true);}
   virtual bool      Close();
   virtual void      SetContainer(JOrder *order){m_order=order;}
   virtual int       Type() {return(CLASS_TYPE_ORDERSTOPS);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::JOrderStopsBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::~JOrderStopsBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::Check(double &volume)
  {
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopsBase::Close()
  {
   bool res=true;
   for(int i=0;i<Total();i++)
     {
      JOrderStop *order_stop=At(i);
      if(CheckPointer(order_stop))
        {
         if(!order_stop.Close())
            res=false;
        }
     }
   return(res);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\OrderStops.mqh"
#else
#include "..\..\mql4\order\OrderStops.mqh"
#endif
//+------------------------------------------------------------------+
