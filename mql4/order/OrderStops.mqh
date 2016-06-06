//+------------------------------------------------------------------+
//|                                                   OrderStops.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStops : public COrderStopsBase
  {
public:
                     COrderStops(void);
                    ~COrderStops(void);
   virtual bool      CheckNewTicket(COrderStop *orderstop);
   virtual ulong     GetNewTicket(COrderStop *orderstop);
   virtual bool      UpdateStopsByTicket(const ulong ticket);
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
         if(res) res=order_stop.Recreate();
     }
   if(res) order_stop.NewTicket(false);
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
