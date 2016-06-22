//+------------------------------------------------------------------+
//|                                                    OrderBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
#include "OrderStopsBase.mqh"
class COrders;
class CStops;
class CStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderBase : public CObject
  {
protected:
   bool              m_closed;
   bool              m_suspend;
   long              m_order_flags;
   int               m_magic;
   double            m_price;
   ulong             m_ticket;
   ENUM_ORDER_TYPE   m_type;
   double            m_volume;
   double            m_volume_initial;
   string            m_symbol;
   COrderStops      *m_order_stops;
   COrderStop       *m_main_stop;
   COrders          *m_orders;
public:
                     COrderBase(void);
                    ~COrderBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDER;}
   //--- initialization
   virtual CObject*  GetContainer(void) {return m_orders;}
   virtual void      SetContainer(COrders *orders){m_orders=orders;}
   //--- getters and setters       
   void              CreateStops(CStops *stops);
   void              CheckStops(void);
   bool              Init(int magic,COrders *orders,CStops *m_stops,bool recreate=false);
   void              IsClosed(const bool closed) {m_closed=closed;}
   bool              IsClosed(void) const {return m_closed;}
   void              IsSuspended(const bool suspend) {m_suspend=suspend;}
   bool              IsSuspended(void) const {return false;}
   void              Magic(const int magic){m_magic=magic;}
   int               Magic(void) const {return m_magic;}
   void              MainStop(COrderStop *order_stop){m_main_stop=order_stop;}
   COrderStop       *MainStop(void) const {return m_main_stop;}
   void              Price(const double price){m_price=price;}
   double            Price(void) const {return m_price;}
   void              OrderType(const ENUM_ORDER_TYPE type){m_type=type;}
   ENUM_ORDER_TYPE   OrderType(void) const {return m_type;}
   void              Symbol(const string symbol) {m_symbol=symbol;}
   string            Symbol(void) const {return m_symbol;}
   void              Ticket(const ulong ticket) {m_ticket=ticket;}
   ulong             Ticket(void) const {return m_ticket;}
   void              Volume(const double volume){m_volume=volume;}
   double            Volume(void) const {return m_volume;}
   void              VolumeInitial(const double volume){m_volume_initial=volume;}
   double            VolumeInitial(void) const {return m_volume_initial;}
   //--- hiding and showing of stop lines
   virtual void      ShowStops(bool show=true) {m_order_stops.Show(show);}
   //--- events
   virtual void      OnTick(void);
   //--- archiving
   virtual bool      Close(void);
   virtual bool      CloseStops(void);
   virtual int       Compare(const CObject*,const int) const;
   //--- output
   virtual string    OrderTypeToString(void) const;
   //--- static methods
   static bool       IsOrderTypeLong(const ENUM_ORDER_TYPE);
   static bool       IsOrderTypeShort(const ENUM_ORDER_TYPE);
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::COrderBase(void) : m_closed(false),
                               m_suspend(false),
                               m_order_flags(0),
                               m_magic(0),
                               m_price(0.0),
                               m_ticket(0),
                               m_type(0),
                               m_volume(0.0),
                               m_volume_initial(0.0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::~COrderBase(void)
  {
   if (CheckPointer(m_order_stops))
      delete m_order_stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Init(int magic,COrders *orders,CStops *stops,bool recreate=false)
  {
   m_magic=magic;
   SetContainer(GetPointer(orders));
   CreateStops(GetPointer(stops));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderBase::CreateStops(CStops *stops)
  {
   if(CheckPointer(stops)==POINTER_INVALID)
      return;
   if(stops.Total()>0)
     {
      if(CheckPointer(m_order_stops)==POINTER_INVALID)
         m_order_stops=new COrderStops();
      for(int i=0;i<stops.Total();i++)
        {
         CStop *stop=stops.At(i);
         if(CheckPointer(stop)==POINTER_INVALID)
            continue;
         m_order_stops.NewOrderStop(GetPointer(this),stop,m_order_stops);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderBase::OnTick(void)
  {
   CheckStops();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderBase::CheckStops(void)
  {
   if (CheckPointer(m_order_stops))
      m_order_stops.Check(m_volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Close(void)
  {
   if(CloseStops())
      IsClosed(true);
   else 
      IsSuspended(true);
   return IsClosed();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::CloseStops(void)
  {
   if (CheckPointer(m_order_stops))
      return m_order_stops.Close();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderBase::Compare(const CObject *node,const int mode=0) const
  {
   const COrder *order=node;
   if(Ticket()>order.Ticket())
      return 1;
   if(Ticket()<order.Ticket())
      return -1;
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COrderBase::OrderTypeToString(void) const
  {
   switch(OrderType())
     {
      case ORDER_TYPE_BUY:          return "BUY";
      case ORDER_TYPE_SELL:         return "SELL";
      case ORDER_TYPE_BUY_LIMIT:    return "BUY LIMIT";
      case ORDER_TYPE_BUY_STOP:     return "BUY STOP";
      case ORDER_TYPE_SELL_LIMIT:   return "SELL LIMIT";
      case ORDER_TYPE_SELL_STOP:    return "SELL STOP";
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::IsOrderTypeLong(const ENUM_ORDER_TYPE type)
  {
   return type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_LIMIT || type==ORDER_TYPE_BUY_STOP;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::IsOrderTypeShort(const ENUM_ORDER_TYPE type)
  {
   return type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_LIMIT || type==ORDER_TYPE_SELL_STOP;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Save(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Load(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\Order.mqh"
#else
#include "..\..\MQL4\Order\Order.mqh"
#endif
//+------------------------------------------------------------------+
