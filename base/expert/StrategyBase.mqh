//+------------------------------------------------------------------+
//|                                                 StrategyBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_EXECUTION_MODE.mqh"
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
   int               m_sleep_success;
   int               m_sleep_error;
   //--- signal parameters
   bool              m_every_tick;
   ENUM_EXECUTION_MODE m_exec_mode;
   int               m_max_orders;
   int               m_max_trades;
   bool              m_one_trade_per_candle;
   ENUM_TIMEFRAMES   m_period;
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
   virtual bool      InitEvent(JEvent *event);
   virtual bool      InitComponents(void);
   virtual bool      InitMoneys(void);
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
   virtual CAccountInfo *AccountInfo(void) const {return(m_account);}
   virtual JEvent   *Event(void) const {return(m_event);}
   virtual JStop    *MainStop(void) const {return(m_main_stop);}
   virtual JMoneys  *Moneys(void) const {return(m_moneys);}
   virtual JOrders  *Orders() const {return(GetPointer(m_orders));}
   virtual JOrders  *OrdersHistory() const {return(GetPointer(m_orders_history));}
   virtual CArrayInt *OtherMagic() const {return(GetPointer(m_other_magic));}
   virtual JSignals *Signals(void) const {return(m_signals);}
   virtual JStops   *Stops(void) const {return(m_stops);}
   virtual CSymbolInfo *SymbolInfo(void) const {return(m_symbol);}
   virtual JTimes   *Times(void) const {return(m_times);}
   virtual void      AsyncMode(const bool async) {m_trade.SetAsyncMode(async);}
   virtual string    Comment(void) const {return(m_comment);}
   virtual void      Comment(const string comment){m_comment=comment;}
   virtual int       DigitsAdjust(void) const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(const int adjust) {m_digits_adjust=adjust;}
   virtual datetime  Expiration(void) const {return(m_expiration);}
   virtual void      Expiration(const datetime expiration) {m_expiration=expiration;}
   virtual datetime  LastTradeTime(void) const {return(m_last_trade_time);}
   virtual void      LastTradeTime(const datetime tradetime) {m_last_trade_time=tradetime;}
   virtual datetime  LastTickTime(void) const {return(m_last_tick_time);}
   virtual void      LastTickTime(const datetime ticktime) {m_last_tick_time=ticktime;}
   virtual double    LotSize(void) const {return(m_lotsize);}
   virtual void      LotSize(const double lotsize){m_lotsize=lotsize;}
   virtual int       Magic(void) const {return m_magic;}
   virtual void      Magic(const int magic) {m_magic=magic;}
   virtual int       OrdersTotal(void) const {return(m_orders.Total());}
   virtual int       OrdersHistoryTotal(void) const {return(m_orders_history.Total());}
   virtual double    PointsAdjust(void) const {return(m_points_adjust);}
   virtual void      PointsAdjust(const double adjust) {m_points_adjust=adjust;}
   virtual ENUM_TRADE_MODE TradeMode(void) const {return(m_trade_mode);}
   virtual void      TradeMode(const ENUM_TRADE_MODE mode){m_trade_mode=mode;}
   virtual int       TradesTotal(void) const{return(m_orders.Total()+m_orders_history.Total());}
   virtual ENUM_EXECUTION_MODE ExecutionMode(void) const {return(m_exec_mode);}
   virtual void      ExecutionMode(const ENUM_EXECUTION_MODE mode) {m_exec_mode=mode;}
   //-- tick
   virtual bool      OnTick(void);
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
   virtual int       CheckSignals(void) const;
   //--- order processing   
   virtual void      ArchiveOrders(void);
   virtual bool      ArchiveOrder(JOrder *order);
   virtual void      CheckClosedOrders(void);
   virtual bool      CloseStops(void);
   virtual void      CloseOppositeOrders(const int res) {}
   virtual bool      IsNewBar(void) const;
   virtual bool      IsTradeProcessed(void) const;
   virtual double    LotSizeCalculate(double price,ENUM_ORDER_TYPE type,double stoploss);
   virtual double    PriceCalculate(const int res);
   virtual double    PriceCalculateCustom(const int res) {return(0);}
   virtual bool      Refresh(void);
   virtual double    StopLossCalculate(const int res,const double price);
   virtual double    TakeProfitCalculate(const int res,const double price);
   virtual bool      TradeOpen(const int res) {return(true);}
   //--- deinitialization
   virtual void      DeinitAccount(void);
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
                                     m_sleep_success(500),
                                     m_sleep_error(500),
                                     m_every_tick(true),
                                     m_exec_mode(MODE_TRADE),
                                     m_max_orders(1),
                                     m_max_trades(-1),
                                     m_one_trade_per_candle(true),
                                     m_period(PERIOD_CURRENT),
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
   return(InitSignals()&&InitStops()&&InitMoneys()&&InitTimes()&&InitAccount());
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
bool JStrategyBase::InitEvent(JEvent *event)
  {
   if(event==NULL) return(false);
   m_event=event;
   return(true);
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
         Print(__FUNCTION__+": unknown object: "+DoubleToStr(object.Type(),0));
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
bool JStrategyBase::OnTick(void)
  {
   m_last_tick_time=m_symbol.Time();
   if(!Active()) return(false);
   bool ret=false;
   if(!Refresh()) return(ret);
   m_orders.OnTick();
   CheckClosedOrders();
   if(IsNewBar())
     {
      int signal=CheckSignals();      
      CloseOppositeOrders(signal);
      CheckClosedOrders();
      if(!IsTradeProcessed())
        {         
         ret=TradeOpen(signal);
         if(ret) m_last_trade_time=m_last_tick_time;
        }      
     }
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::PriceCalculate(const int res)
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
double JStrategyBase::LotSizeCalculate(const double price,const ENUM_ORDER_TYPE type,const double stoploss)
  {
   if(CheckPointer(m_moneys))
      return(m_moneys.Volume(price,type,stoploss));
   return(m_lotsize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStrategyBase::StopLossCalculate(const int res,const double price)
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
double JStrategyBase::TakeProfitCalculate(const int res,const double price)
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
      m_orders_history.InsertSort(m_orders.Detach(i));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::ArchiveOrder(JOrder *order)
  {
   return(m_orders_history.InsertSort(order));
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
         if(order.CloseStops())
            m_orders_history.InsertSort(m_orders.Detach(i));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JStrategyBase::CheckSignals(void) const
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
   if(m_symbol==NULL) return(false);
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
void JStrategyBase::AddOtherMagicString(const string &magics[])
  {
   for(int i=0;i<ArraySize(magics);i++)
      AddOtherMagic(StrToInteger(magics[i]));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategyBase::IsTradeProcessed(void) const
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
bool JStrategyBase::IsNewBar(void) const
  {
   if(m_every_tick) return(true);
   datetime arr[];
   if(CopyTime(m_symbol.Name(),m_period,0,1,arr)==-1)
      return(false);
   if(m_last_tick_time>0 && m_last_tick_time<arr[0])
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
   DeinitAccount();
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
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategyBase::DeinitAccount(void)
  {
   if(m_account!=NULL)
     {
      delete m_account;
      m_account=NULL;
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Strategy.mqh"
#else
#include "..\..\mql4\expert\Strategy.mqh"
#endif
//+------------------------------------------------------------------+
