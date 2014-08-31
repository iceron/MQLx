//+------------------------------------------------------------------+
//|                                                     ENUM_CMD.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
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
