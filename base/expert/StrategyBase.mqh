//+------------------------------------------------------------------+
//|                                                 StrategyBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_EXECUTION_MODE.mqh"
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
#include "..\..\common\enum\ENUM_CHARTEVENT_CUSTOM.mqh"
#include "..\..\common\class\ADT.mqh"
#include <Object.mqh>
#include <Arrays\ArrayInt.mqh>
#include "..\lib\AccountInfo.mqh"
#include "..\lib\SymbolInfo.mqh"
#include "..\event\EventBase.mqh"
#include "..\tick\TickBase.mqh"
#include "..\candle\CandleBase.mqh"
#include "..\signal\SignalsBase.mqh"
#include "..\trade\TradeBase.mqh"
#include "..\order\OrdersBase.mqh"
#include "..\stop\StopsBase.mqh"
#include "..\money\MoneysBase.mqh"
#include "..\time\TimesBase.mqh"
#include "..\comment\CommentsBase.mqh"
#include "..\event\EventsBase.mqh"
class JExpert;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStrategyBase : public CObject
  {
protected:
   //--- trade parameters
   bool              m_activate;
   string            m_comment;
   datetime          m_expiration;
   int               m_magic;
   double            m_lotsize;
   int               m_sleep_success;
   int               m_sleep_error;
   int               m_max_orders_history;
   int               m_history_count;
   //--- signal parameters
   bool              m_every_tick;
   ENUM_EXECUTION_MODE m_exec_mode;
   int               m_max_orders;
   int               m_max_trades;
   bool              m_one_trade_per_candle;
   ENUM_TIMEFRAMES   m_period;
   bool              m_position_reverse;
   bool              m_offline_mode;
   int               m_offline_mode_delay;
   //--- market parameters
   int               m_digits_adjust;
   double            m_points_adjust;
   //--- tick parameters
   MqlTick           m_last_trade_data;
   //--- signal objects
   JSignals         *m_signals;
   //--- trade objects   
   CAccountInfo     *m_account;
   CSymbolInfo      *m_symbol;
   JTrade           *m_trade;
   //--- order objects
   JStops           *m_stops;
   JStop            *m_main_stop;
   JOrders           m_orders;
   JOrders           m_orders_history;
   CArrayInt         m_other_magic;
   //--- money management objects
   JMoneys          *m_moneys;
   //--- trading time objects
   JTimes           *m_times;
   //--- events
   JEvents          *m_events;
   //--- comments
   JComments        *m_comments;
   //--- tick
   JTick             m_tick;
   //--- candle
   JCandle           m_candle;
   //--- container
   JExpert          *m_expert;
public:
                     JStrategyBase(void);
                    ~JStrategyBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_STRATEGY);}
   //--- initialization
   virtual bool      Add(CObject *object);
   virtual bool      AddMoneys(JMoneys *moneys);
   virtual bool      AddSignals(JSignals *signals);
   virtual bool      AddStops(JStops *stops);
   virtual bool      AddTimes(JTimes *times);
   virtual bool      Init(const string symbol,const ENUM_TIMEFRAMES period,const bool every_tick,const int magic,const bool one_trade_per_candle,const bool position_reverse);
   virtual bool      InitAccount(CAccountInfo *account=NULL);
   virtual bool      InitTrade(JTrade *trade=NULL);
   virtual bool      InitEvent(JEvents *events);
   virtual bool      InitComponents(void);
   virtual bool      InitMoneys(void);
   virtual bool      InitOrders(void);
   virtual bool      InitOrdersHistory(void);
   virtual bool      InitSignals(void);
   virtual bool      InitTimes(void);
   virtual bool      InitStops(void);
   virtual bool      Validate(void) const;
   //container
   virtual JExpert  *GetContainer() const {return(GetPointer(m_expert));}
   virtual void      SetContainer(JExpert *e){m_expert=e;}
   //--- activation and deactivation
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   //--- setters and getters   
   virtual CAccountInfo *AccountInfo(void) const {return(GetPointer(m_account));}
   virtual JCandle   *Candle(void) const {return(GetPointer(m_candle));}
   virtual JComments *Comments() {return(GetPointer(m_comments));}
   virtual JEvents  *Events(void) const {return(m_events);}
   virtual JStop    *MainStop(void) const {return(m_main_stop);}
   virtual JMoneys  *Moneys(void) const {return(m_moneys);}
   virtual JOrders  *Orders() const {return(GetPointer(m_orders));}
   virtual JOrders  *OrdersHistory() const {return(GetPointer(m_orders_history));}
   virtual CArrayInt *OtherMagic() const {return(GetPointer(m_other_magic));}
   virtual JSignals *Signals(void) const {return(GetPointer(m_signals));}
   virtual JStops   *Stops(void) const {return(GetPointer(m_stops));}
   virtual CSymbolInfo *SymbolInfo(void) const {return(GetPointer(m_symbol));}
   virtual JTick    *Tick(void) const {return(GetPointer(m_tick));}
   virtual JTimes   *Times(void) const {return(GetPointer(m_times));}
   virtual void      AsyncMode(const bool async) {m_trade.SetAsyncMode(async);}
   virtual string    Comment(void) const {return(m_comment);}
   virtual void      Comment(const string comment){m_comment=comment;}
   virtual void      ChartComment(const bool enable=true);
   virtual void      AddComment(const string comment);
   virtual void      DisplayComment(void);
   virtual int       DigitsAdjust(void) const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(const int adjust) {m_digits_adjust=adjust;}
   virtual datetime  Expiration(void) const {return(m_expiration);}
   virtual void      Expiration(const datetime expiration) {m_expiration=expiration;}
   virtual void      LastTradeRates(MqlTick &tick) {m_last_trade_data=tick;}
   virtual datetime  LastTradeTime(void) const {return(m_last_trade_data.time);}
   virtual datetime  LastTradeBid(void) const {return(m_last_trade_data.bid);}
   virtual datetime  LastTradeAsk(void) const {return(m_last_trade_data.ask);}
   virtual datetime  LastTradeLast(void) const {return(m_last_trade_data.last);}
   virtual datetime  LastTradeVolume(void) const {return(m_last_trade_data.volume);}
   virtual datetime  LastTickTime(void) const {return(m_tick.Time());}
   virtual datetime  LastTickBid(void) const {return(m_tick.Bid());}
   virtual datetime  LastTickAsk(void) const {return(m_tick.Ask());}
   virtual datetime  LastTickLast(void) const {return(m_tick.Last());}
   virtual datetime  LastTickVolume(void) const {return(m_tick.Volume());}
   virtual double    LotSize(void) const {return(m_lotsize);}
   virtual void      LotSize(const double lotsize){m_lotsize=lotsize;}
   virtual int       Magic(void) const {return m_magic;}
   virtual void      Magic(const int magic) {m_magic=magic;}
   virtual int       MaxOrdersHistory(void) const {return m_max_orders_history;}
   virtual void      MaxOrdersHistory(const int max) {m_max_orders_history=max;}
   virtual bool      OfflineMode(void) const {return(m_offline_mode);}
   virtual void      OfflineMode(const bool mode) {m_offline_mode=mode;}
   virtual int       OfflineModeDelay() const {return(m_offline_mode_delay);}
   virtual void      OfflineModeDelay(const int delay){m_offline_mode_delay=delay;}
   virtual int       OrdersTotal(void) const {return(m_orders.Total());}
   virtual int       OrdersHistoryTotal(void) const {return(m_orders_history.Total());}
   virtual double    PointsAdjust(void) const {return(m_points_adjust);}
   virtual void      PointsAdjust(const double adjust) {m_points_adjust=adjust;}
   virtual int       TradesTotal(void) const{return(m_orders.Total()+m_orders_history.Total()+m_history_count);}
   virtual ENUM_EXECUTION_MODE ExecutionMode(void) const {return(m_exec_mode);}
   virtual void      ExecutionMode(const ENUM_EXECUTION_MODE mode) {m_exec_mode=mode;}
   //-- events
   virtual bool      OnTick(void);
   virtual void      OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- signal parameters
   virtual int       Period(void) const {return(PeriodSeconds(m_period));}
   virtual void      Period(const ENUM_TIMEFRAMES period) {m_period=period;}
   virtual bool      EveryTick(void) const {return(m_every_tick);}
   virtual void      EveryTick(const bool every_tick) {m_every_tick=every_tick;}
   virtual bool      OneTradePerCandle(void) const {return(m_one_trade_per_candle);}
   virtual void      OneTradePerCandle(const bool one_trade_per_candle){m_one_trade_per_candle=one_trade_per_candle;}
   virtual bool      PositionReverse(void) const {return(m_position_reverse);}
   virtual void      PositionReverse(const bool position_reverse){m_position_reverse=position_reverse;}
   virtual bool      AddOtherMagic(const int magic);
   virtual void      AddOtherMagicString(const string &magics[]);
   virtual uint      MaxTrades(void) const {return(m_max_trades);}
   virtual void      MaxTrades(const int max_trades){m_max_trades=max_trades;}
   virtual int       MaxOrders(void) const {return(m_max_orders);}
   virtual void      MaxOrders(const int maxorders) {m_max_orders=maxorders;}
   //--- deinitialization
   virtual void      Deinit(const int reason=0);
