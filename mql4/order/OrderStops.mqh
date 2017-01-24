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
   virtual bool      CheckNewTicket(COrderStop*);
   virtual ulong     GetNewTicket(COrderStop*);
   virtual bool      UpdateStopsByTicket(const ulong);
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
bool COrderStops::CheckNewTicket(COrderStop *orderstop)
  {
   if(orderstop.NewTicket())
      return UpdateStopsByTicket(GetNewTicket(orderstop));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStops::UpdateStopsByTicket(const ulong ticket)
  {
   bool res=true;
   COrderStop *order_stop;
   for(int i=0;i<Total();i++)
     {
      order_stop=At(i);
      if(CheckPointer(order_stop))
         if(res) res=order_stop.RecreateStops();
     }
   if(res)
      order_stop.NewTicket(false);
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrderStops::GetNewTicket(COrderStop *orderstop)
  {
   int total= OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()==orderstop.MainMagic())
        {
         orderstop.UpdateTicket(OrderTicket());
         return OrderTicket();
        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
