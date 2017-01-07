//+------------------------------------------------------------------+
//|                                             OrderManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderManager : public COrderManagerBase
  {
protected:
   ENUM_ACCOUNT_MARGIN_MODE m_margin_mode;
public:
                     COrderManager(void);
                    ~COrderManager(void);
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   virtual bool      CloseOrder(COrder*,const int);
   virtual bool      IsHedging(void) const;
   virtual COrder   *TradeOpen(const string,ENUM_ORDER_TYPE);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderManager::COrderManager(void) : m_margin_mode(0)
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
bool COrderManager::IsHedging(void) const
  {
   return m_margin_mode==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder* COrderManager::TradeOpen(const string symbol,ENUM_ORDER_TYPE type)
  {
   double lotsize=0.0,price=0.0;
   int trades_total =TradesTotal();
   int orders_total = OrdersTotal();
   m_symbol=m_symbol_man.Get(symbol);
   if(!IsPositionAllowed(type))
      return NULL;
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      price=PriceCalculate(type);
      lotsize=LotSizeCalculate(price,type,m_main_stop==NULL?0:m_main_stop.StopLossCalculate(symbol,type,price));
      if (SendOrder(type,lotsize,price,0,0))
         return m_orders.NewOrder((int)m_trade.ResultOrder(),m_trade.RequestSymbol(),(int)m_trade.RequestMagic(),m_trade.RequestType(),m_trade.ResultVolume(),m_trade.ResultPrice());
     }      
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::CloseOrder(COrder *order,const int index)
  {
   bool closed=true;
   COrderInfo ord;
   if(!CheckPointer(order))
      return true;
   if(order.Volume()<=0)
      return true;
   if(!CheckPointer(m_symbol) || StringCompare(m_symbol.Name(),order.Symbol())!=0)
      m_symbol=m_symbol_man.Get(order.Symbol());
   if(CheckPointer(m_symbol))
      m_trade=m_trade_man.Get(order.Symbol());
   if(ord.Select(order.Ticket()))
   {
      closed=m_trade.OrderDelete(order.Ticket());
   }   
   else
     {
      ResetLastError();
      if(IsHedging())
      {
         closed=m_trade.PositionClose(order.Ticket());
      }   
      else
        {
         if(COrder::IsOrderTypeLong(order.OrderType()))
            closed=m_trade.Sell(order.Volume(),0,0,0);
         else if(COrder::IsOrderTypeShort(order.OrderType()))
            closed=m_trade.Buy(order.Volume(),0,0,0);
        }
     }
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
