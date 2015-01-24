//+------------------------------------------------------------------+
//|                                                OrderStopBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_VOLUME_TYPE.mqh"
#include <Object.mqh>
#include "..\event\EventBase.mqh"
#include "..\lib\SymbolInfo.mqh"
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
   double            m_stoploss;
   double            m_takeprofit;
   double            m_stoploss_initial;
   double            m_takeprofit_initial;
   ulong             m_stoploss_ticket;
   ulong             m_takeprofit_ticket;
   bool              m_stoploss_closed;
   bool              m_takeprofit_closed;
   ENUM_STOP_TYPE    m_stop_type;
   //--- main order object
   JOrder           *m_order;
   //--- stop objects
   JStop            *m_stop;
   JStopLine        *m_objentry;
   JStopLine        *m_objsl;
   JStopLine        *m_objtp;
   JOrderStops      *m_order_stops;
public:
                     JOrderStopBase(void);
                    ~JOrderStopBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_ORDERSTOP);}
   //--- initialization
   virtual void      Init(JOrder *order,JStop *stop);
   virtual void      SetContainer(JOrderStops *orderstops){m_order_stops=orderstops;}
   //--- getters and setters  
   virtual string    EntryName(void) const {return(m_stop.Name()+"."+(string)m_order.Ticket());}
   virtual ulong     MainMagic(void) const {return(m_order.Magic());}
   virtual ulong     MainTicket(void) const {return(m_order.Ticket());}
   virtual double    MainTicketPrice() const {return(m_order.Price());}
   virtual ENUM_ORDER_TYPE MainTicketType(void) const {return(m_order.OrderType());}
   virtual void      StopLoss(const double stoploss) {m_stoploss=stoploss;}
   virtual double    StopLoss(void) const {return(m_stoploss);}
   virtual string    StopLossName(void) const {return(m_stop.Name()+m_stop.StopLossName()+(string)m_order.Ticket());}
   virtual void      StopLossTicket(const ulong ticket) {m_stoploss_ticket=ticket;}
   virtual ulong     StopLossTicket(void) const {return(m_stoploss_ticket);}
   virtual void      TakeProfit(const double takeprofit) {m_takeprofit=takeprofit;}
   virtual double    TakeProfit(void) const {return(m_takeprofit);}
   virtual string    TakeProfitName(void) const {return(m_stop.Name()+m_stop.TakeProfitName()+(string)m_order.Ticket());}
   virtual void      TakeProfitTicket(const ulong ticket) {m_takeprofit_ticket=ticket;}
   virtual ulong     TakeProfitTicket(void) const {return(m_takeprofit_ticket);}
   virtual void      Volume(const double volume) {m_volume=volume;}
   virtual double    Volume(void) const {return(m_volume);}
   virtual void      VolumeFixed(const double volume) {m_volume_fixed=volume;}
   virtual double    VolumeFixed(void) const {return(m_volume_fixed);}
   virtual void      VolumePercent(const double volume) {m_volume_percent=volume;}
   virtual double    VolumePercent(void) const {return(m_volume_percent);}
   //--- checking   
   virtual void      Check(double &volume) {}
   virtual bool      Close(void);
   virtual bool      CheckTrailing(void);
   virtual bool      DeleteChartObject(const string name);
   virtual bool      DeleteEntry(void);
   virtual bool      DeleteStopLines(void);
   virtual bool      DeleteStopLoss(void);
   virtual bool      DeleteTakeProfit(void);
   virtual bool      IsClosed(void) const {return(CheckPointer(m_objentry)!=POINTER_DYNAMIC);}
   virtual bool      Update(void);
   //--- deinitialization 
   virtual bool      Deinit(void);