protected:
   //--- signal processing
   virtual bool      CheckSignals(int &entry,int &exit) const;
   //--- order processing   
   virtual void      ArchiveOrders(void);
   virtual bool      ArchiveOrder(JOrder *order);
   virtual void      CheckClosedOrders(void);
   virtual void      CheckOldStops(void);
   virtual bool      CloseOrder(JOrder *order,const int index) {return(true);}
   virtual void      CloseOrders(const int entry,const int exit);
   virtual bool      CloseStops(void);
   virtual void      CloseOppositeOrders(const int entry,const int exit);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
   virtual bool      IsNewBar(void);
   virtual double    LotSizeCalculate(double price,ENUM_ORDER_TYPE type,double stoploss);
   virtual void      ManageOrders(void);
   virtual void      ManageOrdersHistory(void);
   virtual void      OnTradeTransaction(JOrder *order);
   virtual double    PriceCalculate(ENUM_ORDER_TYPE type);
   virtual double    PriceCalculateCustom(const int res) {return(0);}
   virtual bool      Refresh(void);
   virtual bool      SendOrder(ENUM_ORDER_TYPE type,const double lotsize,const double price,const double stoploss,const double takeprofit);
   virtual double    StopLossCalculate(const int res,const double price);
   virtual double    TakeProfitCalculate(const int res,const double price);
   virtual bool      TradeOpen(const int res) {return(true);}
   //--- deinitialization
   virtual void      DeinitAccount(void);
   virtual void      DeinitEvents(void);
   virtual void      DeinitComments(void);
   virtual void      DeinitMoneys(void);
   virtual void      DeinitSignals(void);
   virtual void      DeinitStops(void);
   virtual void      DeinitSymbol(void);
   virtual void      DeinitTrade(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategyBase::JStrategyBase(void) : m_activate(true),
                                     m_comment(NULL),
                                     m_expiration(0),
                                     m_magic(0),
                                     m_lotsize(0.1),
                                     m_sleep_success(500),
                                     m_sleep_error(500),
                                     m_max_orders_history(100),
                                     m_history_count(0),
                                     m_every_tick(true),
                                     m_exec_mode(MODE_TRADE),
                                     m_max_orders(1),
                                     m_max_trades(-1),
                                     m_one_trade_per_candle(true),
                                     m_period(PERIOD_CURRENT),
                                     m_position_reverse(true),
                                     m_offline_mode(false),
                                     m_offline_mode_delay(500),
                                     m_digits_adjust(0),
                                     m_points_adjust(0.0)
  {
   if(!m_other_magic.IsSorted())
      m_other_magic.Sort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategyBase::~JStrategyBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::Init(string symbol,ENUM_TIMEFRAMES period=PERIOD_CURRENT,bool every_tick=true,int magic=0,bool one_trade_per_candle=true,bool position_reverse=true)
  {
   if(m_symbol==NULL)
      if((m_symbol=new CSymbolInfo)==NULL)
         return(false);
   if(!m_symbol.Name(symbol))
      return(false);
   m_period=period;
   m_every_tick=every_tick;
   m_magic=magic;
   m_position_reverse=position_reverse;
   m_one_trade_per_candle=one_trade_per_candle;
   m_digits_adjust=(m_symbol.Digits()==3 || m_symbol.Digits()==5)?10:1;
   m_points_adjust=m_symbol.Point()*m_digits_adjust;
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitComponents(void)
  {
   bool result=InitOrders() && InitOrdersHistory() && InitSignals() && InitStops() && InitAccount() && InitMoneys() && InitTimes();
   if(OfflineMode())
      EventChartCustom(0,OFFLINE_TICK,0,0,m_symbol.Name());
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitOrders(void)
  {
   return(m_orders.Init(m_magic,GetPointer(this),m_stops,m_events));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitOrdersHistory(void)
  {
   return(m_orders_history.Init(m_magic,GetPointer(this),m_stops,m_events));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitSignals(void)
  {
   if(m_signals==NULL) return(true);
   return(m_signals.Init(GetPointer(this)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitStops(void)
  {
   if(m_stops==NULL) return(true);
   return(m_stops.Init(GetPointer(this)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitMoneys(void)
  {
   if(m_moneys==NULL) return(true);
   return(m_moneys.Init(GetPointer(this)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitTimes(void)
  {
   if(m_times==NULL) return(true);
   return(m_times.Init(GetPointer(this)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitTrade(JTrade *trade=NULL)
  {
   if(m_trade!=NULL)
      delete m_trade;
   if(trade==NULL)
     {
      if((m_trade=new JTrade)==NULL)
         return(false);
     }
   else m_trade=trade;
   m_trade.SetSymbol(GetPointer(m_symbol));
   m_trade.SetExpertMagicNumber(m_magic);
   m_trade.SetDeviationInPoints((ulong)(3*m_digits_adjust/m_symbol.Point()));
   m_trade.SetOrderExpiration(m_expiration);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitAccount(CAccountInfo *account=NULL)
  {
   if(m_account!=NULL)
      delete m_account;
   if(account==NULL)
     {
      if((m_account=new CAccountInfo)==NULL)
         return(false);
     }
   else m_account=account;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitEvent(JEvents *events=NULL)
  {
   if(events==NULL)
     {
      m_events=new JEvents();
     }
   else
      m_events=events;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::ChartComment(const bool enable=true)
  {
   if(enable)
      m_comments=new JComments();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new JComment(comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DisplayComment(void)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Display();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::Add(CObject *object)
  {
   bool result=false;
   switch(object.Type())
     {
      case CLASS_TYPE_SIGNALS:
        {
         result=AddSignals(object);
         break;
        }
      case CLASS_TYPE_MONEYS:
        {
         result=AddMoneys(object);
         break;
        }
      case CLASS_TYPE_STOPS:
        {
         result=AddStops(object);
         break;
        }
      case CLASS_TYPE_TIMES:
        {
         result=AddTimes(object);
         break;
        }
      default:
        {
         Print(__FUNCTION__+": unknown object: "+DoubleToString(object.Type(),0));
        }
     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddSignals(JSignals *signals)
  {
   if(CheckPointer(signals)==POINTER_DYNAMIC)
     {
      m_signals=signals;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddMoneys(JMoneys *moneys)
  {
   if(CheckPointer(moneys)==POINTER_DYNAMIC)
     {
      m_moneys=moneys;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddStops(JStops *stops)
  {
   if(CheckPointer(stops)==POINTER_DYNAMIC)
     {
      m_stops=stops;
      m_main_stop=m_stops.Main();
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddTimes(JTimes *times)
  {
   if(CheckPointer(times)==POINTER_DYNAMIC)
     {
      m_times=times;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::Validate(void) const
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
     {
      if(!m_signals.Validate())
         return(false);
     }
   if(CheckPointer(m_moneys)==POINTER_DYNAMIC)
     {
      if(!m_moneys.Validate())
         return(false);
     }
   if(CheckPointer(m_stops)==POINTER_DYNAMIC)
     {
      if(!m_stops.Validate())
         return(false);
     }
   if(CheckPointer(m_times)==POINTER_DYNAMIC)
     {
      if(!m_times.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==CHARTEVENT_CUSTOM+OFFLINE_TICK)
     {
      string name=CheckPointer(m_symbol)?m_symbol.Name():Symbol();
      if(StringCompare(sparam,name)==0)
        {
         while(true && !IsStopped())
           {
            OnTick();
            Sleep(m_offline_mode_delay);
           }
         EventChartCustom(0,OFFLINE_TICK,0,0,name);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::OnTick(void)
  {
   if(!Active()) return(false);
   if(!Refresh()) return(false);
   bool ret=false;
   bool newtick= m_tick.IsNewTick(m_symbol);
   bool newbar = IsNewBar();
   m_orders.OnTick();
   ManageOrders();
   int entry=0,exit=0;
   CheckSignals(entry,exit);
   AddComment(TimeToStr(LastTickTime(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   AddComment("Last Trade: "+TimeToStr(LastTradeTime(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   AddComment("Last Time: "+TimeToStr(m_candle.LastTime(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   AddComment("Last Open: "+m_candle.LastOpen());
   AddComment("Last Close: "+m_candle.LastClose());
   AddComment("Total Orders: "+OrdersTotal());
   AddComment("entry signal: "+EnumToString((ENUM_CMD)entry));
   AddComment("exit signal: "+EnumToString((ENUM_CMD)exit));
   if(newbar || (m_every_tick && newtick))
     {
      CloseOppositeOrders(entry,exit);
      ManageOrders();
      if(!m_candle.TradeProcessed())
        {
         ret=TradeOpen(entry);
         if(ret)
           {
            m_last_trade_data=m_tick.LastTick();
            m_candle.TradeProcessed(true);
           }
        }
     }

   ManageOrdersHistory();
   if(CheckPointer(m_events)==POINTER_DYNAMIC)
      m_events.Run();
   DisplayComment();
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::OnTradeTransaction(JOrder *order)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::ManageOrders(void)
  {
   CheckClosedOrders();
   CheckOldStops();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::PriceCalculate(ENUM_ORDER_TYPE type)
  {
   double price=0;
   switch(type)
     {
      case ORDER_TYPE_BUY:
         price=m_symbol.Ask();
         break;
      case ORDER_TYPE_SELL:
         price=m_symbol.Bid();
         break;
      default:
         price=PriceCalculateCustom(type);
     }
   return(price);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::LotSizeCalculate(const double price,const ENUM_ORDER_TYPE type,const double stoploss)
  {
   if(CheckPointer(m_moneys))
      return(m_moneys.Volume(price,type,stoploss));
   return(m_lotsize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::SendOrder(const ENUM_ORDER_TYPE type,const double lotsize,const double price,const double sl,const double tp)
  {
   bool ret=false;
   CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SEND,EnumToString(type)+" "+DoubleToString(lotsize,2)+" "+DoubleToString(sl,5)+" "+DoubleToString(tp,5)+" "+m_comment+" "+DoubleToString(m_magic,0));
   if(JOrder::IsOrderTypeLong(type))
      ret=m_trade.Buy(lotsize,price,sl,tp,m_comment);
   if(JOrder::IsOrderTypeShort(type))
      ret=m_trade.Sell(lotsize,price,sl,tp,m_comment);
   if(!ret)
      CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_SEND);
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::StopLossCalculate(const int res,const double price)
  {
   if(CheckPointer(m_main_stop))
      return(m_main_stop.StopLossTicks(ORDER_TYPE_BUY,price));
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::TakeProfitCalculate(const int res,const double price)
  {
   if(CheckPointer(m_main_stop))
     {
      ENUM_ORDER_TYPE type;
      if(res==CMD_BUY) type=ORDER_TYPE_BUY;
      else if(res==CMD_SELL) type=ORDER_TYPE_SELL;
      return(m_main_stop.TakeProfitTicks(type,price));
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::CloseStops(void)
  {
   return(m_orders.CloseStops());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategyBase::CloseOppositeOrders(const int entry,const int exit)
  {
   if(m_orders.Total()==0) return;
   if(m_position_reverse)
      CloseOrders(entry,exit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategyBase::CloseOrders(const int entry,const int exit)
  {
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
     {
      JOrder *order=m_orders.At(i);
      if((JSignal::IsOrderAgainstSignal((ENUM_ORDER_TYPE) order.OrderType(),(ENUM_CMD) entry) && m_position_reverse) ||
         (JSignal::IsOrderAgainstSignal((ENUM_ORDER_TYPE) order.OrderType(),(ENUM_CMD) exit)))
        {
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_CLOSE,order);
         if(CloseOrder(order,i))
            CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_CLOSE_DONE,order);
         else
            CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_CLOSE);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::ArchiveOrders(void)
  {
   bool result=false;
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
      ArchiveOrder(m_orders.Detach(i));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::ArchiveOrder(JOrder *order)
  {
   bool result=m_orders_history.Add(order);
   if(result)
      m_orders_history.Clean(false);
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::CheckClosedOrders(void)
  {
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
     {
      JOrder *order=m_orders.At(i);
      ulong ticket = order.Ticket();
      if(order.IsClosed())
         ArchiveOrder(m_orders.Detach(i));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::CheckOldStops(void)
  {
   if(m_orders_history.Clean())
      return;
   bool status=true;
   int total= m_orders_history.Total();
   for(int i=m_orders_history.Total()-1;i>=0;i--)
     {
      JOrder *order=m_orders_history.At(i);
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
void JStrategyBase::ManageOrdersHistory(void)
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
bool JStrategyBase::CheckSignals(int &entry,int &exit) const
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
      return(m_signals.CheckSignals(entry,exit));
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::Refresh(void)
  {
   if(!CheckPointer(m_symbol)) 
      return(false);
   if(!m_symbol.RefreshRates())
      return(false);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddOtherMagic(const int magic)
  {
   if(m_other_magic.Search(magic)>=0)
      return(true);
   return(m_other_magic.InsertSort(magic));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::AddOtherMagicString(const string &magics[])
  {
   for(int i=0;i<ArraySize(magics);i++)
      AddOtherMagic((int)magics[i]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::IsNewBar(void)
  {
   return(m_candle.IsNewCandle(m_symbol,m_period));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::Deinit(const int reason=0)
  {
   DeinitStops();
   DeinitSymbol();
   DeinitTrade();
   DeinitSignals();
   DeinitMoneys();
   DeinitAccount();
   DeinitEvents();
   DeinitComments();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitSignals(void)
  {
   if(m_signals!=NULL)
     {
      m_signals.Clear();
      delete m_signals;
      m_signals=NULL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitStops(void)
  {
   ADT::Delete(m_stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitTrade(void)
  {
   ADT::Delete(m_trade);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitMoneys(void)
  {
   ADT::Delete(m_moneys);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitSymbol(void)
  {
   ADT::Delete(m_symbol);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitAccount(void)
  {
   ADT::Delete(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitEvents(void)
  {
   ADT::Delete(m_events);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitComments(void)
  {
   ADT::Delete(m_comments);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Strategy.mqh"
#else
#include "..\..\mql4\expert\Strategy.mqh"
#endif
//+------------------------------------------------------------------+
