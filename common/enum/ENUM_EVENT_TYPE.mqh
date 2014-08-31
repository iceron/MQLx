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
