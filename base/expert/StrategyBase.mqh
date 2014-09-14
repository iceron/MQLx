//+------------------------------------------------------------------+
//|                                                     JStrategyBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "..\..\common\enum\ENUM_PLATFORM_MODE.mqh"
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
#include "..\..\common\enum\ENUM_TRADE_MODE.mqh"
#include <Object.mqh>
#include <Arrays\ArrayInt.mqh>
#include "..\lib\AccountInfo.mqh"
#include "..\lib\SymbolInfo.mqh"
#include "..\event\EventBase.mqh"
#include "..\signal\SignalsBase.mqh"
#include "..\trade\TradeBase.mqh"
#include "..\order\OrdersBase.mqh"
#include "..\stop\StopsBase.mqh"
#include "..\money\MoneysBase.mqh"
#include "..\time\TimesBase.mqh"
#include "..\event\EventBase.mqh"
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
   //--- signal parameters
   bool              m_every_tick;
   int               m_max_orders;
   int               m_max_trades;
   bool              m_one_trade_per_candle;
   ENUM_TIMEFRAMES   m_period;
   ENUM_PLATFORM_MODE m_platform_mode;
   bool              m_position_reverse;
   ENUM_TRADE_MODE   m_trade_mode;
   //--- market parameters
   int               m_digits_adjust;
   double            m_points_adjust;
   //--- datetime parameters
   datetime          m_last_tick_time;
   datetime          m_last_trade_time;
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
   JEvent           *m_event;
   //--- container
   JExpert          *m_expert;
public:
                     JStrategyBase(void);
                    ~JStrategyBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_STRATEGY);}
   //--- initialization
   virtual bool      Add(CObject *object);
   virtual bool      Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,int magic,bool one_trade_per_candle,bool position_reverse);
   virtual bool      InitTrade(JTrade *trade);
   virtual bool      InitEvent(JEvent *event);
   virtual bool      InitComponents(void);
   virtual bool      InitMoneys(void);
   virtual bool      InitSignals(void);
   virtual bool      InitTimes(void);
   virtual bool      InitStops(void);
   virtual void      SetContainer(JExpert *e){m_expert=e;}
   //--- activation and deactivation
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   //--- setters and getters   
   virtual CAccountInfo *AccountInfo(void) const {return(m_account);}
   virtual CSymbolInfo *SymbolInfo(void) const {return(m_symbol);}
   virtual JMoneys   *Moneys(void) const {return(m_moneys);}
   virtual JSignals  *Signals(void) const {return(m_signals);}
   virtual JStops    *Stops(void) const {return(m_stops);}
   virtual void      AsyncMode(bool async) {m_trade.SetAsyncMode(async);}
   virtual string    Comment(void) const {return(m_comment);}
   virtual void      Comment(string comment){m_comment=comment;}
   virtual int       DigitsAdjust(void) const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(int adjust) {m_digits_adjust=adjust;}
   virtual datetime  Expiration(void) const {return(m_expiration);}
   virtual void      Expiration(datetime expiration) {m_expiration=expiration;}
   virtual datetime  LastTradeTime(void) const {return(m_last_trade_time);}
   virtual void      LastTradeTime(datetime tradetime) {m_last_trade_time=tradetime;}
   virtual datetime  LastTickTime(void) const {return(m_last_tick_time);}
   virtual void      LastTickTime(datetime ticktime) {m_last_tick_time=ticktime;}
   virtual double    LotSize(void) const {return(m_lotsize);}
   virtual void      LotSize(double lotsize){m_lotsize=lotsize;}
   virtual int       Magic(void) const {return m_magic;}
   virtual void      Magic(int magic) {m_magic=magic;}
   virtual int       OrdersTotal(void) const {return(m_orders.Total());}
   virtual int       OrdersHistoryTotal(void) const {return(m_orders_history.Total());}
   virtual int       TradesTotal(void) const{return(m_orders.Total()+m_orders_history.Total());}
   virtual double    PointsAdjust(void) const {return(m_points_adjust);}
   virtual void      PointsAdjust(double adjust) {m_points_adjust=adjust;}
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
   virtual int       MaxOrders(void) const {return(m_max_orders);}
   virtual void      MaxOrders(int maxorders) {m_max_orders=maxorders;}
   //--- trading time parameters
   virtual bool      AddTime(JTime *time);
   //--- deinitialization
   virtual void      Deinit(const int reason=0);
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
                                     m_lotsize(1.0),
                                     m_every_tick(true),
                                     m_max_orders(1),
                                     m_max_trades(-1),
                                     m_one_trade_per_candle(true),
                                     m_period(PERIOD_CURRENT),
                                     m_platform_mode(MODE_LIVE|MODE_BACKTEST|MODE_VISUAL|MODE_OPTIMIZATION),
                                     m_position_reverse(true),
                                     m_trade_mode(TRADE_MODE_MARKET),                                     
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
bool JStrategyBase::InitComponents(void)
  {
   return(InitSignals()&&InitStops()&&InitMoneys()&& InitTimes());
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
bool JStrategyBase::Add(CObject *object)
  {
   switch(object.Type())
     {
      case CLASS_TYPE_SIGNALS:
        {
         m_signals=object;
         break;
        }
      case CLASS_TYPE_MONEYS:
        {
         m_moneys=object;
         break;
        }
      case CLASS_TYPE_STOPS:
        {
         m_stops=object;
         m_main_stop=m_stops.Main();
         break;
        }
      case CLASS_TYPE_TIMES:
        {
         m_times=object;
         break;
        }
      default:
        {
         Print("unknown object");
        }
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
   if(CheckPointer(m_moneys))
      return(m_moneys.Volume(price,type,stoploss));
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
   return(0);
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
void JStrategyBase::ArchiveOrders(void)
  {
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
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
int JStrategyBase::CheckSignals(void)
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
      return(m_signals.CheckSignals());
   return(CMD_NEUTRAL);
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
   if(m_other_magic.Search(magic))
      return(true);
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
void JStrategyBase::Deinit(const int reason=0)
  {
   DeinitStops();
   DeinitSymbol();
   DeinitTrade();
   DeinitSignals();
   DeinitMoneys();
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
   if(m_stops!=NULL)
     {
      m_stops.Clear();
      delete m_stops;
      m_stops=NULL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitTrade(void)
  {
   if(m_trade!=NULL)
     {
      delete m_trade;
      m_trade=NULL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitMoneys(void)
  {
   if(m_moneys!=NULL)
     {
      m_moneys.Clear();
      delete m_moneys;
      m_moneys=NULL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitSymbol(void)
  {
   if(m_symbol!=NULL)
     {
      delete m_symbol;
      m_symbol=NULL;
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Strategy.mqh"
#else
#include "..\..\mql4\expert\Strategy.mqh"
#endif
//+------------------------------------------------------------------+
