//+------------------------------------------------------------------+
//|                                                     ENUM_CMD.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CMD
  {
   CMD_VOID=-1,
   CMD_NEUTRAL,
   CMD_BUY,
   CMD_SELL,
   CMD_BUYLIMIT,
   CMD_SELLLIMIT,
   CMD_BUYSTOP,
   CMD_SELLSTOP,
   CMD_LONG,
   CMD_SHORT,
   CMD_LIMIT,
   CMD_STOP,
   CMD_MARKET,
   CMD_PENDING,
   CMD_ALL
  };
//+------------------------------------------------------------------+
