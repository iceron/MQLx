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
   CStops           *m_stops;
public:
                     CStopBase(void);
                    ~CStopBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOP;}
   //--- initialization
   virtual bool      Init(CSymbolManager *,CAccountInfo *);
   virtual bool      InitAccount(CAccountInfo *);
   virtual bool      InitSymbol(CSymbolManager *);
   virtual bool      InitTrade(void);
   virtual void      SetContainer(CStops *stops){m_stops=stops;}
   virtual bool      Validate(void) const;
   //--- getters and setters
   bool              Active(void) {return m_active;}
   void              Active(const bool activate) {m_active=activate;}
   bool              Broker(void) const {return m_stop_type==STOP_TYPE_BROKER;}
   void              Comment(string comment) {m_comment=comment;}
   string            Comment(void) const {return m_comment;}
   void              Delay(int delay) {m_delay=delay;}
   int               Delay(void) const {return m_delay;}
   void              SetDeviation(int deviation) {m_deviation=deviation;}
   int               SetDeviation(void) const {return m_deviation;}
   void              EntryColor(const color clr) {m_entry_color=clr;}
   void              EntryStyle(const ENUM_LINE_STYLE style) {m_entry_style=style;}
   void              Magic(const int magic) {m_magic=magic;}
   int               Magic(void) const {return m_magic;}
   void              Main(const bool main) {m_main=main; m_oco=true;}
   bool              Main(void) const {return m_main;}
   void              Name(const string name) {m_name=name;}
   string            Name(void) const{return m_name;}
   void              OCO(const bool oco) {if(!Main())m_oco=oco;}
   bool              OCO(void) const{return m_oco;}
   bool              Pending(void) const {return m_stop_type==STOP_TYPE_PENDING;}
   void              StopLoss(const double sl) {m_stoploss=sl;}
   double            StopLoss(void) const {return m_stoploss;}
   void              StopLossColor(const color clr) {m_stoploss_color=clr;}
   bool              StopLossCustom(void) {return m_stoploss==0;}
   void              StopLossName(const string name) {m_stoploss_name=name;}
   string            StopLossName(void) const{return m_stoploss_name;}
   void              StopLossStyle(const ENUM_LINE_STYLE style) {m_stoploss_style=style;}
   void              StopType(const ENUM_STOP_TYPE stop_type);
   ENUM_STOP_TYPE    StopType(void) const {return m_stop_type;}
   string            SymbolName(void) {return m_symbol.Name();}
   void              TakeProfit(const double tp) {m_takeprofit=tp;}
   double            TakeProfit(void) const {return m_takeprofit;}
   void              TakeProfitColor(const color clr) {m_takeprofit_color=clr;}
   bool              TakeProfitCustom(void) {return m_takeprofit==0;}
   void              TakeProfitName(const string name) {m_takeprofit_name=name;}
   string            TakeProfitName(void) const {return m_takeprofit_name;}
   void              TakeProfitStyle(const ENUM_LINE_STYLE style) {m_takeprofit_style=style;}
   bool              Virtual(void) const {return m_stop_type==STOP_TYPE_VIRTUAL;}
   void              Volume(double volume) {m_volume = volume;}
   double            Volume(void) const {return m_volume;}
   void              VolumeType(const ENUM_VOLUME_TYPE type){m_volume_type=type;}
   //--- stop order checking
   virtual bool      CheckStopLoss(COrder *,COrderStop *);
   virtual bool      CheckTakeProfit(COrder *,COrderStop *);
   virtual bool      CheckStopOrder(double &,const ulong) const {return false;}
   virtual bool      OrderModify(const ulong,const double);
   //--- stop order object creation
   virtual CStopLine *CreateEntryObject(const long,const string,const int,const double);
   virtual CStopLine *CreateStopLossObject(const long,const string,const int,const double);
   virtual CStopLine *CreateTakeProfitObject(const long,const string,const int,const double);
   //--- stop order price calculation   
   virtual bool      Refresh(const string);
   virtual double    StopLossCalculate(const string,const ENUM_ORDER_TYPE,const double);
   virtual double    StopLossCustom(const ENUM_ORDER_TYPE,const double) {return 0;}
   virtual double    StopLossPrice(COrder *,COrderStop *){return 0;}
   virtual double    StopLossTicks(const ENUM_ORDER_TYPE,const double) {return m_stoploss;}
   virtual double    TakeProfitCalculate(const string,const ENUM_ORDER_TYPE,const double price);
   virtual double    TakeProfitCustom(const ENUM_ORDER_TYPE,const double) {return 0;}
   virtual double    TakeProfitPrice(COrder *,COrderStop *) {return 0;}
   virtual double    TakeProfitTicks(const ENUM_ORDER_TYPE,const double) {return m_takeprofit;}
   //--- trailing   
   virtual bool      Add(CTrails *);
   virtual double    CheckTrailing(const string,const ENUM_ORDER_TYPE,const double,const double,const ENUM_TRAIL_TARGET);
