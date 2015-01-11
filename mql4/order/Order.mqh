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
                     JOrder(const ulong ticket,const ENUM_ORDER_TYPE type,const double volume,const double price);
                    ~JOrder(void);
   virtual bool      IsClosed(void);
   virtual void      Ticket(const ulong ticket) {m_ticket_current=ticket;}
   virtual ulong     Ticket(void) const {return(MathMax(m_ticket_current,m_ticket));}
   virtual void      NewTicket(const bool updated) {m_ticket_updated=updated;}
   virtual bool      NewTicket(void) const {return(m_ticket_updated);}
   virtual int       Compare(const CObject *node,const int mode=0) const;
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
JOrder::JOrder(const ulong ticket,const ENUM_ORDER_TYPE type,const double volume,const double price)
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
//|                                                                  |
//+------------------------------------------------------------------+
int JOrder::Compare(const CObject *node,const int mode=0) const
  {
   int result=0;
   const JOrder *ticket = node;
   if(m_ticket_current>0)
     {
      if(m_ticket_current>ticket.Ticket())
         result=1;
      else if(m_ticket_current<ticket.Ticket())
         result=-1;
      else result = 0;  
     }
   if(m_ticket>0)
     {
      if(m_ticket>ticket.Ticket())
         result=1;
      else if(m_ticket<ticket.Ticket())
         result=-1;
      else result = 0;   
     }   
   return(result);
  }
//+------------------------------------------------------------------+
