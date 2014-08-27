//+------------------------------------------------------------------+
//|                                                    OrderStop.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Object.mqh>
#include <Trade\SymbolInfo.mqh>
#include "Trade.mqh"
#include "Stop.mqh"
#include <ChartObjects\ChartObjectsLines.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderStop : public CObject
  {
protected:
   //--- stop parameters
   string            m_name;
   ulong             m_main_ticket;
   ENUM_ORDER_TYPE   m_main_type;
   double            m_main_volume;
   double            m_main_volume_initial;
   double            m_main_price;
   double            m_volume;
   double            m_volume_fixed;
   double            m_volume_percent;
   string            m_stoploss_name;
   string            m_takeprofit_name;
   double            m_stoploss;
   double            m_takeprofit;
   double            m_stoploss_initial;
   double            m_takeprofit_initial;
   ulong             m_stoploss_ticket;
   ulong             m_takeprofit_ticket;
   bool              m_stoploss_closed;
   bool              m_takeprofit_closed;
   ENUM_STOP_TYPE    m_stop_type;
   bool              m_visible;
   bool              m_oco;
   //--- stop objects
   JStop            *m_stop;
   CChartObjectHLine *m_objentry;
   CChartObjectHLine *m_objsl;
   CChartObjectHLine *m_objtp;
public:
                     JOrderStop();
                    ~JOrderStop();
   virtual void      Init(ulong ticket,ENUM_ORDER_TYPE type,double price,double volume,JStop *stop);
   virtual void      Check(double &volume);
   virtual bool      Update();
   virtual bool      CheckTrailing();
   virtual bool      Deinit();
protected:
   virtual bool      ModifyOrderStop(double stoploss,double takeprofit);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStop::JOrderStop() : m_name(NULL),
                           m_main_ticket(0),
                           m_main_type(0),
                           m_main_volume(0.0),
                           m_main_volume_initial(0.0),
                           m_main_price(0.0),
                           m_volume(0.0),
                           m_volume_fixed(0.0),
                           m_volume_percent(0.0),
                           m_stop(NULL),
                           m_stoploss_name(NULL),
                           m_takeprofit_name(NULL),
                           m_stoploss(0.0),
                           m_takeprofit(0.0),
                           m_stoploss_initial(0.0),
                           m_takeprofit_initial(0.0),
                           m_stoploss_ticket(0),
                           m_takeprofit_ticket(0),
                           m_stoploss_closed(false),
                           m_takeprofit_closed(false),
                           m_stop_type(0),
                           m_visible(true),
                           m_oco(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStop::~JOrderStop()
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStop::Init(ulong ticket,ENUM_ORDER_TYPE type,double price,double volume,JStop *stop)
  {
   if(!stop.Activate()) return;
   m_main_ticket=ticket;
   m_main_type=type;
   m_main_price=price;
   m_main_volume_initial=volume;
   m_main_volume=m_main_volume_initial;
   string ticket_str=DoubleToString(m_main_ticket,0);
   m_stop=stop;
   m_name= stop.Name()+"."+ticket_str;
   m_stoploss_name=stop.Name()+stop.StopLossName()+ticket_str;
   m_takeprofit_name=stop.Name()+stop.TakeProfitName()+ticket_str;
   stop.Volume(m_volume_fixed,m_volume_percent);
   m_volume=MathMax(m_volume_fixed,m_volume_percent);
   m_oco=stop.OCO();
   m_stop.Refresh();
   m_stoploss_initial=stop.StopLossPrice(m_main_volume_initial,m_main_volume,m_volume,m_main_price,m_main_type,m_stoploss_ticket);
   m_takeprofit_initial=stop.TakeProfitPrice(m_main_volume_initial,m_main_volume,m_volume,m_main_price,m_main_type,m_takeprofit_ticket);
   m_stoploss=m_stoploss_initial;
   m_takeprofit=m_takeprofit_initial;
   m_objentry=stop.CreateEntryObject(0,m_name,0,m_main_price);
   m_objsl=stop.CreateStopLossObject(0,m_stoploss_name,0,m_stoploss);
   m_objtp=stop.CreateTakeProfitObject(0,m_takeprofit_name,0,m_takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::Deinit()
  {
   if(m_stop!=NULL) delete m_stop;
   if(m_objentry!=NULL) delete m_objentry;
   if(m_objsl!=NULL) delete m_objsl;
   if(m_objtp!=NULL) delete m_objtp;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrderStop::Check(double &volume)
  {
   if(m_stop==NULL) return;
   if((m_stoploss_closed && m_takeprofit_closed) || volume<=0)
     {
      if(m_objentry!=NULL)
         delete m_objentry;
      if(m_objsl!=NULL)
         delete m_objsl;
      if(m_objtp!=NULL)
         delete m_objtp;
      return;
     }
   if(CheckPointer(m_objsl) && !m_stoploss_closed)
     {
      if(m_stop.Pending())
         if(m_stop.CheckStopOrder(volume,m_stoploss_ticket)) m_stoploss_closed=true;
      else if(m_stop.CheckStopLoss(m_main_volume_initial,volume,m_volume,m_main_type,m_stoploss))
         m_stoploss_closed=true;
     }
   if(CheckPointer(m_objtp) && !m_takeprofit_closed)
     {
      if(m_stop.Pending())
         if(m_stop.CheckStopOrder(volume,m_takeprofit_ticket)) m_takeprofit_closed=true;
      else if(m_stop.CheckTakeProfit(m_main_volume_initial,volume,m_volume,m_main_type,m_takeprofit))
         m_takeprofit_closed=true;
     }
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      if(m_oco)
        {
         if(m_stoploss_closed && !m_takeprofit_closed)
           {
            if(m_stop.Pending())
              {
               if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
                  m_takeprofit_closed=true;
              }
            else m_takeprofit_closed=true;
           }

         if(m_takeprofit_closed && !m_stoploss_closed)
           {
            if(m_stop.Pending())
              {
               if(m_stop.DeleteStopOrder(m_stoploss_ticket))
                  m_stoploss_closed=true;
              }
            else m_stoploss_closed=true;
           }
        }
      else
        {
         if(m_stoploss_closed && m_objsl!=NULL) delete m_objsl;
         if(m_takeprofit_closed && m_objtp!=NULL) delete m_objtp;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::CheckTrailing()
  {
   if(m_stop==NULL) return(false);
   if(m_stoploss_closed && m_takeprofit_closed) return(false);
   double stoploss=0,takeprofit=0;
   if(!m_stoploss_closed) stoploss=m_stop.CheckTrailing(m_main_type,m_main_price,m_stoploss,m_takeprofit);
   if(!m_takeprofit_closed)takeprofit=m_stop.CheckTrailing(m_main_type,m_main_price,m_stoploss,m_takeprofit);
   return(ModifyOrderStop(stoploss,takeprofit));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::ModifyOrderStop(double stoploss,double takeprofit)
  {
   bool modify=false;
   bool stoploss_modified=false,takeprofit_modified=false;
   if(stoploss>0 && ((m_main_type==ORDER_TYPE_BUY && stoploss>m_stoploss) || (m_main_type==ORDER_TYPE_SELL && stoploss<m_stoploss)))
     {
      if(m_stop.Pending())
        {
         modify=m_stop.OrderModify(m_stoploss_ticket,stoploss);
        }
      else modify=true;
      if(modify)
        {
         if(CheckPointer(m_objsl))
           {
            if(m_objsl.Price(0,stoploss))
              {
               m_stoploss=stoploss;
               stoploss_modified=true;
              }
           }
        }
     }
   if(takeprofit>0 && ((m_main_type==ORDER_TYPE_BUY && takeprofit<m_takeprofit) || (m_main_type==ORDER_TYPE_SELL && takeprofit>m_takeprofit)))
     {
      if(m_stop.Pending())
        {
         modify=m_stop.OrderModify(m_takeprofit_ticket,stoploss);
        }
      else modify=true;
      if(modify)
        {
         if(CheckPointer(m_objtp))
           {
            if(m_objtp.Price(0,takeprofit))
              {
               m_takeprofit=takeprofit;
               takeprofit_modified=true;
              }
           }
        }
     }
   return(takeprofit_modified || stoploss_modified);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::Update()
  {
   if(m_stop==NULL) return(true);
   double stoploss=0.0,takeprofit=0.0;
   if(CheckPointer(m_objtp))
     {
      double tp_line=m_objtp.Price(0);
      if(tp_line!=m_takeprofit)
         takeprofit=tp_line;
     }
   if(CheckPointer(m_objsl))
     {
      double sl_line=m_objsl.Price(0);
      if(sl_line!=m_stoploss)
         stoploss=sl_line;
     }
   return(ModifyOrderStop(stoploss,takeprofit));
  }
//+------------------------------------------------------------------+
