//+------------------------------------------------------------------+
//|                                            EventStandardBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "EventBase.mqh"
#include "..\..\common\enum\ENUM_ALERT_MODE.mqh"
#include "..\..\common\enum\ENUM_EVENT_CLASS.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventStandardBase : public JEvent
  {
public:
                     JEventStandardBase(void);
                     JEventStandardBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
                    ~JEventStandardBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT_STANDARD);}
   virtual void      OnProgramInit(void);
   virtual void      OnProgramInitDone(void);
   virtual void      OnProgramDeinitDone(void);
   virtual void      OnClassCreate(void);
   virtual void      OnClassCreateDone(void);
   virtual void      OnClassDelete(void);
   virtual void      OnClassDeleteDone(void);
   virtual void      OnClassValidate(void);
   virtual void      OnClassValidateDone(void);
   virtual void      OnCandle(void);
   virtual void      OnTick(void);
   virtual void      OnOrderSend(void);
   virtual void      OnOrderSendDone(void);
   virtual void      OnOrderEntryModify(void);
   virtual void      OnOrderEntryModifyDone(void);
   virtual void      OnOrderSLModify(void);
   virtual void      OnOrderSLModifyDone(void);
   virtual void      OnOrderTPModify(void);
   virtual void      OnOrderTPModifyDone(void);
   virtual void      OnOrderMEModify(void);
   virtual void      OnOrderMEModifyDone(void);
   virtual void      OnOrderClose(void);
   virtual void      OnOrderCloseDone(void);
   virtual void      OnOrderStopsClose(void);
   virtual void      OnOrderStopsCloseDone(void);
   virtual void      OnOrderStopLossTrail(void);
   virtual void      OnOrderStopLossTrailDone(void);
   virtual void      OnOrderTakeProfitTrail(void);
   virtual void      OnOrderTakeProfitTrailDone(void);
   virtual void      OnTradeEnabled(void);
   virtual void      OnTradeDisabled(void);
   virtual void      OnTradeTimeStart(void);
   virtual void      OnTradeTimeEnd(void);
   virtual bool      Run(JEventRegistry *registry);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::JEventStandardBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::JEventStandardBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   Init(action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::~JEventStandardBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventStandardBase::Run(JEventRegistry *registry)
  {
   switch(Action())
     {
      case ACTION_PROGRAM_INIT:
        {
         OnProgramInit();
         break;
        }
      case ACTION_PROGRAM_DEINIT:
        {
         OnProgramInitDone();
         break;
        }
      case ACTION_CLASS_VALIDATE:
        {
         OnClassValidate();
         break;
        }
      case ACTION_CLASS_VALIDATE_DONE:
        {
         OnClassValidateDone();
         break;
        }
      case ACTION_CANDLE:
        {
         OnCandle();
         break;
        }
      case ACTION_TICK:
        {
         OnTick();
         break;
        }
      case ACTION_ORDER_SEND:
        {
         OnOrderSend();
         break;
        }
      case ACTION_ORDER_SEND_DONE:
        {
         OnOrderSendDone();
         break;
        }
      case ACTION_ORDER_ENTRY_MODIFY:
        {
         OnOrderEntryModify();
         break;
        }
      case ACTION_ORDER_ENTRY_MODIFY_DONE:
        {
         OnOrderEntryModifyDone();
         break;
        }
      case ACTION_ORDER_SL_MODIFY:
        {
         OnOrderSLModify();
         break;
        }
      case ACTION_ORDER_SL_MODIFY_DONE:
        {
         OnOrderSLModifyDone();
         break;
        }
      case ACTION_ORDER_TP_MODIFY:
        {
         OnOrderTPModify();
         break;
        }
      case ACTION_ORDER_TP_MODIFY_DONE:
        {
         OnOrderTPModifyDone();
         break;
        }
      case ACTION_ORDER_ME_MODIFY:
        {
         OnOrderMEModify();
         break;
        }
      case ACTION_ORDER_ME_MODIFY_DONE:
        {
         OnOrderMEModifyDone();
         break;
        }
      case ACTION_ORDER_CLOSE:
        {
         OnOrderClose();
         break;
        }
      case ACTION_ORDER_CLOSE_DONE:
        {
         OnOrderCloseDone();
         break;
        }
      case ACTION_ORDER_STOPS_CLOSE_DONE:
        {
         OnOrderStopsCloseDone();
         break;
        }
      case ACTION_ORDER_STOPLOSS_TRAIL:
        {
         OnOrderStopLossTrail();
         break;
        }
      case ACTION_ORDER_STOPLOSS_TRAIL_DONE:
        {
         OnOrderStopLossTrailDone();
         break;
        }
      case ACTION_ORDER_TAKEPROFIT_TRAIL:
        {
         OnOrderTakeProfitTrail();
         break;
        }
      case ACTION_ORDER_TAKEPROFIT_TRAIL_DONE:
        {
         OnOrderTakeProfitTrailDone();
         break;
        }
      case ACTION_TRADE_ENABLED:
        {
         OnTradeEnabled();
         break;
        }
      case ACTION_TRADE_DISABLED:
        {
         OnTradeDisabled();
         break;
        }
      case ACTION_TRADE_TIME_START:
        {
         OnTradeTimeStart();
         break;
        }
      case ACTION_TRADE_TIME_END:
        {
         OnTradeTimeEnd();
         break;
        }
     }
   Execute(registry);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnProgramInit(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnProgramInitDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnProgramDeinitDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassCreate(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassCreateDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassDelete(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassDeleteDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassValidate(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassValidateDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnCandle(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTick(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSend(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSendDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderEntryModify(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderEntryModifyDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSLModify(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSLModifyDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTPModify(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTPModifyDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderMEModify(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderMEModifyDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderClose(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderCloseDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderStopsClose(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderStopsCloseDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderStopLossTrail(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderStopLossTrailDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTakeProfitTrail(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTakeProfitTrailDone(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeEnabled(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeDisabled(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeTimeStart(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeTimeEnd(void)
  {
  }

//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventStandard.mqh"
#else
#include "..\..\mql4\event\EventStandard.mqh"
#endif
//+------------------------------------------------------------------+
