//+------------------------------------------------------------------+
//|                                             COrderManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#property strict
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderManager : public COrderManagerBase
  {
protected:
public:
                     COrderManager();
                    ~COrderManager();
   virtual bool      CloseOrder(JOrder*,const int);
   virtual void      OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result);
   virtual bool      TradeOpen(const int res);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::COrderManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::~COrderManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManager::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   if(request.magic==m_magic || m_other_magic.Search((int)request.magic)>=0)
      m_orders.NewOrder((int)result.order,request.type,result.volume,result.price);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::TradeOpen(const int res)
  {
   if(res<=0) return(false);
   bool ret=false;
   double lotsize=0.0,price=0.0;
   int trades_total =TradesTotal();
   int orders_total = OrdersTotal();
   ENUM_ORDER_TYPE type=JSignal::SignalToOrderType(res);
   if(!IsPositionAllowed(type))
      return(true);
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      price=PriceCalculate(type);
      lotsize=LotSizeCalculate(price,type,m_main_stop.StopLossCalculate(type,price));
      ret=SendOrder(type,lotsize,price,0,0);
     }
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::CloseOrder(JOrder *order,const int index)
  {
   bool closed=false;
   COrderInfo ord;
   if(CheckPointer(order)==POINTER_DYNAMIC)
     {
      if(ord.Select(order.Ticket()))
         closed=m_trade.OrderDelete(order.Ticket());
      else
        {
         if(JOrder::IsOrderTypeLong(order.OrderType()))
            closed=m_trade.Sell(order.Volume(),0,0,0);
         else if(JOrder::IsOrderTypeShort(order.OrderType()))
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
   return(closed);
  }
//+------------------------------------------------------------------+