protected:
   //--- object creation
   virtual CStopLine *CreateObject(const long,const string,const int,const double);
   //--- stop order price calculation
   virtual double    LotSizeCalculate(COrder *,COrderStop *);
   //--- stop order entry   
   virtual bool      GetClosePrice(const string,const ENUM_ORDER_TYPE,double &);
   //--- stop order exit
   virtual bool      CloseStop(COrder *,COrderStop *,const double) {return true;}
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
   if (Virtual() && Pending())
   {
      PrintFormat(__FUNCTION__+": stop cannot be both pending and virtual");
      return false;
   }
   if (Virtual() && Broker())
   {
      PrintFormat(__FUNCTION__+": stop cannot be both broker-based and virtual");
      return false;
   }
   if(m_trails!=NULL)
     {
      for(int i=0;i<m_trails.Total();i++)
        {
         CTrail *trail=m_trails.At(i);
         if (trail!=NULL)
            if(!trail.Validate())
               return false;
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   if(symbolmanager==NULL || accountinfo==NULL) 
      return false;
   InitSymbol(symbolmanager);
   InitAccount(accountinfo);
   InitTrade();
   if(m_trails!=NULL)
   {
      if (!m_trails.Init(symbolmanager,GetPointer(this)))
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
bool CStopBase::InitSymbol(CSymbolManager *symbolmanager)
  {
   m_symbol_man = symbolmanager;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::InitAccount(CAccountInfo *accountinfo=NULL)
  {
   if(accountinfo==NULL) return false;
   m_account=accountinfo;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::InitTrade()
  {
   for (int i=0;i<m_symbol_man.Total();i++)
   {
      CSymbolInfo *symbol = m_symbol_man.At(i);
      CExpertTradeX *trade = new CExpertTradeX();
      if (trade!=NULL)
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
   double lotsize=0.0;   
   if(m_volume_type==VOLUME_TYPE_FIXED)
      lotsize=orderstop.Volume();
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
      lotsize=orderstop.Volume()*order.Volume();
   if(m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
      lotsize=orderstop.Volume()*order.VolumeInitial();
   else if(m_volume_type==VOLUME_TYPE_REMAINING)
      lotsize=order.Volume();
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
   if(!Refresh(symbol)) return false;
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
   if(!Refresh(order.Symbol())) return false;
   double stoploss=orderstop.StopLoss();
   if(stoploss<=0.0) return false;
   double price=0.0;
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)order.OrderType();
   if(!GetClosePrice(order.Symbol(),type,price)) return false;
   bool close=false;
   if(type==ORDER_TYPE_BUY)
      if(price<=stoploss) 
         close=true;
   else if(type==ORDER_TYPE_SELL)
      if(price>=stoploss) 
         close=true;
   if(close)
      return CloseStop(order,orderstop,price);
   return close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::CheckTakeProfit(COrder *order,COrderStop *orderstop)
  {
   if(!Refresh(order.Symbol())) return false;
   double takeprofit=orderstop.TakeProfit();
   if(takeprofit<=0.0) return false;
   double price=0.0;
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)order.OrderType();
   if(!GetClosePrice(order.Symbol(),type,price)) return false;
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
   if (m_symbol==NULL || StringCompare(m_symbol.Name(),symbol)!=0)
   {
      m_symbol = m_symbol_man.Get(symbol);
      m_trade = m_trade_man.Get(symbol);
   }   
   if(CheckPointer(m_symbol)==POINTER_DYNAMIC)
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
   if (m_trails!=NULL)
      delete m_trails;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::StopType(const ENUM_STOP_TYPE type)
  {
   m_stop_type=type;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Add(CTrails *trails)
  {
   if(CheckPointer(trails)==POINTER_DYNAMIC)
      m_trails=trails;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::CheckTrailing(const string symbol,const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode)
  {
   if(!CheckPointer(m_trails)) return 0;
   if(!Refresh(symbol)) return 0;
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
