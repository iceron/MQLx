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
   virtual void      OnTradeTransaction(void);
   virtual bool      TradeOpen(const int res);
   virtual void      CloseOrders(const int res);
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
JStrategy::CloseOppositeOrders(const int res)
  {
   if(m_orders.Total()==0) return;
   if(m_position_reverse)
      CloseOrders(res);
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
      if(IsOrderAgainstSignal((ENUM_ORDER_TYPE) order.OrderType(),(ENUM_CMD) res))
      {
         if (CloseOrder(order,i))
            CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_CLOSE_DONE,order);
         else
            CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_CLOSE);
      }      
     }
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
      JOrder *order=new JOrder(OrderTicket(),(ENUM_ORDER_TYPE)::OrderType(),::OrderLots(),::OrderOpenPrice());
      if(m_orders.InsertSort(order))
        {
         order.EventHandler(Events());
         order.Magic(m_magic);
         order.CreateStops(GetPointer(m_stops));
         order.SetContainer(GetPointer(m_orders));
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SEND_DONE,order);
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
   ENUM_ORDER_TYPE type = SignalToOrderType(res);
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
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SEND,EnumToString(type)+" "+DoubleToString(lotsize,2)+" "+DoubleToString(sl,5)+" "+DoubleToString(tp,5)+" "+m_comment+" "+DoubleToString(m_magic,0));
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
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SEND,EnumToString(type)+" "+DoubleToString(lotsize,2)+" "+DoubleToString(sl,5)+" "+DoubleToString(tp,5)+" "+m_comment+" "+DoubleToString(m_magic,0));
         ret=m_trade.Sell(lotsize,price,sl,tp,m_comment);
        }
     }
   if (!ret)
      CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_SEND);
   return(ret);
  }
//+------------------------------------------------------------------+
