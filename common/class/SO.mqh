//+------------------------------------------------------------------+
//|                                                       SO.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_CMD.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SO
  {
public:
                     SO();
                    ~SO();
   static bool       IsOrderTypeLong(const ENUM_ORDER_TYPE type);
   static bool       IsOrderTypeShort(const ENUM_ORDER_TYPE type);
   static bool       IsOrderAgainstSignal(const ENUM_ORDER_TYPE type,const ENUM_CMD res,const bool exact=false);
   static bool       IsSignalTypeLong(const ENUM_CMD type);
   static bool       IsSignalTypeShort(const ENUM_CMD type);
   static int        SignalReverse(const int s);
   static ENUM_ORDER_TYPE SignalToOrderType(const int s);
  };
//+------------------------------------------------------------------+
SO::SO()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SO::~SO()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SO::IsOrderTypeLong(const ENUM_ORDER_TYPE type)
  {
   return(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_LIMIT || type==ORDER_TYPE_BUY_STOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SO::IsOrderTypeShort(const ENUM_ORDER_TYPE type)
  {
   return(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_LIMIT || type==ORDER_TYPE_SELL_STOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SO::IsOrderAgainstSignal(const ENUM_ORDER_TYPE type,const ENUM_CMD res,const bool exact=false)
  {
   if(exact)
     {
      switch(type)
        {
         case ORDER_TYPE_BUY:
           {
            if(res==CMD_BUY)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_SELL:
           {
            if(res==CMD_SELL)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_BUY_LIMIT:
           {
            if(res==CMD_BUYLIMIT)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_BUY_STOP:
           {
            if(res==CMD_BUYSTOP)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_SELL_LIMIT:
           {
            if(res==CMD_SELLLIMIT)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_SELL_STOP:
           {
            if(res==CMD_SELLSTOP)
               return(true);
            else
               return(false);
           }
         default:
           {
            Print(__FUNCTION__+": unknown order type");
           }
        }
     }
   return((IsSignalTypeShort((ENUM_CMD) res) && IsOrderTypeLong(type))
          || (IsSignalTypeLong((ENUM_CMD)res) && IsOrderTypeShort(type))
          || (res==CMD_VOID));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SO::IsSignalTypeLong(const ENUM_CMD type)
  {
   return(type==CMD_LONG || type==CMD_BUY || type==CMD_BUYLIMIT || type==CMD_BUYSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SO::IsSignalTypeShort(const ENUM_CMD type)
  {
   return(type==CMD_SHORT || type==CMD_SELL || type==CMD_SELLLIMIT || type==CMD_SELLSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SO::SignalReverse(const int s)
  {
   switch(s)
     {
      case CMD_VOID:
        {
         return(CMD_ALL);
        }
      case CMD_NEUTRAL:
        {
         return(CMD_NEUTRAL);
        }
      case CMD_BUY:
        {
         return(CMD_SELL);
        }
      case CMD_SELL:
        {
         return(CMD_BUY);
        }
      case CMD_BUYLIMIT:
        {
         return(CMD_SELLLIMIT);
        }
      case CMD_SELLLIMIT:
        {
         return(CMD_BUYLIMIT);
        }
      case CMD_BUYSTOP:
        {
         return(CMD_SELLSTOP);
        }
      case CMD_SELLSTOP:
        {
         return(CMD_BUYSTOP);
        }
      case CMD_LONG:
        {
         return(CMD_SHORT);
        }
      case CMD_SHORT:
        {
         return(CMD_LONG);
        }
      case CMD_LIMIT:
        {
         return(CMD_STOP);
        }
      case CMD_STOP:
        {
         return(CMD_LIMIT);
        }
      case CMD_MARKET:
        {
         return(CMD_PENDING);
        }
      case CMD_PENDING:
        {
         return(CMD_MARKET);
        }
      case CMD_ALL:
        {
         return(CMD_VOID);
        }
     }
   return(s);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE SO::SignalToOrderType(const int s)
  {
   ENUM_ORDER_TYPE ret=ORDER_TYPE_BUY;
   switch(s)
     {
      case CMD_BUY:
         ret=ORDER_TYPE_BUY;
         break;
      case CMD_SELL:
         ret=ORDER_TYPE_SELL;
         break;
      case CMD_BUYLIMIT:
         ret=ORDER_TYPE_BUY_LIMIT;
         break;
      case CMD_SELLLIMIT:
         ret=ORDER_TYPE_SELL_LIMIT;
         break;
      case CMD_BUYSTOP:
         ret=ORDER_TYPE_BUY_STOP;
         break;
      case CMD_SELLSTOP:
         ret=ORDER_TYPE_SELL_STOP;
         break;
     }
   return(ret);
  }
//+------------------------------------------------------------------+
