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
   int               m_magic_close;
public:
                     COrderManager(void);
                    ~COrderManager(void);
   virtual bool      Validate(void) const;
   virtual bool      CloseOrder(COrder*,const int);
   virtual void      OnTradeTransaction(const MqlTradeTransaction &,const MqlTradeRequest &,const MqlTradeResult &);
   virtual bool      TradeOpen(const string,const ENUM_ORDER_TYPE);
   int               MagicClose(void) const {return m_magic;}
   void              MagicClose(const int magic) {m_magic_close=magic;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::COrderManager(void) : m_magic_close(0)
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
bool COrderManager::Validate(void) const
  {
   if(m_magic==m_magic_close || m_other_magic.Search(m_magic_close)>=0)
      return false;
   return COrderManagerBase::Validate();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderManager::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {   
   if(trans.type==TRADE_TRANSACTION_ORDER_DELETE && trans.order_state==ORDER_STATE_FILLED)
     {
      if(HistoryOrderSelect(trans.order))
        {
         ulong ticket=HistoryOrderGetInteger(trans.order,ORDER_TICKET);;
         ulong magic=HistoryOrderGetInteger(trans.order,ORDER_MAGIC);
         string symbol = HistoryOrderGetString(trans.order,ORDER_SYMBOL);
         double volume = HistoryOrderGetDouble(trans.order,ORDER_VOLUME_INITIAL);
         double price=HistoryOrderGetDouble(trans.order,ORDER_PRICE_OPEN);
         if((magic==m_magic || m_other_magic.Search((int)magic)>=0) && m_symbol_man.Search(symbol))
            m_orders.NewOrder((int)ticket,symbol,(int)magic,trans.order_type,volume,price);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::TradeOpen(const string symbol,ENUM_ORDER_TYPE type)
  {
   bool ret=false;
   double lotsize=0.0,price=0.0;
   int trades_total =TradesTotal();
   int orders_total = OrdersTotal();
   m_symbol=m_symbol_man.Get(symbol);
   if(!IsPositionAllowed(type))
      return true;
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      price=PriceCalculate(type);
      lotsize=LotSizeCalculate(price,type,m_main_stop==NULL?0:m_main_stop.StopLossCalculate(symbol,type,price));
      ret=SendOrder(type,lotsize,price,0,0);
     }
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::CloseOrder(COrder *order,const int index)
  {
   bool closed=true;
   COrderInfo ord;
   if(CheckPointer(order))
     {
      if(order.Volume()<=0) return true;
      if(!CheckPointer(m_symbol) || StringCompare(m_symbol.Name(),order.Symbol())!=0)
         m_symbol=m_symbol_man.Get(order.Symbol());
      if(CheckPointer(m_symbol))
         m_trade=m_trade_man.Get(order.Symbol());
      m_trade.SetExpertMagicNumber(m_magic_close);
      if(ord.Select(order.Ticket()))
         closed=m_trade.OrderDelete(order.Ticket());
      else
        {
         if(COrder::IsOrderTypeLong(order.OrderType()))
            closed=m_trade.Sell(order.Volume(),0,0,0);
         else if(COrder::IsOrderTypeShort(order.OrderType()))
            closed=m_trade.Buy(order.Volume(),0,0,0);
        }
      m_trade.SetExpertMagicNumber(m_magic);
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
