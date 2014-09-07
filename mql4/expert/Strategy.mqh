//+------------------------------------------------------------------+
//|                                                     JStrategy.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStrategy : public JStrategyBase
  {
public:
                     JStrategy();
                    ~JStrategy();
   virtual bool      OnTick();
   virtual void      OnTradeTransaction();
   virtual bool      TradeOpen(int res);
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
bool JStrategy::OnTick()
  {
   if(!Activate()) return(false);
   bool ret=false;
   if(!Refresh()) return(ret);
   m_orders.OnTick();
   CheckClosedOrders();
   if(!IsTradeProcessed())
     {
      int signal=CheckSignals();
      CloseOppositeOrders(signal);
      ret=TradeOpen(signal);
      if(ret) m_last_trade_time=m_symbol.Time();
     }
   OnTradeTransaction();
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::OnTradeTransaction()
  {
   JOrder *temp=new JOrder();
   int total= ::OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()!=m_magic && m_other_magic.Search(OrderMagicNumber())<0) continue;
      if(m_symbol.Name()!=OrderSymbol()) continue;
      temp.Ticket(OrderTicket());
      if(m_orders.Total()>0)
         if(m_orders.Search(temp)>=0)
            continue;
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
bool JStrategy::TradeOpen(int res)
  {
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
