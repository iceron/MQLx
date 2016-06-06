//+------------------------------------------------------------------+
//|                                             COrderManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#property strict
class CStrategy;
#include <Arrays\ArrayInt.mqh>
#include "..\lib\AccountInfo.mqh"
//#include "..\lib\SymbolInfo.mqh"
#include "..\..\common\class\ADT.mqh"
#include "..\order\OrdersBase.mqh"
#include "..\stop\StopsBase.mqh"
#include "..\signal\SignalsBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderManagerBase : public CObject
  {
protected:
   double            m_lotsize;
   COrders           m_orders;
   COrders           m_orders_history;
   string            m_comment;
   int               m_magic;
   int               m_expiration;
   int               m_history_count;
   bool              m_position_reverse;
   int               m_max_orders_history;
   bool              m_trade_allowed;
   bool              m_long_allowed;
   bool              m_short_allowed;
   int               m_max_orders;
   int               m_max_trades;
   CArrayInt         m_other_magic;
   CSymbolInfo      *m_symbol;
   CSymbolManager   *m_symbol_man;
   JTrade           *m_trade;
   //CTradeManager    *m_trade_man;
   CMoneys          *m_moneys;
   //--- order objects
   CStops           *m_stops;
   CStop            *m_main_stop;
public:
                     COrderManagerBase();
                    ~COrderManagerBase();
   //--- initialization
   virtual bool      Init(CStrategy *s,CSymbolManager *symbolman,CAccountInfo *accountinfo);
   virtual bool      InitStops(CStrategy *s,CSymbolManager *symbolman,CAccountInfo *accountinfo);
   bool              InitMoneys(CStrategy *s,CSymbolInfo *symbolinfo,CAccountInfo *accountinfo);
   bool              InitTrade(JTrade*);
   bool              InitOrders(void);
   bool              InitOrdersHistory(void);
   virtual bool      Validate(void) const;
   //--- setters and getters
   bool              IsPositionAllowed(ENUM_ORDER_TYPE) const;
   bool              EnableTrade(void) const {return m_trade_allowed;}
   void              EnableTrade(bool allowed){m_trade_allowed=allowed;}
   bool              EnableLong(void) const {return m_long_allowed;}
   void              EnableLong(bool allowed){m_long_allowed=allowed;}
   bool              EnableShort(void) const {return m_short_allowed;}
   void              EnableShort(bool allowed){m_short_allowed=allowed;}
   int               TradesTotal(void) const{return m_orders.Total()+m_orders_history.Total()+m_history_count;}
   virtual uint      MaxTrades(void) const {return m_max_trades;}
   virtual void      MaxTrades(const int max_trades){m_max_trades=max_trades;}
   virtual int       MaxOrders(void) const {return m_max_orders;}
   virtual void      MaxOrders(const int max_orders) {m_max_orders=max_orders;}
   int               Magic(void) const {return m_magic;}
   void              Magic(const int magic) {m_magic=magic;}
   double            LotSize(void) const {return m_lotsize;}
   void              LotSize(const double lotsize){m_lotsize=lotsize;}
   string            Comment(void) const {return m_comment;}
   void              Comment(const string comment){m_comment=comment;}
   int               MaxOrdersHistory(void) const {return m_max_orders_history;}
   void              MaxOrdersHistory(const int max) {m_max_orders_history=max;}
   void              AsyncMode(const bool async) {m_trade.SetAsyncMode(async);}
   int               OrdersTotal(void) const {return m_orders.Total();}
   int               OrdersHistoryTotal(void) const {return m_orders_history.Total();}
   //--- object pointers
   CStop             *MainStop(void) const {return m_main_stop;}
   CMoneys           *Moneys(void) const {return GetPointer(m_moneys);}
   COrders           *Orders() {return GetPointer(m_orders);}
   COrders           *OrdersHistory() {return GetPointer(m_orders_history);}
   CStops            *Stops(void) const {return GetPointer(m_stops);}
   CArrayInt         *OtherMagic() {return GetPointer(m_other_magic);}
   //--- current orders
   virtual void      ArchiveOrders(void);
   virtual bool      ArchiveOrder(COrder*);
   virtual void      CheckClosedOrders(void);
   virtual void      CheckOldStops(void);
   virtual void      CloseOrders(const int,const int);
   virtual bool      CloseStops(void);
   virtual void      CloseOppositeOrders(const int,const int);
   virtual void      ManageOrders(void);
   virtual bool      CloseOrder(COrder*,const int) {return true;}
   //--- orders history
   virtual void      ManageOrdersHistory(void);
   //--- money manager
   virtual double    LotSizeCalculate(double,ENUM_ORDER_TYPE,double);
   virtual bool      AddMoneys(CMoneys*);
   //--- stop levels  
   virtual bool      AddStops(CStops*);
   //--- symbol manager
   virtual bool      SetSymbol(CSymbolInfo*);
   //--- trade manager
   int               Expiration(void) const {return m_expiration;}
   void              Expiration(const int expiration) {m_expiration=expiration;}
   virtual bool      AddOtherMagic(const int);
   virtual void      AddOtherMagicString(const string&[]);
   virtual bool      TradeOpen(const string,const int) {return true;}
   //--- events
   virtual void      OnTradeTransaction(COrder *){}
   virtual void      OnTick();
protected:
   //--- trade manager
   virtual double    PriceCalculate(ENUM_ORDER_TYPE);
   virtual double    PriceCalculateCustom(const int) {return 0;}
   virtual double    StopLossCalculate(const int,const double);
   virtual double    TakeProfitCalculate(const int,const double);
   bool              SendOrder(const ENUM_ORDER_TYPE,const double,const double,const double,const double);

   //--- deinitialization  
   virtual void      Deinit(const int);
   virtual void      DeinitStops();
   virtual void      DeinitTrade();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManagerBase::COrderManagerBase() : m_lotsize(0.1),
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
bool COrderManagerBase::Init(CStrategy *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {

   InitStops(s,symbolmanager,accountinfo);
   //InitMoneys(s,symbolinfo,accountinfo);
   InitTrade();
   InitOrders();
   InitOrdersHistory();
   
   m_symbol_man=symbolmanager;
//m_account = accountinfo;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::SetSymbol(CSymbolInfo *symbol)
  {
   if(CheckPointer(symbol)==POINTER_DYNAMIC)
      m_symbol=symbol;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::SendOrder(const ENUM_ORDER_TYPE type,const double lotsize,const double price,const double sl,const double tp)
  {
   bool ret=0;
   if (CheckPointer(GetPointer(m_symbol))==POINTER_DYNAMIC)
      m_trade.SetSymbol(GetPointer(m_symbol));
   if(COrder::IsOrderTypeLong(type))
      ret=m_trade.Buy(lotsize,price,sl,tp,m_comment);
   if(COrder::IsOrderTypeShort(type))
      ret=m_trade.Sell(lotsize,price,sl,tp,m_comment);
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitMoneys(CStrategy *s,CSymbolInfo *symbolinfo,CAccountInfo *accountinfo)
  {
   if(m_moneys==NULL) return true;
   return m_moneys.Init(s,symbolinfo,accountinfo);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitTrade(JTrade *trade=NULL)
  {

   if(m_trade!=NULL)
      delete m_trade;
   if(trade==NULL)
     {
      if((m_trade=new JTrade)==NULL)
         return false;
     }
   else m_trade=trade;
   //m_trade.SetSymbol(GetPointer(m_symbol));
   m_trade.SetExpertMagicNumber(m_magic);
   //m_trade.SetDeviationInPoints((ulong)(3*m_digits_adjust/m_symbol.Point()));
   //m_trade.SetOrderExpiration(m_expiration);
   
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitOrders(void)
  {
   return m_orders.Init(NULL,m_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::InitOrdersHistory(void)
  {
   return m_orders_history.Init(NULL,m_stops);
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
   bool result=m_orders_history.Add(order);
   if(result)
      m_orders_history.Clean(false);
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::CheckClosedOrders(void)
  {
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
     {
      COrder *order=m_orders.At(i);
      ulong ticket = order.Ticket();
      if(order.IsClosed())
         ArchiveOrder(m_orders.Detach(i));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::CheckOldStops(void)
  {
   if(m_orders_history.Clean())
      return;
   bool status=true;
   for(int i=m_orders_history.Total()-1;i>=0;i--)
     {
      COrder *order=m_orders_history.At(i);
      if(order.Clean())
         continue;
      if(order.CloseStops())
         order.Clean(true);
      else
        {
         if(status)
            status=false;
        }
     }
   m_orders_history.Clean(status);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::CloseOrders(const int entry,const int exit)
  {
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
     {
      COrder *order=m_orders.At(i);
      if((CSignal::IsOrderAgainstSignal((ENUM_ORDER_TYPE) order.OrderType(),(ENUM_CMD) entry) && m_position_reverse) ||
         (CSignal::IsOrderAgainstSignal((ENUM_ORDER_TYPE) order.OrderType(),(ENUM_CMD) exit)))
        {
         CloseOrder(order,i);
        }
     }
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
COrderManagerBase::CloseOppositeOrders(const int entry,const int exit)
  {
   if(m_orders.Total()>0)
      CloseOrders(entry,exit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::ManageOrders(void)
  {   
   CheckClosedOrders();   
   CheckOldStops();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::ManageOrdersHistory(void)
  {
   if(m_orders_history.Clean())
     {
      int excess=m_orders_history.Total()-m_max_orders_history;
      if(excess>0)
         m_orders_history.DeleteRange(0,excess-1);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::OnTick(void)
  {
   m_orders.OnTick();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::IsPositionAllowed(ENUM_ORDER_TYPE type) const
  {
   return EnableTrade() && ((COrder::IsOrderTypeLong(type) && EnableLong())
                      || (COrder::IsOrderTypeShort(type) && EnableShort()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::PriceCalculate(ENUM_ORDER_TYPE type)
  {
   double price=0;
   switch(type)
     {
      case ORDER_TYPE_BUY:    price=m_symbol.Ask();   break;
      case ORDER_TYPE_SELL:   price=m_symbol.Bid();   break;
      default:                price=PriceCalculateCustom(type);
     }
   return price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::StopLossCalculate(const int res,const double price)
  {
   if(CheckPointer(m_main_stop))
   {
      ENUM_ORDER_TYPE type=ORDER_TYPE_BUY;
      if(res==CMD_BUY) type=ORDER_TYPE_BUY;
      else if(res==CMD_SELL) type=ORDER_TYPE_SELL;
      return m_main_stop.StopLossTicks(ORDER_TYPE_BUY,price);
   }   
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::TakeProfitCalculate(const int res,const double price)
  {
   if(CheckPointer(m_main_stop))
     {
      ENUM_ORDER_TYPE type=ORDER_TYPE_BUY;
      if(res==CMD_BUY) type=ORDER_TYPE_BUY;
      else if(res==CMD_SELL) type=ORDER_TYPE_SELL;
      return m_main_stop.TakeProfitTicks(type,price);
     }
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
bool COrderManagerBase::InitStops(CStrategy *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   if(m_stops!=NULL)
      return m_stops.Init(s,symbolmanager,accountinfo);
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
   ADT::Delete(m_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManagerBase::DeinitTrade()
  {
   ADT::Delete(m_trade);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManagerBase::AddMoneys(CMoneys *moneys)
  {
   if(CheckPointer(moneys)==POINTER_DYNAMIC)
     {
      m_moneys=moneys;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderManagerBase::LotSizeCalculate(const double price,const ENUM_ORDER_TYPE type,const double stoploss)
  {
   if(CheckPointer(m_moneys))
      return m_moneys.Volume(0,type,stoploss);
   return m_lotsize;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\ordermanager\OrderManager.mqh"
#else
#include "..\..\mql4\ordermanager\OrderManager.mqh"
#endif
//+------------------------------------------------------------------+
