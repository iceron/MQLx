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
   ENUM_ACCOUNT_MARGIN_MODE m_margin_mode;
public:
                     COrderManager(void);
                    ~COrderManager(void);
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   virtual bool      Validate(void) const;
   virtual bool      CloseOrder(COrder*,const int);
   virtual bool      IsHedging(void) const;
   virtual void      OnTradeTransaction(const MqlTradeTransaction&,const MqlTradeRequest&,const MqlTradeResult&);
   virtual bool      TradeOpen(const string,const ENUM_ORDER_TYPE);
   int               MagicClose(void) const;
   void              MagicClose(const int);
   virtual bool      Save(const int);
   virtual bool      Load(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::COrderManager(void) : m_magic_close(0),
                                     m_margin_mode(0)
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
bool COrderManager::Init(CSymbolManager *symbol_man,CAccountInfo *account,CEventAggregator *event_man=NULL)
  {
   m_margin_mode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   return COrderManagerBase::Init(symbol_man,account,event_man);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int COrderManager::MagicClose(void) const
  {
   return m_magic;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::MagicClose(const int magic)
  {
   m_magic_close=magic;
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
bool COrderManager::IsHedging(void) const
  {
   return m_margin_mode==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;
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
         ENUM_ORDER_TYPE order_type=trans.order_type;
         if(order_type==ORDER_TYPE_BUY_STOP|| order_type==ORDER_TYPE_BUY_LIMIT)
            order_type= ORDER_TYPE_BUY;
         else if(order_type==ORDER_TYPE_SELL_STOP || order_type==ORDER_TYPE_SELL_LIMIT)
            order_type=ORDER_TYPE_SELL;
         if((magic==m_magic || m_other_magic.Search((int)magic)>=0) && m_symbol_man.Search(symbol)>=0)
            m_orders.NewOrder((int)ticket,symbol,(int)magic,order_type,volume,price);
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
   if(!CheckPointer(order))
      return closed;
   if(order.Volume()<=0)
      return true;
   if(!CheckPointer(m_symbol) || StringCompare(m_symbol.Name(),order.Symbol())!=0)
      m_symbol=m_symbol_man.Get(order.Symbol());
   if(CheckPointer(m_symbol))
      m_trade=m_trade_man.Get(order.Symbol());
   m_trade.SetExpertMagicNumber(m_magic_close);
   if(ord.Select(order.Ticket()))
      closed=m_trade.OrderDelete(order.Ticket());
   else
     {
      CHistoryOrderInfo h_ord;
      h_ord.Ticket(order.Ticket());
      if(IsHedging())
         closed=m_trade.PositionClose(h_ord.PositionId());
      else
        {
         if(COrder::IsOrderTypeLong(order.OrderType()))
            closed=m_trade.Sell(order.Volume(),0,0,0);
         else if(COrder::IsOrderTypeShort(order.OrderType()))
            closed=m_trade.Buy(order.Volume(),0,0,0);
        }
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
   return closed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::Save(const int handle)
  {
   file.Handle(handle);
   if(!file.WriteInteger(m_magic_close))
      return false;
   return COrderManagerBase::Save(handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::Load(const int handle)
  {
   file.Handle(handle);
   if(!file.ReadInteger(m_magic_close))
      return false;
   return COrderManagerBase::Load(handle);
  }
//+------------------------------------------------------------------+
