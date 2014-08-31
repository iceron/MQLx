//+------------------------------------------------------------------+
//|                                                         Stop.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <traderjet-cross\common\enum\ENUM_TRAIL_TARGET.mqh>
#include <traderjet-cross\common\enum\ENUM_TRAIL_MODE.mqh>
#include <traderjet-cross\common\enum\ENUM_STOP_TYPE.mqh>
#include <Trade\OrderInfo.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>
#include <traderjet-cross\mql5\trade\Trade.mqh>
#include <traderjet-cross\mql5\trailing\Trails.mqh>
#include <traderjet-cross\mql5\event\Event.mqh>
#include <traderjet-cross\mql5\order\OrderStop.mqh>
#include <traderjet-cross\mql5\stop\StopLine.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStop : public CObject
  {
protected:
   //--- stop order parameters   
   bool              m_activate;
   string            m_name;
   double            m_stoploss;
   string            m_stoploss_name;
   double            m_takeprofit;
   string            m_takeprofit_name;
   ENUM_STOP_TYPE    m_stop_type;
   bool              m_oco;
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
   //--- stop order trade object
   JTrade           *m_trade;
   //--- stop order trailing object
   JTrails           m_trails;
   //--- events
   JEvent           *m_event;
public:
                     JStop(string name);
                    ~JStop();
   //--- initialization
   virtual bool      InitSymbol(CSymbolInfo *symbolinfo=NULL);
   virtual bool      InitTrade(JTrade *trade=NULL);
   virtual bool      InitEvent(JEvent *event);
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- stop order getters and setters
   virtual void      Comment(string comment) {m_comment=comment;}
   virtual string    Comment() const {return(m_comment);}
   virtual int       DigitsAdjust() const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(int adjust) {m_digits_adjust=adjust;}
   virtual void      EntryColor(color clr) {m_entry_color=clr;}
   virtual void      EntryStyle(ENUM_LINE_STYLE style) {m_entry_style=style;}
   virtual void      Magic(int magic) {m_magic=magic;}
   virtual int       Magic() const {return(m_magic);}
   virtual bool      Main() const {return(m_stop_type==STOP_TYPE_MAIN);}
   virtual void      Name(string name) {m_name=name;}
   virtual string    Name() const{return(m_name);}
   virtual void      OCO(bool oco) {m_oco=oco;}
   virtual bool      OCO() const{return(m_oco);}
   virtual bool      Pending() {return(m_stop_type==STOP_TYPE_PENDING);}
   virtual double    PointsAdjust() const {return(m_points_adjust);}
   virtual void      PointsAdjust(double adjust) {m_points_adjust=adjust;}
   virtual void      StopLoss(double sl) {m_stoploss=sl;}
   virtual double    StopLoss() const {return(m_stoploss);}
   virtual void      StopLossColor(color clr) {m_stoploss_color=clr;}
   virtual void      StopLossName(string name) {m_stoploss_name=name;}
   virtual string    StopLossName() const{return(m_stoploss_name);}
   virtual void      StopLossStyle(ENUM_LINE_STYLE style) {m_stoploss_style=style;}
   virtual void      StopType(ENUM_STOP_TYPE stop_type);
   virtual ENUM_STOP_TYPE StopType() const {return(m_stop_type);}
   virtual void      TakeProfit(double tp) {m_takeprofit=tp;}
   virtual double    TakeProfit() const {return(m_takeprofit);}
   virtual void      TakeProfitColor(color clr) {m_takeprofit_color=clr;}
   virtual void      TakeProfitName(string name) {m_takeprofit_name=name;}
   virtual string    TakeProfitName() const {return(m_takeprofit_name);}
   virtual void      TakeProfitStyle(ENUM_LINE_STYLE style) {m_takeprofit_style=style;}
   virtual bool      Virtual() const {return(m_stop_type==STOP_TYPE_VIRTUAL);}
   virtual void      Volume(JOrderStop *orderstop);
   virtual double    VolumeFixed() const {return(m_volume_fixed);}
   virtual void      VolumeFixed(double volume) {m_volume_fixed=volume;}
   virtual double    VolumePercent() const {return(m_volume_percent);}
   virtual void      VolumePercent(double volume) {m_volume_percent=volume;}
   virtual void      VolumeType(ENUM_VOLUME_TYPE type){m_volume_type=type;}
   //--- stop order checking
   virtual bool      CheckStopLoss(JOrderStop *orderstop);
   virtual bool      CheckTakeProfit(JOrderStop *orderstop);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const;
   virtual bool      DeleteStopOrder(const ulong ticket) const;
   virtual bool      OrderModify(ulong ticket,double value);
   //--- stop order object creation
   virtual JStopLine *CreateEntryObject(long id,string name,int window,double price);
   virtual JStopLine *CreateStopLossObject(long id,string name,int window,double price);
   virtual JStopLine *CreateTakeProfitObject(long id,string name,int window,double price);
   //--- stop order price calculation
   virtual double    TakeProfitPrice(JOrderStop *orderstop);
   virtual double    StopLossPrice(JOrderStop *orderstop);
   virtual double    StopLossTicks(ENUM_ORDER_TYPE type,double price) {return(m_stoploss);}
   virtual double    TakeProfitTicks(ENUM_ORDER_TYPE type,double price) {return(m_takeprofit);}
   virtual bool      Refresh();
   //--- trailing   
   virtual bool      AddTrailing(JTrail *trail);
   virtual double    CheckTrailing(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit);
protected:
   //--- object creation
   virtual JStopLine *CreateObject(long id,string name,int window,double price);
   //--- stop order price calculation
   virtual double    LotSizeCalculate(JOrderStop *orderstop);
   virtual double    StopLossCalculate(JOrderStop *orderstop);
   virtual double    StopLossCustom(JOrderStop *orderstop);
   virtual double    TakeProfitCalculate(JOrderStop *orderstop);
   virtual double    TakeProfitCustom(JOrderStop *orderstop);
   //--- stop order entry   
   virtual bool      OpenStop(JOrderStop *orderstop,double val);
   virtual bool      GetClosePrice(ENUM_ORDER_TYPE type,double &price);
   //--- stop order exit
   virtual bool      CloseStop(JOrderStop *orderstop,double price);
   //--- deinitialization
   virtual bool      Deinit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop::JStop(string name) : m_activate(true),
                            m_magic(INT_MAX),
                            m_stoploss(0),
                            m_takeprofit(0),
                            m_volume_type(VOLUME_TYPE_FIXED),
                            m_volume_fixed(0),
                            m_volume_percent(0),
                            m_comment(NULL),
                            m_oco(true),
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
   m_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop::~JStop()
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::InitSymbol(CSymbolInfo *symbolinfo=NULL)
  {
   m_symbol=symbolinfo;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::InitTrade(JTrade *trade=NULL)
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
bool JStop::InitEvent(JEvent *event)
  {
   m_event=event;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::Volume(JOrderStop *orderstop)
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
double JStop::LotSizeCalculate(JOrderStop *orderstop)
  {
   double lotsize=0.0;
   if(m_volume_type==VOLUME_TYPE_FIXED)
      return(orderstop.Volume());
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
      return(orderstop.Volume()*orderstop.VolumeMain());
   if(m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
      lotsize=orderstop.Volume()*orderstop.VolumeMainInitial();
   else if(m_volume_type==VOLUME_TYPE_REMAINING)
      lotsize=orderstop.VolumeMain();
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::OpenStop(JOrderStop *orderstop,double val)
  {
   bool res=false;
   double lotsize=LotSizeCalculate(orderstop);
   ENUM_ORDER_TYPE type = orderstop.MainTicketType();
   if(m_stop_type==STOP_TYPE_PENDING || m_stop_type==STOP_TYPE_MAIN)
     {
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
        {
         res=m_trade.Sell(lotsize,val,0,0,m_comment);
        }
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
        {
         res=m_trade.Buy(lotsize,val,0,0,m_comment);
        }
     }
   return(res);   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::CloseStop(JOrderStop *orderstop,double price)
  {
   bool res=false;
   ENUM_ORDER_TYPE type = orderstop.MainTicketType();
   if(m_stop_type==STOP_TYPE_VIRTUAL)
     {
      double lotsize=LotSizeCalculate(orderstop);
      if(type==ORDER_TYPE_BUY)
         res=m_trade.Sell(MathMin(lotsize,orderstop.VolumeMain()),price,0,0,m_comment);
      else if(type==ORDER_TYPE_SELL)
         res=m_trade.Buy(MathMin(lotsize,orderstop.VolumeMain()),price,0,0,m_comment);
      if(res) orderstop.VolumeMain(orderstop.VolumeMain()-lotsize);
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::TakeProfitPrice(JOrderStop *orderstop)
  {  
   double val = m_takeprofit>0?TakeProfitCalculate(orderstop):TakeProfitCustom(orderstop);
   if((m_stop_type==STOP_TYPE_PENDING || m_stop_type==STOP_TYPE_MAIN) && (val>0.0))
   {
      if (OpenStop(orderstop,val))
      {
         orderstop.TakeProfitTicket(m_trade.ResultOrder());
         return(NormalizeDouble(val,m_symbol.Digits()));
      }         
   }  
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::StopLossPrice(JOrderStop *orderstop)
  {
   double val = m_stoploss>0?StopLossCalculate(orderstop):StopLossCustom(orderstop);
   if((m_stop_type==STOP_TYPE_PENDING || m_stop_type==STOP_TYPE_MAIN) && (val>0.0))
   {
      if (OpenStop(orderstop,val))
      {
         orderstop.StopLossTicket(m_trade.ResultOrder());
         return(NormalizeDouble(val,m_symbol.Digits()));
      }         
   }      
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::StopLossCalculate(JOrderStop *orderstop)
  {
   ENUM_ORDER_TYPE type = orderstop.MainTicketType();
   double price = orderstop.MainTicketPrice();
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return(price-m_stoploss*m_points_adjust);
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return(price+m_stoploss*m_points_adjust);
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::TakeProfitCalculate(JOrderStop *orderstop)
  {
   ENUM_ORDER_TYPE type = orderstop.MainTicketType();
   double price = orderstop.MainTicketPrice();
   if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
      return(price+m_takeprofit*m_points_adjust);
   else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
      return(price-m_takeprofit*m_points_adjust);
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::TakeProfitCustom(JOrderStop *orderstop)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::StopLossCustom(JOrderStop *orderstop)
  {
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::StopType(ENUM_STOP_TYPE stop_type)
  {
   m_stop_type=stop_type;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::GetClosePrice(ENUM_ORDER_TYPE type,double &price)
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
bool JStop::CheckStopLoss(JOrderStop *orderstop)
  {
   double stoploss = orderstop.StopLoss();
   if(stoploss<=0.0) return(false);
   double price=0.0;
   ENUM_ORDER_TYPE type = orderstop.MainTicketType();
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
     {
      return(CloseStop(orderstop,price));
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::CheckTakeProfit(JOrderStop *orderstop)
  {
   double takeprofit = orderstop.TakeProfit();
   if(takeprofit<=0.0) return(false);
   double price=0.0;
   ENUM_ORDER_TYPE type = orderstop.MainTicketType();
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
     {
      return(CloseStop(orderstop,price));
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::CheckStopOrder(double &volume_remaining,const ulong ticket) const
  {
   COrderInfo ord;
   CHistoryOrderInfo h_ord;
   HistorySelect(0,TimeCurrent());
   if(ticket>0)
     {
      if(ord.Select(ticket)) return(false);
      else
        {
         long state;
         h_ord.Ticket(ticket);
         if(h_ord.InfoInteger(ORDER_STATE,state))
           {
            if(h_ord.State()==ORDER_STATE_FILLED)
              {
               volume_remaining-=h_ord.VolumeInitial();
               return(true);
              }
           }
         else
           {
            int total= HistoryOrdersTotal();
            for(int i=0;i<total;i++)
              {
               ulong t=HistoryOrderGetTicket(i);
               if(t==ticket)
                 {
                  if(h_ord.InfoInteger(ORDER_STATE,state))
                    {
                     if(state==ORDER_STATE_FILLED)
                       {
                        volume_remaining-=h_ord.VolumeInitial();
                        return(true);
                       }
                    }
                 }
              }
           }
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::DeleteStopOrder(const ulong ticket) const
  {
   if(ticket<=0) return(true);
   if(m_trade.OrderDelete(ticket))
     {
      uint result=m_trade.ResultRetcode();
      if(result==TRADE_RETCODE_DONE || result==TRADE_RETCODE_PLACED)
         return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::Refresh()
  {
   return(m_symbol.RefreshRates());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool JStop::Deinit()
  {
   if(m_symbol!=NULL) delete m_symbol;
   if(m_trade!=NULL) delete m_trade;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::AddTrailing(JTrail *trail)
  {
   trail.Init(m_symbol);
   trail.PointsAdjust(m_points_adjust);
   trail.DigitsAdjust(m_digits_adjust);
   return(m_trails.Add(trail));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::CheckTrailing(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit)
  {
   if(!Refresh()) return(0);
   return(m_trails.Check(type,entry_price,stoploss,takeprofit));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::OrderModify(ulong ticket,double value)
  {
   bool res=m_trade.OrderModify(ticket,value,0.0,0.0,0,0,0.0);
//if(res)
//m_event.Add(EVENT_TYPE_ORDER_MODIFY,__FUNCTION__,"order modified","symbol: "+m_symbol.Name()+" ticket: "+DoubleToString(ticket,0)+" price: "+DoubleToString(value));
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStop::CreateEntryObject(long id,string name,int window,double price)
  {
   if(m_entry_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStop::CreateStopLossObject(long id,string name,int window,double price)
  {
   if(m_stoploss_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStop::CreateTakeProfitObject(long id,string name,int window,double price)
  {
   if(m_takeprofit_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine *JStop::CreateObject(long id,string name,int window,double price)
  {
   if(price==0.0) return(NULL);
   JStopLine *obj=new JStopLine();
   obj.Create(id,name,window,price);
   return(obj);
  }
//+------------------------------------------------------------------+
