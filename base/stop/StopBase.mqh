//+------------------------------------------------------------------+
//|                                                         Stop.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
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
   //--- stop order symbol object
   CSymbolInfo      *m_symbol;
   //--- stop order account object
   CAccountInfo     *m_account;
   //--- stop order trade object
   JTrade           *m_trade;
   //--- stop order trailing object
   JTrails          *m_trails;
   //--- events
   JEvent           *m_event;
   //-- stops
   JStops           *m_stops;
public:
                     JStopBase();
                    ~JStopBase();
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual bool      InitAccount(CAccountInfo *accountinfo=NULL);
   virtual bool      InitSymbol(CSymbolInfo *symbolinfo=NULL);
   virtual bool      InitTrade(JTrade *trade=NULL);
   virtual bool      InitEvent(JEvent *event);
   //--- activation and deactivation
   virtual bool      Active() {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   //--- stop order getters and setters
   virtual void      Comment(string comment) {m_comment=comment;}
   virtual string    Comment() const {return(m_comment);}
   virtual int       DigitsAdjust() const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(int adjust) {m_digits_adjust=adjust;}
   virtual void      EntryColor(color clr) {m_entry_color=clr;}
   virtual void      EntryStyle(ENUM_LINE_STYLE style) {m_entry_style=style;}
   virtual void      Magic(int magic) {m_magic=magic;}
   virtual int       Magic() const {return(m_magic);}
   virtual void      Main(bool main) {m_main=main;}
   virtual bool      Main() const {return(m_main);}
   virtual void      Name(string name) {m_name=name;}
   virtual string    Name() const{return(m_name);}
   virtual void      OCO(bool oco) {if(!Main())m_oco=oco;}
   virtual bool      OCO() const{return(m_oco);}
   virtual bool      Pending() {return(m_stop_type==STOP_TYPE_PENDING);}
   virtual double    PointsAdjust() const {return(m_points_adjust);}
   virtual void      PointsAdjust(double adjust) {m_points_adjust=adjust;}
   virtual void      StopLoss(double sl) {m_stoploss=sl;}
   virtual double    StopLoss() const {return(m_stoploss);}
   virtual void      StopLossColor(color clr) {m_stoploss_color=clr;}
   virtual bool      StopLossCustom() {return(m_stoploss==0);}
   virtual void      StopLossName(string name) {m_stoploss_name=name;}
   virtual string    StopLossName() const{return(m_stoploss_name);}
   virtual void      StopLossStyle(ENUM_LINE_STYLE style) {m_stoploss_style=style;}
   virtual void      StopType(ENUM_STOP_TYPE stop_type);
   virtual ENUM_STOP_TYPE StopType() {return(m_stop_type);}
   virtual void      TakeProfit(double tp) {m_takeprofit=tp;}
   virtual double    TakeProfit() const {return(m_takeprofit);}
   virtual void      TakeProfitColor(color clr) {m_takeprofit_color=clr;}
   virtual bool      TakeProfitCustom() {return(m_takeprofit==0);}
   virtual void      TakeProfitName(string name) {m_takeprofit_name=name;}
   virtual string    TakeProfitName() const {return(m_takeprofit_name);}
   virtual void      TakeProfitStyle(ENUM_LINE_STYLE style) {m_takeprofit_style=style;}
   virtual int       Type() {return(CLASS_TYPE_STOP);}
   virtual bool      Virtual() const {return(m_stop_type==STOP_TYPE_VIRTUAL);}
   virtual void      Volume(JOrderStop *orderstop,double &volume_fixed,double &volume_percent);
   virtual double    VolumeFixed() const {return(m_volume_fixed);}
   virtual void      VolumeFixed(double volume) {m_volume_fixed=volume;}
   virtual double    VolumePercent() const {return(m_volume_percent);}
   virtual void      VolumePercent(double volume) {m_volume_percent=volume;}
   virtual void      VolumeType(ENUM_VOLUME_TYPE type){m_volume_type=type;}
   //--- stop order checking
   virtual bool      CheckStopLoss(JOrder *order,JOrderStop *orderstop);
   virtual bool      CheckTakeProfit(JOrder *order,JOrderStop *orderstop);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const {return(false);}
   virtual bool      OrderModify(ulong ticket,double value);
   //--- stop order object creation
   virtual JStopLine *CreateEntryObject(long id,string name,int window,double price);
   virtual JStopLine *CreateStopLossObject(long id,string name,int window,double price);
   virtual JStopLine *CreateTakeProfitObject(long id,string name,int window,double price);
   //--- stop order price calculation
   virtual double    TakeProfitPrice(JOrder *order,JOrderStop *orderstop) {return(0.0);}
   virtual double    StopLossPrice(JOrder *order,JOrderStop *orderstop){return(0.0);}
   virtual double    StopLossTicks(ENUM_ORDER_TYPE type,double price) {return(m_stoploss);}
   virtual double    TakeProfitTicks(ENUM_ORDER_TYPE type,double price) {return(m_takeprofit);}
   virtual bool      Refresh();
   virtual double    StopLossCalculate(ENUM_ORDER_TYPE type,double price);
   virtual double    StopLossCustom(ENUM_ORDER_TYPE type,double price);
   virtual double    TakeProfitCalculate(ENUM_ORDER_TYPE type,double price);
   virtual double    TakeProfitCustom(ENUM_ORDER_TYPE type,double price);
   //--- trailing   
   virtual bool      Add(JTrails *trails);
   virtual double    CheckTrailing(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit);

   virtual void      SetContainer(JStops *stops){m_stops=stops;}
protected:
   //--- object creation
   virtual JStopLine *CreateObject(long id,string name,int window,double price);
   //--- stop order price calculation
   virtual double    LotSizeCalculate(JOrder *order,JOrderStop *orderstop);
   //--- stop order entry   
   virtual bool      GetClosePrice(ENUM_ORDER_TYPE type,double &price);
   //--- stop order exit
   virtual bool      CloseStop(JOrder *order,JOrderStop *orderstop,double price);
   //--- deinitialization
   virtual bool      Deinit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopBase::JStopBase() : m_activate(true),
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
                         m_stoploss_style(STYLE_SOLID),
                         m_takeprofit_style(STYLE_SOLID)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopBase::~JStopBase()
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::Init(JStrategy *s)
  {
   InitSymbol(s.SymbolInfo());
   InitAccount(s.AccountInfo());
   m_points_adjust = s.PointsAdjust();
   m_digits_adjust = s.DigitsAdjust();
   InitTrade();
   if (CheckPointer(m_trails)==POINTER_DYNAMIC)
      m_trails.Init(s);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::InitSymbol(CSymbolInfo *symbolinfo=NULL)
  {
   m_symbol=symbolinfo;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::InitAccount(CAccountInfo *accountinfo=NULL)
  {
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
bool JStopBase::CloseStop(JOrder *order,JOrderStop *orderstop,double price)
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
double JStopBase::StopLossCalculate(ENUM_ORDER_TYPE type,double price)
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
double JStopBase::TakeProfitCalculate(ENUM_ORDER_TYPE type,double price)
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
double JStopBase::TakeProfitCustom(ENUM_ORDER_TYPE type,double price)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopBase::StopLossCustom(ENUM_ORDER_TYPE type,double price)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::GetClosePrice(ENUM_ORDER_TYPE type,double &price)
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
bool JStopBase::Refresh()
  {
   if(CheckPointer(m_symbol)==POINTER_DYNAMIC)
      return(m_symbol.RefreshRates());
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool JStopBase::Deinit()
  {
   if(m_symbol!=NULL) delete m_symbol;
   if(m_trade!=NULL) delete m_trade;
   if(m_trails!=NULL)
     {
      m_trails.Clear();
      delete m_trails;
      m_trails=NULL;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStopBase::StopType(ENUM_STOP_TYPE type)
  {
   m_stop_type=type;
   if(m_main) m_oco=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::Add(JTrails *trails)
  {
   /*
   if(m_trails.Add(trail))
     {
      trail.Init(m_symbol);
      trail.PointsAdjust(m_points_adjust);
      trail.DigitsAdjust(m_digits_adjust);
      trail.SetContainer(GetPointer(m_trails));
      return(true);
     }
   return(false);
   */
   
   m_trails = trails;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopBase::CheckTrailing(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit)
  {
   if (!CheckPointer(m_trails)) return(0);
   if(!Refresh()) return(0);
   return(m_trails.Check(type,entry_price,stoploss,takeprofit));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopBase::OrderModify(ulong ticket,double value)
  {
   return(m_trade.OrderModify(ticket,value,0.0,0.0,0,0,0.0));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateEntryObject(long id,string name,int window,double price)
  {
   if(m_entry_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateStopLossObject(long id,string name,int window,double price)
  {
   if(m_stoploss_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateTakeProfitObject(long id,string name,int window,double price)
  {
   if(m_takeprofit_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStopBase::CreateObject(long id,string name,int window,double price)
  {
   if(price==0.0) return(NULL);
   JStopLine *obj=new JStopLine();
   if(obj.Create(id,name,window,price)) return(obj);
   return(NULL);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\stop\Stop.mqh"
#else
#include "..\..\mql4\stop\Stop.mqh"
#endif
//+------------------------------------------------------------------+
