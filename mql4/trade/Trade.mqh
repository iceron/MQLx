//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
#include "..\..\common\enum\ENUM_ORDER_TYPE_TIME.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTrade : public CObject
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  {
protected:
   bool              m_activate;
   int               m_magic;
   ulong             m_deviation;
   ENUM_ORDER_TYPE_TIME m_order_type_time;
   datetime          m_order_expiration;
   bool              m_async_mode;
   color             m_color_long;
   color             m_color_short;
   color             m_color_buystop;
   color             m_color_buylimit;
   color             m_color_sellstop;
   color             m_color_selllimit;
   color             m_color_modify;
   color             m_color_exit;
   CSymbolInfo      *m_symbol;
public:
                     JTrade(void);
                    ~JTrade(void);
   virtual int Type() const {return(CLASS_TYPE_TRADE);}
   //--- activation and deactivation
   virtual bool      Activate() const {return(m_activate);}
   virtual void      Activate(const bool activate) {m_activate=activate;}
   //--- setters and getters
   virtual color     ArrowColor(const ENUM_ORDER_TYPE type);
   virtual void      SetAsyncMode(const bool mode) {m_async_mode=mode;}
   virtual void      SetExpertMagicNumber(const int magic) {m_magic=magic;}
   virtual void      SetDeviationInPoints(const ulong deviation) {m_deviation=deviation;}
   virtual void      SetOrderExpiration(const datetime expire) {m_order_expiration=expire;}
   virtual bool      SetSymbol(CSymbolInfo *symbol);
   //-- trade methods   
   virtual ulong     Buy(const double volume,const double price,const double sl,const double tp,const string comment="");
   virtual ulong     Sell(const double volume,const double price,const double sl,const double tp,const string comment="");
   virtual bool      OrderDelete(const ulong ticket);
   virtual bool      OrderClose(const ulong ticket,const double lotsize=0,const double price=0);
   virtual bool      OrderCloseAll(CArrayInt *other_magic,const bool restrict_symbol=true);
   virtual bool      OrderModify(const ulong ticket,const double price,const double sl,const double tp,const ENUM_ORDER_TYPE_TIME type_time,const datetime expiration,const double stoplimit=0.0);
   virtual ulong     OrderOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume,const double limit_price,const double price,const double sl,const double tp,const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,const datetime expiration=0,const string comment="");
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrade::JTrade(void) : m_activate(true),
                       m_magic(0),
                       m_deviation(10),
                       m_order_type_time(0),
                       m_symbol(NULL),
                       m_async_mode(0),
                       m_color_long(clrGreen),
                       m_color_buystop(clrGreen),
                       m_color_buylimit(clrGreen),
                       m_color_sellstop(clrRed),
                       m_color_selllimit(clrRed),
                       m_color_short(clrRed),
                       m_color_modify(clrNONE),
                       m_color_exit(clrNONE)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrade::~JTrade(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrade::SetSymbol(CSymbolInfo *symbol)
  {
   if(symbol!=NULL)
     {
      m_symbol=symbol;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrade::OrderModify(const ulong ticket,const double price,const double sl,const double tp,
                         const ENUM_ORDER_TYPE_TIME type_time,const datetime expiration,const double stoplimit=0.0)
  {
   return(::OrderModify((int)ticket,price,sl,tp,expiration,m_color_modify));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrade::OrderDelete(const ulong ticket)
  {
   return(::OrderDelete((int)ticket));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong JTrade::Buy(const double volume,const double price,const double sl,const double tp,const string comment="")
  {
   if(m_symbol==NULL)
      return(false);
   string symbol=m_symbol.Name();
   double stops_level=m_symbol.StopsLevel()*m_symbol.Point();
   double ask=m_symbol.Ask();
   if(symbol=="")
      return(0);
   if(price!=0)
     {
      if(price>ask+stops_level)
         return(OrderOpen(symbol,ORDER_TYPE_BUY_STOP,volume,0.0,price,sl,tp,m_order_type_time,m_order_expiration,comment));
      if(price<ask-stops_level)
         return(OrderOpen(symbol,ORDER_TYPE_BUY_LIMIT,volume,0.0,price,sl,tp,m_order_type_time,m_order_expiration,comment));
     }
   return(OrderOpen(symbol,ORDER_TYPE_BUY,volume,0.0,ask,sl,tp,m_order_type_time,m_order_expiration,comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong JTrade::Sell(const double volume,const double price,const double sl,const double tp,const string comment="")
  {
   if(m_symbol==NULL)
      return(false);
   string symbol=m_symbol.Name();
   double stops_level=m_symbol.StopsLevel()*m_symbol.Point();
   double bid=m_symbol.Bid();
   if(symbol=="")
      return(0);
   if(price!=0)
     {
      if(price>bid+stops_level)
         return(OrderOpen(symbol,ORDER_TYPE_SELL_LIMIT,volume,0.0,price,sl,tp,m_order_type_time,m_order_expiration,comment));
      if(price<bid-stops_level)
         return(OrderOpen(symbol,ORDER_TYPE_SELL_STOP,volume,0.0,price,sl,tp,m_order_type_time,m_order_expiration,comment));
     }
   return(OrderOpen(symbol,ORDER_TYPE_SELL,volume,0.0,bid,sl,tp,m_order_type_time,m_order_expiration,comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong JTrade::OrderOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume,
                        const double limit_price,const double price,const double sl,const double tp,
                        const ENUM_ORDER_TYPE_TIME type_time=ORDER_TIME_GTC,const datetime expiration=0,
                        const string comment="")
  {
   bool res;
   ulong ticket;
   color arrowcolor=ArrowColor(order_type);
   datetime expire=0;
   if(order_type>1 && expiration>0) expire=expiration*1000+TimeCurrent();
   double stops_level=m_symbol.StopsLevel();
   if(stops_level==0 && order_type<=1)
     {
      ticket=::OrderSend(symbol,order_type,volume,price,(int)(m_deviation*m_symbol.Point()),0,0,comment,m_magic,expire,arrowcolor);
      Sleep(500);
      if(ticket>0)
         if(sl>0 || tp>0)
            res=::OrderModify((int)ticket,OrderOpenPrice(),sl,tp,OrderExpiration());
     }
   else ticket=::OrderSend(symbol,order_type,volume,price,(int)m_deviation,sl,tp,comment,m_magic,expire,arrowcolor);
   if(ticket>0)
      return(ticket);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrade::OrderClose(const ulong ticket,const double lotsize=0.0,const double price=0.0)
  {
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
      return(false);
   if(OrderCloseTime()>0)
      return(true);
   double close_price=0.0;
   int deviation=0;
   if(OrderSymbol()==m_symbol.Name() && price>0.0)
     {
      close_price=NormalizeDouble(price,m_symbol.Digits());
      deviation=(int)(m_deviation*m_symbol.Point());
     }
   else
     {
      close_price=NormalizeDouble(OrderClosePrice(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS));
      deviation=(int)(m_deviation*MarketInfo(OrderSymbol(),MODE_POINT));
     }
   double lots=(lotsize>0.0)?lotsize:OrderLots();
   return(::OrderClose((int)ticket,lots,close_price,deviation,m_color_exit));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrade::OrderCloseAll(CArrayInt *other_magic,const bool restrict_symbol=true)
  {
   bool res=true;
   int total= OrdersTotal();
   for(int i=total-1;i>=0;i--)
     {
      double bid=0.0,ask=0.0;
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderSymbol()!=m_symbol.Name() && restrict_symbol) continue;
      if(OrderMagicNumber()!=m_magic && other_magic.Search(OrderMagicNumber())<0) continue;
      m_symbol.RefreshRates();
      RefreshRates();
      if(OrderSymbol()==m_symbol.Name())
        {
         bid = m_symbol.Bid();
         ask = m_symbol.Ask();
        }
      else
        {
         bid = MarketInfo(OrderSymbol(),MODE_BID);
         ask = MarketInfo(OrderSymbol(),MODE_ASK);
        }
      if(res) res=OrderClose(OrderTicket(),OrderLots(),OrderType()==ORDER_TYPE_BUY?bid:ask);
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color JTrade::ArrowColor(const ENUM_ORDER_TYPE type)
  {
   switch(type)
     {
      case ORDER_TYPE_BUY:
         return(m_color_long);
      case ORDER_TYPE_SELL:
         return(m_color_short);
      case ORDER_TYPE_BUY_STOP:
         return(m_color_buystop);
      case ORDER_TYPE_BUY_LIMIT:
         return(m_color_buylimit);
      case ORDER_TYPE_SELL_STOP:
         return(m_color_sellstop);
      case ORDER_TYPE_SELL_LIMIT:
         return(m_color_selllimit);
     }
   return(clrNONE);
  }
//+------------------------------------------------------------------+
