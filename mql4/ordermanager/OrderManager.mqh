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
   virtual bool      CloseOrder(COrder*,const int);
   virtual void      OnTradeTransaction(COrder *order=NULL);
   virtual bool      TradeOpen(const string symbol,const int res);
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
void COrderManager::OnTradeTransaction(COrder *order=NULL)
  {
   COrder *temp=new COrder();
   int total= ::OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()!=m_magic && m_other_magic.Search(OrderMagicNumber())<0) continue;
      if(m_symbol.Name()!=OrderSymbol()) continue;
      temp.Ticket(OrderTicket());
      if(m_orders.Search(temp)>=0) continue;
      m_orders.NewOrder(OrderTicket(),OrderSymbol(),OrderMagicNumber(),(ENUM_ORDER_TYPE)::OrderType(),::OrderLots(),::OrderOpenPrice());
     }
   delete temp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::TradeOpen(const string symbol,const int res)
  {
   if(res<=0) return false;
   bool ret=false;
   int trades_total = TradesTotal();
   int orders_total = OrdersTotal();
   ENUM_ORDER_TYPE type=CSignal::SignalToOrderType(res);
   m_symbol = m_symbol_man.Get(symbol);
   if(!IsPositionAllowed(type))
      return true;
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      double price=PriceCalculate(type);
      double sl=0,tp=0;
      if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
        {
         sl = m_main_stop.StopLossCustom()?m_main_stop.StopLossCustom(type,price):m_main_stop.StopLossCalculate(symbol,type,price);
         tp = m_main_stop.TakeProfitCustom()?m_main_stop.TakeProfitCustom(type,price):m_main_stop.TakeProfitCalculate(symbol,type,price);
        }
      double lotsize=LotSizeCalculate(price,type,sl);
      ret=SendOrder(type,lotsize,price,sl,tp);
     }
   if(ret)
      OnTradeTransaction();
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::CloseOrder(COrder *order,const int index)
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
   return closed;
  }
//+------------------------------------------------------------------+
