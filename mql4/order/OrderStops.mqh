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
class JOrderStops : public JOrderStopsBase
  {
public:
                     JOrderStops(void);
                    ~JOrderStops(void);
   virtual bool      CheckNewTicket(JOrderStop *orderstop);
   virtual ulong     GetNewTicket(JOrderStop *orderstop);
   virtual bool      UpdateStopsByTicket(const ulong ticket);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStops::JOrderStops(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStops::~JOrderStops(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStops::CheckNewTicket(JOrderStop *orderstop)
  {
   if(orderstop.NewTicket())
      return(UpdateStopsByTicket(GetNewTicket(orderstop)));
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStops::UpdateStopsByTicket(const ulong ticket)
  {
   bool res=true;
   JOrderStop *order_stop;
   for(int i=0;i<Total();i++)
     {
      order_stop=At(i);
      if(CheckPointer(order_stop))
         if(res) res=order_stop.Recreate();
     }
   if(res) order_stop.NewTicket(false);
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong JOrderStops::GetNewTicket(JOrderStop *orderstop)
  {
   int total= OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()==orderstop.MainMagic())
        {
         orderstop.UpdateTicket(OrderTicket());
         return(OrderTicket());
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
