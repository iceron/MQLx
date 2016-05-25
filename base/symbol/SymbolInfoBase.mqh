//+------------------------------------------------------------------+
//|                                               SymbolInfoBase.mqh |
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
class CSymbolInfoBase : public CObject
  {
protected:
   string            m_name;               // symbol name
   MqlTick           m_tick;               // structure of tick;
   double            m_point;              // symbol point
   double            m_tick_value;         // symbol tick value   
   double            m_tick_size;          // symbol tick size
   double            m_contract_size;      // symbol contract size
   double            m_lots_min;           // symbol lots min
   double            m_lots_max;           // symbol lots max
   double            m_lots_step;          // symbol lots step   
   double            m_swap_long;          // symbol swap long
   double            m_swap_short;         // symbol swap short
   int               m_digits;             // symbol digits   
   ENUM_SYMBOL_TRADE_EXECUTION m_trade_execution;    // symbol trade execution
   int m_trade_calcmode;     // symbol trade calcmode
   ENUM_SYMBOL_TRADE_MODE m_trade_mode;         // symbol trade mode
   int m_swap_mode;          // symbol swap mode
   ENUM_DAY_OF_WEEK  m_swap3;              // symbol swap3      
public:
                     CSymbolInfoBase(void);
                    ~CSymbolInfoBase(void);
   //--- methods of access to protected data
   string            Name(void) const { return(m_name); }
   bool              Name(const string name);
   bool              Refresh(void);
   bool              RefreshRates(void);
   //--- fast access methods to the integer symbol propertyes
   bool              Select(void) const;
   bool              Select(const bool select);
   //--- volumes
   ulong             Volume(void) const { return(m_tick.volume); }
   //--- miscellaneous
   datetime          Time(void) const { return(m_tick.time); }
   int               Spread(void) const;
   bool              SpreadFloat(void) const;
   //--- trade levels
   int               StopsLevel(void) const;
   int               FreezeLevel(void) const;
   //--- fast access methods to the double symbol propertyes
   //--- bid parameters
   double            Bid(void) const { return(m_tick.bid); }
   //--- ask parameters
   double            Ask(void) const { return(m_tick.ask); }
   //--- last parameters
   double            Last(void) const { return(m_tick.last); }
   //--- terms of trade
   int TradeCalcMode(void) const { return(m_trade_calcmode); }
   ENUM_SYMBOL_TRADE_MODE TradeMode(void) const { return(m_trade_mode); }
   string            TradeModeDescription(void) const;
   //--- execution terms of trade
   ENUM_SYMBOL_TRADE_EXECUTION TradeExecution(void) const { return(m_trade_execution); }
   string            TradeExecutionDescription(void) const;
   //--- swap terms of trade
   int SwapMode(void) const { return(m_swap_mode); }
   string            SwapModeDescription(void) const;
   ENUM_DAY_OF_WEEK  SwapRollover3days(void) const { return(m_swap3); }
   string            SwapRollover3daysDescription(void) const;
   //--- dates for futures
   datetime          StartTime(void) const;
   datetime          ExpirationTime(void) const;
   //--- tick parameters
   int               Digits(void)                       const { return(m_digits);             }
   double            Point(void)                        const { return(m_point);              }
   double            TickValue(void)                    const { return(m_tick_value);         }
   double            TickSize(void)                     const { return(m_tick_size);          }
   //--- lots parameters
   double            ContractSize(void)                 const { return(m_contract_size);      }
   double            LotsMin(void)                      const { return(m_lots_min);           }
   double            LotsMax(void)                      const { return(m_lots_max);           }
   double            LotsStep(void)                     const { return(m_lots_step);          }
   //--- swaps
   double            SwapLong(void)                     const { return(m_swap_long);          }
   double            SwapShort(void)                    const { return(m_swap_short);         }
   //--- fast access methods to the string symbol propertyes
   string            CurrencyBase(void) const;
   string            CurrencyProfit(void) const;
   string            CurrencyMargin(void) const;
   string            Description(void) const;
   string            Path(void) const;   
   //--- access methods to the API MQL5 functions
   bool              InfoInteger(const ENUM_SYMBOL_INFO_INTEGER prop_id,long &var) const;
   bool              InfoDouble(const ENUM_SYMBOL_INFO_DOUBLE prop_id,double &var) const;
   bool              InfoString(const ENUM_SYMBOL_INFO_STRING prop_id,string &var) const;
   //--- service methods
   double            NormalizePrice(const double price) const;
   bool              CheckMarketWatch(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSymbolInfoBase::CSymbolInfoBase(void) : m_name(""),
                                 m_point(0.0),
                                 m_tick_value(0.0),                                 
                                 m_tick_size(0.0),
                                 m_contract_size(0.0),
                                 m_lots_min(0.0),
                                 m_lots_max(0.0),
                                 m_lots_step(0.0),
                                 m_swap_long(0.0),
                                 m_swap_short(0.0),
                                 m_digits(0),                                 
                                 m_trade_execution(0),
                                 m_trade_calcmode(0),
                                 m_trade_mode(0),
                                 m_swap_mode(0),
                                 m_swap3(0)                              
                                 
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSymbolInfoBase::~CSymbolInfoBase(void)
  {
  }
//+------------------------------------------------------------------+
//| Set name                                                         |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::Name(const string name)
  {
   m_name=name;
//---
   if(!CheckMarketWatch())
      return(false);
//---
   if(!Refresh())
     {
      m_name="";
      Print(__FUNCTION__+": invalid data of symbol '"+name+"'");
      return(false);
     }
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Refresh cached data                                              |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::Refresh(void)
  {
   long tmp=0;
//---
   if(!SymbolInfoDouble(m_name,SYMBOL_POINT,m_point))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_VALUE,m_tick_value))
      return(false);   
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_TICK_SIZE,m_tick_size))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_TRADE_CONTRACT_SIZE,m_contract_size))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_MIN,m_lots_min))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_MAX,m_lots_max))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_VOLUME_STEP,m_lots_step))
      return(false);   
   if(!SymbolInfoDouble(m_name,SYMBOL_SWAP_LONG,m_swap_long))
      return(false);
   if(!SymbolInfoDouble(m_name,SYMBOL_SWAP_SHORT,m_swap_short))
      return(false);
   if(!SymbolInfoInteger(m_name,SYMBOL_DIGITS,tmp))
      return(false);
   m_digits=(int)tmp;   
   if(!SymbolInfoInteger(m_name,SYMBOL_TRADE_EXEMODE,tmp))
      return(false);
   m_trade_execution=(ENUM_SYMBOL_TRADE_EXECUTION)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_TRADE_CALC_MODE,tmp))
      return(false);
   m_trade_calcmode=(int)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_TRADE_MODE,tmp))
      return(false);
   m_trade_mode=(ENUM_SYMBOL_TRADE_MODE)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_SWAP_MODE,tmp))
      return(false);
   m_swap_mode=(int)tmp;
   if(!SymbolInfoInteger(m_name,SYMBOL_SWAP_ROLLOVER3DAYS,tmp))
      return(false);
   m_swap3=(ENUM_DAY_OF_WEEK)tmp;   
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Refresh cached data                                              |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::RefreshRates(void)
  {
   return(SymbolInfoTick(m_name,m_tick));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SELECT"                           |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::Select(void) const
  {
   return((bool)SymbolInfoInteger(m_name,SYMBOL_SELECT));
  }
//+------------------------------------------------------------------+
//| Set the property value "SYMBOL_SELECT"                           |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::Select(const bool select)
  {
   return(SymbolSelect(m_name,select));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SPREAD"                           |
//+------------------------------------------------------------------+
int CSymbolInfoBase::Spread(void) const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_SPREAD));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_SPREAD_FLOAT"                     |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::SpreadFloat(void) const
  {
   return((bool)SymbolInfoInteger(m_name,SYMBOL_SPREAD_FLOAT));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_STOPS_LEVEL"                |
//+------------------------------------------------------------------+
int CSymbolInfoBase::StopsLevel(void) const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_TRADE_STOPS_LEVEL));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_FREEZE_LEVEL"               |
//+------------------------------------------------------------------+
int CSymbolInfoBase::FreezeLevel(void) const
  {
   return((int)SymbolInfoInteger(m_name,SYMBOL_TRADE_FREEZE_LEVEL));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_TRADE_EXEMODE" as string          |
//+------------------------------------------------------------------+
string CSymbolInfoBase::TradeExecutionDescription(void) const
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
//| Get the property value "SYMBOL_SWAP_ROLLOVER3DAYS" as string     |
//+------------------------------------------------------------------+
string CSymbolInfoBase::SwapRollover3daysDescription(void) const
  {
   string str;
//---
   switch(m_swap3)
     {
      case SUNDAY   : str="Sunday";    break;
      case MONDAY   : str="Monday";    break;
      case TUESDAY  : str="Tuesday";   break;
      case WEDNESDAY: str="Wednesday"; break;
      case THURSDAY : str="Thursday";  break;
      case FRIDAY   : str="Friday";    break;
      case SATURDAY : str="Saturday";  break;
      default       : str="Unknown";
     }
//--- result
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_START_TIME"                       |
//+------------------------------------------------------------------+
datetime CSymbolInfoBase::StartTime(void) const
  {
   return((datetime)SymbolInfoInteger(m_name,SYMBOL_START_TIME));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_EXPIRATION_TIME"                  |
//+------------------------------------------------------------------+
datetime CSymbolInfoBase::ExpirationTime(void) const
  {
   return((datetime)SymbolInfoInteger(m_name,SYMBOL_EXPIRATION_TIME));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_CURRENCY_BASE"                    |
//+------------------------------------------------------------------+
string CSymbolInfoBase::CurrencyBase(void) const
  {
   return(SymbolInfoString(m_name,SYMBOL_CURRENCY_BASE));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_CURRENCY_PROFIT"                  |
//+------------------------------------------------------------------+
string CSymbolInfoBase::CurrencyProfit(void) const
  {
   return(SymbolInfoString(m_name,SYMBOL_CURRENCY_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_CURRENCY_MARGIN"                  |
//+------------------------------------------------------------------+
string CSymbolInfoBase::CurrencyMargin(void) const
  {
   return(SymbolInfoString(m_name,SYMBOL_CURRENCY_MARGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_DESCRIPTION"                      |
//+------------------------------------------------------------------+
string CSymbolInfoBase::Description(void) const
  {
   return(SymbolInfoString(m_name,SYMBOL_DESCRIPTION));
  }
//+------------------------------------------------------------------+
//| Get the property value "SYMBOL_PATH"                             |
//+------------------------------------------------------------------+
string CSymbolInfoBase::Path(void) const
  {
   return(SymbolInfoString(m_name,SYMBOL_PATH));
  }
//+------------------------------------------------------------------+
//| Access functions SymbolInfoInteger(...)                          |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::InfoInteger(const ENUM_SYMBOL_INFO_INTEGER prop_id,long &var) const
  {
   return(SymbolInfoInteger(m_name,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions SymbolInfoDouble(...)                           |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::InfoDouble(const ENUM_SYMBOL_INFO_DOUBLE prop_id,double &var) const
  {
   return(SymbolInfoDouble(m_name,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions SymbolInfoString(...)                           |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::InfoString(const ENUM_SYMBOL_INFO_STRING prop_id,string &var) const
  {
   return(SymbolInfoString(m_name,prop_id,var));
  }
//+------------------------------------------------------------------+
//| Normalize price                                                  |
//+------------------------------------------------------------------+
double CSymbolInfoBase::NormalizePrice(const double price) const
  {
   if(m_tick_size!=0)
      return(NormalizeDouble(MathRound(price/m_tick_size)*m_tick_size,m_digits));
//---
   return(NormalizeDouble(price,m_digits));
  }
//+------------------------------------------------------------------+
//| Checks if symbol is selected in the MarketWatch                  |
//| and adds symbol to the MarketWatch, if necessary                 |
//+------------------------------------------------------------------+
bool CSymbolInfoBase::CheckMarketWatch(void)
  {
//--- check if symbol is selected in the MarketWatch
   if(!Select())
     {
      if(!Select(true))
        {
         printf(__FUNCTION__+": Error adding symbol %d",GetLastError());
         return(false);
        }
     }
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\symbol\SymbolInfo.mqh"
#else
#include "..\..\mql4\symbol\SymbolInfo.mqh"
#endif
//+------------------------------------------------------------------+