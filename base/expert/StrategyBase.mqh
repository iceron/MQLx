//+------------------------------------------------------------------+
//|                                                     JStrategyBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\common\enum\ENUM_TRADE_MODE.mqh"
#include <Object.mqh>
#include <Arrays\ArrayInt.mqh>
#include "..\lib\SymbolInfo.mqh"
#include "..\event\EventBase.mqh"
#include "..\signal\SignalsBase.mqh"
#include "..\trade\TradeBase.mqh"
#include "..\order\OrdersBase.mqh"
#include "..\stop\StopsBase.mqh"
#include "..\money\MoneyBase.mqh"
#include "..\time\TimesBase.mqh"
#include "..\event\EventBase.mqh"
//class JExpert;
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
   double            m_price;
   double            m_stoploss;
   double            m_takeprofit;
   //--- signal parameters
   bool              m_every_tick;
   int               m_max_orders;
   int               m_max_trades;
   ENUM_TRADE_MODE   m_trade_mode;
   bool              m_one_trade_per_candle;
   ENUM_TIMEFRAMES   m_period;
   bool              m_position_reverse;
   //--- market parameters
   int               m_digits_adjust;
   double            m_points_adjust;
   //--- datetime parameters
   datetime          m_last_tick_time;
   datetime          m_last_trade_time;
   //--- signal objects
   JSignals          m_signals;
   //--- trade objects   
   CSymbolInfo      *m_symbol;
   JTrade           *m_trade;
   //--- order objects
   JStops            m_stops;
   JStop            *m_main_stop;
   JOrders           m_orders;
   JOrders           m_orders_history;
   CArrayInt         m_other_magic;
   //--- money management objects
   JMoney           *m_money;
   //--- trading time objects
   JTimes           *m_times;
   //--- events
   JEvent           *m_event;
   //--- container
   //JExpert          *m_expert;
