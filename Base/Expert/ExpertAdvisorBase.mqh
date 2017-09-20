//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Candle\CandleManagerBase.mqh"
#include "..\Signal\SignalsBase.mqh"
#include "..\Stop\StopsBase.mqh"
#include "..\Money\MoneysBase.mqh"
#include "..\Time\TimesBase.mqh"
#include "..\Ordermanager\OrderManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisorBase : public CObject
  {
protected:
   //--- trade parameters
   bool              m_active;
   string            m_name;
   int               m_distance;
   double            m_distance_factor_long;
   double            m_distance_factor_short;
   bool              m_on_tick_process;
   //--- signal parameters
   bool              m_every_tick;
   bool              m_one_trade_per_candle;
   datetime          m_last_trade_time;
   string            m_symbol_name;
   int               m_period;
   bool              m_position_reverse;
   //--- signal objects
   CSignals         *m_signals;
   //--- trade objects   
   CAccountInfo      m_account;
   CSymbolManager    m_symbol_man;
   COrderManager     m_order_man;
   //--- trading time objects
   CTimes           *m_times;
   //--- candle
   CCandleManager    m_candle_man;
   //--- events
   CEventAggregator *m_event_man;
   //--- container
   CObject          *m_container;
public:
                     CExpertAdvisorBase(void);
                    ~CExpertAdvisorBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_EXPERT;}
   //--- initialization
   bool              AddEventAggregator(CEventAggregator*);
   bool              AddMoneys(CMoneys*);
   bool              AddSignal(CSignals*);
   bool              AddStops(CStops*);
   bool              AddSymbol(const string);
   bool              AddTimes(CTimes*);
   virtual bool      Init(const string,const int,const int,const bool,const bool,const bool);
   virtual bool      InitAccount(void);
   virtual bool      InitCandleManager(void);
   virtual bool      InitEventAggregator(void);
   virtual bool      InitComponents(void);
   virtual bool      InitSignals(void);
   virtual bool      InitTimes(void);
   virtual bool      InitOrderManager(void);
   virtual bool      Validate(void) const;
   //--- container
   void              SetContainer(CObject*);
   CObject          *GetContainer(void);
   //--- activation and deactivation
   bool              Active(void) const;
   void              Active(const bool);
   //--- setters and getters       
   string            Name(void) const;
   void              Name(const string);
   int               Distance(void) const;
   void              Distance(const int);
   double            DistanceFactorLong(void) const;
   void              DistanceFactorLong(const double);
   double            DistanceFactorShort(void) const;
   void              DistanceFactorShort(const double);
   string            SymbolName(void) const;
   void              SymbolName(const string);
   //--- object pointers
   CAccountInfo     *AccountInfo(void);
   CStop            *MainStop(void);
   CMoneys          *Moneys(void);
   COrders          *Orders(void);
   COrders          *OrdersHistory(void);
   CStops           *Stops(void);
   CSignals         *Signals(void);
   CTimes           *Times(void);
   //--- order manager
   string            Comment(void) const;
   void              Comment(const string);
   bool              EnableTrade(void) const;
   void              EnableTrade(bool);
   bool              EnableLong(void) const;
   void              EnableLong(bool);
   bool              EnableShort(void) const;
   void              EnableShort(bool);
   int               Expiration(void) const;
   void              Expiration(const int);
   double            LotSize(void) const;
   void              LotSize(const double);
   int               MaxOrdersHistory(void) const;
   void              MaxOrdersHistory(const int);
   int               Magic(void) const;
   void              Magic(const int);
   uint              MaxTrades(void) const;
   void              MaxTrades(const int);
   int               MaxOrders(void) const;
   void              MaxOrders(const int);
   int               OrdersTotal(void) const;
   int               OrdersHistoryTotal(void) const;
   int               TradesTotal(void) const;
   //--- signal manager   
   int               Period(void) const;
   void              Period(const int);
   bool              EveryTick(void) const;
   void              EveryTick(const bool);
   bool              OneTradePerCandle(void) const;
   void              OneTradePerCandle(const bool);
   bool              PositionReverse(void) const;
   void              PositionReverse(const bool);
   //--- additional candles
   void              AddCandle(const string,const int);
   //--- new bar detection
   void              DetectNewBars(void);
   //-- events
   virtual bool      OnTick(void);
   virtual void      OnChartEvent(const int,const long&,const double&,const string&);
   virtual void      OnTimer(void);
   virtual void      OnTrade(void);
   virtual void      OnDeinit(const int,const int);
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);

