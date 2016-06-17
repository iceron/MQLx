//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\common\class\ADT.mqh"
#include <Object.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Files\FileBin.mqh>
#include "..\Lib\AccountInfo.mqh"
//#include "..\Lib\ExpertBase.mqh"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Candle\CandleBase.mqh"
#include "..\Signal\SignalBase.mqh"
#include "..\Trade\ExpertTradeBase.mqh"
#include "..\Order\OrdersBase.mqh"
#include "..\Stop\StopsBase.mqh"
#include "..\Money\MoneysBase.mqh"
#include "..\Time\TimesBase.mqh"
#include "..\Comment\CommentsBase.mqh"
#include "..\Ordermanager\OrderManagerBase.mqh"
#include "..\Candle\CandleManagerBase.mqh"
#include "..\Signal\ExpertSignalXBase.mqh"
class CExpertAdvisors;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisorBase : public CObject
  {
protected:
   //--- trade parameters
   bool              m_activate;
   string            m_name;
   //--- signal parameters
   bool              m_every_tick;
   bool              m_one_trade_per_candle;
   string            m_symbol_name;
   int               m_period;
   bool              m_position_reverse;
   //bool              m_offline_mode;
   //int               m_offline_mode_delay;
   //--- signal objects
   //CSignals         *m_signals;
   CSignal          *m_signal;
   //--- trade objects   
   CAccountInfo     *m_account;
   CSymbolManager    m_symbol_man;
   COrderManager     m_order_man;
   //--- trading time objects
   CTimes           *m_times;
   //--- comments
   CComments        *m_comments;
   //--- candle
   CCandleManager    m_candle_man;
   //--- container
   CExpertAdvisors *m_expert;
public:
                     CExpertAdvisorBase(void);
                    ~CExpertAdvisorBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STRATEGY;}
   //--- initialization
   virtual bool      Add(CObject*);
   virtual bool      AddMoneys(CMoneys*);
   virtual bool      AddSignal(CSignal*);
   virtual bool      AddStops(CStops*);
   virtual bool      AddSymbol(const string);
   virtual bool      AddTimes(CTimes*);
   virtual bool      Init(const string,const int,const int,const bool,const bool,const bool);
   virtual bool      InitAccount(CAccountInfo*);
   virtual bool      InitComponents(void);
   virtual bool      InitSignals(void);
   virtual bool      InitTimes(void);
   virtual bool      InitOrderManager(void) {return m_order_man.Init(GetPointer(this),GetPointer(m_symbol_man),GetPointer(m_account));}
   virtual bool      Validate(void) const;
   //--- container
   virtual CExpertAdvisors *GetContainer(void) const {return GetPointer(m_expert);}
   virtual void      SetContainer(CExpertAdvisors *e){m_expert=e;}
   //--- activation and deactivation
   virtual bool      Active(void) const {return m_activate;}
   virtual void      Active(const bool activate) {m_activate=activate;}
   //--- setters and getters       
   string            Name() const {return m_name;}
   void              Name(const string name) {m_name=name;}
   //bool              OfflineMode(void) const {return m_offline_mode;}
   //void              OfflineMode(const bool mode) {m_offline_mode=mode;}
   //int               OfflineModeDelay() const {return m_offline_mode_delay;}
   //void              OfflineModeDelay(const int delay){m_offline_mode_delay=delay;}
   string            SymbolName() const {return m_symbol_name;}
   void              SymbolName(const string name) {m_symbol_name=name;}
   //--- object pointers
   //CAccountInfo      *AccountInfo(void) const {return GetPointer(m_account);}
   CComments         *Comments(void) const {return GetPointer(m_comments);}
   CStop             *MainStop(void) const {return m_order_man.MainStop();}
   CMoneys           *Moneys(void) const {return m_order_man.Moneys();}
   COrders           *Orders(void) {return m_order_man.Orders();}
   COrders           *OrdersHistory(void) {return m_order_man.OrdersHistory();}
   CArrayInt         *OtherMagic(void) {return m_order_man.OtherMagic();}
   CStops            *Stops(void) const {return m_order_man.Stops();}
   //CSignals          *Signals(void) const {return GetPointer(m_signals);}
   CTimes            *Times(void) const {return GetPointer(m_times);}
   //--- chart comment manager
   void              AddComment(const string);
   void              ChartComment(CComments *comments) {m_comments=comments;}
   void              DisplayComment(void);
   //--- order manager
   virtual bool      AddOtherMagic(const int magic) {return m_order_man.AddOtherMagic(magic);}
   virtual void      AddOtherMagicString(const string &magics[]){m_order_man.AddOtherMagicString(magics);}
   void              AsyncMode(const bool async) {m_order_man.AsyncMode(async);}
   string            Comment(void) const {return m_order_man.Comment();}
   void              Comment(const string comment){m_order_man.Comment(comment);}
   bool              EnableTrade(void) const {return m_order_man.EnableTrade();}
   void              EnableTrade(bool allowed){m_order_man.EnableTrade(allowed);}
   bool              EnableLong(void) const {return m_order_man.EnableLong();}
   void              EnableLong(bool allowed){m_order_man.EnableLong(allowed);}
   bool              EnableShort(void) const {return m_order_man.EnableShort();}
   void              EnableShort(bool allowed){m_order_man.EnableShort(allowed);}
   int               Expiration(void) const {return m_order_man.Expiration();}
   void              Expiration(const int expiration) {m_order_man.Expiration(expiration);}
   double            LotSize(void) const {return m_order_man.LotSize();}
   void              LotSize(const double lotsize){m_order_man.LotSize(lotsize);}
   int               MaxOrdersHistory(void) const {return m_order_man.MaxOrdersHistory();}
   void              MaxOrdersHistory(const int max) {m_order_man.MaxOrdersHistory(max);}
   int               Magic(void) const {return m_order_man.Magic();}
   void              Magic(const int magic) {m_order_man.Magic(magic);}
   virtual uint      MaxTrades(void) const {return m_order_man.MaxTrades();}
   virtual void      MaxTrades(const int max_trades){m_order_man.MaxTrades(max_trades);}
   virtual int       MaxOrders(void) const {return m_order_man.MaxOrders();}
   virtual void      MaxOrders(const int max_orders) {m_order_man.MaxOrders(max_orders);}
   int               OrdersTotal(void) const {return m_order_man.OrdersTotal();}
   int               OrdersHistoryTotal(void) const {return m_order_man.OrdersHistoryTotal();}
   int               TradesTotal(void) const{return m_order_man.TradesTotal();}
   //--- signal manager   
   virtual int       Period(void) const {return m_period;}
   virtual void      Period(const int period) {m_period=(ENUM_TIMEFRAMES)period;}
   //virtual bool      EveryTick(void) const {return m_every_tick;}
   //virtual void      EveryTick(const bool every_tick) {m_every_tick=every_tick;}
   virtual bool      OneTradePerCandle(void) const {return m_one_trade_per_candle;}
   virtual void      OneTradePerCandle(const bool one_trade_per_candle){m_one_trade_per_candle=one_trade_per_candle;}
   virtual bool      PositionReverse(void) const {return m_position_reverse;}
   virtual void      PositionReverse(const bool position_reverse){m_position_reverse=position_reverse;}
   //--- additional candles
   virtual void      AddCandle(const string,const int);
   //--- new bar detection
   virtual void      DetectNewBars(void) const {m_candle_man.Check();}
   //-- generic events
   virtual bool      OnTick(void);
   virtual void      OnChartEvent(const int,const long&,const double&,const string&) {}
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);



