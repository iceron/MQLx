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
#include "Order.mqh"
#include "Orders.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStop : public CArrayObj
  {
protected:
   CSymbolInfo      *m_symbol;
   string            m_name;
   string            m_stoploss_name;
   string            m_takeprofit_name;
   double            m_stoploss;
   double            m_takeprofit;
   bool              m_visible;
   bool              m_virtual;
   bool              m_oco;
   double            m_point_adjust;
   int               m_digits_adjust;

   color             m_entry_color;
   color             m_stoploss_color;
   color             m_takeprofit_color;
   ENUM_LINE_STYLE   m_entry_style;
   ENUM_LINE_STYLE   m_stoploss_style;
   ENUM_LINE_STYLE   m_takeprofit_style;

   JTrade           *m_trade;
   double            m_volume;
   int               m_magic;
public:
   CChartObjectHLine *obj_entry;
   CChartObjectHLine *obj_stoploss;
   CChartObjectHLine *obj_takeprofit;
   
                     JStop(string symbol,string name,string sl=".sl.",string tp=".tp.");
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
   virtual void      Check(JOrders &m_orders);

   virtual double    Volume() {return(m_volume);}
   virtual void      Volume(double volume) {m_volume=volume;}
   virtual double    TakeProfit(double price,ulong type);
   virtual double    StopLoss(double price,ulong type);

   virtual void      SL(double sl) {m_stoploss = sl;}
   virtual void      TP(double tp) {m_takeprofit = tp;}
   virtual double    SL() {return(m_stoploss);}
   virtual double    TP() {return(m_takeprofit);}

   virtual void      EntryStyle(ENUM_LINE_STYLE style) {m_entry_style=style;}
   virtual void      StopLossStyle(ENUM_LINE_STYLE style) {m_stoploss_style=style;}
   virtual void      TakeProfitStyle(ENUM_LINE_STYLE style) {m_takeprofit_style=style;}

   virtual void      EntryColor(color clr) {m_entry_color=clr;}
   virtual void      StopLossColor(color clr) {m_stoploss_color=clr;}
   virtual void      TakeProfitColor(color clr) {m_takeprofit_color=clr;}

   virtual void      Magic(int magic) {m_magic=magic;}

   virtual void      Visible(bool visible) {m_visible=visible;}
   virtual bool      Visible() {return(m_visible);}
   virtual void      Virtual(bool nopending) {m_virtual=nopending;}
   virtual bool      Virtual() {return(m_virtual);}
   virtual void      OCO(bool oco) {m_oco=oco;}
   virtual bool      OCO() {return(m_oco);}

   virtual bool      Refresh();
   virtual bool      InitTrade(CExpertTrade *trade=NULL);
   virtual bool      Deinit();
  };
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
JStop::JStop(string symbol,string name,string sl=".sl.",string tp=".tp.")
  {
   if(m_symbol==NULL)
     {
      if((m_symbol=new CSymbolInfo)==NULL)
         return;
     }

   if(!m_symbol.Name(symbol))
      return;

   m_digits_adjust=(m_symbol.Digits()==3 || m_symbol.Digits()==5) ? 10 : 1;
   m_point_adjust=m_symbol.Point()*m_digits_adjust;
   Refresh();

   m_magic=0;
   m_oco=true;
   m_virtual=true;

   m_name=name;
   m_stoploss_name=sl;
   m_takeprofit_name=tp;

   m_entry_color=clrGray;
   m_stoploss_color=clrRed;
   m_takeprofit_color=clrRed;

   m_entry_style=STYLE_SOLID;
   m_stoploss_style=STYLE_SOLID;
   m_takeprofit_style=STYLE_SOLID;
   InitTrade();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::InitTrade(CExpertTrade *trade=NULL)
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
double JStop::TakeProfit(double price,ulong type)
  {
   double val=0.0;
   if(m_takeprofit>0.0)
     {
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
        {
         val=price+m_takeprofit*m_point_adjust;
        }
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
        {
         val=price-m_takeprofit*m_point_adjust;
        }
     }
   return(NormalizeDouble(val,m_digits_adjust));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::StopLoss(double price,ulong type)
  {
   double val=0.0;
   if(m_stoploss>0.0)
     {
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
        {
         val=price-m_stoploss*m_point_adjust;
        }
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
        {
         val=price+m_stoploss*m_point_adjust;
        }
     }
   return(NormalizeDouble(val,m_digits_adjust));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::Create(ulong order_ticket,int order_type,double volume,double price)
  {
   if(m_virtual) CreateVirtual(order_ticket,order_type,volume,price);
   else CreateNonVirtual(order_ticket,order_type,volume,price);
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
void JStop::CreateVirtual(ulong order_ticket,int order_type,double volume,double price)
  {
   
   double entry=price;
   double stoploss=StopLoss(price,order_type);
   double takeprofit=TakeProfit(price,order_type);
   string ticket=DoubleToString(order_ticket,0);

   if(ObjectFind(0,ticket)<0)
     {
      if(ObjectCreate(0,ticket,OBJ_HLINE,0,0,entry))
        {
         ObjectSetString(0,ticket,OBJPROP_TEXT,DoubleToString(volume));
         ObjectSetInteger(0,ticket,OBJPROP_COLOR,m_entry_color);
        }
     }
   if(ObjectCreate(0,m_name+m_stoploss_name+ticket,OBJ_HLINE,0,0,stoploss))
     {
      ObjectSetString(0,m_name+m_stoploss_name+ticket,OBJPROP_TEXT,DoubleToString(m_volume));
      ObjectSetInteger(0,m_name+m_stoploss_name+ticket,OBJPROP_COLOR,m_stoploss_color);
     }
   if(ObjectCreate(0,m_name+m_takeprofit_name+ticket,OBJ_HLINE,0,0,takeprofit))
     {
      ObjectSetString(0,m_name+m_takeprofit_name+ticket,OBJPROP_TEXT,DoubleToString(m_volume));;
      ObjectSetInteger(0,m_name+m_takeprofit_name+ticket,OBJPROP_COLOR,m_takeprofit_color);
     }
     
     
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::Check(JOrders &m_orders)
  {
   int total=m_orders.Total();
   for(int i=0;i<total;i++)
     {
      bool res=false;
      bool removed= false;
      int deleted = 0;
      JOrder *order=m_orders.At(i);
      if(order==NULL) continue;
      if(order.OrderTicket()==0) continue;
      string ticket=DoubleToString(order.OrderTicket(),0);
      double deleted_volume=0;
      double volume= StringToDouble(ObjectGetString(0,ticket,OBJPROP_TEXT));
      double entry = ObjectGetDouble(0,ticket,OBJPROP_PRICE,0);
      double stoploss=ObjectGetDouble(0,m_name+m_stoploss_name+ticket,OBJPROP_PRICE,0);
      double takeprofit=ObjectGetDouble(0,m_name+m_takeprofit_name+ticket,OBJPROP_PRICE,0);
      double stoploss_volume=MathMin(volume,StringToDouble(ObjectGetString(0,m_name+m_stoploss_name+ticket,OBJPROP_TEXT)));
      double takeprofit_volume=MathMin(volume,StringToDouble(ObjectGetString(0,m_name+m_takeprofit_name+ticket,OBJPROP_TEXT)));
      Refresh();
      double ask = m_symbol.Ask();
      double bid = m_symbol.Bid();
      ENUM_ORDER_TYPE type=order.OrderType();

      if(ObjectFind(0,ticket)<0 || volume<=0)
        {
         removed=true;
        }
      else
        {
         if(m_virtual)
           {
            if(type==ORDER_TYPE_BUY)
              {
               if(ask<stoploss && stoploss>0)
                 {
                  res=m_trade.Sell(stoploss_volume,bid,0,0);
                  if(res)
                    {
                     deleted_volume=stoploss_volume;
                     deleted=-1;
                    }
                 }
               if(ask>takeprofit && takeprofit>0)
                 {
                  res=m_trade.Sell(takeprofit_volume,bid,0,0);
                  if(res)
                    {
                     deleted_volume=takeprofit_volume;
                     deleted=1;
                    }
                 }
              }
            else if(type==ORDER_TYPE_SELL)
              {
               if(bid>stoploss && stoploss>0)
                 {
                  res=m_trade.Buy(stoploss_volume,ask,0,0);
                  if(res)
                    {
                     deleted_volume=stoploss_volume;
                     deleted=-1;
                    }
                 }
               if(bid<takeprofit && takeprofit>0)
                 {
                  res=m_trade.Buy(takeprofit_volume,ask,0,0);
                  if(res)
                    {
                     deleted_volume=takeprofit_volume;
                     deleted=1;
                    }
                 }
              }
           }
        }

      if(res || removed)
        {
         if(removed)
           {
            ObjectDelete(0,ticket);
           }
         if(m_oco || removed)
           {
            ObjectDelete(0,m_name+m_stoploss_name+ticket);
            ObjectDelete(0,m_name+m_takeprofit_name+ticket);
           }
         else
           {
            if(deleted==-1)
              {
               ObjectDelete(0,m_name+m_stoploss_name+ticket);
              }
            else if(deleted==1)
              {
               ObjectDelete(0,m_name+m_takeprofit_name+ticket);
              }
           }
         ObjectSetString(0,ticket,OBJPROP_TEXT,DoubleToString(volume-deleted_volume));
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::Refresh()
  {
   MqlDateTime time;
   if(!m_symbol.RefreshRates())
      return(false);
   TimeToStruct(m_symbol.Time(),time);
   return(true);
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
