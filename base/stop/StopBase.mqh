//+------------------------------------------------------------------+
//|                                                     StopBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_TRAIL_TARGET.mqh"
#include "..\..\Common\Enum\ENUM_STOP_TYPE.mqh"
#include "..\Lib\AccountInfo.mqh"
#include "..\Stop\StopLineBase.mqh"
#include "..\Trade\TradeManagerBase.mqh"
#include "..\Trail\TrailsBase.mqh"
#include "..\Order\OrderStopBase.mqh"
class COrder;
class COrderStop;
class CStops;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStopBase : public CObject
  {
protected:
   //--- stop order parameters   
   bool              m_active;
   bool              m_main;
   string            m_name;
   bool              m_oco;
   double            m_stoploss;
   string            m_stoploss_name;
   ENUM_STOP_TYPE    m_stop_type;
   double            m_takeprofit;
   string            m_takeprofit_name;
   int               m_delay;
   //--- stop order trade parameters
   ENUM_VOLUME_TYPE  m_volume_type;
   double            m_volume;
   int               m_magic;
   int               m_deviation;
   string            m_comment;
   //--- stop order objects parameters
   bool              m_entry_visible;
   bool              m_stoploss_visible;
   bool              m_takeprofit_visible;
   color             m_entry_color;
   color             m_stoploss_color;
   color             m_takeprofit_color;
   ENUM_LINE_STYLE   m_entry_style;
   ENUM_LINE_STYLE   m_stoploss_style;
   ENUM_LINE_STYLE   m_takeprofit_style;
   //--- objects
   CSymbolManager   *m_symbol_man;
   CSymbolInfo      *m_symbol;
   CAccountInfo     *m_account;
   CTradeManager     m_trade_man;
   CExpertTradeX    *m_trade;
   CTrails          *m_trails;
   CEventAggregator *m_event_man;
   CStops           *m_stops;
public:
                     CStopBase(void);
                    ~CStopBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOP;}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   virtual bool      InitAccount(CAccountInfo*);
   virtual bool      InitEvent(CEventAggregator*);
   virtual bool      InitSymbol(CSymbolManager*);
   virtual bool      InitTrade(void);
   virtual CStops   *GetContainer(void);
   virtual void      SetContainer(CStops*);
   virtual bool      Validate(void) const;
   //--- getters and setters
   bool              Active(void);
   void              Active(const bool);
   bool              Broker(void) const;
   void              Comment(const string);
   string            Comment(void) const;
   void              Delay(int delay);
   int               Delay(void) const;
   void              SetDeviation(const int);
   int               SetDeviation(void) const;
   void              EntryColor(const color clr);
   void              EntryStyle(const ENUM_LINE_STYLE);
   void              EntryVisible(const bool);
   bool              EntryVisible(void) const;
   void              Magic(const int);
   int               Magic(void) const;
   void              Main(const bool);
   bool              Main(void) const;
   void              Name(const string);
   string            Name(void) const;
   void              OCO(const bool oco);
   bool              OCO(void) const;
   bool              Pending(void) const;
   void              StopLoss(const double);
   double            StopLoss(void) const;
   void              StopLossColor(const color);
   bool              StopLossCustom(void);
   void              StopLossName(const string);
   string            StopLossName(void) const;
   void              StopLossVisible(const bool);
   bool              StopLossVisible(void) const;
   void              StopLossStyle(const ENUM_LINE_STYLE);
   void              StopType(const ENUM_STOP_TYPE);
   ENUM_STOP_TYPE    StopType(void) const;
   string            SymbolName(void);
   void              TakeProfit(const double);
   double            TakeProfit(void) const;
   void              TakeProfitColor(const color);
   bool              TakeProfitCustom(void);
   void              TakeProfitName(const string);
   string            TakeProfitName(void) const;
   void              TakeProfitStyle(const ENUM_LINE_STYLE);
   void              TakeProfitVisible(const bool);
   bool              TakeProfitVisible(void) const;
   bool              Virtual(void) const;
   void              Volume(double);
   double            Volume(void) const;
   void              VolumeType(const ENUM_VOLUME_TYPE);
   ENUM_VOLUME_TYPE  VolumeType(void) const;
   //--- stop order checking
   virtual bool      CheckStopLoss(COrder*,COrderStop*);
   virtual bool      CheckTakeProfit(COrder*,COrderStop*);
   virtual bool      CheckStopOrder(double&,const ulong);
   virtual bool      DeleteStopOrder(const ulong)=0;
   virtual bool      DeleteMarketStop(const ulong)=0;
   virtual bool      OrderModify(const ulong,const double);
   //--- stop order object creation
   virtual CStopLine *CreateEntryObject(const long,const string,const int,const double);
   virtual CStopLine *CreateStopLossObject(const long,const string,const int,const double);
   virtual CStopLine *CreateTakeProfitObject(const long,const string,const int,const double);
   //--- stop order price calculation   
   virtual bool      Refresh(const string);
   virtual double    StopLossCalculate(const string,const ENUM_ORDER_TYPE,const double);
   virtual double    StopLossCustom(const string,const ENUM_ORDER_TYPE,const double);
   virtual double    StopLossPrice(COrder*,COrderStop*);
   virtual double    StopLossTicks(const ENUM_ORDER_TYPE,const double);
   virtual double    TakeProfitCalculate(const string,const ENUM_ORDER_TYPE,const double);
   virtual double    TakeProfitCustom(const string,const ENUM_ORDER_TYPE,const double);
   virtual double    TakeProfitPrice(COrder*,COrderStop*);
   virtual double    TakeProfitTicks(const ENUM_ORDER_TYPE,const double);
   //--- trailing   
   virtual bool      Add(CTrails*);
   virtual double    CheckTrailing(const string,const ENUM_ORDER_TYPE,const double,const double,const ENUM_TRAIL_TARGET);
