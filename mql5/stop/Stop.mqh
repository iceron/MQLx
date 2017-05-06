//+------------------------------------------------------------------+
//|                                                         Stop.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Trade\OrderInfo.mqh>
#include <Trade\PositionInfo.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStop : public CStopBase
  {
protected:
   ENUM_ACCOUNT_MARGIN_MODE m_margin_mode;
public:
                     CStop(void);
                     CStop(const string);
                    ~CStop(void);
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   virtual ulong     Buy(const double,const double);
   virtual ulong     Sell(const double,const double);
   virtual bool      CheckStopOrder(double&,const ulong) const;
   virtual bool      DeleteStopOrder(const ulong);
   virtual bool      DeleteMarketStop(const ulong);
   virtual bool      Move(const ulong,const double,const double);
   virtual bool      MoveStopLoss(const ulong,const double);
   virtual bool      MoveTakeProfit(const ulong,const double);
   virtual double    StopLossPrice(COrder*,COrderStop*);
   virtual double    TakeProfitPrice(COrder*,COrderStop*);
   virtual bool      IsHedging(void) const;
protected:
   virtual bool      OpenStop(COrder*,COrderStop*,double);
   virtual bool      CloseStop(COrder*,COrderStop*,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::CStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo,CEventAggregator *event_man=NULL)
  {
   m_margin_mode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   return CStopBase::Init(symbolmanager,accountinfo,event_man);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::CStop(const string name)
  {
   m_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::~CStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::IsHedging(void) const
  {
   return m_margin_mode==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::CheckStopOrder(double &volume_remaining,const ulong ticket) const
  {
   COrderInfo ord;
   CHistoryOrderInfo h_ord;
   HistorySelect(0,TimeCurrent());
   if(ticket>0)
     {
      if(ord.Select(ticket)) return false;
      else
        {
         long state;
         h_ord.Ticket(ticket);
         if(h_ord.InfoInteger(ORDER_STATE,state))
           {
            if(h_ord.State()==ORDER_STATE_FILLED)
              {
               volume_remaining-=h_ord.VolumeInitial();
               return true;
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
                        return true;
                       }
                    }
                 }
              }
           }
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::DeleteStopOrder(const ulong ticket)
  {
   if(ticket<=0)
      return true;
   bool result=false;
   COrderInfo ord;
   if(ord.Select(ticket))
     {
      m_symbol=m_symbol_man.Get(ord.Symbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      if(m_trade.OrderDelete(ticket))
        {
         uint res=m_trade.ResultRetcode();
         if(res==TRADE_RETCODE_DONE || res==TRADE_RETCODE_PLACED)
            result=true;
        }
     }
   else
     {
      ResetLastError();
      CPositionInfo pos;
      if(!IsHedging())
        {
         if(pos.SelectByTicket(ticket))
           {
            m_symbol=m_symbol_man.Get(pos.Symbol());
            if(!CheckPointer(m_symbol))
               return false;
            m_trade=m_trade_man.Get(m_symbol.Name());
            if(!CheckPointer(m_trade))
               return false;
            if(m_trade.PositionClose(ticket))
              {
               uint res=m_trade.ResultRetcode();
               if(res==TRADE_RETCODE_DONE || res==TRADE_RETCODE_PLACED)
                  result=true;
              }
           }
        }
      else
        {
         result = true;        
        }
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::DeleteMarketStop(const ulong ticket)
  {
   if(ticket<=0)
      return true;
   if (!IsHedging())
      return true;
   bool result=false;
   CPositionInfo pos;
   if(pos.SelectByTicket(ticket))
     {
      double vol;
      pos.InfoDouble(POSITION_VOLUME,vol);     
      if(pos.Volume()>0)
        {
         if(!CheckPointer(m_symbol))
            return false;
         m_trade=m_trade_man.Get(m_symbol.Name());
         if(!CheckPointer(m_trade))
            return false;
         if(m_trade.PositionClose(ticket))
           {
            uint res=m_trade.ResultRetcode();
            if(res==TRADE_RETCODE_DONE || res==TRADE_RETCODE_PLACED)
               result=true;
           }
        }
       else result = true;
       
     }
   else 
   {
      ResetLastError();
      result=true;
   }   
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::TakeProfitPrice(COrder *order,COrderStop *orderstop)
  {
   double val=m_takeprofit>0?TakeProfitCalculate(order.Symbol(),order.OrderType(),order.Price()):TakeProfitCustom(order.Symbol(),order.OrderType(),order.Price());
   if((m_stop_type==STOP_TYPE_PENDING || m_main) && (val>0.0))
      if(OpenStop(order,orderstop,val))
         orderstop.TakeProfitTicket(m_trade.ResultOrder());
   return val==0?val:NormalizeDouble(val,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::StopLossPrice(COrder *order,COrderStop *orderstop)
  {
   double val=m_stoploss>0?StopLossCalculate(order.Symbol(),order.OrderType(),order.Price()):StopLossCustom(order.Symbol(),order.OrderType(),order.Price());
   if((Pending() || Broker()) && (val>0.0))
     {
      if(OpenStop(order,orderstop,val))
         orderstop.StopLossTicket(m_trade.ResultOrder());
     }
   return val==0?val:NormalizeDouble(val,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::OpenStop(COrder *order,COrderStop *orderstop,double val)
  {
   if(val==0)
      return false;
   bool res=false;
   double lotsize=LotSizeCalculate(order,orderstop);
   ENUM_ORDER_TYPE type=orderstop.MainTicketType();
   if(Pending() || Broker())
     {
      m_symbol=m_symbol_man.Get(order.Symbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
         res=m_trade.Sell(lotsize,val,0,0,m_comment);
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
         res=m_trade.Buy(lotsize,val,0,0,m_comment);
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong CStop::Buy(const double lotsize,const double val)
  {
   if(m_trade.Buy(lotsize,val,0,0,m_comment))
      return m_trade.ResultOrder();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong CStop::Sell(const double lotsize,const double val)
  {
   if(m_trade.Sell(lotsize,val,0,0,m_comment))
      return m_trade.ResultOrder();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::CloseStop(COrder *order,COrderStop *orderstop,const double price)
  {
   bool res=false;
   ENUM_ORDER_TYPE type=order.OrderType();
   m_symbol=m_symbol_man.Get(order.Symbol());
   if(!CheckPointer(m_symbol))
      return false;
   m_trade=m_trade_man.Get(m_symbol.Name());
   if(!CheckPointer(m_trade))
      return false;
   if(CheckPointer(m_trade))
     {
      if(m_stop_type==STOP_TYPE_VIRTUAL)
        {
         double lotsize=MathMin(order.Volume(),LotSizeCalculate(order,orderstop));
         if(IsHedging())
           {
            if(OrderSelect(order.Ticket()))
              {
               long pos_id=OrderGetInteger(ORDER_POSITION_ID);
               res=m_trade.PositionClose(pos_id);
              }
           }
         else
           {
            if(type==ORDER_TYPE_BUY)
               res=m_trade.Sell(MathMin(lotsize,order.Volume()),price,0,0,m_comment);
            else if(type==ORDER_TYPE_SELL)
               res=m_trade.Buy(MathMin(lotsize,order.Volume()),price,0,0,m_comment);
            if(res)
               order.Volume(order.Volume()-lotsize);
           }
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::Move(const ulong ticket,const double stoploss,const double takeprofit)
  {
   return MoveStopLoss(ticket,stoploss) && MoveTakeProfit(ticket,takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::MoveStopLoss(const ulong ticket,const double stoploss)
  {
   COrderInfo order;
   if(order.Select(ticket))
     {
      m_symbol=m_symbol_man.Get(order.Symbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      double price_open=order.PriceOpen();
      if(MathAbs(stoploss-price_open)<m_symbol.TickSize())
         return false;
      return OrderModify(order.Ticket(),stoploss);
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::MoveTakeProfit(const ulong ticket,const double takeprofit)
  {
   COrderInfo order;
   if(order.Select(ticket))
     {
      m_symbol=m_symbol_man.Get(order.Symbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      double price_open=order.PriceOpen();
      if(MathAbs(takeprofit-price_open)<m_symbol.TickSize())
         return false;
      return OrderModify(order.Ticket(),takeprofit);
     }
   return false;
  }
//+------------------------------------------------------------------+
