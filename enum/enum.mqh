//+------------------------------------------------------------------+
//|                                                         enum.mqh |
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
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_TRADE_MODE
  {
   TRADE_MODE_MARKET,
   TRADE_MODE_PENDING
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum MONEY_UPDATE_TYPE
  {
   MONEY_UPDATE_NONE,
   MONEY_UPDATE_PERIOD,
   MONEY_UPDATE_MARGIN,
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_STOP_TYPE
  {
   STOP_TYPE_MAIN,
   STOP_TYPE_VIRTUAL,
   STOP_TYPE_PENDING
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_VOLUME_TYPE
  {
   VOLUME_TYPE_FIXED,
   VOLUME_TYPE_PERCENT_REMAINING,
   VOLUME_TYPE_PERCENT_TOTAL,
   VOLUME_TYPE_REMAINING
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_TIME_FILTER_TYPE
  {
   TIME_FILTER_INCLUDE,
   TIME_FILTER_EXCLUDE
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_TRAIL_TYPE
  {
   TRAIL_TYPE_PIPS,
   TRAIL_TYPE_PRICE
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_TRAIL_TARGET
  {
   TRAIL_TARGET_STOPLOSS,
   TRAIL_TARGET_TAKEPROFIT
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_TRAIL_MODE
  {
   TRAIL_MODE_TRAILING,
   TRAIL_MODE_BREAKEVEN
  };
//+------------------------------------------------------------------+
