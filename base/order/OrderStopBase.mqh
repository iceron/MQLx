//+------------------------------------------------------------------+
//|                                                OrderStopBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_VOLUME_TYPE.mqh"
#include <Arrays\ArrayDouble.mqh>
#include "..\File\ExpertFileBase.mqh"
#include "..\Trade\ExpertTradeBase.mqh"
#include "..\Stop\StopBase.mqh"
#include "..\Stop\StopLineBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
#include "..\File\ExpertFileBase.mqh"
class COrderStops;
class COrder;
class CStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBase : public CObject
  {
protected:
   bool              m_active;
   //--- stop parameters
   double            m_volume;
   CArrayDouble      m_stoploss;
   CArrayDouble      m_takeprofit;
   ulong             m_stoploss_ticket;
   ulong             m_takeprofit_ticket;
   bool              m_stoploss_closed;
   bool              m_takeprofit_closed;
   bool              m_closed;
   ENUM_STOP_TYPE    m_stop_type;
   string            m_stop_name;
   //--- main order object
   COrder           *m_order;
   //--- stop objects
   CStop            *m_stop;
   CStopLine        *m_objentry;
   CStopLine        *m_objsl;
   CStopLine        *m_objtp;
   COrderStops      *m_order_stops;
public:
                     COrderStopBase(void);
                    ~COrderStopBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOP;}
   //--- initialization
   virtual void      Init(COrder*,CStop*,COrderStops*);
   virtual COrderStops *GetContainer(void);
   virtual void      SetContainer(COrderStops*);
   virtual void      Show(bool);
   //--- getters and setters  
   bool              Active(void) const;
   void              Active(bool active);
   string            EntryName(void) const;
   ulong             MainMagic(void) const;
   ulong             MainTicket(void) const;
   double            MainTicketPrice(void) const;
   ENUM_ORDER_TYPE   MainTicketType(void) const;
   COrder           *Order(void);
   void              Order(COrder*);
   CStop            *Stop(void);
   void              Stop(CStop*);
   bool              StopLoss(const double);
   double            StopLoss(void) const;
   double            StopLoss(const int);
   void              StopLossClosed(const bool);
   bool              StopLossClosed(void);
   double            StopLossLast(void) const;
   string            StopLossName(void) const;
   void              StopLossTicket(const ulong);
   ulong             StopLossTicket(void) const;
   void              StopName(const string);
   string            StopName(void) const;
   bool              TakeProfit(const double);
   double            TakeProfit(void) const;
   double            TakeProfit(const int);
   void              TakeProfitClosed(const bool);
   bool              TakeProfitClosed(void);
   double            TakeProfitLast(void) const;
   string            TakeProfitName(void) const;
   void              TakeProfitTicket(const ulong);
   ulong             TakeProfitTicket(void) const;
   void              Volume(const double);
   double            Volume(void) const;
   //--- checking   
   virtual void      Check(double&)=0;
   virtual bool      Close(void);
   virtual bool      CheckTrailing(void);
   virtual bool      DeleteChartObject(const string);
   virtual bool      DeleteEntry(void);
   virtual bool      DeleteStopLines(void);
   virtual bool      DeleteStopLoss(void);
   virtual bool      DeleteTakeProfit(void);
   virtual bool      IsClosed(void);
   virtual bool      Update(void) {return true;}
   virtual void      UpdateVolume(double) {}
   //--- deinitialization 
   virtual void      Deinit(void);
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);
   virtual void      Recreate(void);
