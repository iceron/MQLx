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
public:
                     JOrder(void);
                     JOrder(const ulong ticket,const string symbol,const ENUM_ORDER_TYPE type,const double volume,const double price);
                    ~JOrder(void);
   virtual bool      IsClosed(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(const ulong ticket,const string symbol,const ENUM_ORDER_TYPE type,const double volume,const double price)
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
JOrder::~JOrder(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrder::IsClosed(void)
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
