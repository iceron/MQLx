//+------------------------------------------------------------------+
//|                                                         Stop.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStop : public CStopBase
  {
public:
                     CStop(void);
                     CStop(const string);
                    ~CStop(void);
   virtual bool      CheckStopOrder(double &,const ulong) const;
   virtual bool      DeleteStopOrder(const ulong);
   virtual bool      DeleteMarketStop(const ulong);
   virtual bool      Move(const ulong,const double,const double);
   virtual bool      MoveStopLoss(const ulong,const double);
   virtual bool      MoveTakeProfit(const ulong,const double);
   virtual double    StopLossPrice(COrder*,COrderStop*);
   virtual double    TakeProfitPrice(COrder*,COrderStop*);
protected:
   virtual ulong     OpenStop(COrder*,COrderStop*,const double);
   virtual bool      CloseStop(COrder*,COrderStop*,const double);
   virtual ulong     GetNewTicket(COrder*,COrderStop*);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::CStop(void)
  {
   m_entry_visible=false;
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
bool CStop::CheckStopOrder(double &volume_remaining,const ulong ticket) const
  {
   if(ticket<=0)
      return false;
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
      return false;
   if(OrderType()<=1)
     {
      volume_remaining-=OrderLots();
      return true;
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
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
      return true;
   m_symbol=m_symbol_man.Get(OrderSymbol());
   if(!CheckPointer(m_symbol))
      return false;
   m_trade=m_trade_man.Get(m_symbol.Name());
   if(!CheckPointer(m_trade))
      return false;
   if(OrderCloseTime()==0)
     {
      if(OrderType()<=1)
         return m_trade.OrderClose(ticket);
      if(OrderType()>1)
         return m_trade.OrderDelete(ticket);
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::TakeProfitPrice(COrder *order,COrderStop *orderstop)
  {
   double val=0;
   if(orderstop.TakeProfit()>0)
      val=orderstop.TakeProfit();
   else
      val=m_takeprofit>0?TakeProfitCalculate(order.Symbol(),order.OrderType(),order.Price()):TakeProfitCustom(order.Symbol(),order.OrderType(),order.Price());
   if(Pending() && val>0.0)
      orderstop.TakeProfitTicket(OpenStop(order,orderstop,val));
   return NormalizeDouble(val,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::StopLossPrice(COrder *order,COrderStop *orderstop)
  {
   double val=0;
   if(orderstop.StopLoss()>0)
      val=orderstop.StopLoss();
   else
      val=m_stoploss>0?StopLossCalculate(order.Symbol(),order.OrderType(),order.Price()):StopLossCustom(order.Symbol(),order.OrderType(),order.Price());
   if(Pending() && val>0.0)
      orderstop.StopLossTicket(OpenStop(order,orderstop,val));
   return NormalizeDouble(val,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong CStop::OpenStop(COrder *order,COrderStop *orderstop,const double val)
  {
   ulong res=0;
   double lotsize=LotSizeCalculate(order,orderstop);
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)order.OrderType();
   m_symbol=m_symbol_man.Get(order.Symbol());
   if(!CheckPointer(m_symbol))
      return false;
   m_trade=m_trade_man.Get(m_symbol.Name());
   if(!CheckPointer(m_trade))
      return false;
   if(Pending())
     {
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
bool CStop::CloseStop(COrder *order,COrderStop *orderstop,const double price)
  {
   bool res=false;
   ENUM_ORDER_TYPE type=(ENUM_ORDER_TYPE)order.OrderType();
   int ticket=(int) order.Ticket();
   if(m_stop_type==STOP_TYPE_VIRTUAL)
     {
      if(!OrderSelect(ticket,SELECT_BY_TICKET))
         return false;
      m_symbol=m_symbol_man.Get(OrderSymbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      double lotsize_calc=LotSizeCalculate(order,orderstop);
      double lotsize=MathMin(order.Volume(),lotsize_calc);
      res=m_trade.OrderClose(ticket,lotsize,price);
      if(res)
        {
         if(lotsize<order.Volume())
            order.NewTicket(true);
         order.Volume(order.Volume()-lotsize);
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong CStop::GetNewTicket(COrder *order,COrderStop *orderstop)
  {
   int total= ::OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS))
         continue;
      if(OrderMagicNumber()==order.Magic())
         return OrderTicket();
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::Move(const ulong ticket,const double stoploss,const double takeprofit)
  {
   if(OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      m_symbol=m_symbol_man.Get(OrderSymbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      if(MathAbs(stoploss-OrderStopLoss())<m_symbol.TickSize())
         return false;
      if(MathAbs(takeprofit-OrderTakeProfit())<m_symbol.TickSize())
         return false;
      return m_trade.OrderModify(OrderTicket(),OrderOpenPrice(),stoploss,takeprofit,0,OrderExpiration());
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::MoveStopLoss(const ulong ticket,const double stoploss)
  {
   if(OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      m_symbol=m_symbol_man.Get(OrderSymbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      if(MathAbs(stoploss-OrderStopLoss())<m_symbol.TickSize())
         return false;
      return m_trade.OrderModify(OrderTicket(),OrderOpenPrice(),stoploss,OrderTakeProfit(),0,OrderExpiration());
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::MoveTakeProfit(const ulong ticket,const double takeprofit)
  {
   if(OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      m_symbol=m_symbol_man.Get(OrderSymbol());
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      if(MathAbs(takeprofit-OrderTakeProfit())<m_symbol.TickSize())
         return false;
      return m_trade.OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),takeprofit,0,OrderExpiration());
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::DeleteMarketStop(const ulong ticket)
  {
   if(ticket<=0)
      return true;
   bool result=false;
   if(OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      if (OrderCloseTime()>0)
         return true;      
      if(!CheckPointer(m_symbol))
         return false;
      m_trade=m_trade_man.Get(m_symbol.Name());
      if(!CheckPointer(m_trade))
         return false;
      result = m_trade.OrderClose(ticket);      
     }
   else 
   {
      ResetLastError();
      result=true;
   }   
   return result;
  }
//+------------------------------------------------------------------+
