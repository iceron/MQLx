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
#include "Trade.mqh"
#include "Order.mqh"
#include "Orders.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStop : public CArrayObj
  {
private:
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
                     JStop(string symbol,string name,string sl=".sl.",string tp=".tp.");
                    ~JStop();
   virtual double    TakeProfit(double price,ulong type);
   virtual double    StopLoss(double price,ulong type);
   virtual double    Volume();
   virtual void      Volume(double volume);
   virtual void      Create(const MqlTradeTransaction &trans);
   virtual void      Check(JOrders &m_orders);
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

   virtual void      Visible(bool visible) {m_visible = visible;}
   virtual void      Virtual(bool nopending) {m_virtual = nopending;}
   virtual void      OCO(bool oco) {m_oco=oco;}
   virtual void      Name(string name) {m_name=name;}
   virtual void      StopLossName(string name) {m_stoploss_name=name;}
   virtual void      TakeProfitName(string name) {m_takeprofit_name=name;}
   virtual bool      InitTrade(CExpertTrade *trade=NULL);
   virtual bool      Refresh();
   virtual bool      Deinit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop::~JStop()
  {
  }
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

   m_name=name;
   m_stoploss_name=sl;
   m_takeprofit_name=tp;

   m_entry_color=clrGray;
   m_stoploss_color=clrRed;
   m_takeprofit_color=clrRed;

   m_entry_style=STYLE_SOLID;
   m_stoploss_style=STYLE_SOLID;
   m_takeprofit_style=STYLE_SOLID;
   if(!m_virtual) InitTrade();
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
double JStop::Volume()
  {
   return m_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStop::Volume(double volume)
  {
   m_volume=volume;
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
//+------------------------------------------------------------------+
void JStop::Create(const MqlTradeTransaction &trans)
  {
   double entry=trans.price;
   double stoploss=StopLoss(trans.price,trans.order_type);
   double takeprofit=TakeProfit(trans.price,trans.order_type);
   string order=DoubleToString(trans.order,0);

   if(ObjectFind(0,m_name+"."+order)<0)
     {
      if(ObjectCreate(0,m_name+order,OBJ_HLINE,0,0,entry))
        {
         ObjectSetString(0,m_name+"."+order,OBJPROP_TEXT,DoubleToString(trans.volume));
         if(ObjectCreate(0,m_name+m_stoploss_name+order,OBJ_HLINE,0,0,stoploss))
            ObjectSetString(0,m_name+m_stoploss_name+order,OBJPROP_TEXT,DoubleToString(m_volume));
         if(ObjectCreate(0,m_name+m_takeprofit_name+order,OBJ_HLINE,0,0,takeprofit))
            ObjectSetString(0,m_name+m_takeprofit_name+order,OBJPROP_TEXT,DoubleToString(m_volume));;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

void JStop::Check(JOrders &m_orders)
  {
   int total=m_orders.Total();
   for(int i=0;i<total;i++)
     {
      bool close = false;
      int direction = 0;
      JOrder *order = m_orders.At(i);
      string ticket = DoubleToString(order.OrderTicket(),0);
      double entry = ObjectGetDouble(0,m_name+"."+ticket,OBJPROP_PRICE,1);
      double stoploss = ObjectGetDouble(0,m_name+m_stoploss_name+ticket,OBJPROP_PRICE,1);
      double takeprofit = ObjectGetDouble(0,m_name+m_takeprofit_name+ticket,OBJPROP_PRICE,1);
      double stoploss_volume = StringToDouble(ObjectGetString(0,m_name+m_stoploss_name+ticket,OBJPROP_TEXT));
      double takeprofit_volume = StringToDouble(ObjectGetString(0,m_name+m_takeprofit_name+ticket,OBJPROP_TEXT));      
      Refresh();
      double ask = m_symbol.Ask();
      double bid = m_symbol.Bid();
      ENUM_ORDER_TYPE type = order.OrderType();
      Print(ticket," ",entry," ",stoploss," ",takeprofit," ",stoploss_volume," ",takeprofit_volume);
      
      if (m_virtual)
      {
         if (type==ORDER_TYPE_BUY)
         {
            if (ask<stoploss)  
               m_trade.Sell(stoploss_volume,bid,stoploss,takeprofit);
            if (ask>takeprofit)
               m_trade.Sell(takeprofit_volume,bid,stoploss,takeprofit);
         }   
         else if (type==ORDER_TYPE_SELL)
         {
            if (bid>stoploss)  
               m_trade.Buy(stoploss_volume,ask,stoploss,takeprofit);
            if (bid<takeprofit)
               m_trade.Buy(takeprofit_volume,ask,stoploss,takeprofit);
         }
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
//+------------------------------------------------------------------+
bool JStop::Deinit()
  {
   if(m_symbol!=NULL) delete m_symbol;
   return(true);
  }
//+------------------------------------------------------------------+
