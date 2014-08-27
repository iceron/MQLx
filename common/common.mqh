//+------------------------------------------------------------------+
//|                                                       common.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
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
bool IsSignalTypeLong(ENUM_CMD type)
  {
   return(type==CMD_BUY || type==CMD_BUYLIMIT || type==CMD_BUYSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsSignalTypeShort(ENUM_CMD type)
  {
   return(type==CMD_SELL || type==CMD_SELLLIMIT || type==CMD_SELLSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool DeleteObject(CObject *object)
  {
   delete object;
   object=NULL;
   return(object==NULL);
  }
  
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
