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
                     CStop(const string name);
                    ~CStop(void);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const;
   virtual bool      DeleteStopOrder(const ulong ticket) const;
   virtual double    TakeProfitPrice(COrder *order,COrderStop *orderstop);
   virtual double    StopLossPrice(COrder *order,COrderStop *orderstop);
   virtual ulong     OpenStop(COrder *order,COrderStop *orderstop,const double val);
   virtual bool      CloseStop(COrder *order,COrderStop *orderstop,const double price);
   virtual bool      Move(const ulong ticket,const double stoploss,const double takeprofit);
   virtual bool      MoveStopLoss(const ulong ticket,const double stoploss);
   virtual bool      MoveTakeProfit(const ulong ticket,const double stoploss);
protected:
   virtual ulong     GetNewTicket(COrder *order,COrderStop *orderstop);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::CStop(void)
  {
   m_entry_visible = false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::CStop(const string name)
  {
   m_name=name;
   m_entry_visible = false;
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
bool CStop::DeleteStopOrder(const ulong ticket) const
  {
   if(ticket<=0) return true;
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
      return true;
   if(OrderType()>1 && OrderCloseTime()==0)
      return m_trade.OrderDelete(ticket);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::TakeProfitPrice(COrder *order,COrderStop *orderstop)
  {
   double val = 0;
   if (orderstop.TakeProfit()>0)
      val = orderstop.TakeProfit();
   else
      val=m_takeprofit>0?TakeProfitCalculate(order.Symbol(),order.OrderType(),order.Price()):TakeProfitCustom(order.OrderType(),order.Price());
   if(m_stop_type==STOP_TYPE_PENDING && val>0.0)
      orderstop.TakeProfitTicket(OpenStop(order,orderstop,val));
   return NormalizeDouble(val,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::StopLossPrice(COrder *order,COrderStop *orderstop)
  {
   double val = 0;
   if (orderstop.StopLoss()>0)
      val = orderstop.StopLoss();
   else
      val=m_stoploss>0?StopLossCalculate(order.Symbol(),order.OrderType(),order.Price()):StopLossCustom(order.OrderType(),order.Price());
   if(m_stop_type==STOP_TYPE_PENDING && val>0.0)
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
   ENUM_ORDER_TYPE type=order.OrderType();
   if(m_stop_type==STOP_TYPE_PENDING && !m_main)
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
   ENUM_ORDER_TYPE type=order.OrderType();
   int ticket=(int) order.Ticket();
   if(m_stop_type==STOP_TYPE_VIRTUAL)
     {
      double lotsize=MathMin(order.Volume(),LotSizeCalculate(order,orderstop));
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
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()==order.Magic()) return OrderTicket();
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
      if(MathAbs(stoploss-OrderStopLoss())<m_symbol.TickSize()) return false;
      if(MathAbs(takeprofit-OrderStopLoss())<m_symbol.TickSize()) return false;
      return m_trade.OrderModify(ticket,OrderOpenPrice(),stoploss,takeprofit,0,OrderExpiration());
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
      if(MathAbs(stoploss-OrderStopLoss())<m_symbol.TickSize())
         return false;
      return m_trade.OrderModify(ticket,OrderOpenPrice(),stoploss,OrderTakeProfit(),0,OrderExpiration());
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
      if(MathAbs(takeprofit-OrderStopLoss())<m_symbol.TickSize()) return false;
      return m_trade.OrderModify(ticket,OrderOpenPrice(),OrderStopLoss(),takeprofit,0,OrderExpiration());
     }
   return false;
  }
//+------------------------------------------------------------------+
