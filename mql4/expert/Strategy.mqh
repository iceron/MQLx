//+------------------------------------------------------------------+
//|                                                     Strategy.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStrategy : public JStrategyBase
  {
public:
                     JStrategy(void);
                    ~JStrategy(void);
   virtual void      CloseOppositeOrders(int res);
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(void);
   virtual bool      TradeOpen(int res);
   virtual void      CloseOrders(int res);
   virtual bool      CloseOrder(JOrder *order,int index);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::JStrategy(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::~JStrategy(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::CloseOppositeOrders(int res)
  {   
   if(m_orders.Total()==0) return;
   if(m_position_reverse)
      CloseOrders(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::CloseOrders(int res)
  {   
   int total= m_orders.Total(); 
   for(int i=total-1;i>=0;i--)
     {
      JOrder *order=m_orders.At(i);         
      if(IsOrderAgainstSignal((ENUM_ORDER_TYPE) order.OrderType(),(ENUM_CMD) res))
            CloseOrder(order,i);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::CloseOrder(JOrder *order,int index)
  {
   bool closed=false;
   if(CheckPointer(order)==POINTER_DYNAMIC)
     {
      if(order.OrderType()==ORDER_TYPE_BUY || order.OrderType()==ORDER_TYPE_SELL)
         closed=m_trade.OrderClose(order.Ticket());
      else
         closed=m_trade.OrderDelete(order.Ticket());
      if(closed)
        {
         if(order.CloseStops())
           {
            if(ArchiveOrder(m_orders.Detach(index)))
               order.IsClosed(true);
           }
        }
     }
   return(closed);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::OnTick(void)
  {
   if(!Active()) return(false);
   bool ret=false;
   if(!Refresh()) return(ret);
   m_orders.OnTick();
   CheckClosedOrders();
   if(IsNewBar())
     {
      int signal=CheckSignals();      
      CloseOppositeOrders(signal);
      CheckClosedOrders();
      if(!IsTradeProcessed())
        {         
         ret=TradeOpen(signal);
         if(ret) m_last_trade_time=m_symbol.Time();
        }
      OnTradeTransaction();
     }
   m_last_tick_time=m_symbol.Time();
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::OnTradeTransaction(void)
  {
   JOrder *temp=new JOrder();
   int total= ::OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()!=m_magic && m_other_magic.Search(OrderMagicNumber())<0) continue;
      if(m_symbol.Name()!=OrderSymbol()) continue;
      temp.Ticket(OrderTicket());
      if(m_orders.Search(temp)>=0) continue;
      JOrder *order=new JOrder(OrderTicket(),(ENUM_ORDER_TYPE)::OrderType(),::OrderLots(),::OrderOpenPrice());
      if(m_orders.InsertSort(order))
        {
         order.Magic(m_magic);
         order.CreateStops(GetPointer(m_stops));
         order.SetContainer(GetPointer(m_orders));
        }
     }
   delete temp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::TradeOpen(const int res)
  {
   if(res<=0) return(false);
   bool ret=false;
   double sl=0,tp=0;
   double lotsize=0.0,price=0.0;
   int trades_total =TradesTotal();
   int orders_total = OrdersTotal();   
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      m_trade.SetSymbol(m_symbol);
      price=PriceCalculate(res);
      if(res==CMD_LONG)
        {
         if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
           {
            sl = m_main_stop.StopLossCustom()?m_main_stop.StopLossCustom(ORDER_TYPE_BUY,price):m_main_stop.StopLossCalculate(ORDER_TYPE_BUY,price);
            tp = m_main_stop.TakeProfitCustom()?m_main_stop.TakeProfitCustom(ORDER_TYPE_BUY,price):m_main_stop.TakeProfitCalculate(ORDER_TYPE_BUY,price);
           }
         lotsize=LotSizeCalculate(price,ORDER_TYPE_BUY,StopLossCalculate(res,price));
         ret=m_trade.Buy(lotsize,price,sl,tp,m_comment);
        }
      else if(res==CMD_SHORT)
        {
         if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
           {
            sl = m_main_stop.StopLossCustom()?m_main_stop.StopLossCustom(ORDER_TYPE_SELL,price):m_main_stop.StopLossCalculate(ORDER_TYPE_SELL,price);
            tp = m_main_stop.TakeProfitCustom()?m_main_stop.TakeProfitCustom(ORDER_TYPE_SELL,price):m_main_stop.TakeProfitCalculate(ORDER_TYPE_SELL,price);
           }
         lotsize=LotSizeCalculate(price,ORDER_TYPE_SELL,StopLossCalculate(res,price));
         ret=m_trade.Sell(lotsize,price,sl,tp,m_comment);
        }
     }
   return(ret);
  }
//+------------------------------------------------------------------+
