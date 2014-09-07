//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
class JOrder : public JOrderBase
  {
public:
                     JOrder();
                     JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price);
                    ~JOrder();
   virtual bool      IsClosed();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price)
  {
   m_ticket=ticket;
   m_type=type;
   m_volume_initial=volume;
   m_volume= m_volume_initial;
   m_price = price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::~JOrder()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrder::IsClosed(void)
  {
   if(m_closed) return(true);
   if(Volume()<=0.0)
     {
      m_closed=true;
      return(true);
     }
   if (CheckPointer(m_main_stop)==POINTER_DYNAMIC)
      if (m_main_stop.IsClosed()) 
         return(true);
   return(false);
  }
//+------------------------------------------------------------------+
