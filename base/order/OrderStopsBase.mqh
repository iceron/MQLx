//+------------------------------------------------------------------+
//|                                               OrderStopsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
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
                     JOrderStopsBase(void);
                    ~JOrderStopsBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_ORDERSTOPS);}
   //--- initialization
   virtual void      SetContainer(JOrder *order){m_order=order;}
   virtual void      Deinit();
   //--- checking
   virtual void      Check(double &volume);
   virtual bool      CheckNewTicket(JOrderStop *orderstop) {return(true);}
   virtual bool      Close(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::JOrderStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::~JOrderStopsBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopsBase::Deinit(void)
  {
   for(int i=Total()-1;i>=0;i--)
     {
      JOrderStop *orderstop=At(i);
      orderstop.Deinit();
     }
   Clear();
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
bool JOrderStopsBase::Close(void)
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
