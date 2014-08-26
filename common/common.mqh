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
   return(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_LIMIT || type==ORDER_TYPE_BUY_STOP);
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
bool IsSignalTypeLong(ENUM_CMD type)
  {
   return(type==CMD_BUY || type==CMD_BUYLIMIT || type==CMD_BUYSTOP);
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
//+------------------------------------------------------------------+
