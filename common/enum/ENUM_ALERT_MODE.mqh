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
enum ENUM_ALERT_MODE
  {
   ALERT_MODE_NONE,
   ALERT_MODE_PRINT=1,
   ALERT_MODE_EMAIL=2,
   ALERT_MODE_POPUP=4,
   ALERT_MODE_PUSH=8,
   ALERT_MODE_FTP=16
  };
//+------------------------------------------------------------------+
