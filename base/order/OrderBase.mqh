//+------------------------------------------------------------------+
//|                                                    OrderBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
#include "..\File\ExpertFileBase.mqh"
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
   bool              m_initialized;
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
   COrderStops       m_order_stops;
   COrderStop       *m_main_stop;
   COrders          *m_orders;
public:
                     COrderBase(void);
                    ~COrderBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDER;}
   //--- initialization
   virtual COrders *GetContainer(void);
   virtual void      SetContainer(COrders*);
   void              CreateStops(CStops*);
   bool              Init(COrders*,CStops*);
   bool              Initialized(void);
   void              Initialized(bool);
   void              MainStop(COrderStop*);
   COrderStop       *MainStop(void);
   //--- getters and setters     
   void              IsClosed(const bool);
   bool              IsClosed(void) const;
   void              IsSuspended(const bool);
   bool              IsSuspended(void) const;
   void              Magic(const int);
   int               Magic(void) const;
   void              Price(const double);
   double            Price(void) const;
   void              OrderType(const ENUM_ORDER_TYPE);
   ENUM_ORDER_TYPE   OrderType(void) const;
   void              Symbol(const string);
   string            Symbol(void) const;
   void              Ticket(const ulong);
   ulong             Ticket(void) const;
   void              Volume(const double);
   double            Volume(void) const;
   void              VolumeInitial(const double);
   double            VolumeInitial(void) const;
   //--- objects
   COrderStops      *OrderStops(void);
   //--- checking
   void              CheckStops(void);
   //--- hiding and showing of stop lines
   virtual void      ShowStops(const bool);
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
COrderBase::COrderBase(void) : m_initialized(true),
                               m_closed(false),
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Init(COrders *orders,CStops *stops)
  {
   if(CheckPointer(orders))
      SetContainer(GetPointer(orders));
   if(CheckPointer(stops))
      CreateStops(GetPointer(stops));
   m_order_stops.SetContainer(GetPointer(this));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Initialized(void)
  {
   return m_initialized;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderBase::Initialized(bool initialized)
  {
   m_initialized=initialized;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::IsClosed(const bool value)
  {
   m_closed=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::IsClosed(void) const
  {
   return m_closed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::IsSuspended(const bool value)
  {
   m_suspend=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::IsSuspended(void) const
  {
   return m_suspend;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::Magic(const int value)
  {
   m_magic=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderBase::Magic(void) const
  {
   return m_magic;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::Price(const double value)
  {
   m_price=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderBase::Price(void) const
  {
   return m_price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::OrderType(const ENUM_ORDER_TYPE value)
  {
   m_type=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE COrderBase::OrderType(void) const
  {
   return m_type;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::Symbol(const string value)
  {
   m_symbol=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COrderBase::Symbol(void) const
  {
   return m_symbol;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::Ticket(const ulong value)
  {
   m_ticket=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrderBase::Ticket(void) const
  {
   return m_ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::Volume(const double value)
  {
   m_volume=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderBase::Volume(void) const
  {
   return m_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::VolumeInitial(const double value)
  {
   m_volume_initial=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderBase::VolumeInitial(void) const
  {
   return m_volume_initial;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::MainStop(COrderStop *order_stop)
  {
   m_main_stop=order_stop;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStop *COrderBase::MainStop(void)
  {
   return m_main_stop;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::ShowStops(const bool show=true)
  {
   m_order_stops.Show(show);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderBase::SetContainer(COrders *orders)
  {
   m_orders=orders;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrders *COrderBase::GetContainer(void)
  {
   return m_orders;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStops *COrderBase::OrderStops(void)
  {
   return GetPointer(m_order_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderBase::CreateStops(CStops *stops)
  {
   if(!CheckPointer(stops))
      return;
   if(stops.Total()>0)
     {
      for(int i=0;i<stops.Total();i++)
        {
         CStop *stop=stops.At(i);
         if(CheckPointer(stop)==POINTER_INVALID)
            continue;
         m_order_stops.NewOrderStop(GetPointer(this),stop);
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
   m_order_stops.Check(m_volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Close(void)
  {
   IsSuspended(true);
   if(CloseStops())
      IsClosed(true);
   return IsClosed();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::CloseStops(void)
  {
   return m_order_stops.Close();
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
   if(handle==INVALID_HANDLE)
      return false;
   file.WriteBool(m_initialized);
   file.WriteBool(m_closed);
   file.WriteBool(m_suspend);
   file.WriteInteger(m_magic);
   file.WriteDouble(m_price);
   file.WriteLong(m_ticket);
   file.WriteEnum(m_type);
   file.WriteDouble(m_volume);
   file.WriteDouble(m_volume_initial);
   file.WriteString(m_symbol);
   file.WriteObject(GetPointer(m_order_stops));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderBase::Load(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return false;
   if(!file.ReadBool(m_initialized))
      return false;
   if(!file.ReadBool(m_closed))
      return false;
   if(!file.ReadBool(m_suspend))
      return false;
   if(!file.ReadInteger(m_magic))
      return false;
   if(!file.ReadDouble(m_price))
      return false;
   if(!file.ReadLong(m_ticket))
      return false;
   if(!file.ReadEnum(m_type))
      return false;
   if(!file.ReadDouble(m_volume))
      return false;
   if(!file.ReadDouble(m_volume_initial))
      return false;
   if(!file.ReadString(m_symbol))
      return false;
   if(!file.ReadObject(GetPointer(m_order_stops)))
      return false;
   m_order_stops.SetContainer(GetPointer(this));
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\Order.mqh"
#else
#include "..\..\MQL4\Order\Order.mqh"
#endif
//+------------------------------------------------------------------+
