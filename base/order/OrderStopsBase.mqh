//+------------------------------------------------------------------+
//|                                               OrderStopsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "OrderStopBrokerBase.mqh"
#include "OrderStopVirtualBase.mqh"
#include "OrderStopPendingBase.mqh"
class COrder;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopsBase : public CArrayObj
  {
protected:
   bool              m_active;
   COrder           *m_order;
public:
                     COrderStopsBase(void);
                    ~COrderStopsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOPS;}
   bool              Active(){return m_active;}
   void              Active(bool active){m_active=active;}
   //--- initialization
   virtual CObject*  GetContainer(void) {return m_order;}
   virtual void      SetContainer(COrder *order){m_order=order;}
   virtual bool      NewOrderStop(COrder*,CStop*,COrderStops*);
   //--- checking
   virtual void      Check(double &volume);
   virtual bool      CheckNewTicket(COrderStop *) {return true;}
   virtual bool      Close(void);
   //--- hiding and showing of stop lines
   virtual void      Show(const bool);
   //--- recovery
   virtual bool      CreateElement(const int);
   virtual bool      Save(const int);
   virtual bool      Load(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopsBase::COrderStopsBase(void) : m_active(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopsBase::~COrderStopsBase(void)
  {
   Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopsBase::NewOrderStop(COrder *order,CStop *stop,COrderStops *order_stops)
  {
   COrderStop *order_stop=NULL;
   if(CheckPointer(stop))
     {
      switch(stop.StopType())
        {
         case STOP_TYPE_BROKER:  order_stop = new COrderStopBroker();  break;
         case STOP_TYPE_PENDING: order_stop = new COrderStopPending(); break;
         case STOP_TYPE_VIRTUAL: order_stop = new COrderStopVirtual(); break;
        }
     }
   if(CheckPointer(order_stop))
     {
      order_stop.Init(order,stop,order_stops);
      return Add(order_stop);
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopsBase::Check(double &volume)
  {
   if(!Active())
      return;
   int total=Total();
   if(total>0)
     {
      for(int i=0;i<Total();i++)
        {
         COrderStop *order_stop=At(i);
         if(CheckPointer(order_stop))
           {
            if (order_stop.IsClosed())
               continue;
            order_stop.CheckTrailing();
            order_stop.Update();
            order_stop.Check(volume);
            if(!CheckNewTicket(order_stop))
               return;
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
COrderStopsBase::Show(const bool show=true)
  {
   for(int i=0;i<Total();i++)
     {
      COrderStop *orderstop=At(i);
      orderstop.Show(show);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopsBase::CreateElement(const int index)
  {
   return true;
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
#include "..\..\MQL5\Order\OrderStops.mqh"
#else
#include "..\..\MQL4\Order\OrderStops.mqh"
#endif
//+------------------------------------------------------------------+