protected:
   //--- object creation
   virtual CStopLine *CreateObject(const long,const string,const int,const double);
   //--- stop order price calculation
   virtual double    LotSizeCalculate(COrder*,COrderStop*);
   //--- stop order entry   
   virtual bool      GetClosePrice(const string,const ENUM_ORDER_TYPE,double&);
   //--- stop order exit
   virtual bool      CloseStop(COrder*,COrderStop*,const double)=0;
   //--- deinitialization
   virtual void      Deinit(void);
   virtual void      DeinitSymbol(void);
   virtual void      DeinitTrade(void);
   virtual void      DeinitTrails(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::CStopBase(void) : m_active(true),
                             m_magic(INT_MAX),
                             m_main(false),
                             m_oco(true),
                             m_stoploss(0),
                             m_takeprofit(0),
                             m_volume_type(VOLUME_TYPE_FIXED),
                             m_volume(0),
                             m_deviation(30),
                             m_comment(NULL),
                             m_stop_type(STOP_TYPE_VIRTUAL),
                             m_stoploss_name(".sl."),
                             m_takeprofit_name(".tp."),
                             m_delay(500),
                             m_entry_visible(true),
                             m_stoploss_visible(true),
                             m_takeprofit_visible(true),
                             m_entry_color(clrGray),
                             m_stoploss_color(clrRed),
                             m_takeprofit_color(clrRed),
                             m_entry_style(STYLE_SOLID),
                             m_stoploss_style(STYLE_DASH),
                             m_takeprofit_style(STYLE_DASH)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::~CStopBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Validate(void) const
  {
   if(m_name==NULL)
     {
      PrintFormat(__FUNCTION__+": empty name for stop");
      return false;
     }
   if(Virtual())
     {
      if(Pending())
        {
         PrintFormat(__FUNCTION__+": stop cannot be both pending and virtual");
         return false;
        }
      if(Broker())
        {
         PrintFormat(__FUNCTION__+": stop cannot be both broker-based and virtual");
         return false;
        }
     }
   if(CheckPointer(m_trails))
      return m_trails.Validate();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStops *CStopBase::GetContainer(void)
  {
   return m_stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::SetContainer(CStops *stops)
  {
   m_stops=stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Active(void)
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::Active(const bool activate)
  {
   m_active=activate;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Broker(void) const
  {
   return m_stop_type==STOP_TYPE_BROKER;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::Comment(string comment)
  {
   m_comment=comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CStopBase::Comment(void) const
  {
   return m_comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::Delay(int delay)
  {
   m_delay=delay;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CStopBase::Delay(void) const
  {
   return m_delay;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::SetDeviation(int deviation)
  {
   m_deviation=deviation;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CStopBase::SetDeviation(void) const
  {
   return m_deviation;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::EntryColor(const color clr)
  {
   m_entry_color=clr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::EntryStyle(const ENUM_LINE_STYLE style)
  {
   m_entry_style=style;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::EntryVisible(const bool value)
  {
   m_entry_visible=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::EntryVisible(void) const
  {
   return m_entry_visible;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::Magic(const int magic)
  {
   m_magic=magic;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CStopBase::Magic(void) const
  {
   return m_magic;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::Main(const bool main)
  {
   m_main=main;
   m_oco=m_main;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Main(void) const
  {
   return m_main;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::Name(const string name)
  {
   m_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CStopBase::Name(void) const
  {
   return m_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::OCO(const bool oco)
  {
   if(!Main())
      m_oco=oco;
   else m_oco=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::OCO(void) const
  {
   return m_oco;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Pending(void) const
  {
   return m_stop_type==STOP_TYPE_PENDING;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::StopLoss(const double sl)
  {
   m_stoploss=sl;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::StopLoss(void) const
  {
   return m_stoploss;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::StopLossColor(const color clr)
  {
   m_stoploss_color=clr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::StopLossCustom(void)
  {
   return m_stoploss==0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::StopLossName(const string name)
  {
   m_stoploss_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CStopBase::StopLossName(void) const
  {
   return m_stoploss_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::StopLossStyle(const ENUM_LINE_STYLE style)
  {
   m_stoploss_style=style;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::StopLossVisible(const bool value)
  {
   m_stoploss_visible=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::StopLossVisible(void) const
  {
   return m_stoploss_visible;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::StopType(const ENUM_STOP_TYPE type)
  {
   m_stop_type=type;
   if(m_stop_type==STOP_TYPE_BROKER)
      m_main=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_STOP_TYPE CStopBase::StopType(void) const
  {
   return m_stop_type;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CStopBase::SymbolName(void)
  {
   return m_symbol.Name();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::TakeProfit(const double tp)
  {
   m_takeprofit=tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::TakeProfit(void) const
  {
   return m_takeprofit;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::TakeProfitColor(const color clr)
  {
   m_takeprofit_color=clr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::TakeProfitCustom(void)
  {
   return m_takeprofit==0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::TakeProfitName(const string name)
  {
   m_takeprofit_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CStopBase::TakeProfitName(void) const
  {
   return m_takeprofit_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::TakeProfitStyle(const ENUM_LINE_STYLE style)
  {
   m_takeprofit_style=style;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::TakeProfitVisible(const bool value)
  {
   m_takeprofit_visible=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::TakeProfitVisible(void) const
  {
   return m_takeprofit_visible;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Virtual(void) const
  {
   return m_stop_type==STOP_TYPE_VIRTUAL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::Volume(double volume)
  {
   m_volume=volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::Volume(void) const
  {
   return m_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::VolumeType(const ENUM_VOLUME_TYPE type)
  {
   m_volume_type=type;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_VOLUME_TYPE CStopBase::VolumeType(void) const
  {
   return m_volume_type;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::CheckStopOrder(double &,const ulong)
  {
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::StopLossCustom(const string,const ENUM_ORDER_TYPE,const double)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::StopLossPrice(COrder *,COrderStop *)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::StopLossTicks(const ENUM_ORDER_TYPE,const double)
  {
   return m_stoploss;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::TakeProfitCustom(const string,const ENUM_ORDER_TYPE,const double)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::TakeProfitPrice(COrder *,COrderStop *)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::TakeProfitTicks(const ENUM_ORDER_TYPE,const double)
  {
   return m_takeprofit;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo,CEventAggregator *event_man=NULL)
  {
   if(!CheckPointer(accountinfo))
      return false;
   InitSymbol(symbolmanager);
   InitAccount(accountinfo);
   InitEvent(event_man);
   InitTrade();
   if(CheckPointer(m_trails))
     {
      m_trails.SetContainer(GetPointer(this));
      if(!m_trails.Init(symbolmanager,event_man))
        {
         Print(__FUNCTION__+": error in trailing manager initialization");
         return false;
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::InitEvent(CEventAggregator *event_man)
  {
   m_event_man=event_man;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::InitSymbol(CSymbolManager *symbolmanager)
  {
   m_symbol_man=symbolmanager;
   return CheckPointer(m_symbol_man);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::InitAccount(CAccountInfo *accountinfo=NULL)
  {
   if(CheckPointer(accountinfo))
      m_account=accountinfo;
   return CheckPointer(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::InitTrade()
  {
   for(int i=0;i<m_symbol_man.Total();i++)
     {
      CSymbolInfo *symbol=m_symbol_man.At(i);
      CExpertTradeX *trade=new CExpertTradeX();
      if(CheckPointer(trade))
        {
         trade.SetSymbol(GetPointer(symbol));
         trade.SetExpertMagicNumber(m_magic);
         trade.SetDeviationInPoints((ulong)(m_deviation/symbol.Point()));
         m_trade_man.Add(trade);
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::LotSizeCalculate(COrder *order,COrderStop *orderstop)
  {
   m_symbol=m_symbol_man.Get(order.Symbol());
   if(!CheckPointer(m_symbol))
      return 0;
   double lotsize=0.0;
   if(Main())
      lotsize=order.Volume();
   else
     {
      if(m_volume_type==VOLUME_TYPE_FIXED)
         lotsize=orderstop.Volume();
      else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
         lotsize=orderstop.Volume()*order.Volume();
      if(m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
         lotsize=orderstop.Volume()*order.VolumeInitial();
      else if(m_volume_type==VOLUME_TYPE_REMAINING)
         lotsize=order.Volume();
     }
   double maxvol=m_symbol.LotsMax();
   double minvol=m_symbol.LotsMin();
   if(lotsize<minvol)
      lotsize=minvol;
   if(lotsize>maxvol)
      lotsize=maxvol;
   return lotsize;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::StopLossCalculate(const string symbol,const ENUM_ORDER_TYPE type,const double price)
  {   
   if(!Refresh(symbol))
      return 0;
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return price-m_stoploss*m_symbol.Point();
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return price+m_stoploss*m_symbol.Point();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::TakeProfitCalculate(const string symbol,const ENUM_ORDER_TYPE type,const double price)
  {
   if(!Refresh(symbol))
      return 0;
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return price+m_takeprofit*m_symbol.Point();
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return price-m_takeprofit*m_symbol.Point();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::GetClosePrice(const string symbol,const ENUM_ORDER_TYPE type,double &price)
  {
   if(!Refresh(symbol))
      return false;
   if(type==ORDER_TYPE_BUY)
      price=m_symbol.Bid();
   else if(type==ORDER_TYPE_SELL)
      price=m_symbol.Ask();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::CheckStopLoss(COrder *order,COrderStop *orderstop)
  {
   if(!Refresh(order.Symbol()))
      return false;
   double stoploss=orderstop.StopLoss();
   if(stoploss<=0.0)
      return false;
   double price=0.0;
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)order.OrderType();
   if(!GetClosePrice(order.Symbol(),type,price))
      return false;
   bool close=false;
   if(type==ORDER_TYPE_BUY)
     {
      if(price<=stoploss)
         close=true;
     }
   else if(type==ORDER_TYPE_SELL)
     {
      if(price>=stoploss)
         close=true;
     }
   if(close)
      return CloseStop(order,orderstop,price);
   return close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::CheckTakeProfit(COrder *order,COrderStop *orderstop)
  {
   if(!Refresh(order.Symbol()))
      return false;
   double takeprofit=orderstop.TakeProfit();
   if(takeprofit<=0.0)
      return false;
   double price=0.0;
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)order.OrderType();
   if(!GetClosePrice(order.Symbol(),type,price))
      return false;
   bool close=false;
   if(type==ORDER_TYPE_BUY)
      if(price>=takeprofit) close=true;
   else if(type==ORDER_TYPE_SELL)
      if(price<=takeprofit) close=true;
   if(close)
      return CloseStop(order,orderstop,price);
   return close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Refresh(const string symbol)
  {
   if(!CheckPointer(m_symbol) || StringCompare(m_symbol.Name(),symbol)!=0)
     {
      m_symbol= m_symbol_man.Get(symbol);
      m_trade = m_trade_man.Get(symbol);
     }
   if(CheckPointer(m_symbol))
      return m_symbol.RefreshRates();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::Deinit(void)
  {
   DeinitTrade();
   DeinitTrails();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::DeinitSymbol(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::DeinitTrade(void)
  {
   m_trade_man.Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::DeinitTrails(void)
  {
   if(CheckPointer(m_trails)==POINTER_DYNAMIC)
      delete m_trails;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Add(CTrails *trails)
  {
   if(CheckPointer(trails)==POINTER_DYNAMIC)
      m_trails=trails;
   return CheckPointer(m_trails);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::CheckTrailing(const string symbol,const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode)
  {
   if(!CheckPointer(m_trails))
      return 0;
   return m_trails.Check(symbol,type,entry_price,price,mode);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::OrderModify(const ulong ticket,const double value)
  {
   return m_trade.OrderModify(ticket,value,0.0,0.0,0,0,0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLine *CStopBase::CreateEntryObject(const long id,const string name,const int window,const double price)
  {
   CStopLine *obj=CreateObject(id,name,window,price);
   if(CheckPointer(obj)==POINTER_DYNAMIC)
     {
      obj.Selectable(false);
      obj.SetStyle(m_entry_style);
      obj.SetColor(m_entry_color);
      if(!m_entry_visible)
         obj.Timeframes(OBJ_NO_PERIODS);
      return obj;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLine *CStopBase::CreateStopLossObject(const long id,const string name,const int window,const double price)
  {
   CStopLine *obj=CreateObject(id,name,window,price);
   if(CheckPointer(obj)==POINTER_DYNAMIC)
     {
      obj.Selectable(true);
      obj.SetStyle(m_stoploss_style);
      obj.SetColor(m_stoploss_color);
      if(!m_stoploss_visible)
         obj.Timeframes(OBJ_NO_PERIODS);
      return obj;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLine *CStopBase::CreateTakeProfitObject(const long id,const string name,const int window,const double price)
  {
   CStopLine *obj=CreateObject(id,name,window,price);
   if(CheckPointer(obj)==POINTER_DYNAMIC)
     {
      obj.Selectable(true);
      obj.SetStyle(m_takeprofit_style);
      obj.SetColor(m_takeprofit_color);
      if(!m_takeprofit_visible)
         obj.Timeframes(OBJ_NO_PERIODS);
      return obj;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLine *CStopBase::CreateObject(const long id,const string name,const int window,const double price)
  {
   CStopLine *obj=new CStopLine();
   if(obj.Create(id,name,window,price))
      return obj;
   return NULL;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Stop\Stop.mqh"
#else
#include "..\..\MQL4\Stop\Stop.mqh"
#endif
//+------------------------------------------------------------------+
