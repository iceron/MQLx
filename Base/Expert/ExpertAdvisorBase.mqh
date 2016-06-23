//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Candle\CandleManagerBase.mqh"
#include "..\Signal\SignalBase.mqh"
#include "..\Stop\StopsBase.mqh"
#include "..\Money\MoneysBase.mqh"
#include "..\Time\TimesBase.mqh"
#include "..\Comment\CommentsBase.mqh"
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
   //--- signal parameters
   bool              m_every_tick;
   bool              m_one_trade_per_candle;
   string            m_symbol_name;
   int               m_period;
   bool              m_position_reverse;
   //--- signal objects
   CSignal          *m_signal;
   //--- trade objects   
   CAccountInfo      m_account;
   CSymbolManager    m_symbol_man;
   COrderManager     m_order_man;
   //--- trading time objects
   CTimes           *m_times;
   //--- comments
   CComments        *m_comments;
   //--- candle
   CCandleManager    m_candle_man;
   //--- events
   CEventAggregator *m_event_man;
   //--- container
   CObject          *m_container;
public:
                     CExpertAdvisorBase(void);
                    ~CExpertAdvisorBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STRATEGY;}
   //--- initialization
   bool              AddChartComment(CComments*);
   bool              AddEventAggregator(CEventAggregator*);
   bool              AddMoneys(CMoneys*);
   bool              AddSignal(CSignal*);
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
   void              Name(const string name);
   string            SymbolName(void) const;
   void              SymbolName(const string name);
   //--- object pointers
   CAccountInfo     *AccountInfo(void);
   CComments        *Comments(void);
   CStop            *MainStop(void);
   CMoneys          *Moneys(void);
   COrders          *Orders(void);
   COrders          *OrdersHistory(void);
   CArrayInt        *OtherMagic(void);
   CStops           *Stops(void);
   CSignal          *Signal(void);
   CTimes           *Times(void);
   //--- chart comment manager
   void              AddComment(const string);
   void              DisplayComment(void);
   //--- order manager
   bool              AddOtherMagic(const int magic);
   void              AddOtherMagicString(const string &magics[]);
   void              AsyncMode(const bool async);
   string            Comment(void) const;
   void              Comment(const string comment);
   bool              EnableTrade(void) const;
   void              EnableTrade(bool allowed);
   bool              EnableLong(void) const;
   void              EnableLong(bool allowed);
   bool              EnableShort(void) const;
   void              EnableShort(bool allowed);
   int               Expiration(void) const;
   void              Expiration(const int expiration);
   double            LotSize(void) const;
   void              LotSize(const double lotsize);
   int               MaxOrdersHistory(void) const;
   void              MaxOrdersHistory(const int max);
   int               Magic(void) const;
   void              Magic(const int magic);
   uint              MaxTrades(void) const;
   void              MaxTrades(const int max_trades);
   int               MaxOrders(void) const;
   void              MaxOrders(const int max_orders);
   int               OrdersTotal(void) const;
   int               OrdersHistoryTotal(void) const;
   int               PricePoints(void) const;
   void              PricePoints(const int points);
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
   //-- generic events
   virtual bool      OnTick(void);
   virtual void      OnChartEvent(const int,const long&,const double&,const string&) {}
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
   virtual bool      TradeOpen(const string,const ENUM_ORDER_TYPE);
   //--- symbol manager
   virtual bool      RefreshRates(void);
   //--- deinitialization
   void              Deinit(const int);
   void              DeinitAccount(void);
   void              DeinitComments(void);
   void              DeinitSignals(void);
   void              DeinitSymbol(void);
   void              DeinitTimes(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::CExpertAdvisorBase(void) : m_active(true),
                                               m_every_tick(true),
                                               m_symbol_name(NULL),
                                               m_one_trade_per_candle(true),
                                               m_period(PERIOD_CURRENT),
                                               m_position_reverse(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::~CExpertAdvisorBase(void)
  {
   Deinit();
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
CComments *CExpertAdvisorBase::Comments(void)
  {
   return GetPointer(m_comments);
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
CArrayInt *CExpertAdvisorBase::OtherMagic(void)
  {
   return m_order_man.OtherMagic();
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
CSignal *CExpertAdvisorBase::Signal(void)
  {
   return GetPointer(m_signal);
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
bool CExpertAdvisorBase::AddOtherMagic(const int magic)
  {
   return m_order_man.AddOtherMagic(magic);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::AddOtherMagicString(const string &magics[])
  {
   m_order_man.AddOtherMagicString(magics);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::AsyncMode(const bool async)
  {
   m_order_man.AsyncMode(async);
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
int CExpertAdvisorBase::PricePoints(void) const
  {
   return m_order_man.PricePoints();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorBase::PricePoints(const int points)
  {
   m_order_man.PricePoints(points);
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
   if(!CheckPointer(m_signal))
      return true;
   return m_signal.Init(GetPointer(m_symbol_man),GetPointer(m_event_man));
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
void CExpertAdvisorBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new CComment(comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DisplayComment()
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Display();
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
bool CExpertAdvisorBase::AddChartComment(CComments *comments)
  {
   if(CheckPointer(m_comments))
      delete m_comments;
   m_comments=comments;
   return true;
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
bool CExpertAdvisorBase::AddSignal(CSignal *signal)
  {
   if(CheckPointer(m_signal))
      delete m_signal;
   m_signal=signal;
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
   if(CheckPointer(m_signal)==POINTER_DYNAMIC)
     {
      if(!m_signal.Validate())
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
bool CExpertAdvisorBase::TradeOpen(const string symbol,const ENUM_ORDER_TYPE type)
  {
   return m_order_man.TradeOpen(symbol,type);
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
   if(!RefreshRates())
      return false;
   bool ret=false;
   DetectNewBars();
   bool checkopenlong=false,
   checkopenshort=false,
   checkcloselong=false,
   checkcloseshort=false;
   if(CheckPointer(m_signal))
     {
      m_signal.Check();
      double   price=EMPTY_VALUE;
      double   sl=0.0;
      double   tp=0.0;
      datetime expiration=TimeCurrent();
      checkopenlong=m_signal.CheckOpenLong();
      checkopenshort = m_signal.CheckOpenShort();
      checkcloselong = m_signal.CheckCloseLong();
      checkcloseshort= m_signal.CheckCloseShort();
      //bool checkreverselong=m_signal.CheckReverseLong(price,sl,tp,expiration);
      //bool checkreverseshort=m_signal.CheckReverseShort(price,sl,tp,expiration);
     }
   COrders *orders=m_order_man.Orders();
   for(int i=orders.Total()-1;i>=0;i--)
     {
      COrder *order=orders.At(i);
      if(!CheckPointer(order))
         continue;
      order.OnTick();
      if(order.IsSuspended())
        {
         if(m_order_man.CloseOrder(order,i))
            continue;
        }
      if((checkcloselong && order.OrderType()==ORDER_TYPE_BUY) || 
         (checkcloseshort && order.OrderType()==ORDER_TYPE_SELL))
        {
         if(m_order_man.CloseOrder(order,i))
            continue;
        }
     }
   m_order_man.OnTick();
   if(CheckPointer(m_signal) && (!CheckPointer(m_times) || m_times.Evaluate()))
     {
      if(checkopenlong)
         ret=TradeOpen(m_symbol_name,ORDER_TYPE_BUY);
      if(checkopenshort)
         ret=TradeOpen(m_symbol_name,ORDER_TYPE_SELL);
     }
   return ret;
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
void CExpertAdvisorBase::Deinit(const int reason=0)
  {
   DeinitSymbol();
   DeinitSignals();
   DeinitComments();
   DeinitTimes();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitSignals(void)
  {
   delete m_signal;
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
void CExpertAdvisorBase::DeinitComments(void)
  {
   if(CheckPointer(m_comments))
      delete m_comments;
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
bool CExpertAdvisorBase::Save(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Load(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Expert\ExpertAdvisor.mqh"
#else
#include "..\..\MQL4\Expert\ExpertAdvisor.mqh"
#endif
//+------------------------------------------------------------------+
