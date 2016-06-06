//+------------------------------------------------------------------+
//|                                               OrderStopsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "OrderStopBase.mqh"
class COrder;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopsBase : public CArrayObj
  {
protected:
   COrder           *m_order;
public:
                     COrderStopsBase(void);
                    ~COrderStopsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOPS;}
   //--- initialization
   virtual void      SetContainer(COrder *order){m_order=order;}
   virtual bool      NewOrderStop(COrder *order,CStop *stop,COrderStops *order_stops);
   //--- checking
   virtual void      Check(double &volume);
   virtual bool      CheckNewTicket(COrderStop *orderstop) {return true;}
   virtual bool      Close(void);
   //--- hiding and showing of stop lines
   virtual void      Show(bool show=true);
   //--- recovery
   virtual bool      CreateElement(const int index);
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopsBase::COrderStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopsBase::~COrderStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopsBase::NewOrderStop(COrder *order,CStop *stop,COrderStops *order_stops)
  {
   COrderStop *order_stop=new COrderStop();
   order_stop.Init(order,stop,order_stops);
   return Add(order_stop);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopsBase::Check(double &volume)
  {
   int total=Total();
   if(total>0)
     {
      for(int i=0;i<Total();i++)
        {
         COrderStop *order_stop=At(i);
         if(CheckPointer(order_stop))
           {
            order_stop.CheckTrailing();
            order_stop.Update();
            order_stop.Check(volume);
            if(!CheckNewTicket(order_stop)) return;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopsBase::Close(void)
  {
   bool res=true;
   int total=Total();
   if(total>0)
     {
      for(int i=0;i<total;i++)
        {
         COrderStop *order_stop=At(i);
         if(CheckPointer(order_stop))
           {
            if(!order_stop.Close())
               res=false;
           }
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopsBase::Show(bool show=true)
  {
   for (int i=0;i<Total();i++)
   {
      COrderStop *orderstop = At(i);
      orderstop.Show(show);
   }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopsBase::CreateElement(const int index)
  {
   COrderStop * orderstop = new COrderStop();
   orderstop.SetContainer(GetPointer(this));
   return Insert(GetPointer(orderstop),index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopsBase::Save(const int handle)
  {  
   CArrayObj::Save(handle);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopsBase::Load(const int handle)
  {
   CArrayObj::Load(handle);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\OrderStops.mqh"
#else
#include "..\..\mql4\order\OrderStops.mqh"
#endif
//+------------------------------------------------------------------+
