//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
class JStop : public JStopBase
  {
public:
                     JStop(string name);
                    ~JStop(void);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const;
   virtual bool      DeleteStopOrder(const ulong ticket) const;
   virtual double    TakeProfitPrice(JOrder *order,JOrderStop *orderstop);
   virtual double    StopLossPrice(JOrder *order,JOrderStop *orderstop);
   virtual int       OpenStop(JOrder *order,JOrderStop *orderstop,double val);
   virtual bool      CloseStop(JOrder *order,JOrderStop *orderstop,double price);
   virtual bool      MoveStopLoss(ulong ticket,double stoploss);
   virtual bool      MoveTakeProfit(ulong ticket,double stoploss);
protected:
   virtual ulong     GetNewTicket(JOrder *order,JOrderStop *orderstop);
  };
//+------------------------------------------------------------------+
JStop::JStop(string name)
  {
   m_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop::~JStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::CheckStopOrder(double &volume_remaining,const ulong ticket) const
  {
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
      return(false);
   if(OrderType()<=1)
     {
      volume_remaining-=OrderLots();
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::DeleteStopOrder(const ulong ticket) const
  {
   if(ticket<=0) return(true);
   if(!OrderSelect((int)ticket,SELECT_BY_TICKET))
      return(true);
   if(OrderType()>1 && OrderCloseTime()==0)
      return(m_trade.OrderDelete(ticket));
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::TakeProfitPrice(JOrder *order,JOrderStop *orderstop)
  {
   double val=m_takeprofit>0?TakeProfitCalculate(order.OrderType(),order.Price()):TakeProfitCustom(order.OrderType(),order.Price());
   if(m_stop_type==STOP_TYPE_PENDING && val>0.0)
      orderstop.StopLossTicket(OpenStop(order,orderstop,val));
   return(NormalizeDouble(val,m_symbol.Digits()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStop::StopLossPrice(JOrder *order,JOrderStop *orderstop)
  {
   double val=m_stoploss>0?StopLossCalculate(order.OrderType(),order.Price()):StopLossCustom(order.OrderType(),order.Price());
   if(m_stop_type==STOP_TYPE_PENDING && val>0.0)
      orderstop.StopLossTicket(OpenStop(order,orderstop,val));
   return(NormalizeDouble(val,m_symbol.Digits()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JStop::OpenStop(JOrder *order,JOrderStop *orderstop,double val)
  {
   int res=-1;
   double lotsize=LotSizeCalculate(order,orderstop);
   ENUM_ORDER_TYPE type=order.OrderType();
   if(m_stop_type==STOP_TYPE_PENDING && !m_main)
     {
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
         res=m_trade.Sell(lotsize,val,0,0,m_comment);
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
         res=m_trade.Buy(lotsize,val,0,0,m_comment);
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::CloseStop(JOrder *order,JOrderStop *orderstop,double price)
  {
   bool res=false;
   ENUM_ORDER_TYPE type=order.OrderType();
   int ticket=(int) order.Ticket();
   if(m_stop_type==STOP_TYPE_VIRTUAL)
     {
      double lotsize=LotSizeCalculate(order,orderstop);
      res=m_trade.OrderClose(ticket,lotsize,price);
      if(res)
        {
         if(lotsize<order.Volume())
            order.NewTicket(true);
         order.Volume(order.Volume()-lotsize);
        }
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong JStop::GetNewTicket(JOrder *order,JOrderStop *orderstop)
  {
   int total= ::OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()==order.Magic()) return(OrderTicket());
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::MoveStopLoss(ulong ticket,double stoploss)
  {
   if(OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      if(MathAbs(stoploss-OrderStopLoss())<m_symbol.TickSize()) return(false);
      return(m_trade.OrderModify(ticket,OrderOpenPrice(),stoploss,OrderTakeProfit(),0,OrderExpiration()));
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStop::MoveTakeProfit(ulong ticket,double takeprofit)
  {
   if(OrderSelect((int)ticket,SELECT_BY_TICKET))
     {
      if(MathAbs(takeprofit-OrderStopLoss())<m_symbol.TickSize()) return(false);
      return(m_trade.OrderModify(ticket,OrderOpenPrice(),OrderStopLoss(),takeprofit,0,OrderExpiration()));
     }
   return(false);
  }
//+------------------------------------------------------------------+
