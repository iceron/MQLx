//+------------------------------------------------------------------+
//|                                                OrderStopBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_VOLUME_TYPE.mqh"
#include <Arrays\ArrayDouble.mqh>
#include "..\event\EventBase.mqh"
//#include "..\lib\SymbolInfo.mqh"
#include "..\trade\TradeBase.mqh"
#include "..\stop\StopBase.mqh"
#include "..\stop\StopLineBase.mqh"
class JOrder;
class JOrderStops;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderStopBase : public CObject
  {
protected:
   //--- stop parameters
   double            m_volume;
   double            m_volume_fixed;
   double            m_volume_percent;
   CArrayDouble      m_stoploss;
   CArrayDouble      m_takeprofit;
   double            m_stoploss_initial;
   double            m_takeprofit_initial;
   ulong             m_stoploss_ticket;
   ulong             m_takeprofit_ticket;
   bool              m_stoploss_closed;
   bool              m_takeprofit_closed;
   ENUM_STOP_TYPE    m_stop_type;
   string            m_stop_name;
   //--- main order object
   JOrder           *m_order;
   //--- stop objects
   JStop            *m_stop;
   JStopLine        *m_objentry;
   JStopLine        *m_objsl;
   JStopLine        *m_objtp;
   JOrderStops      *m_order_stops;
   JEvents          *m_events;
public:
                     JOrderStopBase(void);
                    ~JOrderStopBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOP;}
   //--- initialization
   virtual void      Init(JOrder *order,JStop *stop,JOrderStops *order_stops,JEvents *events=NULL);
   virtual void      SetContainer(JOrderStops *orderstops){m_order_stops=orderstops;}
   //--- getters and setters  
   string            EntryName(void) const {return m_stop.Name()+"."+(string)m_order.Ticket();}
   bool              EventHandler(JEvents *events);
   ulong             MainMagic(void) const {return m_order.Magic();}
   ulong             MainTicket(void) const {return m_order.Ticket();}
   double            MainTicketPrice() const {return m_order.Price();}
   ENUM_ORDER_TYPE   MainTicketType(void) const {return m_order.OrderType();}
   JOrder            *Order() {return GetPointer(m_order);}
   void              StopLoss(const double stoploss) {m_stoploss.Add(stoploss);}
   double            StopLoss(void) const {return m_stoploss.Total()>0?m_stoploss.At(m_stoploss.Total()-1):0;}
   double            StopLoss(const int index) const {return m_stoploss.Total()>index?m_stoploss.At(index):0;}
   double            StopLossLast(void) const {return m_stoploss.Total()>2?m_stoploss.At(m_stoploss.Total()-2):0;}
   string            StopLossName(void) const {return m_stop.Name()+m_stop.StopLossName()+(string)m_order.Ticket();}
   void              StopLossTicket(const ulong ticket) {m_stoploss_ticket=ticket;}
   ulong             StopLossTicket(void) const {return m_stoploss_ticket;}
   void              TakeProfit(const double takeprofit) {m_takeprofit.Add(takeprofit);}
   double            TakeProfit(void) const {return m_takeprofit.Total()>0?m_takeprofit.At(m_takeprofit.Total()-1):0;}
   double            TakeProfit(const int index) const {return m_takeprofit.Total()>index?m_takeprofit.At(index):0;}
   double            TakeProfitLast(void) const {return m_takeprofit.Total()>2?m_takeprofit.At(m_takeprofit.Total()-2):0;}
   string            TakeProfitName(void) const {return m_stop.Name()+m_stop.TakeProfitName()+(string)m_order.Ticket();}
   void              TakeProfitTicket(const ulong ticket) {m_takeprofit_ticket=ticket;}
   ulong             TakeProfitTicket(void) const {return m_takeprofit_ticket;}
   void              Volume(const double volume) {m_volume=volume;}
   double            Volume(void) const {return m_volume;}
   void              VolumeFixed(const double volume) {m_volume_fixed=volume;}
   double            VolumeFixed(void) const {return m_volume_fixed;}
   void              VolumePercent(const double volume) {m_volume_percent=volume;}
   double            VolumePercent(void) const {return m_volume_percent;}
   //--- hiding and showing of stop lines
   virtual void      Show(bool show=true);
   //--- checking   
   virtual void      Check(double &volume) {}
   virtual void      CheckInit();
   virtual void      CheckDeinit();
   virtual bool      Close(void);
   virtual bool      CheckTrailing(void);
   virtual bool      DeleteChartObject(const string name);
   virtual bool      DeleteEntry(void);
   virtual bool      DeleteStopLines(void);
   virtual bool      DeleteStopLoss(void);
   virtual bool      DeleteTakeProfit(void);
   virtual bool      IsClosed(void) const {return CheckPointer(m_objentry)!=POINTER_DYNAMIC;}
   virtual bool      Update(void);
   //--- deinitialization 
   virtual bool      Deinit(void);
   //--- recovery
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
protected:
   virtual bool      IsStopLossValid(const double stoploss) const;
   virtual bool      IsTakeProfitValid(const double takeprofit) const;
   virtual bool      Modify(const double stoploss,const double takeprofit);
   virtual bool      ModifyStops(const double stoploss,const double takeprofit) {return true;}
   virtual bool      ModifyStopLoss(const double stoploss) {return true;}
   virtual bool      ModifyTakeProfit(const double takeprofit) {return true;}
   virtual bool      UpdateOrderStop(const double stoploss,const double takeprofit) {return true;}
   //--- events
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
   //--- objects
   virtual void      MoveStopLoss(const double stoploss);
   virtual void      MoveTakeProfit(const double takeprofit);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopBase::JOrderStopBase(void) : m_volume(0.0),
                                       m_volume_fixed(0.0),
                                       m_volume_percent(0.0),
                                       m_stoploss_ticket(0),
                                       m_takeprofit_ticket(0),
                                       m_stoploss_closed(false),
                                       m_takeprofit_closed(false),
                                       m_stop_type(0),
                                       m_stop_name("")
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopBase::~JOrderStopBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopBase::Init(JOrder *order,JStop *stop,JOrderStops *order_stops,JEvents *events=NULL)
  {
   if(stop==NULL || order==NULL) return;
   if(!stop.Active()) return;
   SetContainer(m_order_stops);
   m_stop_name=stop.Name();
   EventHandler(events);
   m_order=order;
   m_stop=stop;
   m_stop.Volume(GetPointer(this),m_volume_fixed,m_volume_percent);
   m_volume=MathMax(m_volume_fixed,m_volume_percent);
   m_stop.Refresh(order.Symbol());
   double stoploss=m_stop.StopLossPrice(order,GetPointer(this));
   double takeprofit=m_stop.TakeProfitPrice(order,GetPointer(this));
   m_objsl=m_stop.CreateStopLossObject(0,StopLossName(),0,stoploss);
   m_stoploss.Add(stoploss);
   m_objtp=m_stop.CreateTakeProfitObject(0,TakeProfitName(),0,takeprofit);
   m_takeprofit.Add(takeprofit);
   m_objentry=m_stop.CreateEntryObject(0,EntryName(),0,order.Price());
   if(stop.Main())
      order.MainStop(GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Deinit(void)
  {
   ADT::Delete(m_objentry);
   ADT::Delete(m_objsl);
   ADT::Delete(m_objtp);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::IsStopLossValid(const double stoploss) const
  {
   return (stoploss>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && stoploss>StopLoss()) || (m_order.OrderType()==ORDER_TYPE_SELL && stoploss<StopLoss())));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::IsTakeProfitValid(const double takeprofit) const
  {
   return (takeprofit>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && takeprofit<TakeProfit()) || (m_order.OrderType()==ORDER_TYPE_SELL && takeprofit>TakeProfit())));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::CheckTrailing(void)
  {
   if(m_stop==NULL || m_order.IsClosed() || (m_stoploss_closed && m_takeprofit_closed))
      return false;
   bool result=false;
   int action=-1;
   double stoploss=0,takeprofit=0;
   if(!m_stoploss_closed) stoploss=m_stop.CheckTrailing(m_order.Symbol(),m_order.OrderType(),m_order.Price(),StopLoss(),TRAIL_TARGET_STOPLOSS);
   if(!m_takeprofit_closed)takeprofit=m_stop.CheckTrailing(m_order.Symbol(),m_order.OrderType(),m_order.Price(),TakeProfit(),TRAIL_TARGET_TAKEPROFIT);
   if(!IsStopLossValid(stoploss))
      stoploss=0;
   if(!IsTakeProfitValid(takeprofit))
      takeprofit=0;
   if(stoploss>0 && takeprofit>0)
      action=ACTION_ORDER_TRAIL;
   else if(stoploss>0 && takeprofit==0)
      action=ACTION_ORDER_TRAIL_SL;
   else if(takeprofit>0 && stoploss==0)
      action=ACTION_ORDER_TRAIL_TP;
   if(action!=-1)
     {
      CreateEvent(EVENT_CLASS_STANDARD,(ENUM_ACTION)action,GetPointer(this));
      result=Modify(stoploss,takeprofit);
      if(result)
        {
         switch(action)
           {
            case ACTION_ORDER_TRAIL:
               CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_TRAIL_DONE,GetPointer(this));
               break;
            case ACTION_ORDER_TRAIL_SL:
               CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_TRAIL_SL_DONE,GetPointer(this));
               break;
            case ACTION_ORDER_TRAIL_TP:
               CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_TRAIL_TP_DONE,GetPointer(this));
               break;
           }
        }
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Close(void)
  {
   Print(__FUNCTION__);
   CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_CLOSE,GetPointer(this));
   bool res1=false,res2=false,result=false;
   Print(m_stoploss_closed+" "+StopLoss()+" "+m_stoploss_ticket);
   if(m_stoploss_closed || StopLoss()==0 || m_stoploss_ticket==0)
      res1=true;
   else if(m_stoploss_ticket>0 && !m_stoploss_closed)
     {
      Print(__FUNCTION__+" deleting sl");
      if(m_stop.DeleteStopOrder(m_stoploss_ticket))
         res1=DeleteStopLoss();
     }
   Print(m_takeprofit_closed+" "+TakeProfit()+" "+m_takeprofit_ticket);
   if(m_takeprofit_closed || TakeProfit()==0 || m_takeprofit_ticket==0)
      res2=true;
   else if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
     {
      Print(__FUNCTION__+" deleting tp");
      if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
         res2=DeleteTakeProfit();
     }
   if(res1 && res2)
      result=DeleteEntry() && DeleteStopLoss() && DeleteTakeProfit();
   CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_CLOSE,GetPointer(this));
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Update(void)
  {
   if(m_stop==NULL) return true;
   if(m_order.IsClosed()) return false;
   double stoploss=0.0,takeprofit=0.0;
   bool result=false;
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
     {
      double tp_line=m_objtp.GetPrice();
      if(tp_line!=TakeProfit())
         takeprofit=tp_line;
     }
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
     {
      double sl_line=m_objsl.GetPrice();
      if(sl_line!=StopLoss())
         stoploss=sl_line;
     }
   result=UpdateOrderStop(stoploss,takeprofit);
   if(result)
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_UPDATE_DONE,GetPointer(this));
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopBase::CheckInit()
  {
   CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_CHECK,GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopBase::CheckDeinit()
  {
   CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_CHECK_DONE,GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::DeleteChartObject(string name)
  {
   return ObjectDelete(0,name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::DeleteStopLoss(void)
  {
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
     {
      string name=m_objsl.Name();
      delete m_objsl;
      if(ObjectFind(0,name)>=0)
         DeleteChartObject(name);
      if(ObjectFind(0,name)>=0)
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::DeleteTakeProfit(void)
  {
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
     {
      string name=m_objtp.Name();
      delete m_objtp;
      if(ObjectFind(0,name)>=0)
         DeleteChartObject(name);
      if(ObjectFind(0,name)>=0)
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::DeleteEntry(void)
  {
   if(CheckPointer(m_objentry)==POINTER_DYNAMIC)
     {
      string name=m_objentry.Name();
      delete m_objentry;
      if(ObjectFind(0,name)>=0)
         DeleteChartObject(name);
      if(ObjectFind(0,name)>=0)
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::DeleteStopLines(void)
  {
   if(DeleteStopLoss() && DeleteTakeProfit())
      return DeleteEntry();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::EventHandler(JEvents *events)
  {
   if(events!=NULL)
      m_events=events;
   return m_events!=NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopBase::MoveStopLoss(const double stoploss)
  {
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
      if(m_objsl.Move(stoploss))
         StopLoss(stoploss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStopBase::MoveTakeProfit(const double takeprofit)
  {
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
      if(m_objtp.Move(takeprofit))
         TakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Modify(const double stoploss,const double takeprofit)
  {
   bool stoploss_modified=false,takeprofit_modified=false;
   double oldsl=StopLoss(),oldtp=TakeProfit();
   if(stoploss>0 && takeprofit>0)
     {
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_MODIFY,GetPointer(this));
      if(ModifyStops(stoploss,takeprofit))
        {
         stoploss_modified=true;
         takeprofit_modified=true;
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_MODIFY_DONE,GetPointer(this));
        }
      else CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_MODIFY,GetPointer(this));
     }
   else if(stoploss>0 && takeprofit==0)
     {
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SL_MODIFY,GetPointer(this));
      stoploss_modified=ModifyStopLoss(stoploss);
      if(stoploss_modified)
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SL_MODIFY_DONE,GetPointer(this));
      else CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_SL_MODIFY,GetPointer(this));
     }
   else if(takeprofit>0 && stoploss==0)
     {
      CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_TP_MODIFY,GetPointer(this));
      takeprofit_modified=ModifyTakeProfit(takeprofit);
      if(takeprofit_modified)
         CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_TP_MODIFY_DONE,GetPointer(this));
      else CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_TP_MODIFY,GetPointer(this));
     }
   return stoploss_modified || takeprofit_modified;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopBase::Show(bool show=true)
  {
   int setting=show?OBJ_ALL_PERIODS:OBJ_NO_PERIODS;
   if(CheckPointer(m_objentry)) m_objentry.Timeframes(setting);
   if(CheckPointer(m_objsl))     m_objsl.Timeframes(setting);
   if(CheckPointer(m_objtp))     m_objtp.Timeframes(setting);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Save(const int handle)
  {
   ADT::WriteDouble(handle,m_volume);
   ADT::WriteDouble(handle,m_volume_fixed);
   ADT::WriteDouble(handle,m_volume_percent);
   ADT::WriteObject(handle,GetPointer(m_stoploss));
   ADT::WriteObject(handle,GetPointer(m_takeprofit));
   ADT::WriteLong(handle,m_stoploss_ticket);
   ADT::WriteLong(handle,m_takeprofit_ticket);
   ADT::WriteBool(handle,m_stoploss_closed);
   ADT::WriteBool(handle,m_takeprofit_closed);
   ADT::WriteInteger(handle,m_stop_type);
   ADT::WriteString(handle,m_stop_name);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Load(const int handle)
  {
   int temp;
   ADT::ReadDouble(handle,m_volume);
   ADT::ReadDouble(handle,m_volume_fixed);
   ADT::ReadDouble(handle,m_volume_percent);
   ADT::ReadObject(handle,GetPointer(m_stoploss));
   ADT::ReadObject(handle,GetPointer(m_takeprofit));
   ADT::ReadLong(handle,m_stoploss_ticket);
   ADT::ReadLong(handle,m_takeprofit_ticket);
   ADT::ReadBool(handle,m_stoploss_closed);
   ADT::ReadBool(handle,m_takeprofit_closed);
   ADT::ReadInteger(handle,temp);
   m_stop_type=(ENUM_STOP_TYPE) temp;
   ADT::ReadString(handle,m_stop_name);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\OrderStop.mqh"
#else
#include "..\..\mql4\order\OrderStop.mqh"
#endif
//+------------------------------------------------------------------+
