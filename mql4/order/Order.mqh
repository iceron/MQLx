//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayInt.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrder : public COrderBase
  {
protected:
   CArrayInt         m_ticket_current;
   bool              m_ticket_updated;
public:
                     COrder(void);
                     COrder(const ulong ticket,const string symbol,const ENUM_ORDER_TYPE type,const double volume,const double price);
                    ~COrder(void);
   virtual int       Compare(const CObject*,const int) const;
   virtual bool      IsSuspended(void);
   virtual void      OnTick(void);
   virtual void      Ticket(const ulong ticket);
   virtual ulong     Ticket(void) const;
   virtual void      NewTicket(const bool updated);
   virtual bool      NewTicket(void) const;
   //--- recovery
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder::COrder(void): m_ticket_updated(false)
  {
   if(!m_ticket_current.IsSorted())
      m_ticket_current.Sort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder::COrder(const ulong ticket,const string symbol,const ENUM_ORDER_TYPE type,const double volume,const double price)
  {
   if(!m_ticket_current.IsSorted())
      m_ticket_current.Sort();
   m_ticket=ticket;
   m_ticket_current.InsertSort((int)ticket);
   m_symbol=symbol;
   m_type=type;
   m_volume_initial=volume;
   m_volume= m_volume_initial;
   m_price = price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder::~COrder(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder::Ticket(const ulong ticket)
  {
   m_ticket_current.InsertSort((int)ticket);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrder::Ticket(void) const
  {
   return m_ticket_current.At(m_ticket_current.Total()-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder::NewTicket(const bool updated)
  {
   m_ticket_updated=updated;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrder::NewTicket(void) const
  {
   return m_ticket_updated;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrder::IsSuspended(void)
  {
   if(m_suspend==true)
      return true;
   if(OrdersTotal()==0)
     {
      IsSuspended(true);
      return true;
     }
   if(Volume()<=0.0)
     {
      IsSuspended(true);
      return true;
     }
   if(OrderSelect((int)Ticket(),SELECT_BY_TICKET))
     {
      if(OrderCloseTime()>0)
        {
         IsSuspended(true);
         return true;
        }
     }
   if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
     {
      if(m_main_stop.IsClosed())
        {
         IsSuspended(true);
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrder::Compare(const CObject *node,const int mode=0) const
  {
   const COrder *order=node;
   for(int i=0;i<m_ticket_current.Total();i++)
     {
      int ticket=m_ticket_current.At(i);
      if(ticket==order.Ticket())
         return 0;
     }
   return COrderBase::Compare(node,mode);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrder::OnTick(void)
  {
   if(!Initialized())
     {
      if(OrderSelect((int)Ticket(),SELECT_BY_TICKET))
        {
         m_type=(ENUM_ORDER_TYPE)::OrderType();
         if(m_type<=1)
           {
            if(Init(m_orders,m_orders.Stops()))
               Initialized(true);
           }
        }
     }
   if(Initialized())
      COrderBase::OnTick();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrder::Save(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrder::Load(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
