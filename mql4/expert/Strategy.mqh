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
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(void);
   virtual bool      TradeOpen(const int res);
   virtual bool      CloseOrder(JOrder *order,const int index);
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
bool JStrategy::CloseOrder(JOrder *order,const int index)
  {
   bool closed=false;
   if(CheckPointer(order)==POINTER_DYNAMIC)
     {
      if(order.OrderType()==ORDER_TYPE_BUY || order.OrderType()==ORDER_TYPE_SELL)
         closed=m_trade.OrderClose((ulong)order.Ticket());
      else
         closed=m_trade.OrderDelete((ulong)order.Ticket());
      if(closed)
        {
         if(ArchiveOrder(m_orders.Detach(index)))
           {
            order.IsClosed(true);
            m_orders_history.Clean(false);
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
   bool ret=JStrategyBase::OnTick();
   if(ret) OnTradeTransaction();
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
      Print(__FUNCTION__+": adding order");
      m_orders.NewOrder(OrderTicket(),(ENUM_ORDER_TYPE)::OrderType(),::OrderLots(),::OrderOpenPrice());
      Print(__FUNCTION__+": done adding order "+m_orders.Total());
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
   int trades_total = TradesTotal();
   int orders_total = OrdersTotal();   
   ENUM_ORDER_TYPE type=JSignal::SignalToOrderType(res); 
   if (!IsPositionAllowed(type))
      return(true);
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {      
      double price=PriceCalculate(type);
      double sl=0,tp=0;                
      if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
        {
          sl = m_main_stop.StopLossCustom()?m_main_stop.StopLossCustom(type,price):m_main_stop.StopLossCalculate(type,price);
          tp = m_main_stop.TakeProfitCustom()?m_main_stop.TakeProfitCustom(type,price):m_main_stop.TakeProfitCalculate(type,price);
        }
      double lotsize=LotSizeCalculate(price,ORDER_TYPE_BUY,StopLossCalculate(res,price));
      ret=SendOrder(type,lotsize,price,sl,tp);
     }
   return(ret);
  }
//+------------------------------------------------------------------+
