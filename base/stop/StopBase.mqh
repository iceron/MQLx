//+------------------------------------------------------------------+
//|                                                     StopBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_TRAIL_TARGET.mqh"
#include "..\..\common\enum\ENUM_TRAIL_MODE.mqh"
#include "..\..\common\enum\ENUM_STOP_TYPE.mqh"
#include "..\event\EventBase.mqh"
#include "..\stop\StopLineBase.mqh"
#include "..\trade\TradeBase.mqh"
#include "..\trailing\TrailsBase.mqh"
#include "..\order\OrderStopBase.mqh"
class JOrder;
class JOrderStop;
class JStops;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStopBase : public CObject
  {
protected:
   //--- stop order parameters   
   bool              m_activate;
   bool              m_convert_stop_type;
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
   //--- stop order market parameters
   double            m_points_adjust;
   int               m_digits_adjust;
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
   CSymbolInfo      *m_symbol;
   CAccountInfo     *m_account;
   JTrade           *m_trade;
   JTrails          *m_trails;
   JEvent           *m_event;
   JStops           *m_stops;
public:
                     JStopBase(void);
                    ~JStopBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_STOP);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual bool      InitAccount(CAccountInfo *accountinfo=NULL);
   virtual bool      InitSymbol(CSymbolInfo *symbolinfo=NULL);
   virtual bool      InitTrade(JTrade *trade=NULL);
   virtual bool      InitEvent(JEvent *event);
   virtual void      SetContainer(JStops *stops){m_stops=stops;}
   virtual bool      Validate(void) const;
   //--- getters and setters
   virtual bool      Active(void) {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual void      Comment(string comment) {m_comment=comment;}
   virtual string    Comment(void) const {return(m_comment);}
   virtual int       DigitsAdjust(void) const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(const int adjust) {m_digits_adjust=adjust;}
   virtual void      EntryColor(const color clr) {m_entry_color=clr;}
   virtual void      EntryStyle(const ENUM_LINE_STYLE style) {m_entry_style=style;}
   virtual void      Magic(const int magic) {m_magic=magic;}
   virtual int       Magic(void) const {return(m_magic);}
   virtual void      Main(const bool main) {m_main=main;}
   virtual bool      Main(void) const {return(m_main);}
   virtual void      Name(const string name) {m_name=name;}
   virtual string    Name(void) const{return(m_name);}
   virtual void      OCO(const bool oco) {if(!Main())m_oco=oco;}
   virtual bool      OCO(void) const{return(m_oco);}
   virtual bool      Pending() const {return(m_stop_type==STOP_TYPE_PENDING);}
   virtual double    PointsAdjust(void) const {return(m_points_adjust);}
   virtual void      PointsAdjust(const double adjust) {m_points_adjust=adjust;}
   virtual void      StopLoss(const double sl) {m_stoploss=sl;}
   virtual double    StopLoss(void) const {return(m_stoploss);}
   virtual void      StopLossColor(const color clr) {m_stoploss_color=clr;}
   virtual bool      StopLossCustom(void) {return(m_stoploss==0);}
   virtual void      StopLossName(const string name) {m_stoploss_name=name;}
   virtual string    StopLossName(void) const{return(m_stoploss_name);}
   virtual void      StopLossStyle(const ENUM_LINE_STYLE style) {m_stoploss_style=style;}
   virtual void      StopType(const ENUM_STOP_TYPE stop_type);
   virtual ENUM_STOP_TYPE StopType(void) const {return(m_stop_type);}
   virtual void      TakeProfit(const double tp) {m_takeprofit=tp;}
   virtual double    TakeProfit(void) const {return(m_takeprofit);}
   virtual void      TakeProfitColor(const color clr) {m_takeprofit_color=clr;}
   virtual bool      TakeProfitCustom(void) {return(m_takeprofit==0);}
   virtual void      TakeProfitName(const string name) {m_takeprofit_name=name;}
   virtual string    TakeProfitName(void) const {return(m_takeprofit_name);}
   virtual void      TakeProfitStyle(const ENUM_LINE_STYLE style) {m_takeprofit_style=style;}
   virtual bool      Virtual(void) const {return(m_stop_type==STOP_TYPE_VIRTUAL);}
   virtual void      Volume(JOrderStop *orderstop,double &volume_fixed,double &volume_percent);
   virtual double    VolumeFixed(void) const {return(m_volume_fixed);}
   virtual void      VolumeFixed(const double volume) {m_volume_fixed=volume;}
   virtual double    VolumePercent(void) const {return(m_volume_percent);}
   virtual void      VolumePercent(const double volume) {m_volume_percent=volume;}
   virtual void      VolumeType(const ENUM_VOLUME_TYPE type){m_volume_type=type;}
   //--- stop order checking
   virtual bool      CheckStopLoss(JOrder *order,JOrderStop *orderstop);
   virtual bool      CheckTakeProfit(JOrder *order,JOrderStop *orderstop);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const {return(false);}
   virtual bool      OrderModify(const ulong ticket,const double value);
   //--- stop order object creation
   virtual JStopLine *CreateEntryObject(const long id,const string name,const int window,const double price);
   virtual JStopLine *CreateStopLossObject(const long id,const string name,const int window,const double price);
   virtual JStopLine *CreateTakeProfitObject(const long id,const string name,const int window,const double price);
   //--- stop order price calculation   
   virtual bool      Refresh(void);
   virtual double    StopLossCalculate(const ENUM_ORDER_TYPE type,const double price);
   virtual double    StopLossCustom(const ENUM_ORDER_TYPE type,const double price);
   virtual double    StopLossPrice(JOrder *order,JOrderStop *orderstop){return(0.0);}
   virtual double    StopLossTicks(const ENUM_ORDER_TYPE type,const double price) {return(m_stoploss);}
   virtual double    TakeProfitCalculate(const ENUM_ORDER_TYPE type,const double price);
   virtual double    TakeProfitCustom(const ENUM_ORDER_TYPE type,const double price);
   virtual double    TakeProfitPrice(JOrder *order,JOrderStop *orderstop) {return(0.0);}
   virtual double    TakeProfitTicks(const ENUM_ORDER_TYPE type,const double price) {return(m_takeprofit);}
   //--- trailing   
   virtual bool      Add(JTrails *trails);
   virtual double    CheckTrailing(const ENUM_ORDER_TYPE type,const double entry_price,const double stoploss,const double takeprofit);
protected:
   //--- object creation
   virtual JStopLine *CreateObject(const long id,const string name,const int window,const double price);
   //--- stop order price calculation
   virtual double    LotSizeCalculate(JOrder *order,JOrderStop *orderstop);
   //--- stop order entry   
   virtual bool      GetClosePrice(const ENUM_ORDER_TYPE type,double &price);
   //--- stop order exit
   virtual bool      CloseStop(JOrder *order,JOrderStop *orderstop,const double price);
   //--- deinitialization
   virtual void      Deinit(void);
   virtual void      DeinitSymbol(void);
   virtual void      DeinitTrade(void);
   virtual void      DeinitTrails(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopBase::JStopBase(void) : m_activate(true),
                             m_convert_stop_type(true),
                             m_magic(INT_MAX),
                             m_main(false),
                             m_oco(true),
                             m_stoploss(0),
                             m_takeprofit(0),
                             m_volume_type(VOLUME_TYPE_FIXED),
                             m_volume_fixed(0),
                             m_volume_percent(0),
                             m_comment(NULL),
                             m_points_adjust(0),
                             m_digits_adjust(0),
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
JStopBase::~JStopBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::Validate(void) const 
  {
   if (m_name==NULL)
   {
      Print(__FUNCTION__+": Empty name for stop.");
      return(false);
   }
   if (CheckPointer(m_trails))
   {
      for (int i=0;i<m_trails.Total();i++)
      {
         JTrail *trail = m_trails.At(i);
         if (!trail.Validate())
            return(false);
      }
   }   
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::Init(JStrategy *s)
  {
   if (s==NULL) return(false);
   InitSymbol(s.SymbolInfo());
   InitAccount(s.AccountInfo());
   m_points_adjust = s.PointsAdjust();
   m_digits_adjust = s.DigitsAdjust();
   InitTrade();
   if(CheckPointer(m_trails)==POINTER_DYNAMIC)
      m_trails.Init(s,GetPointer(this));
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::InitSymbol(CSymbolInfo *symbolinfo=NULL)
  {
   if (symbolinfo==NULL) return(false);
   m_symbol=symbolinfo;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::InitAccount(CAccountInfo *accountinfo=NULL)
  {
   if (accountinfo==NULL) return(false);
   m_account=accountinfo;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::InitTrade(JTrade *trade=NULL)
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
bool JStopBase::InitEvent(JEvent *event)
  {
   if (event==NULL) return(false);
   m_event=event;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStopBase::Volume(JOrderStop *orderstop,double &volume_fixed,double &volume_percent)
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
double JStopBase::LotSizeCalculate(JOrder *order,JOrderStop *orderstop)
  {
   double lotsize=0.0;
   if(m_volume_type==VOLUME_TYPE_FIXED)
      return(orderstop.Volume());
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
      return(orderstop.Volume()*order.Volume());
   if(m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
      lotsize=orderstop.Volume()*order.VolumeInitial();
   else if(m_volume_type==VOLUME_TYPE_REMAINING)
      lotsize=order.Volume();
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::CloseStop(JOrder *order,JOrderStop *orderstop,const double price)
  {
   bool res=false;
   ENUM_ORDER_TYPE type=order.OrderType();
   if(m_stop_type==STOP_TYPE_VIRTUAL)
     {
      double lotsize=LotSizeCalculate(order,orderstop);
      if(type==ORDER_TYPE_BUY)
         res=m_trade.Sell(MathMin(lotsize,order.Volume()),price,0,0,m_comment);
      else if(type==ORDER_TYPE_SELL)
         res=m_trade.Buy(MathMin(lotsize,order.Volume()),price,0,0,m_comment);
      if(res) order.Volume(order.Volume()-lotsize);
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopBase::StopLossCalculate(const ENUM_ORDER_TYPE type,const double price)
  {
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return(price-m_stoploss*m_points_adjust);
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return(price+m_stoploss*m_points_adjust);
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopBase::TakeProfitCalculate(const ENUM_ORDER_TYPE type,const double price)
  {
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return(price+m_takeprofit*m_points_adjust);
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return(price-m_takeprofit*m_points_adjust);
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopBase::TakeProfitCustom(const ENUM_ORDER_TYPE type,const double price)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopBase::StopLossCustom(const ENUM_ORDER_TYPE type,const double price)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::GetClosePrice(const ENUM_ORDER_TYPE type,double &price)
  {
   if(!Refresh()) return(false);
   if(type==ORDER_TYPE_BUY)
      price=m_symbol.Bid();
   else if(type==ORDER_TYPE_SELL)
      price=m_symbol.Ask();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::CheckStopLoss(JOrder *order,JOrderStop *orderstop)
  {
   double stoploss=orderstop.StopLoss();
   if(stoploss<=0.0) return(false);
   double price=0.0;
   ENUM_ORDER_TYPE type=order.OrderType();
   if(!GetClosePrice(type,price)) return(false);
   bool close=false;
   if(type==ORDER_TYPE_BUY)
     {
      if(price<=stoploss) close=true;
     }
   else if(type==ORDER_TYPE_SELL)
     {
      if(price>=stoploss) close=true;
     }
   if(close)
      return(CloseStop(order,orderstop,price));
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::CheckTakeProfit(JOrder *order,JOrderStop *orderstop)
  {
   double takeprofit=orderstop.TakeProfit();
   if(takeprofit<=0.0) return(false);
   double price=0.0;
   ENUM_ORDER_TYPE type=order.OrderType();
   if(!GetClosePrice(type,price)) return(false);
   bool close=false;
   if(type==ORDER_TYPE_BUY)
     {
      if(price>=takeprofit) close=true;
     }
   else if(type==ORDER_TYPE_SELL)
     {
      if(price<=takeprofit) close=true;
     }
   if(close)
      return(CloseStop(order,orderstop,price));
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::Refresh(void)
  {
   if(CheckPointer(m_symbol)==POINTER_DYNAMIC)
      return(m_symbol.RefreshRates());
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStopBase::Deinit(void)
  {
   DeinitSymbol();
   DeinitTrade();
   DeinitTrails();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStopBase::DeinitSymbol(void)
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
void JStopBase::DeinitTrade(void)
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
void JStopBase::DeinitTrails(void)
  {
   if(m_trails!=NULL)
     {
      m_trails.Clear();
      delete m_trails;
      m_trails=NULL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStopBase::StopType(const ENUM_STOP_TYPE type)
  {
   m_stop_type=type;
   if(m_main) m_oco=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::Add(JTrails *trails)
  {
   if(CheckPointer(trails)==POINTER_DYNAMIC)
      m_trails=trails;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopBase::CheckTrailing(const ENUM_ORDER_TYPE type,const double entry_price,const double stoploss,const double takeprofit)
  {
   if(!CheckPointer(m_trails)) return(0);
   if(!Refresh()) return(0);
   return(m_trails.Check(type,entry_price,stoploss,takeprofit));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::OrderModify(const ulong ticket,const double value)
  {
   return(m_trade.OrderModify(ticket,value,0.0,0.0,0,0,0.0));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateEntryObject(const long id,const string name,const int window,const double price)
  {
   if(m_entry_visible)
     {
      JStopLine *obj=CreateObject(id,name,window,price);
      if(CheckPointer(obj)==POINTER_DYNAMIC)
        {
         obj.Selectable(false);
         obj.SetStyle(m_entry_style);
         obj.SetColor(m_entry_color);
         return(obj);
        }
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateStopLossObject(const long id,const string name,const int window,const double price)
  {
   if(m_stoploss_visible)
     {
      JStopLine *obj=CreateObject(id,name,window,price);
      if(CheckPointer(obj)==POINTER_DYNAMIC)
        {
         obj.Selectable(true);
         obj.SetStyle(m_stoploss_style);
         obj.SetColor(m_stoploss_color);
         return(obj);
        }
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateTakeProfitObject(const long id,const string name,const int window,const double price)
  {
   if(m_takeprofit_visible)
     {
      JStopLine *obj=CreateObject(id,name,window,price);
      if(CheckPointer(obj)==POINTER_DYNAMIC)
        {
         obj.Selectable(true);
         obj.SetStyle(m_takeprofit_style);
         obj.SetColor(m_takeprofit_color);
         return(obj);
        }
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateObject(const long id,const string name,const int window,const double price)
  {
   if(price==0.0) return(NULL);
   JStopLine *obj=new JStopLine();
   if(obj.Create(id,name,window,price))
      return(obj);
   return(NULL);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\stop\Stop.mqh"
#else
#include "..\..\mql4\stop\Stop.mqh"
#endif
//+------------------------------------------------------------------+
