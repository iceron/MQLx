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
   if(!Active()) return(false);
   bool ret=false;
   if(!Refresh()) return(ret);
   m_orders.OnTick();
   CheckClosedOrders();
   if(IsNewBar())
     {
      int signal=CheckSignals();
      CloseOppositeOrders(signal);
      if(!IsTradeProcessed())
        {
         ret=TradeOpen(signal);
         if(ret) m_last_trade_time=m_symbol.Time();
        }
     }
   m_last_tick_time=m_symbol.Time();
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
      order.Magic(m_magic);
      order.CreateStops(GetPointer(m_stops));
      if(m_orders.InsertSort(order))
        {
         order.Magic(m_magic);
         order.SetContainer(GetPointer(m_orders));
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
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      m_trade.SetSymbol(m_symbol);
      price=PriceCalculate(res);
      if(res==CMD_LONG)
        {
         lotsize=LotSizeCalculate(price,ORDER_TYPE_BUY,StopLossCalculate(res,price));
         ret=m_trade.Buy(lotsize,price,0,0,m_comment);
        }
      else if(res==CMD_SHORT)
        {
         lotsize=LotSizeCalculate(price,ORDER_TYPE_SELL,StopLossCalculate(res,price));
         ret=m_trade.Sell(lotsize,price,0,0,m_comment);
        }
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
/*
   if(m_position_reverse)
     {
      JOrder *order=m_orders.At(m_orders.Total()-1);
      ENUM_ORDER_TYPE type=order.OrderType();
      if((res==CMD_LONG && IsOrderTypeShort(type)) || (res==CMD_SHORT && IsOrderTypeLong(type)) || res==CMD_VOID)
        {
         if(CloseStops())
           {
            m_trade.PositionClose(m_symbol.Name());
            ArchiveOrders();
            m_orders.Clear();
           }
        }
     }
   */
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::CloseOrders(const int res)
  {
   int total= m_orders.Total();
   for(int i=total-1;i>=0;i--)
     {
      JOrder *order=m_orders.At(i);
      if((IsSignalTypeLong((ENUM_CMD) res) && IsOrderTypeLong(order.OrderType()))
         || (IsSignalTypeShort((ENUM_CMD)res) && IsOrderTypeShort(order.OrderType()))
         || (res=CMD_VOID))
         CloseOrder(order,i);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::CloseOrder(JOrder *order,int index)
  {
   bool closed=false;
   COrderInfo ord;
   CHistoryOrderInfo h_ord;
   if(CheckPointer(order))
     {
      if (ord.Select(order.Ticket())
         closed=m_trade.OrderDelete(order.Ticket());
      else
      {
         if (IsOrderTypeLong(order.OrderType()))
            closed=m_trade.Sell(order.Volume(),0,0,0);
         else if (IsOrderTypeShort(order.OrderType()))
            closed=m_trade.Buy(order.Volume(),0,0,0);
      }            
      if(closed)
        {
         if(order.CloseStops())
           {
            if(ArchiveOrder(m_orders.Detach(index)))
               order.IsClosed(true);
           }
        }
     }
  }
//+------------------------------------------------------------------+
