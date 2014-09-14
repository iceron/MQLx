//+------------------------------------------------------------------+
//|                                              ENUM_EVENT_TYPE.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_EVENT_TYPE
  {
   EVENT_TYPE_ORDER_SENT,
   EVENT_TYPE_ORDER_ENTRY,
   EVENT_TYPE_ORDER_MODIFY,
   EVENT_TYPE_ORDER_EXIT,
   EVENT_TYPE_ORDER_REVERSE,
   EVENT_TYPE_ERROR,
   EVENT_TYPE_CUSTOM
  };
//+------------------------------------------------------------------+
