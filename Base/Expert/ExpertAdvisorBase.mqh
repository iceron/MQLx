//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
#include "..\..\common\class\ADT.mqh"
#include <Object.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Files\FileBin.mqh>
#include "..\Lib\AccountInfo.mqh"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Candle\CandleBase.mqh"
#include "..\Signal\SignalsBase.mqh"
#include "..\Trade\ExpertTradeBase.mqh"
#include "..\Order\OrdersBase.mqh"
#include "..\Stop\StopsBase.mqh"
#include "..\Money\MoneysBase.mqh"
#include "..\Time\TimesBase.mqh"
#include "..\Comment\CommentsBase.mqh"
#include "..\Ordermanager\OrderManagerBase.mqh"
#include "..\Candle\CandleManagerBase.mqh"
class CExperts;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertBase : public CObject
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
   CSignals         *m_signals;
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
   CExperts         *m_expert;
public:
                     CExpertBase(void);
                    ~CExpertBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STRATEGY;}
   //--- initialization
   virtual bool      Add(CObject*);
   virtual bool      AddMoneys(CMoneys*);
   virtual bool      AddSignals(CSignals*);
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
   virtual CExperts *GetContainer(void) const {return GetPointer(m_expert);}
   virtual void      SetContainer(CExperts *e){m_expert=e;}
   //--- activation and deactivation
   virtual bool      Active(void) const {return m_activate;}
   virtual void      Active(const bool activate) {m_activate=activate;}
   //--- setters and getters       
   string            Name() const {return m_name;}
   void              Name(const string name) {m_name = name;}
   //bool              OfflineMode(void) const {return m_offline_mode;}
   //void              OfflineMode(const bool mode) {m_offline_mode=mode;}
   //int               OfflineModeDelay() const {return m_offline_mode_delay;}
   //void              OfflineModeDelay(const int delay){m_offline_mode_delay=delay;}
   string            SymbolName() const {return m_symbol_name;}
   void              SymbolName(const string name) {m_symbol_name = name;}
   //--- object pointers
   CAccountInfo      *AccountInfo(void) const {return GetPointer(m_account);}
   CComments         *Comments(void) const {return GetPointer(m_comments);}
   CStop             *MainStop(void) const {return m_order_man.MainStop();}
   CMoneys           *Moneys(void) const {return m_order_man.Moneys();}
   COrders           *Orders(void) {return m_order_man.Orders();}
   COrders           *OrdersHistory(void) {return m_order_man.OrdersHistory();}
   CArrayInt         *OtherMagic(void) {return m_order_man.OtherMagic();}
   CStops            *Stops(void) const {return m_order_man.Stops();}
   CSignals          *Signals(void) const {return GetPointer(m_signals);}
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
   virtual void      Period(const int period) {m_period=period;}
   virtual bool      EveryTick(void) const {return m_every_tick;}
   virtual void      EveryTick(const bool every_tick) {m_every_tick=every_tick;}
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
   virtual bool      TradeOpen(const string symbol,const int res) {return m_order_man.TradeOpen(symbol,res);}
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
CExpertBase::CExpertBase(void) : m_activate(true),
                                 m_every_tick(true),
                                 m_symbol_name(NULL),
                                 m_one_trade_per_candle(true),
                                 m_period(PERIOD_CURRENT),
                                 m_position_reverse(true)
                                 //m_offline_mode(false)
                                 //m_offline_mode_delay(500)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertBase::~CExpertBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::Init(string symbol,int period,int magic,bool every_tick=true,bool one_trade_per_candle=true,bool position_reverse=true)
  {
   m_symbol_name = symbol;
   CSymbolInfo *instrument;
   if((instrument=new CSymbolInfo)==NULL)
      return false;
   if(symbol==NULL) symbol=Symbol();
   if(!instrument.Name(symbol))
      return false;
   instrument.Refresh();
   m_symbol_man.Add(instrument);
   m_period=period;
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
bool CExpertBase::InitComponents(void)
  {
   return InitSignals() && InitAccount() && InitTimes() && InitOrderManager();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::InitSignals(void)
  {
   if(m_signals==NULL) 
      return true;
   return m_signals.Init(GetPointer(this),GetPointer(m_comments));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::InitTimes(void)
  {
   if(m_times==NULL) 
      return true;
   return m_times.Init(GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::InitAccount(CAccountInfo *account=NULL)
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
void CExpertBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new CComment(comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertBase::DisplayComment()
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Display();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::Add(CObject *object)
  {
   bool result=false;
   switch(object.Type())
     {
      case CLASS_TYPE_SIGNALS:   result=AddSignals(object); break;
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
bool CExpertBase::AddSignals(CSignals *signals)
  {
   if(CheckPointer(signals)==POINTER_DYNAMIC)
     {
      m_signals=signals;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::AddMoneys(CMoneys *moneys)
  {
   return m_order_man.AddMoneys(GetPointer(moneys));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::AddStops(CStops *stops)
  {
   return m_order_man.AddStops(GetPointer(stops));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::AddSymbol(string symbol)
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
bool CExpertBase::AddTimes(CTimes *times)
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
CExpertBase::AddCandle(const string symbol,const int timeframe)
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
bool CExpertBase::Validate(void) const
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
bool CExpertBase::OnTick(void)
  {
   if(!Active()) return false;
   if(!RefreshRates()) return false;
   bool ret=false;
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
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::CheckSignals(int &entry,int &exit) const
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
      return m_signals.CheckSignals(entry,exit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::RefreshRates()
  {
   return m_symbol_man.RefreshRates();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertBase::Deinit(const int reason=0)
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
void CExpertBase::DeinitSignals(void)
  {
   ADT::Delete(m_signals);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertBase::DeinitSymbol(void)
  {
//ADT::Delete(m_symbol);
//ADT::Delete(m_symbol_man);
   m_symbol_man.Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertBase::DeinitAccount(void)
  {
   ADT::Delete(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertBase::DeinitComments(void)
  {
   ADT::Delete(m_comments);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertBase::DeinitTimes(void)
  {
   ADT::Delete(m_times);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertBase::Save(const int handle)
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
bool CExpertBase::Load(const int handle)
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
