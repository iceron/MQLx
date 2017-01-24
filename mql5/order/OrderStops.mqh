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
   virtual void      UpdateVolume(const double);
  };
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
   double factor=new_volume/old_volume;
   for(int i=0;i<Total();i++)
     {
      COrderStop *orderstop=At(i);
      if(!CheckPointer(orderstop))
         continue;
      orderstop.UpdateVolume(factor);
     }
  }
//+------------------------------------------------------------------+
