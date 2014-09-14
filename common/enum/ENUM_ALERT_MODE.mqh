//+------------------------------------------------------------------+
//|                                              ENUM_ALERT_MODE.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
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
