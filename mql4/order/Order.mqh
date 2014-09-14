//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrder : public JOrderBase
  {
protected:
   ulong             m_ticket_current;
   bool              m_ticket_updated;
public:
                     JOrder(void);
                     JOrder(ulong ticket,ENUM_ORDER_TYPE type,double volume,double price);
                    ~JOrder(void);
   virtual bool      IsClosed(void);
   virtual void      Ticket(ulong ticket) {m_ticket_current=ticket;}
   virtual ulong     Ticket(void) const {return(MathMax(m_ticket_current,m_ticket));}
   virtual void      NewTicket(bool n) {m_ticket_updated=n;}
   virtual bool      NewTicket(void) const {return(m_ticket_updated);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(void): m_ticket_current(0),
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
JOrder::~JOrder(void)
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
