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
   virtual void      CloseOppositeOrders(const int res);
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result);
   virtual bool      TradeOpen(const int res);
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
bool JStrategy::OnTick(void)
  {
   bool ret=JStrategyBase::OnTick();
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
      if(m_orders.InsertSort(order))
        {
         order.Magic(m_magic);
         order.CreateStops(GetPointer(m_stops));
         order.SetContainer(GetPointer(m_orders));
         OnTradeTransaction();
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::TradeOpen(const int res)
  {
   if(res<=0) return(false);
   bool ret=false;
   double lotsize=0.0,price=0.0;
   int trades_total =TradesTotal();
   int orders_total = OrdersTotal();
   ENUM_ORDER_TYPE type=SignalToOrderType(res);
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      m_trade.SetSymbol(m_symbol);
      price=PriceCalculate(res);      
      double lotsize=LotSizeCalculate(price,ORDER_TYPE_BUY,StopLossCalculate(res,price));
      ret=SendOrder(type,lotsize,price,sl,tp);
     }
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategyBase::CloseOppositeOrders(const int res)
  {
   if(m_orders.Total()==0) return;
   if(m_position_reverse)
     {
      CloseOrders(res);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::CloseOrder(JOrder *order,const int index)
  {
   bool closed=false;
   COrderInfo ord;
   if(CheckPointer(order)==POINTER_DYNAMIC)
     {
      if(ord.Select(order.Ticket()))
         closed=m_trade.OrderDelete(order.Ticket());
      else
        {
         if(IsOrderTypeLong(order.OrderType()))
            closed=m_trade.Sell(order.Volume(),0,0,0);
         else if(IsOrderTypeShort(order.OrderType()))
            closed=m_trade.Buy(order.Volume(),0,0,0);
        }
      if(closed)
        {
         if(ArchiveOrder(m_orders.Detach(index)))
           {
            order.IsClosed(true);
            m_orders_history.Clean(false);
           }
        }
     }
  }
//+------------------------------------------------------------------+
