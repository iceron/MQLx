//+------------------------------------------------------------------+
//|                                                     JStrategy.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Arrays\ArrayInt.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Expert\ExpertTrade.mqh>
#include "Signal.mqh"
#include "Trade.mqh"
#include "SignalManager.mqh"
#include "Orders.mqh"
#include "Order.mqh"
#include "Stops.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStrategy : CObject
  {
protected:
   CSymbolInfo      *m_symbol;
   JTrade           *m_trade;
   JSignalManager    m_signal_manager;
   JOrders           m_orders;
   JStops            m_stops;

   double            m_lotsize;
   double            m_price;
   double            m_stoploss;
   double            m_takeprofit;
   datetime          m_expiration;
   int               m_magic;

   ENUM_TIMEFRAMES   m_period;
   bool              m_every_tick;
   bool              m_one_trade_per_candle;
   bool              m_position_reverse;
   CArrayInt         m_other_magic;
   int               m_max_trades;

   int               m_digits_adjust;
   double            m_point_adjust;
   CPositionInfo     m_position;
   COrderInfo        m_order;
   CHistoryOrderInfo m_hist_order;
   MqlDateTime       m_last_tick_time;
   datetime          m_last_trade_time;
public:
                     JStrategy();
                    ~JStrategy();

   virtual double    Lotsize(){return(m_lotsize);}
   virtual void      Lotsize(double lotsize){m_lotsize=lotsize;}
   virtual double    Price() {return(m_price);}
   virtual void      Price(double price) {m_price=price;}
   virtual double    StopLoss(void) {return(m_stoploss);}
   virtual void      StopLoss(double sl) {m_stoploss=sl;}
   virtual double    TakeProfit(void) {return(m_takeprofit);}
   virtual void      TakeProfit(double tp){m_takeprofit=tp;}
   virtual datetime  Expiration() {return(m_expiration);}
   virtual void      Expiration(datetime expiration) {m_expiration=expiration;}
   virtual int       Magic() {return m_magic;}
   virtual void      Magic(int magic) {m_magic=magic;}

   virtual ENUM_TIMEFRAMES Period() {return(m_period);}
   virtual void      Period(ENUM_TIMEFRAMES period) {m_period=period;}
   virtual bool      EveryTick() {return(m_every_tick);}
   virtual void      EveryTick(bool every_tick) {m_every_tick=every_tick;}
   virtual bool      OneTradePerCandle(){return(m_one_trade_per_candle);}
   virtual void      OneTradePerCandle(bool one_trade_per_candle){m_one_trade_per_candle=one_trade_per_candle;}
   virtual bool      PositionReverse(){return(m_position_reverse);}
   virtual void      PositionReverse(bool position_reverse){m_position_reverse=position_reverse;}
   virtual bool      AddOtherMagic(int magic) {return(m_other_magic.Add(magic));}
   virtual int       MaxTrades(){return(m_max_trades);}
   virtual void      MaxTrades(int max_trades){m_max_trades=max_trades;}

   virtual bool      Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,int magic,bool one_trade_per_candle,bool position_reverse);
   virtual bool      Deinit();

   virtual bool      AddSignal(JSignal *signal);
   virtual bool      InitSignals();
   virtual int       CheckSignals();
   virtual void      DeinitSignals();

   virtual bool      InitTrade(CExpertTrade *trade=NULL);
   virtual bool      DeinitTrade();

   virtual bool      Refresh();
   virtual bool      IsTradeProcessed();

   virtual bool      DeinitSymbol();

   virtual void      AddStops(JStop *stops);
   virtual void      CreateStops(ulong order_ticket,int order_type,double volume,double price);
   virtual bool      DeinitStops();

   virtual bool      OnTick();
   virtual void      OnTrade();
   virtual void      OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::JStrategy()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::~JStrategy()
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick=true,int magic=0,bool one_trade_per_candle=true,bool position_reverse=true)
  {
   if(m_symbol==NULL)
     {
      if((m_symbol=new CSymbolInfo)==NULL)
         return(false);
     }

   if(!m_symbol.Name(symbol))
      return(false);

   m_period    =period;
   m_every_tick=every_tick;
   m_magic     =magic;
   m_position_reverse=position_reverse;
   m_one_trade_per_candle=one_trade_per_candle;
   m_last_trade_time=0;
   m_digits_adjust=(m_symbol.Digits()==3 || m_symbol.Digits()==5) ? 10 : 1;
   m_point_adjust=m_symbol.Point()*m_digits_adjust;
   InitTrade();
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::InitTrade(CExpertTrade *trade=NULL)
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
bool JStrategy::DeinitTrade()
  {
   if(m_trade!=NULL)
     {
      delete m_trade;
      m_trade=NULL;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::InitSignals()
  {
   return(m_signal_manager.InitSignals());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::AddSignal(JSignal *signal)
  {
   return(m_signal_manager.AddSignal(signal));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::OnTick()
  {
   bool ret=false;
   double lotsize=0.2;
   double price=0.0;
   double stoploss=0.0;
   double takeprofit=0.0;
   if(!Refresh()) return(ret);
   m_stops.CheckStops(m_orders);
   if(!IsTradeProcessed())
     {
      int res=CheckSignals();

      if(res==CMD_LONG)
        {
         if(m_position_reverse)
           {
            if(m_position.Select(m_symbol.Name()))
              {
               if(m_position.PositionType()==POSITION_TYPE_SELL)
                 {
                  m_trade.PositionClose(m_symbol.Name(),ULONG_MAX);
                  m_orders.Clear();
                 }
              }
           }
         ret=m_trade.Buy(lotsize,price,stoploss,takeprofit);
        }
      else if(res==CMD_SHORT)
        {
         if(m_position_reverse)
           {
            if(m_position.Select(m_symbol.Name()))
              {
               if(m_position.PositionType()==POSITION_TYPE_BUY)
                 {
                  m_trade.PositionClose(m_symbol.Name(),ULONG_MAX);
                  m_orders.Clear();
                 }
              }
           }
         ret=m_trade.Sell(lotsize,price,stoploss,takeprofit);
        }
      if(ret)
        {
         m_last_trade_time=m_symbol.Time();
        }
     }
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {

   if(request.magic==m_magic || m_other_magic.Search((int)request.magic)>=0)
     {
      JOrder *order=new JOrder(result.order,request.type,result.volume,result.price);
      m_orders.Add(order);
      CreateStops(result.order,request.type,result.volume,result.price);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::CreateStops(ulong order_ticket,int order_type,double volume,double price)
  {
   m_stops.CreateStops(order_ticket,order_type,volume,price);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::AddStops(JStop *stops)
  {
   m_stops.AddStops(stops);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::OnTrade()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JStrategy::CheckSignals()
  {
   return(m_signal_manager.CheckSignals());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::DeinitSignals()
  {
   m_signal_manager.Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::Deinit()
  {
   DeinitStops();
   DeinitSymbol();
   DeinitTrade();
   DeinitSignals();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::DeinitStops()
  {
   m_stops.Clear();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::DeinitSymbol()
  {
   if(m_symbol!=NULL) delete m_symbol;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::Refresh()
  {
   MqlDateTime time;
   if(!m_symbol.RefreshRates())
      return(false);
   TimeToStruct(m_symbol.Time(),time);
   m_last_tick_time=time;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::IsTradeProcessed()
  {
   if(!m_one_trade_per_candle) return(false);
   else
     {
      datetime arr[];
      if(CopyTime(m_symbol.Name(),m_period,0,1,arr)==-1)
         return(false);
      if(m_last_trade_time>0 && m_last_trade_time>=arr[0])
         return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