protected:
   virtual bool      IsStopLossValid(const double) const;
   virtual bool      IsTakeProfitValid(const double) const;
   virtual bool      Modify(const double,const double);
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double) {return true;}
   virtual bool      ModifyTakeProfit(const double){return true;}
   virtual bool      UpdateOrderStop(const double,const double){return true;}
   virtual bool      MoveStopLoss(const double);
   virtual bool      MoveTakeProfit(const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBase::COrderStopBase(void) : m_active(true),
                                       m_volume(0.0),
                                       m_stoploss_ticket(0),
                                       m_takeprofit_ticket(0),
                                       m_stoploss_closed(false),
                                       m_takeprofit_closed(false),
                                       m_closed(false),
                                       m_stop_type(0),
                                       m_stop_name("")
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBase::~COrderStopBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBase::SetContainer(COrderStops *orderstops)
  {
   m_order_stops=orderstops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStops *COrderStopBase::GetContainer(void)
  {
   return m_order_stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Active(bool active)
  {
   m_active=active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COrderStopBase::EntryName(void) const
  {
   return m_stop.Name()+"."+(string)m_order.Ticket();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrderStopBase::MainMagic(void) const
  {
   return m_order.Magic();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrderStopBase::MainTicket(void) const
  {
   return m_order.Ticket();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::MainTicketPrice(void) const
  {
   return m_order.Price();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE COrderStopBase::MainTicketType(void) const
  {
   return(ENUM_ORDER_TYPE)m_order.OrderType();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Order(COrder *order)
  {
   m_order=order;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder *COrderStopBase::Order(void)
  {
   return GetPointer(m_order);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Stop(CStop *stop)
  {
   m_stop=stop;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop *COrderStopBase::Stop(void)
  {
   return GetPointer(m_stop);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::StopLoss(const double stoploss)
  {
   return m_stoploss.Add(stoploss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::StopLoss(void) const
  {
   return m_stoploss.Total()>0?m_stoploss.At(m_stoploss.Total()-1):0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::StopLoss(const int index)
  {
   return m_stoploss.Total()>index?m_stoploss.At(index):0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::StopLossClosed(const bool value)
  {
   m_stoploss_closed=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::StopLossClosed(void)
  {
   return m_stoploss_closed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::StopLossLast(void) const
  {
   return m_stoploss.Total()>2?m_stoploss.At(m_stoploss.Total()-2):0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COrderStopBase::StopLossName(void) const
  {
   return m_stop.Name()+m_stop.StopLossName()+(string)m_order.Ticket();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::StopLossTicket(const ulong ticket)
  {
   m_stoploss_ticket=ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrderStopBase::StopLossTicket(void) const
  {
   return m_stoploss_ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::StopName(const string stop_name)
  {
   m_stop_name=stop_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COrderStopBase::StopName(void) const
  {
   return m_stop_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::TakeProfit(const double takeprofit)
  {
   return m_takeprofit.Add(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::TakeProfit(void) const
  {
   return m_takeprofit.Total()>0?m_takeprofit.At(m_takeprofit.Total()-1):0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::TakeProfit(const int index)
  {
   return m_takeprofit.Total()>index?m_takeprofit.At(index):0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::TakeProfitClosed(const bool value)
  {
   m_takeprofit_closed=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::TakeProfitClosed(void)
  {
   return m_takeprofit_closed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::TakeProfitLast(void) const
  {
   return m_takeprofit.Total()>2?m_takeprofit.At(m_takeprofit.Total()-2):0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string COrderStopBase::TakeProfitName(void) const
  {
   return m_stop.Name()+m_stop.TakeProfitName()+(string)m_order.Ticket();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::TakeProfitTicket(const ulong ticket)
  {
   m_takeprofit_ticket=ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ulong COrderStopBase::TakeProfitTicket(void) const
  {
   return m_takeprofit_ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Volume(const double volume)
  {
   m_volume=volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double COrderStopBase::Volume(void) const
  {
   return m_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Init(COrder *order,CStop *stop,COrderStops *order_stops)
  {
   if(!CheckPointer(stop) || !CheckPointer(order) || !stop.Active())
      return;
   SetContainer(order_stops);
   m_stop_name=stop.Name();
   m_order=order;
   m_stop=stop;
   m_volume=m_stop.Volume();
   m_stop.Refresh(order.Symbol());
   double stoploss=m_stop.StopLossPrice(order,GetPointer(this));
   double takeprofit=m_stop.TakeProfitPrice(order,GetPointer(this));
   m_stoploss.Add(stoploss);
   m_takeprofit.Add(takeprofit);
   if(MQLInfoInteger(MQL_OPTIMIZATION) || (MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE)))
     {
     }
   else
     {
      if(m_stop.StopLossVisible())
         m_objsl=m_stop.CreateStopLossObject(0,StopLossName(),0,stoploss);
      if(m_stop.TakeProfitVisible())
         m_objtp=m_stop.CreateTakeProfitObject(0,TakeProfitName(),0,takeprofit);
      if((CheckPointer(m_objsl) || CheckPointer(m_objtp)) && m_stop.EntryVisible())
         m_objentry=m_stop.CreateEntryObject(0,EntryName(),0,order.Price());
     }
   if(stop.Main())
      order.MainStop(GetPointer(this));
   m_stop_name=m_stop.Name();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Deinit(void)
  {
   if(CheckPointer(m_objentry))
      delete m_objentry;
   if(CheckPointer(m_objsl))
      delete m_objsl;
   if(CheckPointer(m_objtp))
      delete m_objtp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Recreate(void)
  {
   if(m_closed)
      return;
   if(m_stop.StopLossVisible() && !m_stoploss_closed)
      m_objsl=m_stop.CreateStopLossObject(0,StopLossName(),0,m_stoploss.At(m_stoploss.Total()-1));
   if(m_stop.TakeProfitVisible() && !m_takeprofit_closed)
      m_objtp=m_stop.CreateTakeProfitObject(0,TakeProfitName(),0,m_takeprofit.At(m_takeprofit.Total()-1));
   if(CheckPointer(m_objsl) || CheckPointer(m_objtp))
      m_objentry=m_stop.CreateEntryObject(0,EntryName(),0,m_order.Price());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::IsStopLossValid(const double stoploss) const
  {
   return (stoploss>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && (stoploss>StopLoss() || StopLoss()==0)) ||
           (m_order.OrderType()==ORDER_TYPE_SELL && (stoploss<StopLoss() || StopLoss()==0))));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::IsTakeProfitValid(const double takeprofit) const
  {
   return (takeprofit>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && takeprofit<TakeProfit()) ||
           (m_order.OrderType()==ORDER_TYPE_SELL && takeprofit>TakeProfit())));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::CheckTrailing(void)
  {
   if(!CheckPointer(m_stop) || m_order.IsClosed() || m_order.IsSuspended() || 
      (m_stoploss_closed && m_takeprofit_closed))
      return false;
   double stoploss=0,takeprofit=0;
   string symbol=m_order.Symbol();
   ENUM_ORDER_TYPE type=m_order.OrderType();
   double price=m_order.Price();
   double sl = StopLoss();
   double tp = TakeProfit();
   if(!m_stoploss_closed)
      stoploss=m_stop.CheckTrailing(symbol,type,price,sl,TRAIL_TARGET_STOPLOSS);
   if(!m_takeprofit_closed)
      takeprofit=m_stop.CheckTrailing(symbol,type,price,tp,TRAIL_TARGET_TAKEPROFIT);
   if(!IsStopLossValid(stoploss))
      stoploss=0;
   if(!IsTakeProfitValid(takeprofit))
      takeprofit=0;
   return Modify(stoploss,takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Close(void)
  {
   bool res1=false,res2=false,result=false;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      res1 = m_stop.DeleteStopOrder(m_stoploss_ticket);
      res2 = m_stop.DeleteStopOrder(m_takeprofit_ticket);
     }
   else
     {
      if(m_stoploss_closed || StopLoss()==0 || m_stoploss_ticket==0)
         res1=true;
      else if(m_stoploss_ticket>0 && !m_stoploss_closed)
        {
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
            res1=DeleteStopLoss();
        }
      if(m_takeprofit_closed || TakeProfit()==0 || m_takeprofit_ticket==0)
         res2=true;
      else if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
        {
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
            res2=DeleteTakeProfit();
        }
     }
   if(res1 && res2)
      result=DeleteEntry() && DeleteStopLoss() && DeleteTakeProfit();
   if(result)
      m_closed=true;
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::IsClosed(void)
  {
   if(m_closed)
      return true;
   if(CheckPointer(m_objentry) && !m_objentry.ChartObjectExists())
      m_closed=true;
   if(m_stoploss_closed && m_takeprofit_closed)
      m_closed=true;
   if(m_closed)
      Close();
   return m_closed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteChartObject(string name)
  {
   return ObjectDelete(0,name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteStopLoss(void)
  {
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
     {
      m_objsl.Delete();
      delete m_objsl;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteTakeProfit(void)
  {
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
     {
      m_objtp.Delete();
      delete m_objtp;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteEntry(void)
  {
   if(CheckPointer(m_objentry)==POINTER_DYNAMIC)
     {
      m_objentry.Delete();
      delete m_objentry;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteStopLines(void)
  {
   if(DeleteStopLoss() && DeleteTakeProfit())
      return DeleteEntry();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::MoveStopLoss(const double stoploss)
  {
   if(CheckPointer(m_objsl))
      if(!m_objsl.Move(stoploss))
         return false;
   return StopLoss(stoploss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::MoveTakeProfit(const double takeprofit)
  {
   if(CheckPointer(m_objtp))
      if(!m_objtp.Move(takeprofit))
         return false;
   return TakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Modify(const double stoploss,const double takeprofit)
  {
   bool stoploss_modified=false,takeprofit_modified=false;
   if(stoploss>0 && takeprofit>0)
     {
      if(ModifyStops(stoploss,takeprofit))
        {
         stoploss_modified=true;
         takeprofit_modified=true;
        }
     }
   else if(stoploss>0 && takeprofit==0)
      stoploss_modified=ModifyStopLoss(stoploss);
   else if(takeprofit>0 && stoploss==0)
      takeprofit_modified=ModifyTakeProfit(takeprofit);
   return stoploss_modified || takeprofit_modified;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBase::Show(bool show=true)
  {
   int setting=show?OBJ_ALL_PERIODS:OBJ_NO_PERIODS;
   if(CheckPointer(m_objentry))
      m_objentry.Timeframes(setting);
   if(CheckPointer(m_objsl))
      m_objsl.Timeframes(setting);
   if(CheckPointer(m_objtp))
      m_objtp.Timeframes(setting);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::ModifyStops(const double stoploss,const double takeprofit)
  {
   return ModifyStopLoss(stoploss) && ModifyTakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Save(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return false;
   file.WriteBool(m_active);
   file.WriteDouble(m_volume);
   file.WriteObject(GetPointer(m_stoploss));
   file.WriteObject(GetPointer(m_takeprofit));
   file.WriteLong(m_stoploss_ticket);
   file.WriteLong(m_takeprofit_ticket);
   file.WriteBool(m_stoploss_closed);
   file.WriteBool(m_takeprofit_closed);
   file.WriteBool(m_closed);
   file.WriteEnum(m_stop_type);
   file.WriteString(m_stop_name);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Load(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return false;
   if(!file.ReadBool(m_active))
      return false;
   if(!file.ReadDouble(m_volume))
      return false;
   if(!file.ReadObject(GetPointer(m_stoploss)))
      return false;
   if(!file.ReadObject(GetPointer(m_takeprofit)))
      return false;
   if(!file.ReadLong(m_stoploss_ticket))
      return false;
   if(!file.ReadLong(m_takeprofit_ticket))
      return false;
   if(!file.ReadBool(m_stoploss_closed))
      return false;
   if(!file.ReadBool(m_takeprofit_closed))
      return false;
   if(!file.ReadBool(m_closed))
      return false;
   if(!file.ReadEnum(m_stop_type))
      return false;
   if(!file.ReadString(m_stop_name))
      return false;
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStop.mqh"
#else
#include "..\..\MQL4\Order\OrderStop.mqh"
#endif
//+------------------------------------------------------------------+