protected:
   virtual bool      ModifyOrderStop(const double stoploss,const double takeprofit) {return(true);}
   virtual bool      UpdateOrderStop(const double stoploss,const double takeprofit) {return(true);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStopBase::JOrderStopBase(void) : m_volume(0.0),
                                       m_volume_fixed(0.0),
                                       m_volume_percent(0.0),
                                       m_stoploss(0.0),
                                       m_takeprofit(0.0),
                                       m_stoploss_initial(0.0),
                                       m_takeprofit_initial(0.0),
                                       m_stoploss_ticket(0),
                                       m_takeprofit_ticket(0),
                                       m_stoploss_closed(false),
                                       m_takeprofit_closed(false),
                                       m_stop_type(0)
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
void JOrderStopBase::Init(JOrder *order,JStop *stop)
  {
   if(stop==NULL || order==NULL) return;
   if(!stop.Active()) return;
   m_order=order;
   m_stop=stop;
   m_stop.Volume(GetPointer(this),m_volume_fixed,m_volume_percent);
   m_volume=MathMax(m_volume_fixed,m_volume_percent);
   m_stop.Refresh();
   m_stoploss_initial=m_stop.StopLossPrice(order,GetPointer(this));
   m_takeprofit_initial=m_stop.TakeProfitPrice(order,GetPointer(this));
   m_stoploss=m_stoploss_initial;
   m_takeprofit=m_takeprofit_initial;
   if(m_stoploss_initial>0)
      m_objsl=m_stop.CreateStopLossObject(0,StopLossName(),0,m_stoploss);
   if(m_takeprofit_initial>0)
      m_objtp=m_stop.CreateTakeProfitObject(0,TakeProfitName(),0,m_takeprofit);
   if(m_takeprofit_initial>0 || m_stoploss_initial>0)
      m_objentry=m_stop.CreateEntryObject(0,EntryName(),0,order.Price());   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Deinit(void)
  {
   if(m_objentry!=NULL) delete m_objentry;
   if(m_objsl!=NULL) delete m_objsl;
   if(m_objtp!=NULL) delete m_objtp;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::CheckTrailing(void)
  {
   if(m_stop==NULL)
     {
      return(false);
     }
   if(m_order.IsClosed())
     {
      return(false);
     }
   if(m_stoploss_closed && m_takeprofit_closed)
     {
      return(false);
     }
   double stoploss=0,takeprofit=0;
   if(!m_stoploss_closed) stoploss=m_stop.CheckTrailing(m_order.OrderType(),m_order.Price(),m_stoploss,TRAIL_TARGET_STOPLOSS);
   if(!m_takeprofit_closed)takeprofit=m_stop.CheckTrailing(m_order.OrderType(),m_order.Price(),m_takeprofit,TRAIL_TARGET_TAKEPROFIT);
   return(ModifyOrderStop(stoploss,takeprofit));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Close(void)
  {
   bool res1=false,res2=false;
   if(m_stoploss_closed || m_stoploss==0 || m_stoploss_ticket==0)
     {
      res1=true;
     }
   else if(m_stoploss_ticket>0 && !m_stoploss_closed)
     {
      if(m_stop.DeleteStopOrder(m_stoploss_ticket))
         res1=DeleteStopLoss();
     }
   if(m_takeprofit_closed || m_takeprofit==0 || m_takeprofit_ticket==0)
     {
      res2=true;
     }
   else if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
     {
      if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
         res2=DeleteTakeProfit();
     }
   if(res1 && res2)
      return(DeleteEntry()&&DeleteStopLoss()&&DeleteTakeProfit());
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::Update(void)
  {
   if(m_stop==NULL) return(true);
   if(m_order.IsClosed()) return(false);
   double stoploss=0.0,takeprofit=0.0;
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
     {
      double tp_line=m_objtp.GetPrice();
      if(tp_line!=m_takeprofit)
         takeprofit=tp_line;
     }
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
     {
      double sl_line=m_objsl.GetPrice();
      if(sl_line!=m_stoploss)
         stoploss=sl_line;
     }
   return(UpdateOrderStop(stoploss,takeprofit));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::DeleteChartObject(string name)
  {
   return(ObjectDelete(0,name));
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
         return(false);
     }
   return(true);
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
         return(false);
     }
   return(true);
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
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStopBase::DeleteStopLines(void)
  {
   if(DeleteStopLoss() && DeleteTakeProfit())
      return(DeleteEntry());
   return(false);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\OrderStop.mqh"
#else
#include "..\..\mql4\order\OrderStop.mqh"
#endif
//+------------------------------------------------------------------+
