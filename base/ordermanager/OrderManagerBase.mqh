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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderManagerBase : public CObject
  {
protected:
   double            m_lotsize;
   int               m_price_points;
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
   COrders           m_orders;
   COrders           m_orders_history;
   CArrayInt         m_other_magic;
   CSymbolInfo      *m_symbol;
   CSymbolManager   *m_symbol_man;
   CTradeManager     m_trade_man;
   CExpertTradeX    *m_trade;
   CMoneys          *m_moneys;
   //--- order objects
   CStops           *m_stops;
   CStop            *m_main_stop;
   //--- container
   CObject          *m_container;
public:
                     COrderManagerBase(void);
                    ~COrderManagerBase(void);
   //--- initialization
   virtual bool      Init(CExpertAdvisor *s,CSymbolManager *symbolman,CAccountInfo *accountinfo);
   virtual bool      InitStops(CExpertAdvisor *s,CSymbolManager *symbolman,CAccountInfo *accountinfo);
   bool              InitMoneys(CExpertAdvisor *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo);
   bool              InitTrade(void);
   bool              InitOrders(void);
   bool              InitOrdersHistory(void);
   virtual void      SetContainer(CObject *container) {m_container=container;}
   virtual bool      Validate(void) const;
   //--- setters and getters
   void              AsyncMode(const bool async) {m_trade.SetAsyncMode(async);}
   string            Comment(void) const {return m_comment;}
   void              Comment(const string comment){m_comment=comment;}
   bool              EnableTrade(void) const {return m_trade_allowed;}
   void              EnableTrade(bool allowed){m_trade_allowed=allowed;}
   bool              EnableLong(void) const {return m_long_allowed;}
   void              EnableLong(bool allowed){m_long_allowed=allowed;}
   bool              EnableShort(void) const {return m_short_allowed;}
   void              EnableShort(bool allowed){m_short_allowed=allowed;}
   double            LotSize(void) const {return m_lotsize;}
   void              LotSize(const double lotsize){m_lotsize=lotsize;}
   int               Magic(void) const {return m_magic;}
   void              Magic(const int magic) {m_magic=magic;}
   int               MagicClose(void) const {return m_magic;}
   void              MagicClose(const int magic) {}
   virtual uint      MaxTrades(void) const {return m_max_trades;}
   virtual void      MaxTrades(const int max_trades){m_max_trades=max_trades;}
   virtual int       MaxOrders(void) const {return m_max_orders;}
   virtual void      MaxOrders(const int max_orders) {m_max_orders=max_orders;}
   int               MaxOrdersHistory(void) const {return m_max_orders_history;}
   void              MaxOrdersHistory(const int max) {m_max_orders_history=max;}
   int               OrdersTotal(void) const {return m_orders.Total();}
   int               OrdersHistoryTotal(void) const {return m_orders_history.Total();}
   int               PricePoints(void) const {return m_price_points;}
   void              PricePoints(const int points) {m_price_points=points;}
   int               TradesTotal(void) const{return m_orders.Total()+m_orders_history.Total()+m_history_count;}
   //--- object pointers
   CStop            *MainStop(void) const {return m_main_stop;}
   CMoneys          *Moneys(void) const {return GetPointer(m_moneys);}
   COrders          *Orders(void) {return GetPointer(m_orders);}
   COrders          *OrdersHistory() {return GetPointer(m_orders_history);}
   CStops           *Stops(void) const {return GetPointer(m_stops);}
   CArrayInt        *OtherMagic(void) {return GetPointer(m_other_magic);}
   //--- current orders
   virtual void      ArchiveOrders(void);
   virtual bool      ArchiveOrder(COrder*);
   virtual void      CheckClosedOrders(void);
   //virtual void      CheckOldStops(void);
   virtual bool      CloseStops(void);
   virtual void      ManageOrders(void);
   virtual bool      CloseOrder(COrder*,const int) {return true;}
   //--- orders history
   virtual void      ManageOrdersHistory(void);
   //--- money manager
   virtual double    LotSizeCalculate(const double,const ENUM_ORDER_TYPE,const double);
   virtual bool      AddMoneys(CMoneys*);
   //--- stop levels  
   virtual bool      AddStops(CStops*);
   //--- trade manager
   virtual bool      AddOtherMagic(const int);
   virtual void      AddOtherMagicString(const string&[]);
   int               Expiration(void) const {return m_expiration;}
   void              Expiration(const int expiration) {m_expiration=expiration;}
   bool              IsPositionAllowed(ENUM_ORDER_TYPE) const;
   virtual bool      TradeOpen(const string,const ENUM_ORDER_TYPE) {return true;}
   //--- events
   virtual void      OnTradeTransaction(COrder*){}
   virtual void      OnTick(void);
protected:
   //--- trade manager
   virtual double    PriceCalculate(ENUM_ORDER_TYPE&);
   virtual double    PriceCalculateCustom(ENUM_ORDER_TYPE&) {return 0;}
   virtual double    StopLossCalculate(const ENUM_ORDER_TYPE,const double);
   virtual double    TakeProfitCalculate(const ENUM_ORDER_TYPE,const double);
   bool              SendOrder(const ENUM_ORDER_TYPE,const double,const double,const double,const double);
   //--- deinitialization  
   virtual void      Deinit(const int);
   virtual void      DeinitStops(void);
   virtual void      DeinitTrade(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManagerBase::COrderManagerBase() : m_lotsize(0.1),
                                         m_price_points(0),
                                         m_comment(NULL),
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
   if(!m_other_magic.IsSorted())
      m_other_magic.Sort();
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
bool COrderManagerBase::Init(CExpertAdvisor *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   m_symbol_man=symbolmanager;

   if(!InitStops(s,symbolmanager,accountinfo))
     {
      Print(__FUNCTION__+": error in stops manager initialization");
      return false;
     }
   if(!InitMoneys(s,symbolmanager,accountinfo))
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
bool COrderManagerBase::SendOrder(const ENUM_ORDER_TYPE type,const double lotsize,const double price,const double sl,const double tp)
  {
   bool ret=0;
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
bool COrderManagerBase::InitMoneys(CExpertAdvisor *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   if(CheckPointer(m_moneys))
     {
      m_moneys.SetContainer(GetPointer(this));
      return m_moneys.Init(symbolmanager,accountinfo);
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
double COrderManagerBase::PriceCalculate(ENUM_ORDER_TYPE &type)
  {
   double price=0;
   double price_points=PricePoints();
   double point = m_symbol.Point();
   switch(type)
     {
      case ORDER_TYPE_BUY:
        {
         double ask = m_symbol.Ask();
         if(price_points>0)
            type = ORDER_TYPE_BUY_STOP;
         else if(price_points<0)
            type = ORDER_TYPE_BUY_LIMIT;
         price=ask+price_points*point;         
         break;
        }
      case ORDER_TYPE_SELL:   
      {
         double bid = m_symbol.Bid();
         if(price_points>0)
            type = ORDER_TYPE_SELL_LIMIT;
         else if(price_points<0)
            type = ORDER_TYPE_SELL_STOP;
         price=bid+price_points*point;   
         break;
      }   
      default: price=PriceCalculateCustom(type);
     }
   return price;
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
bool COrderManagerBase::AddOtherMagic(const int magic)
  {
   if(m_other_magic.Search(magic)>=0)
      return true;
   return m_other_magic.InsertSort(magic);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::AddOtherMagicString(const string &magics[])
  {
   for(int i=0;i<ArraySize(magics);i++)
      AddOtherMagic((int)magics[i]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitStops(CExpertAdvisor *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   if(CheckPointer(m_stops))
     {
      m_stops.SetContainer(GetPointer(this));
      return m_stops.Init(symbolmanager,accountinfo);
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
#ifdef __MQL5__
#include "..\..\MQL5\OrderManager\OrderManager.mqh"
#else
#include "..\..\MQL4\OrderManager\OrderManager.mqh"
#endif
//+------------------------------------------------------------------+
