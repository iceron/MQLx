//+------------------------------------------------------------------+
//|                                                       common.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsOrderTypeLong(ENUM_ORDER_TYPE type)
  {
   return(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_LIMIT || type==ORDER_TYPE_BUY_STOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsOrderTypeShort(ENUM_ORDER_TYPE type)
  {
   return(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_LIMIT || type==ORDER_TYPE_SELL_STOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsOrderAgainstSignal(ENUM_ORDER_TYPE type,ENUM_CMD res,bool exact=false)
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
bool IsSignalTypeLong(ENUM_CMD type)
  {
   return(type==CMD_LONG || type==CMD_BUY || type==CMD_BUYLIMIT || type==CMD_BUYSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsSignalTypeShort(ENUM_CMD type)
  {
   return(type==CMD_SHORT || type==CMD_SELL || type==CMD_SELLLIMIT || type==CMD_SELLSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SignalReverse(int s)
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
ENUM_ORDER_TYPE SignalToOrderType(int s)
  {
   ENUM_ORDER_TYPE ret=ORDER_TYPE_BUY;
   switch(s)
     {
      case CMD_BUY:
        {
         ret=ORDER_TYPE_BUY;
        }
      case CMD_SELL:
        {
         ret=ORDER_TYPE_SELL;
        }
      case CMD_BUYLIMIT:
        {
         ret=ORDER_TYPE_BUY_LIMIT;
        }
      case CMD_SELLLIMIT:
        {
         ret=ORDER_TYPE_SELL_LIMIT;
        }
      case CMD_BUYSTOP:
        {
         ret=ORDER_TYPE_BUY_STOP;
        }
      case CMD_SELLSTOP:
        {
         ret=ORDER_TYPE_SELL_STOP;
        }
     }
   return(ret);
  }
//+------------------------------------------------------------------+