protected:
   //--- candle manager   
   virtual bool      IsNewBar(const string,const int);
   //--- order manager
   virtual void      ManageOrders(void);
   virtual void      ManageOrdersHistory(void);
   virtual void      OnTradeTransaction(COrder*) {}
   virtual datetime  Time(const int);
   virtual bool      TradeOpen(const string,const ENUM_ORDER_TYPE,double,bool);
   //--- symbol manager
   virtual bool      RefreshRates(void);
   //--- deinitialization
   void              DeinitAccount(void);
   void              DeinitCandle(void);
   void              DeinitSignals(void);
   void              DeinitSymbol(void);
   void              DeinitTimes(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::CExpertAdvisorBase(void) : m_active(true),
                                               m_name(NULL),
                                               m_distance(0),
                                               m_distance_factor_long(1),
                                               m_distance_factor_short(-1),
                                               m_on_tick_process(false),
                                               m_every_tick(true),
                                               m_symbol_name(NULL),
                                               m_one_trade_per_candle(true),
                                               m_last_trade_time(0),
                                               m_period(PERIOD_CURRENT),
                                               m_position_reverse(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::~CExpertAdvisorBase(void)
  {
   OnDeinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CExpertAdvisorBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Active(const bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Name(const string name)
  {
   m_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CExpertAdvisorBase::Name(void) const
  {
   return m_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Distance(const int point_dist)
  {
   m_distance=point_dist;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::Distance(void) const
  {
   return m_distance;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::DistanceFactorLong(const double factor)
  {
   m_distance_factor_long=factor;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CExpertAdvisorBase::DistanceFactorLong(void) const
  {
   return m_distance_factor_long;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::DistanceFactorShort(const double factor)
  {
   m_distance_factor_short=factor;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CExpertAdvisorBase::DistanceFactorShort(void) const
  {
   return m_distance_factor_short;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::SymbolName(const string name)
  {
   m_symbol_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CExpertAdvisorBase::SymbolName(void) const
  {
   return m_symbol_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAccountInfo *CExpertAdvisorBase::AccountInfo(void)
  {
   return GetPointer(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneys *CExpertAdvisorBase::Moneys(void)
  {
   return m_order_man.Moneys();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrders *CExpertAdvisorBase::Orders(void)
  {
   return m_order_man.Orders();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrders *CExpertAdvisorBase::OrdersHistory(void)
  {
   return m_order_man.OrdersHistory();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStops *CExpertAdvisorBase::Stops(void)
  {
   return m_order_man.Stops();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignals *CExpertAdvisorBase::Signals(void)
  {
   return GetPointer(m_signals);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimes *CExpertAdvisorBase::Times(void)
  {
   return GetPointer(m_times);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CExpertAdvisorBase::Comment(void) const
  {
   return m_order_man.Comment();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Comment(const string comment)
  {
   m_order_man.Comment(comment);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EnableTrade(void) const
  {
   return m_order_man.EnableTrade();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EnableTrade(bool allowed)
  {
   m_order_man.EnableTrade(allowed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EnableLong(void) const
  {
   return m_order_man.EnableLong();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EnableLong(bool allowed)
  {
   m_order_man.EnableLong(allowed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EnableShort(void) const
  {
   return m_order_man.EnableShort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EnableShort(bool allowed)
  {
   m_order_man.EnableShort(allowed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::Expiration(void) const
  {
   return m_order_man.Expiration();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Expiration(const int expiration)
  {
   m_order_man.Expiration(expiration);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CExpertAdvisorBase::LotSize(void) const
  {
   return m_order_man.LotSize();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::LotSize(const double lotsize)
  {
   m_order_man.LotSize(lotsize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::MaxOrdersHistory(void) const
  {
   return m_order_man.MaxOrdersHistory();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::MaxOrdersHistory(const int max)
  {
   m_order_man.MaxOrdersHistory(max);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::Magic(void) const
  {
   return m_order_man.Magic();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Magic(const int magic)
  {
   m_order_man.Magic(magic);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CExpertAdvisorBase::MaxTrades(void) const
  {
   return m_order_man.MaxTrades();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::MaxTrades(const int max_trades)
  {
   m_order_man.MaxTrades(max_trades);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::MaxOrders(void) const
  {
   return m_order_man.MaxOrders();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::MaxOrders(const int max_orders)
  {
   m_order_man.MaxOrders(max_orders);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::OrdersTotal(void) const
  {
   return m_order_man.OrdersTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::OrdersHistoryTotal(void) const
  {
   return m_order_man.OrdersHistoryTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::TradesTotal(void) const
  {
   return m_order_man.TradesTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Init(string symbol,int period,int magic,bool every_tick=true,bool one_trade_per_candle=true,bool position_reverse=true)
  {
   m_symbol_name=symbol;
   CSymbolInfo *instrument;
   if((instrument=new CSymbolInfo)==NULL)
      return false;
   if(symbol==NULL) symbol=Symbol();
   if(!instrument.Name(symbol))
      return false;
   instrument.Refresh();
   m_symbol_man.Add(instrument);
   m_symbol_man.SetPrimary(m_symbol_name);
   m_period=(ENUM_TIMEFRAMES)period;
   m_every_tick=every_tick;
   m_order_man.Magic(magic);
   m_position_reverse=position_reverse;
   m_one_trade_per_candle=one_trade_per_candle;
   CCandle *candle=new CCandle();
   candle.Init(instrument,m_period);
   m_candle_man.Add(candle);
   Magic(magic);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitComponents(void)
  {
   if(!InitSignals())
     {
      Print(__FUNCTION__+": error in signal initialization");
      return false;
     }
   if(!InitTimes())
     {
      Print(__FUNCTION__+": error in time initialization");
      return false;
     }
   if(!InitOrderManager())
     {
      Print(__FUNCTION__+": error in order manager initialization");
      return false;
     }
   if(!InitCandleManager())
     {
      Print(__FUNCTION__+": error in candle manager initialization");
      return false;
     }
   if(!InitEventAggregator())
     {
      Print(__FUNCTION__+": error in event aggregator initialization");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitSignals(void)
  {
   if(!CheckPointer(m_signals))
      return true;
   return m_signals.Init(GetPointer(m_symbol_man),GetPointer(m_event_man));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitTimes(void)
  {
   if(!CheckPointer(m_times))
      return true;
   return m_times.Init(GetPointer(m_symbol_man),GetPointer(m_event_man));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitOrderManager(void)
  {
   return m_order_man.Init(GetPointer(m_symbol_man),GetPointer(m_account));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitCandleManager(void)
  {
   m_candle_man.SetContainer(GetPointer(this));
   return m_candle_man.Init(GetPointer(m_symbol_man),GetPointer(m_event_man));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitEventAggregator(void)
  {
   if(CheckPointer(m_event_man))
      return m_event_man.Init();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddMoneys(CMoneys *moneys)
  {
   return m_order_man.AddMoneys(GetPointer(moneys));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddEventAggregator(CEventAggregator *aggregator)
  {
   if(CheckPointer(m_event_man))
      delete m_event_man;
   m_event_man=aggregator;
   return CheckPointer(m_event_man);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddSignal(CSignals *signals)
  {
   if(CheckPointer(m_signals))
      delete m_signals;
   m_signals=signals;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddStops(CStops *stops)
  {
   return m_order_man.AddStops(GetPointer(stops));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddSymbol(string symbol)
  {
   CSymbolInfo *instrument;
   if((instrument=new CSymbolInfo)==NULL)
      return false;
   if(symbol==NULL) symbol=Symbol();
   if(!instrument.Name(symbol))
      return false;
   instrument.Refresh();
   return m_symbol_man.Add(instrument);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddTimes(CTimes *times)
  {
   if(CheckPointer(times)==POINTER_DYNAMIC)
     {
      m_times=times;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::AddCandle(const string symbol,const int timeframe)
  {
   m_candle_man.Add(symbol,timeframe);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Validate(void) const
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
     {
      if(!m_signals.Validate())
         return false;
     }
   if(CheckPointer(m_times)==POINTER_DYNAMIC)
     {
      if(!m_times.Validate())
         return false;
     }
   return m_order_man.Validate();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::Period(const int value)
  {
   m_period=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorBase::Period(void) const
  {
   return m_period;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::EveryTick(const bool value)
  {
   m_every_tick=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::EveryTick(void) const
  {
   return m_every_tick;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::OneTradePerCandle(const bool value)
  {
   m_one_trade_per_candle=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::OneTradePerCandle(void) const
  {
   return m_one_trade_per_candle;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::PositionReverse(const bool value)
  {
   m_position_reverse=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::PositionReverse(void) const
  {
   return m_position_reverse;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DetectNewBars(void)
  {
   m_candle_man.Check();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::IsNewBar(const string symbol,const int period)
  {
   return m_candle_man.IsNewCandle(symbol,period);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::TradeOpen(const string symbol,const ENUM_ORDER_TYPE type,double price,bool in_points=true)
  {
   return m_order_man.TradeOpen(symbol,type,price,in_points);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CExpertAdvisorBase::Time(const int index=0)
  {
   if(index>=0)
     {
      datetime time[];
      if(CopyTime(m_symbol_name,(ENUM_TIMEFRAMES)m_period,index,1,time)>0)
         return(time[0]);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::ManageOrders(void)
  {
   m_order_man.ManageOrders();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::ManageOrdersHistory(void)
  {
   m_order_man.ManageOrdersHistory();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::OnTick(void)
  {
   if(!Active())
      return false;
   if(m_on_tick_process)
      return false;
   m_on_tick_process=true;
   if(!RefreshRates())
     {
      m_on_tick_process=true;
      return false;
     }
   DetectNewBars();
   bool  checkopenlong=false,
   checkopenshort=false,
   checkcloselong=false,
   checkcloseshort=false;
   if(CheckPointer(m_signals))
     {
      m_signals.Check();
      checkopenlong=m_signals.CheckOpenLong();
      checkopenshort = m_signals.CheckOpenShort();
      checkcloselong = m_signals.CheckCloseLong();
      checkcloseshort= m_signals.CheckCloseShort();
     }
   COrders *orders=m_order_man.Orders();
   for(int i=orders.Total()-1;i>=0;i--)
     {
      COrder *order=orders.At(i);
      if(!CheckPointer(order))
         continue;
      order.OnTick();
      bool is_order_long=COrder::IsOrderTypeLong(order.OrderType());
      bool is_order_short=COrder::IsOrderTypeShort(order.OrderType());
      if((m_position_reverse && 
         ((checkopenlong && is_order_short) || 
         (checkopenshort && is_order_long))) || 
         (checkcloselong && is_order_long) || 
         (checkcloseshort && is_order_short) || 
         order.IsSuspended())
        {
         if(m_order_man.CloseOrder(order,i))
            continue;
        }
     }
   m_order_man.OnTick();
   bool result=false;
   if((checkopenlong || checkopenshort) && 
      (m_every_tick || IsNewBar(m_symbol_name,m_period)) && 
      (!CheckPointer(m_times) || m_times.Evaluate()) && 
      (!m_one_trade_per_candle || m_last_trade_time<Time(0)))
     {
      if(checkopenlong)
        {
         result=TradeOpen(m_symbol_name,ORDER_TYPE_BUY,m_distance*m_distance_factor_long);
        }
      if(checkopenshort)
        {
         result=TradeOpen(m_symbol_name,ORDER_TYPE_SELL,m_distance*m_distance_factor_short);
        }
      if(result)
         m_last_trade_time=TimeCurrent();
     }
   m_on_tick_process=false;
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::OnTimer(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::OnTrade(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::OnDeinit(const int reason=0,const int handle=INVALID_HANDLE)
  {
   DeinitSymbol();
   DeinitSignals();
   DeinitTimes();
   DeinitCandle();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::RefreshRates()
  {
   return m_symbol_man.RefreshRates();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitSignals(void)
  {
   delete m_signals;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitSymbol(void)
  {
   m_symbol_man.Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitTimes(void)
  {
   if(CheckPointer(m_times))
      delete m_times;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitCandle(void)
  {
   m_candle_man.Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Save(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return true;
   return m_order_man.Save(handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Load(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return true;
   return m_order_man.Load(handle);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Expert\ExpertAdvisor.mqh"
#else
#include "..\..\MQL4\Expert\ExpertAdvisor.mqh"
#endif
//+------------------------------------------------------------------+
