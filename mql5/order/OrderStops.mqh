//+------------------------------------------------------------------+
//|                                                   OrderStops.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStops : public COrderStopsBase
  {
public:
                     COrderStops(void);
                    ~COrderStops(void);
   virtual bool      NewOrderStop(COrder*,CStop*);
   virtual void      UpdateVolume(const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStops::NewOrderStop(COrder *order,CStop *stop)
  {
   COrderStop *order_stop=NULL;
   if(CheckPointer(stop))
     {
      switch(stop.StopType())
        {
         case STOP_TYPE_BROKER:  
         {
            if (stop.IsHedging())
               order_stop = new COrderStopBroker(); 
            else 
               order_stop = new COrderStopPending();  
            break;
         }
         case STOP_TYPE_PENDING: order_stop = new COrderStopPending(); break;
         case STOP_TYPE_VIRTUAL: order_stop = new COrderStopVirtual(); break;
        }
     }
   if(CheckPointer(order_stop))
     {
      order_stop.Init(order,stop,GetPointer(this));
      return Add(order_stop);
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStops::COrderStops(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStops::~COrderStops(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStops::UpdateVolume(double deducted)
  {
   double old_volume = m_order.Volume()+deducted;
   double new_volume = m_order.Volume();
   double factor = 0;
   if (old_volume>0)
      factor=new_volume/old_volume;
   for(int i=0;i<Total();i++)
     {
      COrderStop *orderstop=At(i);
      if(!CheckPointer(orderstop))
         continue;
      orderstop.UpdateVolume(factor);
     }
  }
//+------------------------------------------------------------------+
