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
   {
      //Print(__FUNCTION__+" objectfind: "+m_main_stop.EntryName()+" "+ObjectFind(0,m_main_stop.EntryName()));
      //Print(__FUNCTION__+" main order stop exists");
      if(m_main_stop.IsClosed())
        {
         //Print(__FUNCTION__+" main order stop closed: "+m_main_stop.EntryName());
         m_closed=true;
         return true;
        }
      //else Print(__FUNCTION__+" main order stop not closed");
   }     
   /*
   datetime done = (datetime)HistoryOrderGetInteger(m_ticket,ORDER_TIME_DONE);
   if (done>0)
   {
      m_closed = true;
      Print(__FUNCTION__+": main order is already in history: "+done);
      return true;
   }
   */
   return false;
  }
//+------------------------------------------------------------------+
