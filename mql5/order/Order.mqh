//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrder : public COrderBase
  {
public:
                     COrder(void);
                     COrder(const ulong,const string,const ENUM_ORDER_TYPE,const double,const double);
                    ~COrder(void);
   virtual bool      IsSuspended(void);
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
   m_symbol= symbol;
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
bool COrder::IsSuspended(void)
  {
   if(m_suspend==true)
      return true;
   if(Volume()<=0.0)
     {
      IsSuspended(true);
      return true;
     }
   if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
     {
      if(m_main_stop.IsClosed())
        {
         IsSuspended(true);
         return true;
        }
     }
   if (AccountInfoInteger(ACCOUNT_MARGIN_MODE)==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
   {
      if (!PositionSelectByTicket(Ticket()))
      {
         IsSuspended(true);
         return true;
      }
   }
   return false;
  }
//+------------------------------------------------------------------+
