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
                     JEventStandardBase(const ENUM_ACTION action,string message_add);
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
   virtual void      OnOrderModify(void);
   virtual void      OnOrderModifyDone(void);
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
   virtual void      OnOrderTrail(void);
   virtual void      OnOrderTrailDone(void);
   virtual void      OnOrderTrailSL(void);
   virtual void      OnOrderTrailSLDone(void);
   virtual void      OnOrderTrailTP(void);
   virtual void      OnOrderTrailTPDone(void);
   virtual void      OnTradeEnabled(void);
   virtual void      OnTradeDisabled(void);
   virtual void      OnTradeTimeStart(void);
   virtual void      OnTradeTimeEnd(void);
   virtual bool      Run(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL);
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
JEventStandardBase::JEventStandardBase(const ENUM_ACTION action,string message_add)
  {
   Init(action,message_add);
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
bool JEventStandardBase::Run(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL)
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
      case ACTION_ORDER_MODIFY:
        {
         OnOrderModify();
         break;
        }
      case ACTION_ORDER_MODIFY_DONE:
        {
         OnOrderModifyDone();
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
      case ACTION_ORDER_TRAIL:
        {
         OnOrderTrail();
         break;
        }
      case ACTION_ORDER_TRAIL_DONE:
        {
         OnOrderTrailDone();
         break;
        }
      case ACTION_ORDER_TRAIL_SL:
        {
         OnOrderTrailSL();
         break;
        }
      case ACTION_ORDER_TRAIL_SL_DONE:
        {
         OnOrderTrailSLDone();
         break;
        }
      case ACTION_ORDER_TRAIL_TP:
        {
         OnOrderTrailTP();
         break;
        }
      case ACTION_ORDER_TRAIL_TP_DONE:
        {
         OnOrderTrailTPDone();
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
   Execute(registry,sound_file,file_name,ftp_path);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnProgramInit(void)
  {
   m_subject="Program initializing";
   m_message="Program initializing";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnProgramInitDone(void)
  {
   m_subject="Program initialized";
   m_message="Program initialized";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnProgramDeinitDone(void)
  {
   m_subject="Program deinitialized";
   m_message="Program deinitialized";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassCreate(void)
  {
   m_subject="Creating class";
   m_message="Creating class";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassCreateDone(void)
  {
   m_subject="Class created";
   m_message="Class created";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassDelete(void)
  {
   m_subject="Deleting class";
   m_message="Deleting class";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassDeleteDone(void)
  {
   m_subject="Class deleted";
   m_message="Class deleted";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassValidate(void)
  {
   m_subject="Validating class";
   m_message="Validating class";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnClassValidateDone(void)
  {
   m_subject="Class validated";
   m_message="Class validated";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnCandle(void)
  {
   m_subject="New candle detected";
   m_message="New candle detected";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTick(void)
  {
   m_subject = "New tick detected";
   m_message = "New tick detected";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSend(void)
  {
   m_subject = "Sending order";
   m_message = "Sending order";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSendDone(void)
  {
   m_subject = "Order sent";
   m_message = "Order sent";
   JOrder *order = GetObject(CLASS_TYPE_ORDER);
   if (CheckPointer(order)==POINTER_DYNAMIC)
      m_message_add = "#"+DoubleToString(order.Ticket(),0)+" "+EnumToString(order.OrderType());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderEntryModify(void)
  {
   m_subject = "Modifying order entry";
   m_message = "Modifying order entry";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderEntryModifyDone(void)
  {
   m_subject = "Order entry modified";
   m_message = "Order entry modified";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSLModify(void)
  {
   m_subject = "Modifying order SL";
   m_message = "Modifying order SL";   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderSLModifyDone(void)
  {
   m_subject = "Order SL modified";
   m_message = "Order SL modified";
   JOrderStop *orderstop = GetObject(CLASS_TYPE_ORDERSTOP);   
   if (CheckPointer(orderstop)==POINTER_DYNAMIC)
      m_message_add = orderstop.StopLossName()+" "+(string)orderstop.StopLossLast()+"->"+(string)orderstop.StopLoss(); 
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTPModify(void)
  {
   m_subject = "Modifying order TP";
   m_message = "Modifying order TP";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTPModifyDone(void)
  {
   m_subject = "Order TP modified";
   m_message = "Order TP modified";
   JOrderStop *orderstop = GetObject(CLASS_TYPE_ORDERSTOP);   
   if (CheckPointer(orderstop)==POINTER_DYNAMIC)
      m_message_add = orderstop.TakeProfitName()+" "+(string)orderstop.TakeProfitLast()+"->"+(string)orderstop.TakeProfit(); 
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderMEModify(void)
  {
   m_subject = "Modifying order (order by market execution)";
   m_message = "Modifying order (order by market execution)";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderMEModifyDone(void)
  {
   m_subject = "Order modified (order by market execution)";
   m_message = "Order modified (order by market execution)";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderModify(void)
  {
   m_subject = "Modifying order";
   m_message = "Modifying order";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderModifyDone(void)
  {
   m_subject = "Order modified";
   m_message = "Order modified";
   JOrderStop *orderstop = GetObject(CLASS_TYPE_ORDERSTOP);   
   if (CheckPointer(orderstop)==POINTER_DYNAMIC)
   {      
      m_message_add = m_message_add = orderstop.StopLossName()+" "+(string)orderstop.StopLossLast()+"->"+(string)orderstop.StopLoss(); ;  
      m_message_add += " "+orderstop.TakeProfitName()+" "+(string)orderstop.TakeProfitLast()+"->"+(string)orderstop.TakeProfit();  
   }   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderClose(void)
  {
   m_subject = "Closing order";
   m_message = "Closing order";   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderCloseDone(void)
  {
   m_subject = "Order closed";
   m_message = "Order closed";
   JOrder *order = GetObject(CLASS_TYPE_ORDER);
   if (CheckPointer(order)==POINTER_DYNAMIC)
      m_message_add = "#"+DoubleToString(order.Ticket(),0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderStopsClose(void)
  {
   m_subject = "Closing order stop";
   m_message = "Closing order stop";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderStopsCloseDone(void)
  {
   m_subject = "Order stop closed";
   m_message = "Order stop closed";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTrail(void)
  {
   m_subject = "Trailing order";
   m_message = "Trailing order";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTrailDone(void)
  {
   m_subject = "Order trailed";
   m_message = "Order trailed";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTrailSL(void)
  {
   m_subject = "Trailing order SL";
   m_message = "Trailing order SL";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTrailSLDone(void)
  {
   m_subject = "Order SL trailed";
   m_message = "Order SL trailed";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTrailTP(void)
  {
   m_subject = "Trailing order TP";
   m_message = "Trailing order TP";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnOrderTrailTPDone(void)
  {
   m_subject = "Order TP trailed";
   m_message = "Order TP trailed";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeEnabled(void)
  {
   m_subject = "Trading is enabled";
   m_message = "Trading is enabled";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeDisabled(void)
  {
   m_subject = "Trading is disabled";
   m_message = "Trading is disabled";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeTimeStart(void)
  {
   m_subject = "Trading time start detected";
   m_message = "Trading time start detected";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventStandardBase::OnTradeTimeEnd(void)
  {
   m_subject = "Trading time end detected";
   m_message = "Trading time end detected";
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventStandard.mqh"
#else
#include "..\..\mql4\event\EventStandard.mqh"
#endif
//+------------------------------------------------------------------+