protected:
   //--- candle manager   
   virtual bool      IsNewBar(const string symbol,const int period) const {return m_candle_man.IsNewCandle(symbol,period);}
   //--- order manager
   virtual void      CloseOppositeOrders(const string symbol,const int entry,const int exit) {m_order_man.CloseOppositeOrders(symbol,entry,exit);}
   virtual void      ManageOrders(void) {m_order_man.ManageOrders();}
   virtual void      ManageOrdersHistory(void){m_order_man.ManageOrdersHistory();}
   virtual void      OnTradeTransaction(COrder*) {}
   virtual bool      TradeOpen(const string symbol,const ENUM_ORDER_TYPE type) {return m_order_man.TradeOpen(symbol,type);}
   //--- signal manager
   virtual bool      CheckSignals(int&,int&) const;
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
CExpertAdvisorBase::CExpertAdvisorBase(void) : m_activate(true),
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
//InitTrade();
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
      Print("error in signal initialization");
      return false;
     }
   if(!InitAccount())
     {
      Print("error in account initialization");
      return false;
     }
   if(!InitTimes())
     {
      Print("error in time initialization");
      return false;
     }
   if(!InitOrderManager())
     {
      Print("error in order manager initialization");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitSignals(void)
  {
   /*
   if(m_signals==NULL)
      return true;
   return m_signals.Init(GetPointer(this),GetPointer(m_comments));
   */
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitTimes(void)
  {
   if(m_times==NULL)
      return true;
   return m_times.Init(GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::InitAccount(CAccountInfo *account=NULL)
  {
   if(m_account!=NULL)
      delete m_account;
   if(account==NULL)
     {
      if((m_account=new CAccountInfo)==NULL)
         return false;
     }
   else m_account=account;
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
bool CExpertAdvisorBase::Add(CObject *object)
  {
   bool result=false;
   switch(object.Type())
     {
      case CLASS_TYPE_SIGNAL:   result=AddSignal(object); break;
      case CLASS_TYPE_MONEYS:    result=AddMoneys(object);  break;
      case CLASS_TYPE_STOPS:     result=AddStops(object);   break;
      case CLASS_TYPE_TIMES:     result=AddTimes(object);   break;
      default: PrintFormat(__FUNCTION__+": unknown object: "+DoubleToString(object.Type(),0));
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::AddSignal(CSignal *signal)
  {
   if(m_signal!=NULL)
     {
      delete m_signal;
     }
   m_signal=signal;
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
   CSymbolInfo *instrument=new CSymbolInfo();
   instrument.Name(symbol);
   instrument.Refresh();
   CCandle *candle=new CCandle();
   candle.Init(instrument,timeframe);
   m_candle_man.Add(candle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Validate(void) const
  {
/*
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
     {
      if(!m_signals.Validate())
         return false;
     }
   */
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
bool CExpertAdvisorBase::OnTick(void)
  {
   if(!Active()) return false;
   if(!RefreshRates()) return false;

   bool ret=false;
/*
//bool newtick= m_tick.IsNewTick(m_symbol);
   bool newtick=true;
   DetectNewBars();
   bool newbar=IsNewBar(m_symbol_name,m_period);
   m_order_man.OnTick();
   ManageOrders();
   int entry=0,exit=0;
   CheckSignals(entry,exit);
//AddComment("last tick: "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   AddComment("entry signal: "+EnumToString((ENUM_CMD)entry));
   AddComment("exit signal: "+EnumToString((ENUM_CMD)exit));
   if(newbar || (m_every_tick && newtick))
     {
      CloseOppositeOrders(m_symbol_name,entry,exit);
      ManageOrders();
      if(!m_candle_man.TradeProcessed(m_symbol_name,m_period))
        {
         if(!CheckPointer(m_times) || (m_times.Evaluate()))
            ret=TradeOpen(m_symbol_name,entry);
         if(ret)
           {
            //m_last_trade_data=m_tick.LastTick();
            m_candle_man.TradeProcessed(m_symbol_name,m_period,true);
           }
        }
     }
   ManageOrdersHistory();
   DisplayComment();
   */
   DetectNewBars();
//m_orders.OnTick();
//ManageOrders();
   m_signal.Check();
   double   price=EMPTY_VALUE;
   double   sl=0.0;
   double   tp=0.0;
   datetime expiration=TimeCurrent();
   bool checkopenlong=m_signal.CheckOpenLong();
   bool checkopenshort = m_signal.CheckOpenShort();
   bool checkcloselong = m_signal.CheckCloseLong();
   bool checkcloseshort= m_signal.CheckCloseShort();
//bool checkreverselong=m_signal.CheckReverseLong(price,sl,tp,expiration);
//bool checkreverseshort=m_signal.CheckReverseShort(price,sl,tp,expiration);
//Print(checkopenlong+" "+checkopenshort+" "+checkcloselong+" "+checkcloseshort);
   COrders *orders=m_order_man.Orders();
   for(int i=orders.Total()-1;i>=0;i--)
     {
      COrder *order=orders.At(i);
      if(order==NULL)
         continue;
      //ontick handler
      order.OnTick();
      //checking if the order was closed through external means (flag)      
      if(order.IsClosed())
        {
         if(m_order_man.CloseOrder(order,i))
           {
            if(m_order_man.ArchiveOrder(orders.Detach(i)))
               continue;
           }
        }
      //checking if the order should be closed
      if((checkcloselong && order.OrderType()==ORDER_TYPE_BUY) || (checkcloseshort && order.OrderType()==ORDER_TYPE_SELL))
        {
         if(m_order_man.CloseOrder(order,i))
           {
            if(m_order_man.ArchiveOrder(orders.Detach(i)))
               continue;
           }
        }
     }
   if(!CheckPointer(m_times) || (m_times.Evaluate()))
     {
      if(checkopenlong)
        {
         ret=TradeOpen(m_symbol_name,ORDER_TYPE_BUY);
        }
      if(checkopenshort)
        {
         ret=TradeOpen(m_symbol_name,ORDER_TYPE_SELL);
        }
     }
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::CheckSignals(int &entry,int &exit) const
  {
/*
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
      return m_signals.CheckSignals(entry,exit);
   return false;
   */
//Print();
   return true;
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
   DeinitAccount();
   DeinitComments();
   DeinitTimes();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitSignals(void)
  {
//ADT::Delete(m_signals);
   delete m_signal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitSymbol(void)
  {
//ADT::Delete(m_symbol);
//ADT::Delete(m_symbol_man);
   m_symbol_man.Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitAccount(void)
  {
//ADT::Delete(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitComments(void)
  {
   ADT::Delete(m_comments);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorBase::DeinitTimes(void)
  {
   ADT::Delete(m_times);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Save(const int handle)
  {
//ADT::WriteStruct(handle,m_last_trade_data);
//ADT::WriteObject(handle,GetPointer(m_orders));
//ADT::WriteObject(handle,GetPointer(m_orders_history));
//ADT::WriteObject(handle,GetPointer(m_tick));
//ADT::WriteObject(handle,GetPointer(m_candle));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorBase::Load(const int handle)
  {
//ADT::ReadStruct(handle,m_last_trade_data);
//ADT::ReadObject(handle,GetPointer(m_orders));
//ADT::ReadObject(handle,GetPointer(m_orders_history));
//ADT::ReadObject(handle,GetPointer(m_tick));
//ADT::ReadObject(handle,GetPointer(m_candle));
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Expert\ExpertAdvisor.mqh"
#else
#include "..\..\MQL4\Expert\ExpertAdvisor.mqh"
#endif
//+------------------------------------------------------------------+
