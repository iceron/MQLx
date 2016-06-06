//+------------------------------------------------------------------+
//|                                                     StopBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\Common\Enum\ENUM_TRAIL_TARGET.mqh"
#include "..\..\Common\Enum\ENUM_STOP_TYPE.mqh"
#include "..\Stop\StopLineBase.mqh"
#include "..\Trade\TradeBase.mqh"
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
   bool              m_activate;
   bool              m_main;
   string            m_name;
   bool              m_oco;
   double            m_stoploss;
   string            m_stoploss_name;
   ENUM_STOP_TYPE    m_stop_type;
   double            m_takeprofit;
   string            m_takeprofit_name;
   //--- stop order trade parameters
   ENUM_VOLUME_TYPE  m_volume_type;
   double            m_volume_fixed;
   double            m_volume_percent;
   int               m_magic;
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
   CExpertTrade           *m_trade;
   CTrails          *m_trails;
   CStops           *m_stops;
public:
                     CStopBase(void);
                    ~CStopBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOP;}
   //--- initialization
   virtual bool      Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo);
   virtual bool      InitAccount(CAccountInfo *accountinfo=NULL);
   virtual bool      InitSymbol(CSymbolManager *symbolmanager);
   virtual bool      InitTrade(CExpertTrade *trade=NULL);
   virtual void      SetContainer(CStops *stops){m_stops=stops;}
   virtual bool      Validate(void) const;
   //--- getters and setters
   bool              Active(void) {return m_activate;}
   void              Active(const bool activate) {m_activate=activate;}
   bool              Broker() const {return m_stop_type==STOP_TYPE_BROKER;}
   void              Comment(string comment) {m_comment=comment;}
   string            Comment(void) const {return m_comment;}
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
   bool              Pending() const {return m_stop_type==STOP_TYPE_PENDING;}
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
   void              Volume(COrderStop *orderstop,double &volume_fixed,double &volume_percent);
   double            VolumeFixed(void) const {return m_volume_fixed;}
   void              VolumeFixed(const double volume) {m_volume_fixed=volume;}
   double            VolumePercent(void) const {return m_volume_percent;}
   void              VolumePercent(const double volume) {m_volume_percent=volume;}
   void              VolumeType(const ENUM_VOLUME_TYPE type){m_volume_type=type;}
   //--- stop order checking
   virtual bool      CheckStopLoss(COrder *order,COrderStop *orderstop);
   virtual bool      CheckTakeProfit(COrder *order,COrderStop *orderstop);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const {return false;}
   virtual bool      OrderModify(const ulong ticket,const double value);
   //--- stop order object creation
   virtual CStopLine *CreateEntryObject(const long id,const string name,const int window,const double price);
   virtual CStopLine *CreateStopLossObject(const long id,const string name,const int window,const double price);
   virtual CStopLine *CreateTakeProfitObject(const long id,const string name,const int window,const double price);
   //--- stop order price calculation   
   virtual bool      Refresh(const string symbol);
   virtual double    StopLossCalculate(const string symbol,const ENUM_ORDER_TYPE type,const double price);
   virtual double    StopLossCustom(const ENUM_ORDER_TYPE type,const double price) {return 0;}
   virtual double    StopLossPrice(COrder *order,COrderStop *orderstop){return 0;}
   virtual double    StopLossTicks(const ENUM_ORDER_TYPE type,const double price) {return m_stoploss;}
   virtual double    TakeProfitCalculate(const string symbol,const ENUM_ORDER_TYPE type,const double price);
   virtual double    TakeProfitCustom(const ENUM_ORDER_TYPE type,const double price) {return 0;}
   virtual double    TakeProfitPrice(COrder *order,COrderStop *orderstop) {return 0;}
   virtual double    TakeProfitTicks(const ENUM_ORDER_TYPE type,const double price) {return m_takeprofit;}
   //--- trailing   
   virtual bool      Add(CTrails *trails);
   virtual double    CheckTrailing(const string symbol,const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode);
