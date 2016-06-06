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
class COrder : public COrderBase
  {
public:
                     COrder(void);
                     COrder(const ulong ticket,const string symbol,const ENUM_ORDER_TYPE type,const double volume,const double price);
                    ~COrder(void);
   virtual bool      IsClosed(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder::COrder(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder::COrder(const ulong ticket,const string symbol,const ENUM_ORDER_TYPE type,const double volume,const double price)
  {
   m_ticket=ticket;
   m_symbol = symbol;
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
bool COrder::IsClosed(void)
  {
   if(m_closed)
     {
      return true;
     }
   if(Volume()<=0.0)
     {
      m_closed=true;
      return true;
     }
   if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
      if(m_main_stop.IsClosed())
        {
         m_closed=true;
         return true;
        }
   return false;
  }
//+------------------------------------------------------------------+
