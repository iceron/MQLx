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
public:
                     COrderManager(void);
                    ~COrderManager(void);
   virtual bool      CloseOrder(COrder*,const int);
   virtual bool      TradeOpen(const string,ENUM_ORDER_TYPE,double,bool);
   virtual void      OnTradeTransaction(void);
   virtual void      OnTradeTransaction(int);
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
void COrderManager::OnTradeTransaction(int ticket)
  {
   if(ticket>0)
      if(OrderSelect(ticket,SELECT_BY_TICKET))
         m_orders.NewOrder(OrderTicket(),OrderSymbol(),OrderMagicNumber(),(ENUM_ORDER_TYPE)::OrderType(),::OrderLots(),::OrderOpenPrice());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::TradeOpen(const string symbol,ENUM_ORDER_TYPE type,double price,bool in_points=true)
  {
   int trades_total = TradesTotal();
   int orders_total = OrdersTotal();
   m_symbol=m_symbol_man.Get(symbol);
   if(!CheckPointer(m_symbol))
      return false;
   if(!IsPositionAllowed(type))
      return true;
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      ENUM_ORDER_TYPE ordertype=type;
      if(in_points)
         price=PriceCalculate(type);
      double sl=0,tp=0;
      if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
        {
         sl = m_main_stop.StopLossCustom()?m_main_stop.StopLossCustom(symbol,type,price):m_main_stop.StopLossCalculate(symbol,type,price);
         tp = m_main_stop.TakeProfitCustom()?m_main_stop.TakeProfitCustom(symbol,type,price):m_main_stop.TakeProfitCalculate(symbol,type,price);
        }
      double lotsize=LotSizeCalculate(price,type,sl);
      if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
      {
         if (!m_main_stop.Broker())
         {
            sl = 0;
            tp = 0;
         }
      }
      int ticket=(int)SendOrder(type,lotsize,price,sl,tp);
      if(ticket>0)
        {
         if(OrderSelect(ticket,SELECT_BY_TICKET))
         {
            COrder *order = m_orders.NewOrder(OrderTicket(),OrderSymbol(),OrderMagicNumber(),(ENUM_ORDER_TYPE)::OrderType(),::OrderLots(),::OrderOpenPrice());            
            if (CheckPointer(order))
            {
               LatestOrder(GetPointer(order));
               return true;
            }   
         }         
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::CloseOrder(COrder *order,const int index=-1)
  {
   bool closed=true;
   if(CheckPointer(order)==POINTER_DYNAMIC)
     {
      if(!CheckPointer(m_symbol) || StringCompare(m_symbol.Name(),order.Symbol())!=0)
         m_symbol=m_symbol_man.Get(order.Symbol());
      if(CheckPointer(m_symbol))
         m_trade=m_trade_man.Get(order.Symbol());
      if(order.Volume()>0)
        {
         if(order.OrderType()==ORDER_TYPE_BUY || order.OrderType()==ORDER_TYPE_SELL)
            closed=m_trade.OrderClose((ulong)order.Ticket());
         else
            closed=m_trade.OrderDelete((ulong)order.Ticket());
        }
      if(closed)
        {
         int idx = index>=0?index:FindOrderIndex(GetPointer(order));
         if(ArchiveOrder(m_orders.Detach(idx)))
           {
            order.Close();
            order.Volume(0);
           }
        }
     }
   return closed;
  }
//+------------------------------------------------------------------+
