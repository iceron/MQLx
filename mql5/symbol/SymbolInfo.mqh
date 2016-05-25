//+------------------------------------------------------------------+
//|                                               SymbolInfoBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSymbolInfo : public CSymbolInfoBase
  {
protected:
   double            m_tick_value_profit;  // symbol tick value profit
   double            m_tick_value_loss;    // symbol tick value loss
   double            m_lots_limit;         // symbol lots limit
   int               m_order_mode;         // symbol valid orders
   double            m_margin_initial;     // symbol margin initial
   double            m_margin_maintenance; // symbol margin maintenance
   double            m_margin_long;        // symbol margin long position
   double            m_margin_short;       // symbol margin short position
   double            m_margin_limit;       // symbol margin limit order
   double            m_margin_stop;        // symbol margin stop order
   double            m_margin_stoplimit;   // symbol margin stoplimit order
   int               m_trade_time_flags;   // symbol trade time flags
   int               m_trade_fill_flags;   // symbol trade fill flags
public:
                     CSymbolInfo(void);
                    ~CSymbolInfo(void);
   //--- methods of access to protected data
   bool              Refresh(void);              
   //--- fast access methods to the integer symbol propertyes
   bool              IsSynchronized(void) const;
   //--- volumes
   ulong             VolumeHigh(void) const;
   ulong             VolumeLow(void) const;
   //--- miscellaneous
   int               TicksBookDepth(void) const;
   //--- fast access methods to the double symbol propertyes
   //--- bid parameters
   double            BidHigh(void) const;
   double            BidLow(void) const;
   //--- ask parameters
   double            AskHigh(void) const;
   double            AskLow(void) const;
   //--- last parameters
   double            LastHigh(void) const;
   double            LastLow(void) const;
   //--- fast access methods to the mix symbol propertyes
   int               OrderMode(void) const { return(m_order_mode); }
   //--- terms of trade
   string            TradeCalcModeDescription(void) const;
   //--- execution terms of trade
   ENUM_SYMBOL_TRADE_EXECUTION TradeExecution(void) const { return(m_trade_execution); }
   string            TradeExecutionDescription(void) const;
   //--- margin parameters
   double            MarginInitial(void)                const { return(m_margin_initial);     }
   double            MarginMaintenance(void)            const { return(m_margin_maintenance); }
   double            MarginLong(void)                   const { return(m_margin_long);        }
   double            MarginShort(void)                  const { return(m_margin_short);       }
   double            MarginLimit(void)                  const { return(m_margin_limit);       }
   double            MarginStop(void)                   const { return(m_margin_stop);        }
   double            MarginStopLimit(void)              const { return(m_margin_stoplimit);   }
   //--- trade flags parameters
   int               TradeTimeFlags(void)               const { return(m_trade_time_flags);   }
   int               TradeFillFlags(void)               const { return(m_trade_fill_flags);   }
   //--- tick parameters
   double            TickValueProfit(void)              const { return(m_tick_value_profit);  }
   double            TickValueLoss(void)                const { return(m_tick_value_loss);    }
   //--- lots parameters
   double            LotsLimit(void)                    const { return(m_lots_limit);         }
   //--- fast access methods to the string symbol propertyes
   string            Bank(void) const;
   //--- session information
   long              SessionDeals(void) const;
   long              SessionBuyOrders(void) const;
   long              SessionSellOrders(void) const;
   double            SessionTurnover(void) const;
   double            SessionInterest(void) const;
   double            SessionBuyOrdersVolume(void) const;
   double            SessionSellOrdersVolume(void) const;
   double            SessionOpen(void) const;
   double            SessionClose(void) const;
   double            SessionAW(void) const;
   double            SessionPriceSettlement(void) const;
   double            SessionPriceLimitMin(void) const;
   double            SessionPriceLimitMax(void) const;
   //--- access methods to the API MQL5 functions
   bool              InfoInteger(const ENUM_SYMBOL_INFO_INTEGER prop_id,long &var) const;
   bool              InfoDouble(const ENUM_SYMBOL_INFO_DOUBLE prop_id,double &var) const;
   bool              InfoString(const ENUM_SYMBOL_INFO_STRING prop_id,string &var) const;
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSymbolInfo::CSymbolInfo(void) : m_tick_value_profit(0.0),
                                 m_tick_value_loss(0.0),
                                 m_lots_limit(0),
                                 m_order_mode(0),
                                 m_margin_initial(0.0),
                                 m_margin_maintenance(0.0),
                                 m_margin_long(0.0),
                                 m_margin_short(0.0),
                                 m_margin_limit(0.0),
                                 m_margin_stop(0.0),
                                 m_margin_stoplimit(0.0),
                                 m_trade_time_flags(0),
                                 m_trade_fill_flags(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSymbolInfo::~CSymbolInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Refresh cached data                                              |
//+------------------------------------------------------------------+
bool CSymbolInfo::Refresh(void)
  {      
   long tmp=0;
//---
   CSymbolInfoBase::Refresh();
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_VALUE_PROFIT,m_tick_value_profit))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_VALUE_LOSS,m_tick_value_loss))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_LIMIT,m_lots_limit))
      return(false);   
   if(!SymbolInfoInteger(m_name,SYMBOL_ORDER_MODE,tmp))
      return(false);
   m_order_mode=(int)tmp;
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_INITIAL,m_margin_initial))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_MAINTENANCE,m_margin_maintenance))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_LONG,m_margin_long))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_SHORT,m_margin_short))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_LIMIT,m_margin_limit))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_STOP,m_margin_stop))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_MARGIN_STOPLIMIT,m_margin_stoplimit))
      return(false);
   if(!SymbolInfoInteger(m_name,SYMBOL_EXPIRATION_MODE,tmp))
      return(false);
   m_trade_time_flags=(int)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_FILLING_MODE,tmp))
      return(false);
   m_trade_fill_flags=(int)tmp;
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Check synchronize symbol                                         |
//+------------------------------------------------------------------+
bool CSymbolInfo::IsSynchronized(void) const
  {
   return(SymbolIsSynchronized(m_name));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_VOLUMEHIGH"                       |
//+------------------------------------------------------------------+
ulong CSymbolInfo::VolumeHigh(void) const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_VOLUMEHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_VOLUMELOW"                        |
//+------------------------------------------------------------------+
ulong CSymbolInfo::VolumeLow(void) const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_VOLUMELOW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TICKS_BOOKDEPTH"                  |
//+------------------------------------------------------------------+
int CSymbolInfo::TicksBookDepth(void) const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_TICKS_BOOKDEPTH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_BIDHIGH"                          |
//+------------------------------------------------------------------+
double CSymbolInfo::BidHigh(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_BIDHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_BIDLOW"                           |
//+------------------------------------------------------------------+
double CSymbolInfo::BidLow(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_BIDLOW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_ASKHIGH"                          |
//+------------------------------------------------------------------+
double CSymbolInfo::AskHigh(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_ASKHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_ASKLOW"                           |
//+------------------------------------------------------------------+
double CSymbolInfo::AskLow(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_ASKLOW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_LASTHIGH"                         |
//+------------------------------------------------------------------+
double CSymbolInfo::LastHigh(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_LASTHIGH));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_LASTLOW"                          |
//+------------------------------------------------------------------+
double CSymbolInfo::LastLow(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_LASTLOW));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_CALC_MODE" as string        |
//+------------------------------------------------------------------+
string CSymbolInfo::TradeCalcModeDescription(void) const
  {
   string str;
//---
   switch(m_trade_calcmode)
     {
      case SYMBOL_CALC_MODE_FOREX:
         str="Calculation of profit and margin for Forex";
         break;
      case SYMBOL_CALC_MODE_CFD:
         str="Calculation of collateral and earnings for CFD";
         break;
      case SYMBOL_CALC_MODE_FUTURES:
         str="Calculation of collateral and profits for futures";
         break;
      case SYMBOL_CALC_MODE_CFDINDEX:
         str="Calculation of collateral and earnings for CFD on indices";
         break;
      case SYMBOL_CALC_MODE_CFDLEVERAGE:
         str="Calculation of collateral and earnings for the CFD when trading with leverage";
         break;
      case SYMBOL_CALC_MODE_EXCH_STOCKS:
         str="Calculation for exchange stocks";
         break;
      case SYMBOL_CALC_MODE_EXCH_FUTURES:
         str="Calculation for exchange futures";
         break;
      case SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS:
         str="Calculation for FORTS futures";
         break;
      default:
         str="Unknown calculation mode";
     }
//--- result
   return(str);
  }
*/
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_EXEMODE" as string          |
//+------------------------------------------------------------------+
string CSymbolInfo::TradeExecutionDescription(void) const
  {
   string str;
//---
   switch(m_trade_execution)
     {
      case SYMBOL_TRADE_EXECUTION_REQUEST : str="Trading on request";                break;
      case SYMBOL_TRADE_EXECUTION_INSTANT : str="Trading on live streaming prices";  break;
      case SYMBOL_TRADE_EXECUTION_MARKET  : str="Execution of orders on the market"; break;
      case SYMBOL_TRADE_EXECUTION_EXCHANGE: str="Exchange execution";                break;
      default:                              str="Unknown trade execution";
     }
//--- result
   return(str);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SWAP_MODE" as string              |
//+------------------------------------------------------------------+
string CSymbolInfo::SwapModeDescription(void) const
  {
   string str;
//---
   switch(m_swap_mode)
     {
      case SYMBOL_SWAP_MODE_DISABLED:
         str="No swaps";
         break;
      case SYMBOL_SWAP_MODE_POINTS:
         str="Swaps are calculated in points";
         break;
      case SYMBOL_SWAP_MODE_CURRENCY_SYMBOL:
         str="Swaps are calculated in base currency";
         break;
      case SYMBOL_SWAP_MODE_CURRENCY_MARGIN:
         str="Swaps are calculated in margin currency";
         break;
      case SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT:
         str="Swaps are calculated in deposit currency";
         break;
      case SYMBOL_SWAP_MODE_INTEREST_CURRENT:
         str="Swaps are calculated as annual interest using the current price";
         break;
      case SYMBOL_SWAP_MODE_INTEREST_OPEN:
         str="Swaps are calculated as annual interest using the open price";
         break;
      case SYMBOL_SWAP_MODE_REOPEN_CURRENT:
         str="Swaps are charged by reopening positions at the close price";
         break;
      case SYMBOL_SWAP_MODE_REOPEN_BID:
         str="Swaps are charged by reopening positions at the Bid price";
         break;
      default:
         str="Unknown swap mode";
     }
//--- result
   return(str);
  }
*/
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_BANK"                             |
//+------------------------------------------------------------------+
string CSymbolInfo::Bank(void) const
  {
   return(SymbolInfoString(m_name,SYMBOL_BANK));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_DEALS"                    |
//+------------------------------------------------------------------+
long CSymbolInfo::SessionDeals(void) const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_SESSION_DEALS));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_BUY_ORDERS"               |
//+------------------------------------------------------------------+
long CSymbolInfo::SessionBuyOrders(void) const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_SESSION_BUY_ORDERS));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_SELL_ORDERS"              |
//+------------------------------------------------------------------+
long CSymbolInfo::SessionSellOrders(void) const
  {
   return(SymbolInfoInteger(m_name,SYMBOL_SESSION_SELL_ORDERS));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_TURNOVER"                 |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionTurnover(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_TURNOVER));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_INTEREST"                 |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionInterest(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_INTEREST));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_BUY_ORDERS_VOLUME"        |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionBuyOrdersVolume(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_BUY_ORDERS_VOLUME));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_SELL_ORDERS_VOLUME"       |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionSellOrdersVolume(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_SELL_ORDERS_VOLUME));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_OPEN"                     |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionOpen(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_OPEN));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_CLOSE"                    |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionClose(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_CLOSE));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_AW"                       |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionAW(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_AW));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_PRICE_SETTLEMENT"         |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionPriceSettlement(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_PRICE_SETTLEMENT));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_PRICE_LIMIT_MIN"          |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionPriceLimitMin(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_PRICE_LIMIT_MIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SESSION_PRICE_LIMIT_MAX"          |
//+------------------------------------------------------------------+
double CSymbolInfo::SessionPriceLimitMax(void) const
  {
   return(SymbolInfoDouble(m_name,SYMBOL_SESSION_PRICE_LIMIT_MAX));
  }
//+------------------------------------------------------------------+
