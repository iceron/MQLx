//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
class JOrder : public JOrderBase
  {
protected:
   ulong             m_ticket_current;
   bool              m_ticket_updated;
public:
                     JOrder();
                     JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price);
                    ~JOrder();
   virtual bool      IsClosed();
   virtual void      Ticket(ulong ticket) {m_ticket_current=ticket;}
   virtual ulong     Ticket() {return(MathMax(m_ticket_current,m_ticket));}
   virtual void      NewTicket(bool n) {m_ticket_updated=n;}
   virtual bool      NewTicket() {return(m_ticket_updated);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(): m_ticket_current(0),
                  m_ticket_updated(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price)
  {
   m_ticket=ticket;
   m_ticket_current=ticket;
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
bool JOrder::IsClosed()
  {
   if(m_closed) return(true);
   if(Volume()<=0.0)
     {
      m_closed=true;
      return(true);
     }
   else
     {
      if(OrderSelect((int)Ticket(),SELECT_BY_TICKET))
         if(OrderCloseTime()>0)
           {
            m_closed=true;
            return(true);
           }
     }
   return(false);
  }
//+------------------------------------------------------------------+