protected:
   //--- object creation
   virtual CStopLine *CreateObject(const long id,const string name,const int window,const double price);
   //--- stop order price calculation
   virtual double    LotSizeCalculate(COrder *order,COrderStop *orderstop);
   //--- stop order entry   
   virtual bool      GetClosePrice(const string symbol,const ENUM_ORDER_TYPE type,double &price);
   //--- stop order exit
   virtual bool      CloseStop(COrder *order,COrderStop *orderstop,const double price);
   //--- deinitialization
   virtual void      Deinit(void);
   virtual void      DeinitSymbol(void);
   virtual void      DeinitTrade(void);
   virtual void      DeinitTrails(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopBase::CStopBase(void) : m_activate(true),
                             m_magic(INT_MAX),
                             m_main(false),
                             m_oco(true),
                             m_stoploss(0),
                             m_takeprofit(0),
                             m_volume_type(VOLUME_TYPE_FIXED),
                             m_volume_fixed(0),
                             m_volume_percent(0),
                             m_comment(NULL),
                             m_stop_type(STOP_TYPE_VIRTUAL),
                             m_stoploss_name(".sl."),
                             m_takeprofit_name(".tp."),
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
      PrintFormat(__FUNCTION__+": Empty name for stop.");
      return false;
     }
   if(CheckPointer(m_trails))
     {
      for(int i=0;i<m_trails.Total();i++)
        {
         CTrail *trail=m_trails.At(i);
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
   if(symbolmanager==NULL || accountinfo==NULL) return false;
   InitSymbol(symbolmanager);
   InitAccount(accountinfo);
   //m_points_adjust = s.PointsAdjust();
   //m_digits_adjust = s.DigitsAdjust();
   InitTrade();
   if(CheckPointer(m_trails)==POINTER_DYNAMIC)
      m_trails.Init(symbolmanager,GetPointer(this));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::InitSymbol(CSymbolManager *symbolmanager)
  {
   //if(symbolinfo==NULL) return false;
   //m_symbol=symbolinfo;
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
bool CStopBase::InitTrade(CExpertTrade *trade=NULL)
  {
   if(m_trade!=NULL)
      delete m_trade;
   if(trade==NULL)
     {
      if((m_trade=new CExpertTrade)==NULL)
         return false;
     }
   else m_trade=trade;
   m_trade.SetSymbol(GetPointer(m_symbol));
   m_trade.SetExpertMagicNumber(m_magic);
   //m_trade.SetDeviationInPoints((ulong)(3*m_digits_adjust/m_symbol.Point()));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::Volume(COrderStop *orderstop,double &volume_fixed,double &volume_percent)
  {
   if(m_volume_type==VOLUME_TYPE_FIXED || m_volume_type==VOLUME_TYPE_REMAINING)
     {
      orderstop.VolumeFixed(m_volume_fixed);
      orderstop.VolumePercent(0);
     }
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING || m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
     {
      orderstop.VolumeFixed(0);
      orderstop.VolumePercent(m_volume_percent);
     }   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::LotSizeCalculate(COrder *order,COrderStop *orderstop)
  {
   double lotsize=0.0;
   if(m_volume_type==VOLUME_TYPE_FIXED)
      return orderstop.Volume();
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
      return orderstop.Volume()*order.Volume();
   if(m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
      lotsize=orderstop.Volume()*order.VolumeInitial();
   else if(m_volume_type==VOLUME_TYPE_REMAINING)
      lotsize=order.Volume();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::CloseStop(COrder *order,COrderStop *orderstop,const double price)
  {
   bool res=false;
   ENUM_ORDER_TYPE type=order.OrderType();
   m_symbol = m_symbol_man.Get(order.Symbol());
   m_trade.SetSymbol(m_symbol);
   if(m_stop_type==STOP_TYPE_VIRTUAL)
     {
      double lotsize=MathMin(order.Volume(),LotSizeCalculate(order,orderstop));
      if(type==ORDER_TYPE_BUY)
         res=m_trade.Sell(MathMin(lotsize,order.Volume()),price,0,0,m_comment);
      else if(type==ORDER_TYPE_SELL)
         res=m_trade.Buy(MathMin(lotsize,order.Volume()),price,0,0,m_comment);
      if(res) order.Volume(order.Volume()-lotsize);
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::StopLossCalculate(const string symbol,const ENUM_ORDER_TYPE type,const double price)
  {
   if(!Refresh(symbol)) return 0;
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return price-m_stoploss*/*m_points_adjust*/m_symbol.Point();
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return price+m_stoploss*/*m_points_adjust*/m_symbol.Point();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopBase::TakeProfitCalculate(const string symbol,const ENUM_ORDER_TYPE type,const double price)
  {
   if(!Refresh(symbol)) return 0;
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return price+m_takeprofit*/*m_points_adjust*/m_symbol.Point();
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return price-m_takeprofit*/*m_points_adjust*/m_symbol.Point();
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
   ENUM_ORDER_TYPE type=order.OrderType();
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
   return false;
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
   ENUM_ORDER_TYPE type=order.OrderType();
   if(!GetClosePrice(order.Symbol(),type,price)) return false;
   bool close=false;
   if(type==ORDER_TYPE_BUY)
      if(price>=takeprofit) close=true;
   else if(type==ORDER_TYPE_SELL)
      if(price<=takeprofit) close=true;
   if(close)
      return CloseStop(order,orderstop,price);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopBase::Refresh(const string symbol)
  {
   if (m_symbol==NULL || StringCompare(m_symbol.Name(),symbol)!=0)
   {
      m_symbol = m_symbol_man.Get(symbol);
      m_trade.SetSymbol(m_symbol);
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
   //DeinitSymbol();
   DeinitTrade();
   DeinitTrails();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::DeinitSymbol(void)
  {
   //ADT::Delete(m_symbol);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::DeinitTrade(void)
  {
   ADT::Delete(m_trade);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopBase::DeinitTrails(void)
  {
   ADT::Delete(m_trails);
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
#include "..\..\mql5\stop\Stop.mqh"
#else
#include "..\..\mql4\stop\Stop.mqh"
#endif
//+------------------------------------------------------------------+
