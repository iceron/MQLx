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
   virtual void      OnTradeTransaction(void);
   virtual bool      TradeOpen(const string,ENUM_ORDER_TYPE,double,bool);
   int               MagicClose(void) const;
   void              MagicClose(const int);
   virtual bool      Save(const int);
   virtual bool      Load(const int);
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
bool COrderManager::Validate(void) const
  {
   if(m_magic==m_magic_close)
      return false;
   return COrderManagerBase::Validate();
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
         if(magic==m_magic && m_symbol_man.Search(symbol)>=0)
           {
            COrder temp;
            temp.Ticket(ticket);
            int idx=m_orders.Search(GetPointer(temp));
            COrder *order=m_orders.At(idx);
            if(!order.Initialized())
              {
               order.Price(price);
               if(order.Init(GetPointer(m_orders),m_orders.Stops()))
                  order.Initialized(true);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::TradeOpen(const string symbol,ENUM_ORDER_TYPE type,double price,bool in_points=true)
  {
   bool ret=false;
   double lotsize=0.0;
   int trades_total =TradesTotal();
   int orders_total = OrdersTotal();
   m_symbol=m_symbol_man.Get(symbol);
   if(!IsPositionAllowed(type))
      return true;
   if(m_max_orders>orders_total && (m_max_trades>trades_total || m_max_trades<=0))
     {
      if(in_points)
         price=PriceCalculate(type);
      double sl=0.0,tp=0.0;
      if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
        {
         sl = m_main_stop.StopLossCustom()?m_main_stop.StopLossCustom(symbol,type,price):m_main_stop.StopLossCalculate(symbol,type,price);
         tp = m_main_stop.TakeProfitCustom()?m_main_stop.TakeProfitCustom(symbol,type,price):m_main_stop.TakeProfitCalculate(symbol,type,price);
        }
      lotsize=LotSizeCalculate(price,type,m_main_stop==NULL?0:m_main_stop.StopLossCalculate(symbol,type,price));  
      if(CheckPointer(m_main_stop)==POINTER_DYNAMIC)
      {
         if (!m_main_stop.Broker() || !IsHedging())
         {
            sl = 0;
            tp = 0;
         }
      }    
      ret=SendOrder(type,lotsize,price,sl,tp);
      if(ret)
      {
         COrder *order = m_orders.NewOrder((int)m_trade.ResultOrder(),m_trade.RequestSymbol(),(int)m_trade.RequestMagic(),m_trade.RequestType(),m_trade.ResultVolume(),m_trade.ResultPrice());
         if (CheckPointer(order))
         {
            LatestOrder(GetPointer(order));
            return true;
         }
      }         
     }
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderManager::CloseOrder(COrder *order,const int index=-1)
  {
   bool closed=true;
   COrderInfo ord;
   if(order.Volume()>0 || IsHedging())
     {
      if(!CheckPointer(m_symbol) || StringCompare(m_symbol.Name(),order.Symbol())!=0)
         m_symbol=m_symbol_man.Get(order.Symbol());
      if(CheckPointer(m_symbol))
         m_trade=m_trade_man.Get(order.Symbol());
      m_trade.SetExpertMagicNumber(m_magic_close);
      if(ord.Select(order.Ticket()))
        {
         if(m_trade.OrderDelete(order.Ticket()))
           {
            uint res=m_trade.ResultRetcode();
            if(res==TRADE_RETCODE_DONE || res==TRADE_RETCODE_PLACED)
               closed=true;
           }
        }
      else
        {
         ResetLastError();
         if(IsHedging())
           {
            if(m_trade.PositionClose(order.Ticket()))
              {
               uint res=m_trade.ResultRetcode();
               if(res==TRADE_RETCODE_DONE || res==TRADE_RETCODE_PLACED)
                  closed=true;
              }
           }
         else
           {
            if(COrder::IsOrderTypeLong(order.OrderType()))
               closed=m_trade.Sell(order.Volume(),0,0,0);
            else if(COrder::IsOrderTypeShort(order.OrderType()))
               closed=m_trade.Buy(order.Volume(),0,0,0);
           }
        }
      m_trade.SetExpertMagicNumber(m_magic);
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
