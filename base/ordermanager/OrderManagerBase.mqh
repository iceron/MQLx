//+------------------------------------------------------------------+
//|                                             OrderManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayInt.mqh>
#include "..\Lib\AccountInfo.mqh"
#include "..\Money\MoneysBase.mqh"
#include "..\Stop\StopsBase.mqh"
#include "..\Order\OrdersBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
#include "..\File\ExpertFileBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderManagerBase : public CObject
  {
protected:
   double            m_lotsize;
   //int               m_price_points;
   string            m_comment;
   int               m_magic;
   int               m_expiration;
   int               m_history_count;
   int               m_max_orders_history;
   bool              m_trade_allowed;
   bool              m_long_allowed;
   bool              m_short_allowed;
   int               m_max_orders;
   int               m_max_trades;
   COrder           *m_latest_order;
   COrders           m_orders;
   COrders           m_orders_history;
   CAccountInfo     *m_account;
   CSymbolInfo      *m_symbol;
   CSymbolManager   *m_symbol_man;
   CTradeManager     m_trade_man;
   CExpertTradeX    *m_trade;
   CMoneys          *m_moneys;
   CStops           *m_stops;
   CStop            *m_main_stop;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     COrderManagerBase(void);
                    ~COrderManagerBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_ORDER_MANAGER);}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   virtual bool      InitStops(void);
   bool              InitMoneys(void);
   bool              InitTrade(void);
   bool              InitOrders(void);
   bool              InitOrdersHistory(void);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   virtual bool      Validate(void) const;
   //--- setters and getters
   string            Comment(void) const;
   void              Comment(const string);
   bool              EnableTrade(void) const;
   void              EnableTrade(bool);
   bool              EnableLong(void) const;
   void              EnableLong(bool);
   bool              EnableShort(void) const;
   void              EnableShort(bool);
   int               Expiration(void) const;
   void              Expiration(const int expiration);
   double            LotSize(void) const;
   void              LotSize(const double);
   int               Magic(void) const;
   void              Magic(const int);
   int               MagicClose(void) const;
   void              MagicClose(const int);
   virtual uint      MaxTrades(void) const;
   virtual void      MaxTrades(const int);
   virtual int       MaxOrders(void) const;
   virtual void      MaxOrders(const int);
   int               MaxOrdersHistory(void) const;
   void              MaxOrdersHistory(const int);
   int               OrdersTotal(void) const;
   int               OrdersHistoryTotal(void) const;
   int               PricePoints(void) const;
   void              PricePoints(const int);
   int               TradesTotal(void) const;
   //--- object pointers
   CStop            *MainStop(void) const;
   CMoneys          *Moneys(void) const;
   COrder           *LatestOrder(void);
   void              LatestOrder(COrder*);
   COrders          *Orders(void);
   COrders          *OrdersHistory(void);
   CStops           *Stops(void) const;
   //--- current orders
   virtual void      ArchiveOrders(void);
   virtual bool      ArchiveOrder(COrder*);
   virtual void      CheckClosedOrders(void);
   virtual bool      CloseStops(void);
   virtual void      ManageOrders(void);
   virtual bool      CloseOrder(COrder*,const int);
   //--- orders history
   virtual void      ManageOrdersHistory(void);
   //--- money manager
   virtual double    LotSizeCalculate(const double,const ENUM_ORDER_TYPE,const double);
   virtual bool      AddMoneys(CMoneys*);
   //--- stop levels  
   virtual bool      AddStops(CStops*);
   //--- trade manager
   virtual bool      IsHedging(void) const;
   bool              IsPositionAllowed(ENUM_ORDER_TYPE) const;
   virtual bool      TradeOpen(const string,ENUM_ORDER_TYPE,double,bool);
   //--- events
   virtual void      OnTradeTransaction(COrder*);
   virtual void      OnTick(void);
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);
protected:
   //--- trade manager
   int               FindOrderIndex(COrder*,const bool);
   virtual double    PriceCalculate(ENUM_ORDER_TYPE&,double);
   virtual double    PriceCalculateCustom(ENUM_ORDER_TYPE&,double);
   virtual double    StopLossCalculate(const ENUM_ORDER_TYPE,const double);
   virtual double    TakeProfitCalculate(const ENUM_ORDER_TYPE,const double);
   ulong             SendOrder(const ENUM_ORDER_TYPE,const double,const double,const double,const double);
   //--- deinitialization  
   virtual void      Deinit(const int);
   virtual void      DeinitStops(void);
   virtual void      DeinitTrade(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManagerBase::COrderManagerBase() : m_lotsize(0.1),
                                         m_comment(""),
                                         m_magic(0),
                                         m_expiration(0),
                                         m_history_count(0),
                                         m_max_orders_history(1000),
                                         m_trade_allowed(true),
                                         m_long_allowed(true),
                                         m_short_allowed(true),
                                         m_max_orders(1),
                                         m_max_trades(-1)

  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManagerBase::~COrderManagerBase()
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *COrderManagerBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COrderManagerBase::Comment(void) const
  {
   return m_comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::Comment(const string comment)
  {
   m_comment=comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::EnableTrade(void) const
  {
   return m_trade_allowed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::EnableTrade(bool allowed)
  {
   m_trade_allowed=allowed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::EnableLong(void) const
  {
   return m_long_allowed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::EnableLong(bool allowed)
  {
   m_long_allowed=allowed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::EnableShort(void) const
  {
   return m_short_allowed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::EnableShort(bool allowed)
  {
   m_short_allowed=allowed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::LotSize(void) const
  {
   return m_lotsize;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::LotSize(const double lotsize)
  {
   m_lotsize=lotsize;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::Magic(void) const
  {
   return m_magic;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::Magic(const int magic)
  {
   m_magic=magic;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::MagicClose(void) const
  {
   return m_magic;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::MagicClose(const int magic)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint COrderManagerBase::MaxTrades(void) const
  {
   return m_max_trades;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::MaxTrades(const int max_trades)
  {
   m_max_trades=max_trades;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::MaxOrders(void) const
  {
   return m_max_orders;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::MaxOrders(const int max_orders)
  {
   m_max_orders=max_orders;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::MaxOrdersHistory(void) const
  {
   return m_max_orders_history;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::MaxOrdersHistory(const int max)
  {
   m_max_orders_history=max;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::OrdersTotal(void) const
  {
   return m_orders.Total();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::OrdersHistoryTotal(void) const
  {
   return m_orders_history.Total();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::TradesTotal(void) const
  {
   return m_orders.Total()+m_orders_history.Total()+m_history_count;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop *COrderManagerBase::MainStop(void) const
  {
   return m_main_stop;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneys *COrderManagerBase::Moneys(void) const
  {
   return GetPointer(m_moneys);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrders *COrderManagerBase::Orders(void)
  {
   return GetPointer(m_orders);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder *COrderManagerBase::LatestOrder(void)
  {
   return GetPointer(m_latest_order);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::LatestOrder(COrder *latest)
  {
   m_latest_order=latest;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrders *COrderManagerBase::OrdersHistory()
  {
   return GetPointer(m_orders_history);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStops *COrderManagerBase::Stops(void) const
  {
   return GetPointer(m_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::CloseOrder(COrder*,const int)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::Expiration(void) const
  {
   return m_expiration;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::Expiration(const int expiration)
  {
   m_expiration=expiration;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::TradeOpen(const string,ENUM_ORDER_TYPE,double,bool)
  {
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::OnTradeTransaction(COrder*)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManagerBase::FindOrderIndex(COrder *order,const bool history=false)
  {
   if (CheckPointer(order))
   {      
      COrders *orders;
      if (!history)
         orders = GetPointer(m_orders);
      else orders = GetPointer(m_orders_history);
      for (int i=0;i<orders.Total();i++)
      {
         COrder *ord = orders.At(i);
         if (!CheckPointer(ord))
            continue;
         if (order.Compare(GetPointer(ord)))
            return i;
      }
   }   
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::PriceCalculateCustom(ENUM_ORDER_TYPE &type,double points=0)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::Init(CSymbolManager *symbol_man,CAccountInfo *account,CEventAggregator *event_man=NULL)
  {
   m_symbol_man=symbol_man;
   m_account=account;
   m_event_man=event_man;
   if(!InitStops())
     {
      Print(__FUNCTION__+": error in stops manager initialization");
      return false;
     }
   if(!InitMoneys())
     {
      Print(__FUNCTION__+": error in money manager initialization");
      return false;
     }
   if(!InitTrade())
     {
      Print(__FUNCTION__+": error in trade object initialization");
      return false;
     }
   if(!InitOrders())
     {
      Print(__FUNCTION__+": error in orders initialization");
      return false;
     }
   if(!InitOrdersHistory())
     {
      Print(__FUNCTION__+": error in orders history initialization");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrderManagerBase::SendOrder(const ENUM_ORDER_TYPE type,const double lotsize,const double price,const double sl,const double tp)
  {
   ulong ret=false;
   if(CheckPointer(m_symbol))
      m_trade=m_trade_man.Get(m_symbol.Name());
   if(CheckPointer(m_trade))
     {
      if(COrder::IsOrderTypeLong(type))
         ret=m_trade.Buy(lotsize,price,sl,tp,m_comment);
      if(COrder::IsOrderTypeShort(type))
         ret=m_trade.Sell(lotsize,price,sl,tp,m_comment);
     }
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitMoneys(void)
  {
   if(CheckPointer(m_moneys))
     {
      m_moneys.SetContainer(GetPointer(this));
      return m_moneys.Init(m_symbol_man,m_account);
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitTrade()
  {
   for(int i=0;i<m_symbol_man.Total();i++)
     {
      CSymbolInfo *symbol=m_symbol_man.At(i);
      CExpertTradeX *trade=new CExpertTradeX();
      if(CheckPointer(trade))
        {
         trade.SetSymbol(GetPointer(symbol));
         trade.SetExpertMagicNumber(m_magic);
         trade.SetDeviationInPoints((ulong)(30/symbol.Point()));
         trade.SetOrderExpiration(m_expiration);
         m_trade_man.Add(trade);
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitOrders(void)
  {
   m_orders.SetContainer(GetPointer(this));
   return m_orders.Init(m_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitOrdersHistory(void)
  {
   m_orders_history.SetContainer(GetPointer(this));
   return m_orders_history.Init(m_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::Validate(void) const
  {
   if(CheckPointer(m_moneys)==POINTER_DYNAMIC)
     {
      if(!m_moneys.Validate())
         return false;
     }
   if(CheckPointer(m_stops)==POINTER_DYNAMIC)
     {
      if(!m_stops.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::ArchiveOrders(void)
  {
   bool result=false;
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
      ArchiveOrder(m_orders.Detach(i));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::ArchiveOrder(COrder *order)
  {
   return m_orders_history.Add(order);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::CloseStops(void)
  {
   return m_orders.CloseStops();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::ManageOrders(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::ManageOrdersHistory(void)
  {
   int excess=m_orders_history.Total()-m_max_orders_history;
   if(excess>0)
      m_orders_history.DeleteRange(0,excess-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::OnTick(void)
  {
   ManageOrdersHistory();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::IsPositionAllowed(ENUM_ORDER_TYPE type) const
  {
   return EnableTrade() && ((COrder::IsOrderTypeLong(type) && EnableLong())
                      || (COrder::IsOrderTypeShort(type) && EnableShort()));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::IsHedging(void) const
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::PriceCalculate(ENUM_ORDER_TYPE &type,double points=0)
  {
   double price=0;
   double point=m_symbol.Point();
   double ask=m_symbol.Ask();  
   double bid=m_symbol.Bid();
   switch(type)
     {
      case ORDER_TYPE_BUY:
        {              
         if(points>0)
            type=ORDER_TYPE_BUY_STOP;
         else if(points<0)
            type=ORDER_TYPE_BUY_LIMIT;
         else price = ask;
         break;
        }
      case ORDER_TYPE_SELL:
        {         
         if(points>0)
            type=ORDER_TYPE_SELL_LIMIT;
         else if(points<0)
            type=ORDER_TYPE_SELL_STOP;
         else price = bid;
         break;
        }
      case ORDER_TYPE_BUY_LIMIT:
        {
         price=ask-points*point;
         break;
        }
      case ORDER_TYPE_BUY_STOP:
        {
         price=ask+points*point;
         break;
        }
      case ORDER_TYPE_SELL_LIMIT:
        {
         price=bid+points*point;
         break;
        }
      case ORDER_TYPE_SELL_STOP:
        {
         price=bid-points*point;
         break;
        }
      default: price=PriceCalculateCustom(type,points);
     }
   return NormalizeDouble(price,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::StopLossCalculate(const ENUM_ORDER_TYPE type,const double price)
  {
   if(CheckPointer(m_main_stop))
      return m_main_stop.StopLossTicks(type,price);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::TakeProfitCalculate(const ENUM_ORDER_TYPE type,const double price)
  {
   if(CheckPointer(m_main_stop))
      return m_main_stop.TakeProfitTicks(type,price);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitStops()
  {
   if(CheckPointer(m_stops))
     {
      m_stops.SetContainer(GetPointer(this));
      return m_stops.Init(m_symbol_man,m_account,m_event_man);
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::AddStops(CStops *stops)
  {
   if(CheckPointer(stops)==POINTER_DYNAMIC)
     {
      m_stops=stops;
      m_main_stop=m_stops.Main();
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::Deinit(const int reason=0)
  {
   DeinitStops();
   DeinitTrade();
   m_orders.Shutdown();
   m_orders_history.Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::DeinitStops()
  {
   if(CheckPointer(m_stops))
      delete m_stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::DeinitTrade()
  {
   m_trade_man.Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::AddMoneys(CMoneys *moneys)
  {
   if(CheckPointer(moneys)==POINTER_DYNAMIC)
      m_moneys=moneys;
   return CheckPointer(m_moneys);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::LotSizeCalculate(const double price,const ENUM_ORDER_TYPE type,const double stoploss)
  {
   if(CheckPointer(m_moneys))
      return m_moneys.Volume(m_symbol.Name(),0,type,stoploss);
   return m_lotsize;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::Save(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return false;
   file.WriteDouble(m_lotsize);
//file.WriteInteger(m_price_points);
   file.WriteString(m_comment);
   file.WriteInteger(m_expiration);
   file.WriteInteger(m_history_count);
   file.WriteInteger(m_max_orders_history);
   file.WriteBool(m_trade_allowed);
   file.WriteBool(m_long_allowed);
   file.WriteBool(m_short_allowed);
   file.WriteInteger(m_max_orders);
   file.WriteInteger(m_max_trades);
   file.WriteObject(GetPointer(m_orders));
   file.WriteObject(GetPointer(m_orders_history));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::Load(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return false;
   if(!file.ReadDouble(m_lotsize))
      return false;
   if(!file.ReadString(m_comment))
      return false;
   if(!file.ReadInteger(m_expiration))
      return false;
   if(!file.ReadInteger(m_history_count))
      return false;
   if(!file.ReadInteger(m_max_orders_history))
      return false;
   if(!file.ReadBool(m_trade_allowed))
      return false;
   if(!file.ReadBool(m_long_allowed))
      return false;
   if(!file.ReadBool(m_short_allowed))
      return false;
   if(!file.ReadInteger(m_max_orders))
      return false;
   if(!file.ReadInteger(m_max_trades))
      return false;
   if(!file.ReadObject(GetPointer(m_orders)))
      return false;
   if(!file.ReadObject(GetPointer(m_orders_history)))
      return false;
   for(int i=0;i<m_orders.Total();i++)
     {
      COrder *order=m_orders.At(i);
      if(!CheckPointer(order))
         continue;
      COrderStops *orderstops=order.OrderStops();
      if(!CheckPointer(orderstops))
         continue;
      for(int j=0;j<orderstops.Total();j++)
        {
         COrderStop *orderstop=orderstops.At(j);
         if(!CheckPointer(orderstop))
            continue;
         for(int k=0;k<m_stops.Total();k++)
           {
            CStop *stop=m_stops.At(k);
            if(!CheckPointer(stop))
               continue;
            orderstop.Order(order);
            if(StringCompare(orderstop.StopName(),stop.Name())==0)
              {
               orderstop.Stop(stop);
               orderstop.Recreate();
              }
           }
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\OrderManager\OrderManager.mqh"
#else
#include "..\..\MQL4\OrderManager\OrderManager.mqh"
#endif
//+------------------------------------------------------------------+
