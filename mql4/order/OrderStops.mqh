//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
class JOrderStops : public JOrderStopsBase
  {
public:
                     JOrderStops();
                    ~JOrderStops();
   virtual bool      CheckNewTicket(JOrderStop *orderstop);
   virtual ulong     GetNewTicket(JOrderStop *orderstop);
   virtual bool      UpdateStopsByTicket(ulong ticket);
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
bool JOrderStops::UpdateStopsByTicket(ulong ticket)
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
