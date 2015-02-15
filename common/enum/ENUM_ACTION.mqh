//+------------------------------------------------------------------+
//|                                                  ENUM_ACTION.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_ACTION
  {
   ACTION_PROGRAM_INIT,
   ACTION_PROGRAM_INIT_DONE,
   ACTION_PROGRAM_DEINIT,
   ACTION_PROGRAM_DEINIT_DONE,
   ACTION_CLASS_CREATE,   
   ACTION_CLASS_CREATE_DONE,
   ACTION_CLASS_DELETE,
   ACTION_CLASS_DELETE_DONE,
   ACTION_CLASS_VALIDATE,
   ACTION_CLASS_VALIDATE_DONE,
   ACTION_CANDLE,
   ACTION_TICK,
   ACTION_ORDER_SEND,
   ACTION_ORDER_SEND_DONE,
   ACTION_ORDER_ENTRY_MODIFY,
   ACTION_ORDER_ENTRY_MODIFY_DONE,
   ACTION_ORDER_SL_MODIFY,
   ACTION_ORDER_SL_MODIFY_DONE,
   ACTION_ORDER_TP_MODIFY,
   ACTION_ORDER_TP_MODIFY_DONE,
   ACTION_ORDER_ME_MODIFY,
   ACTION_ORDER_ME_MODIFY_DONE,
   ACTION_ORDER_CLOSE,
   ACTION_ORDER_CLOSE_DONE,
   ACTION_ORDER_STOPS_CLOSE,
   ACTION_ORDER_STOPS_CLOSE_DONE,
   ACTION_ORDER_STOPLOSS_TRAIL,
   ACTION_ORDER_STOPLOSS_TRAIL_DONE,
   ACTION_ORDER_TAKEPROFIT_TRAIL,
   ACTION_ORDER_TAKEPROFIT_TRAIL_DONE,
   ACTION_TRADE_ENABLED,
   ACTION_TRADE_DISABLED,
   ACTION_TRADE_TIME_START,
   ACTION_TRADE_TIME_END,
  };
//+------------------------------------------------------------------+
