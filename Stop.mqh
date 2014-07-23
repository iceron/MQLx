//+------------------------------------------------------------------+
//|                                                         Stop.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Trade\OrderInfo.mqh>
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayLong.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>
#include "Trade.mqh"
//#include "Order.mqh"
//#include "Orders.mqh"


enum ENUM_STOP_TYPE
  {
   STOP_TYPE_MAIN,
   STOP_TYPE_VIRTUAL,
   STOP_TYPE_PENDING
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_VOLUME_TYPE
  {
   VOLUME_TYPE_FIXED,
   VOLUME_TYPE_PERCENT_REMAINING,
   VOLUME_TYPE_PERCENT_TOTAL,
   VOLUME_TYPE_REMAINING
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStop : public CObject
  {
protected:
   CSymbolInfo      *m_symbol;
   string            m_name;
   string            m_stoploss_name;
   string            m_takeprofit_name;
   double            m_stoploss;
   double            m_takeprofit;
   ENUM_STOP_TYPE    m_stop_type;
   bool              m_oco;

   double            m_point_adjust;
   int               m_digits_adjust;

   bool              m_entry_visible;
   bool              m_stoploss_visible;
   bool              m_takeprofit_visible;
   color             m_entry_color;
   color             m_stoploss_color;
   color             m_takeprofit_color;
   ENUM_LINE_STYLE   m_entry_style;
   ENUM_LINE_STYLE   m_stoploss_style;
   ENUM_LINE_STYLE   m_takeprofit_style;

   JTrade           *m_trade;
   ENUM_VOLUME_TYPE  m_volume_type;
   double            m_volume_fixed;
   double            m_volume_percent;
   int               m_magic;
public:
                     JStop(string name);
                    ~JStop();

   virtual void      Name(string name) {m_name=name;}
   virtual string    Name() {return(m_name);}
   virtual void      StopLossName(string name) {m_stoploss_name=name;}
   virtual string    StopLossName() {return(m_stoploss_name);}
   virtual void      TakeProfitName(string name) {m_takeprofit_name=name;}
   virtual string    TakeProfitName() {return(m_takeprofit_name);}

   virtual void      Create(ulong order_ticket,int order_type,double volume,double price);
   virtual void      CreateVirtual(ulong order_ticket,int order_type,double volume,double price);
   virtual void      CreateNonVirtual(ulong order_ticket,int order_type,double volume,double price);
   virtual void      Check();

   virtual bool      GetClosePrice(ENUM_ORDER_TYPE type,double &price);
   virtual bool      CheckStopLoss(const double total_volume,double &volume_remaining,double volume,ENUM_ORDER_TYPE type,double stoploss);
   virtual bool      CheckTakeProfit(const double total_volume,double &volume_remaining,double volume,ENUM_ORDER_TYPE type,double takeprofit);
   virtual bool      CloseStop(const double total_volume,double &volume_remaining,double volume,ENUM_ORDER_TYPE type,double price);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const;
   virtual bool      DeleteStopOrder(const ulong ticket) const;

   virtual void      Volume(double &volume_fixed,double &volume_percent);
   virtual double    VolumeFixed() {return(m_volume_fixed);}
   virtual void      VolumeFixed(double volume) {m_volume_fixed=volume;}
   virtual double    VolumePercent() {return(m_volume_percent);}
   virtual void      VolumePercent(double volume) {m_volume_percent=volume;}
   virtual void      VolumeType(ENUM_VOLUME_TYPE type){m_volume_type=type;}
   virtual double    TakeProfitPrice(const double total_volume,const double volume_remaining,double volume,double price,ENUM_ORDER_TYPE type,ulong &ticket);
   virtual double    StopLossPrice(const double total_volume,const double volume_remaining,double volume,double price,ENUM_ORDER_TYPE type,ulong &ticket);

   virtual void      StopLoss(double sl) {m_stoploss=sl;}
   virtual void      TakeProfit(double tp) {m_takeprofit=tp;}
   virtual double    StopLoss() {return(m_stoploss);}
   virtual double    TakeProfit() {return(m_takeprofit);}

   virtual void      EntryStyle(ENUM_LINE_STYLE style) {m_entry_style=style;}
   virtual void      StopLossStyle(ENUM_LINE_STYLE style) {m_stoploss_style=style;}
   virtual void      TakeProfitStyle(ENUM_LINE_STYLE style) {m_takeprofit_style=style;}

   virtual void      EntryColor(color clr) {m_entry_color=clr;}
   virtual void      StopLossColor(color clr) {m_stoploss_color=clr;}
   virtual void      TakeProfitColor(color clr) {m_takeprofit_color=clr;}

   virtual void      Magic(int magic) {m_magic=magic;}

   //virtual void      Visible(bool visible) {m_visible=visible;}
   //virtual bool      Visible() {return(m_visible);}
   virtual void      StopType(ENUM_STOP_TYPE stop_type);
   virtual ENUM_STOP_TYPE      StopType(){return(m_stop_type);}
   virtual bool      Virtual() {return(m_stop_type==STOP_TYPE_VIRTUAL);}
   virtual bool      Main() {return(m_stop_type==STOP_TYPE_MAIN);}
   virtual bool      Pending() {return(m_stop_type==STOP_TYPE_PENDING);}
   virtual void      OCO(bool oco) {m_oco=oco;}
   virtual bool      OCO() {return(m_oco);}
   virtual bool      Refresh();
   virtual bool      InitTrade(JTrade *trade=NULL);
   virtual bool      Init(string symbol,JTrade *trade=NULL);
   virtual bool      Deinit();

   virtual CChartObjectHLine *CreateEntryObject(long id,string name,int window,double price);
   virtual CChartObjectHLine *CreateStopLossObject(long id,string name,int window,double price);
   virtual CChartObjectHLine *CreateTakeProfitObject(long id,string name,int window,double price);
   virtual CChartObjectHLine *CreateObject(long id,string name,int window,double price);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop::~JStop()
  {
//Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop::JStop(string name) : m_magic(INT_MAX),
                            m_stoploss(0),
                            m_takeprofit(0),
                            m_volume_type(VOLUME_TYPE_FIXED),
                            m_volume_fixed(0),
                            m_volume_percent(0),
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

CChartObjectHLine *JStop::CreateEntryObject(long id,string name,int window,double price)
  {
   if(m_entry_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChartObjectHLine *JStop::CreateStopLossObject(long id,string name,int window,double price)
  {
   if(m_stoploss_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChartObjectHLine *JStop::CreateTakeProfitObject(long id,string name,int window,double price)
  {
   if(m_takeprofit_visible)
      return(CreateObject(id,name,window,price));
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChartObjectHLine *JStop::CreateObject(long id,string name,int window,double price)
  {
   CChartObjectHLine*obj=new CChartObjectHLine();
   obj.Create(id,name,window,price);
   return(obj);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::Init(string symbol,JTrade *trade=NULL)
  {
   if(m_symbol==NULL)
     {
      if((m_symbol=new CSymbolInfo)==NULL)
         return(false);
     }
   if(!m_symbol.Name(symbol))
      return(false);
   m_digits_adjust=(m_symbol.Digits()==3 || m_symbol.Digits()==5) ? 10 : 1;
   m_point_adjust=m_symbol.Point()*m_digits_adjust;
   return(InitTrade(trade));
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
double JStop::TakeProfitPrice(const double total_volume,const double volume_remaining,double volume,double price,ENUM_ORDER_TYPE type,ulong &ticket)
  {
   double val=0.0;
   double lotsize=0.0;
   if(m_volume_type==VOLUME_TYPE_FIXED)
      lotsize=volume;
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
      lotsize=volume*volume_remaining;
   if(m_takeprofit>0.0)
     {
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
        {
         val=price+m_takeprofit*m_point_adjust;
         if(m_stop_type==STOP_TYPE_PENDING)
           {
            m_trade.Sell(lotsize,val,0,0);
            ticket=m_trade.ResultOrder();
           }
        }
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
        {
         val=price-m_takeprofit*m_point_adjust;
         if(m_stop_type==STOP_TYPE_PENDING)
           {
            m_trade.Buy(lotsize,val,0,0);
            ticket=m_trade.ResultOrder();
           }
        }
     }
   return(NormalizeDouble(val,m_digits_adjust));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::StopLossPrice(const double total_volume,const double volume_remaining,double volume,double price,ENUM_ORDER_TYPE type,ulong &ticket)
  {
   double val=0.0;
   double lotsize=0.0;
   if(m_volume_type==VOLUME_TYPE_FIXED)
      lotsize=volume;
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
      lotsize=volume*volume_remaining;
   if(m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
      lotsize=volume*total_volume;
   else if(m_volume_type==VOLUME_TYPE_REMAINING)
      lotsize=volume_remaining;
   if(m_stoploss>0.0)
     {
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
        {
         val=price-m_stoploss*m_point_adjust;
         if(m_stop_type==STOP_TYPE_PENDING)
           {
            m_trade.Sell(lotsize,val,0,0);
            ticket=m_trade.ResultOrder();
           }
        }
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
        {
         val=price+m_stoploss*m_point_adjust;
         if(m_stop_type==STOP_TYPE_PENDING)
           {
            m_trade.Buy(lotsize,val,0,0);
            ticket=m_trade.ResultOrder();
           }
        }
     }
   return(NormalizeDouble(val,m_digits_adjust));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::Volume(double &volume_fixed,double &volume_percent)
  {
   if(m_volume_type==VOLUME_TYPE_FIXED || m_volume_type==VOLUME_TYPE_REMAINING)
     {
      volume_fixed=m_volume_fixed;
      volume_percent=0.0;
     }
   else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING || m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
     {
      volume_percent=m_volume_percent;
      volume_fixed=0.0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::StopType(ENUM_STOP_TYPE stop_type)
  {
   m_stop_type=stop_type;
   if(m_stop_type==STOP_TYPE_MAIN) m_stop_type=STOP_TYPE_PENDING;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::CreateNonVirtual(ulong order_ticket,int order_type,double volume,double price)
  {
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
bool JStop::CheckStopLoss(const double total_volume,double &volume_remaining,double volume,ENUM_ORDER_TYPE type,double stoploss)
  {
   if(stoploss<=0.0) return(false);
   double price=0.0;
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
      return(CloseStop(total_volume,volume_remaining,volume,type,price));
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::CheckTakeProfit(const double total_volume,double &volume_remaining,double volume,ENUM_ORDER_TYPE type,double takeprofit)
  {
   if(takeprofit<=0.0) return(false);
   double price=0.0;
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
      return(CloseStop(total_volume,volume_remaining,volume,type,price));
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::CloseStop(const double total_volume,double &volume_remaining,double volume,ENUM_ORDER_TYPE type,double price)
  {
   bool res=false;
   if(m_stop_type==STOP_TYPE_VIRTUAL)
     {
      double lotsize;
      if(m_volume_type==VOLUME_TYPE_FIXED)
         lotsize=volume;
      else if(m_volume_type==VOLUME_TYPE_PERCENT_REMAINING)
         lotsize=volume_remaining*volume;
      else if(m_volume_type==VOLUME_TYPE_PERCENT_TOTAL)
         lotsize=total_volume*volume;
      else if(m_volume_type==VOLUME_TYPE_REMAINING)
         lotsize=volume_remaining;
      if(type==ORDER_TYPE_BUY)
        {
         res=m_trade.Sell(MathMin(lotsize,volume_remaining),price,0,0);
        }
      else if(type==ORDER_TYPE_SELL)
        {
         res=m_trade.Buy(MathMin(lotsize,volume_remaining),price,0,0);
        }
      if(res)
        {
         volume_remaining-=lotsize;
        }
     }
   return(res);
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
         double order_volume;
         h_ord.Ticket(ticket);
         if(h_ord.InfoInteger(ORDER_STATE,state))
           {
            if(state==ORDER_STATE_FILLED)
              {
               return(DeleteStopOrder(ticket));
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
                        if(h_ord.InfoDouble(ORDER_VOLUME_INITIAL,order_volume))
                          {
                           volume_remaining-=order_volume;
                          }
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