public:
                     JStrategyBase(void);
                    ~JStrategyBase(void);
   //--- initialization
   virtual bool      AddSignal(JSignal *signal);
   virtual void      AddStop(JStop *stop);
   virtual bool      Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,int magic,bool one_trade_per_candle,bool position_reverse);
   virtual bool      InitMoney(JMoney *money);
   virtual bool      InitTrade(JTrade *trade);
   virtual bool      InitEvent(JEvent *event);
   //virtual void      SetContainer(JExpert *expert){m_expert=expert;}
   //--- activation and deactivation
   virtual bool      Active() {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   //--- setters and getters
   virtual void      AsyncMode(bool async) {m_trade.SetAsyncMode(async);}
   virtual string    Comment(void) const {return(m_comment);}
   virtual void      Comment(string comment){m_comment=comment;}
   virtual datetime  Expiration(void) const {return(m_expiration);}
   virtual void      Expiration(datetime expiration) {m_expiration=expiration;}
   virtual datetime  LastTradeTime(void) const {return(m_last_trade_time);}
   virtual void      LastTradeTime(datetime tradetime) {m_last_trade_time=tradetime;}
   virtual datetime  LastTickTime(void) {return(m_last_tick_time);}
   virtual void      LastTickTime(datetime ticktime) {m_last_tick_time=ticktime;}
   virtual double    LotSize(void) const {return(m_lotsize);}
   virtual void      LotSize(double lotsize){m_lotsize=lotsize;}
   virtual int       Magic(void) const {return m_magic;}
   virtual void      Magic(int magic) {m_magic=magic;}
   virtual int       OrdersTotal(void);
   virtual int       OrdersHistoryTotal(void);
   virtual int       TradesTotal(void);
   virtual double    Price(void) const {return(m_price);}
   virtual void      Price(double price) {m_price=price;}
   virtual double    StopLoss(void) const {return(m_stoploss);}
   virtual void      StopLoss(double sl) {m_stoploss=sl;}
   virtual double    TakeProfit(void) const {return(m_takeprofit);}
   virtual void      TakeProfit(double tp){m_takeprofit=tp;}
   virtual ENUM_TRADE_MODE TradeMode(void) const {return(m_trade_mode);}
   virtual void      TradeMode(ENUM_TRADE_MODE mode){m_trade_mode=mode;}
   //--- signal parameters
   virtual int       Period(void) const {return(PeriodSeconds(m_period));}
   virtual void      Period(ENUM_TIMEFRAMES period) {m_period=period;}
   virtual bool      EveryTick(void) const {return(m_every_tick);}
   virtual void      EveryTick(bool every_tick) {m_every_tick=every_tick;}
   virtual bool      OneTradePerCandle(void) const {return(m_one_trade_per_candle);}
   virtual void      OneTradePerCandle(bool one_trade_per_candle){m_one_trade_per_candle=one_trade_per_candle;}
   virtual bool      PositionReverse(void) const {return(m_position_reverse);}
   virtual void      PositionReverse(bool position_reverse){m_position_reverse=position_reverse;}
   virtual bool      AddOtherMagic(int magic);
   virtual uint      MaxTrades(void) const {return(m_max_trades);}
   virtual void      MaxTrades(int max_trades){m_max_trades=max_trades;}
   virtual int       MaxOrders(void) {return(m_max_orders);}
   virtual void      MaxOrders(int maxorders) {m_max_orders=maxorders;}
   //--- trading time parameters
   virtual bool      AddTime(JTime *time);
   //--- deinitialization
   virtual bool      Deinit(void);
protected:
   //--- signal processing
   virtual int       CheckSignals(void);
   //--- order processing   
   virtual void      ArchiveOrders(void);
   virtual void      CheckClosedOrders(void);
   virtual bool      CloseStops(void);
   virtual void      CloseOppositeOrders(int res);
   virtual bool      IsTradeProcessed(void);
   virtual double    LotSizeCalculate(double price,ENUM_ORDER_TYPE type,double stoploss);
   virtual double    PriceCalculate(int res);
   virtual double    PriceCalculateCustom(int res);
   virtual bool      Refresh(void);
   virtual double    StopLossCalculate(int res,double price);
   virtual double    TakeProfitCalculate(int res,double price);
   virtual bool      TradeOpen(int res) {return(true);}
   //--- deinitialization
   virtual bool      DeinitMoney(void);
   virtual void      DeinitSignals(void);
   virtual bool      DeinitStops(void);
   virtual bool      DeinitSymbol(void);
   virtual bool      DeinitTrade(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategyBase::JStrategyBase(void) : m_activate(true),
                                     m_comment(NULL),
                                     m_expiration(0),
                                     m_magic(0),
                                     m_lotsize(1.0),
                                     m_price(0),
                                     m_stoploss(0),
                                     m_takeprofit(0),
                                     m_every_tick(true),
                                     m_max_orders(1),
                                     m_max_trades(-1),
                                     m_trade_mode(TRADE_MODE_MARKET),
                                     m_one_trade_per_candle(true),
                                     m_period(PERIOD_CURRENT),
                                     m_position_reverse(true),
                                     m_digits_adjust(0),
                                     m_points_adjust(0.0),
                                     m_last_tick_time(0),
                                     m_last_trade_time(0)
  {
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
     {
      if((m_symbol=new CSymbolInfo)==NULL)
         return(false);
     }
   if(!m_symbol.Name(symbol))
      return(false);
   m_period=period;
   m_every_tick=every_tick;
   m_magic=magic;
   m_position_reverse=position_reverse;
   m_one_trade_per_candle=one_trade_per_candle;
   m_last_trade_time=0;
   m_digits_adjust=(m_symbol.Digits()==3 || m_symbol.Digits()==5)?10:1;
   m_points_adjust=m_symbol.Point()*m_digits_adjust;
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitMoney(JMoney *money=NULL)
  {
   if(m_money!=NULL)
      delete m_money;
   if(money==NULL)
     {
      if((m_money=new JMoney)==NULL)
         return(false);
     }
   else m_money=money;
   return(true);
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
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::InitEvent(JEvent *event)
  {
   m_event=event;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddSignal(JSignal *signal)
  {
   if(m_signals.Add(signal))
     {
      signal.SetContainer(GetPointer(m_signals));
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddTime(JTime *time)
  {
   if(m_times.Add(time))
     {
      time.SetContainer(GetPointer(m_times));
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::PriceCalculate(int res)
  {
   if(m_trade_mode==TRADE_MODE_MARKET)
     {
      if(res==CMD_LONG)
         return(m_symbol.Ask());
      else if(res==CMD_SHORT)
         return(m_symbol.Bid());
     }
   else if(m_trade_mode==TRADE_MODE_PENDING)
     {
      return(PriceCalculateCustom(res));
     }
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::PriceCalculateCustom(int res)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::LotSizeCalculate(double price,ENUM_ORDER_TYPE type,double stoploss)
  {
   if(CheckPointer(m_money))
      return(m_money.Volume(price,type,stoploss));
   return(m_lotsize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::StopLossCalculate(int res,double price)
  {
   if(CheckPointer(m_main_stop))
     {
      ENUM_ORDER_TYPE type;
      if(res==CMD_LONG) type=ORDER_TYPE_BUY;
      else if(res==CMD_SHORT) type=ORDER_TYPE_SELL;
      return(m_main_stop.StopLossTicks(type,price));
     }
   return(m_stoploss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::TakeProfitCalculate(int res,double price)
  {
   if(CheckPointer(m_main_stop))
     {
      ENUM_ORDER_TYPE type;
      if(res==CMD_LONG) type=ORDER_TYPE_BUY;
      else if(res==CMD_SHORT) type=ORDER_TYPE_SELL;
      return(m_main_stop.TakeProfitTicks(type,price));
     }
   return(m_takeprofit);
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
void JStrategyBase::ArchiveOrders(void)
  {
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
     {
      m_orders_history.InsertSort(m_orders.Detach(i));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::CheckClosedOrders(void)
  {
   int total= m_orders.Total();
   for(int i=0;i<total;i++)
     {
      JOrder *order=m_orders.At(i);
      if(order.IsClosed())
         if(order.CloseStops())
            m_orders_history.InsertSort(m_orders.Detach(i));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::CloseOppositeOrders(int res)
  {
   if(m_orders.Total()==0) return;
   if(m_position_reverse)
     {
      JOrder *order=m_orders.At(m_orders.Total()-1);
      ENUM_ORDER_TYPE type=order.OrderType();
      if((res==CMD_LONG && IsOrderTypeShort(type)) || (res==CMD_SHORT && IsOrderTypeLong(type)))
        {
         if(CloseStops())
           {
            ArchiveOrders();
            m_orders.Clear();
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::AddStop(JStop *stop)
  {
   if(m_stops.Add(stop))
     {
      if(m_main_stop==NULL && stop.Main())
         m_main_stop=stop;
      stop.InitSymbol(m_symbol);
      stop.PointsAdjust(m_points_adjust);
      stop.DigitsAdjust(m_digits_adjust);
      stop.InitTrade();
      stop.InitEvent(m_event);
      stop.SetContainer(GetPointer(m_stops));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JStrategyBase::CheckSignals(void)
  {
   return(m_signals.CheckSignals());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JStrategyBase::OrdersTotal(void)
  {
   return(m_orders.Total());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JStrategyBase::OrdersHistoryTotal(void)
  {
   return(m_orders_history.Total());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JStrategyBase::TradesTotal(void)
  {
   return(m_orders_history.Total()+m_orders.Total());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::Refresh(void)
  {
   if(!m_symbol.RefreshRates())
      return(false);
   m_last_tick_time=m_symbol.Time();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::AddOtherMagic(int magic)
  {
   if(m_other_magic.Add(magic))
     {
      m_other_magic.Sort();
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::IsTradeProcessed(void)
  {
   if(!m_one_trade_per_candle) return(false);
   datetime arr[];
   if(CopyTime(m_symbol.Name(),m_period,0,1,arr)==-1)
      return(false);
   if(m_last_trade_time>0 && m_last_trade_time>=arr[0])
      return(true);
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::Deinit(void)
  {
   DeinitStops();
   DeinitSymbol();
   DeinitTrade();
   DeinitSignals();
   DeinitMoney();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitSignals(void)
  {
   m_signals.Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::DeinitStops(void)
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::DeinitTrade(void)
  {
   if(m_trade!=NULL)
     {
      delete m_trade;
      m_trade=NULL;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::DeinitMoney(void)
  {
   if(m_money!=NULL)
     {
      delete m_money;
      m_money=NULL;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::DeinitSymbol(void)
  {
   if(m_symbol!=NULL)
     {
      delete m_symbol;
      m_symbol=NULL;
     }
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Strategy.mqh"
#else
#include "..\..\mql4\expert\Strategy.mqh"
#endif
//+------------------------------------------------------------------+
