//+------------------------------------------------------------------+
//|                                             OrderManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderManager : public COrderManagerBase
  {
protected:
public:
                     COrderManager(void);
                    ~COrderManager(void);
   virtual bool      CloseOrder(COrder*,const int);
   virtual void      OnTradeTransaction(void);
   virtual bool      TradeOpen(const string,const ENUM_ORDER_TYPE);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::COrderManager(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::~COrderManager(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManager::OnTradeTransaction(void)
  {
   COrder *temp=new COrder();
   int total= ::OrdersTotal();
   for(int i=0;i<total;i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()!=m_magic && m_other_magic.Search(OrderMagicNumber())<0) continue;
      if (!m_symbol_man.Search(OrderSymbol())) continue;
      temp.Ticket(OrderTicket());
      if(m_orders.Search(temp)>=0) continue;
      m_orders.NewOrder(OrderTicket(),OrderSymbol(),OrderMagicNumber(),(ENUM_ORDER_TYPE)::OrderType(),::OrderLots(),::OrderOpenPrice());
     }
   delete temp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::TradeOpen(const string symbol,const ENUM_ORDER_TYPE type)
  {
   bool ret=false;
   int trades_total = TradesTotal();
   int orders_total = OrdersTotal();
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
   bool closed=true;
   if(CheckPointer(order)==POINTER_DYNAMIC)
     {
      if (m_symbol==NULL || StringCompare(m_symbol.Name(),order.Symbol())!=0)
         m_symbol = m_symbol_man.Get(order.Symbol());
      if (m_symbol!=NULL)
         m_trade = m_trade_man.Get(order.Symbol());
      if(order.OrderType()==ORDER_TYPE_BUY || order.OrderType()==ORDER_TYPE_SELL)
         closed=m_trade.OrderClose((ulong)order.Ticket());
      else
         closed=m_trade.OrderDelete((ulong)order.Ticket());
      if(closed)
        {
         if(ArchiveOrder(m_orders.Detach(index)))
           {
            order.Close();
            order.Volume(0);
           }
        }
     }
   return closed;
  }
//+------------------------------------------------------------------+
