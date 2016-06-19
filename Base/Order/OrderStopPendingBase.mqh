//+------------------------------------------------------------------+
//|                                         OrderStopPendingBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "OrderStopBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopPendingBase : public COrderStop
  {
public:
                     COrderStopPendingBase(void);
                    ~COrderStopPendingBase(void);
   virtual void      Check(double &);
protected:
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   virtual bool      Update(void);
   virtual bool      UpdateOrderStop(const double,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPendingBase::COrderStopPendingBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPendingBase::~COrderStopPendingBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopPendingBase::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stoploss_ticket>0 && !m_stoploss_closed)
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
           {
            m_stoploss_closed=true;
            delete_sl=DeleteStopLoss();
           }
      if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
           {
            m_takeprofit_closed=true;
            delete_tp=DeleteTakeProfit();
           }
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(CheckPointer(m_objsl) && !m_stoploss_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_stoploss_ticket))
         m_stoploss_closed=true;
     }
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC && !m_takeprofit_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_takeprofit_ticket))
         m_takeprofit_closed=true;
     }
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      if(m_stop.OCO())
        {
         if(m_stoploss_closed && !m_takeprofit_closed)
           {
            if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
               m_takeprofit_closed=true;
           }

         if(m_takeprofit_closed && !m_stoploss_closed)
           {
            if(m_stop.DeleteStopOrder(m_stoploss_ticket))
               m_stoploss_closed=true;
           }
        }
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if(((m_stoploss_closed || !CheckPointer(m_objsl)) && (m_takeprofit_closed || !CheckPointer(m_objtp))) || volume<=0)
     {
      DeleteStopLines();
      if(m_stop.Main())
         m_order.IsSuspended(true);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::ModifyStops(const double stoploss,const double takeprofit)
  {
   return ModifyStopLoss(stoploss) && ModifyTakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::ModifyStopLoss(const double stoploss)
  {
   if(m_stop.OrderModify(m_stoploss_ticket,stoploss))
      return MoveStopLoss(stoploss);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::ModifyTakeProfit(const double takeprofit)
  {
   if(m_stop.OrderModify(m_takeprofit_ticket,takeprofit))
      return MoveTakeProfit(takeprofit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::Update(void)
  {
   if(!CheckPointer(m_stop))
      return true;
   if(m_order.IsClosed() || m_order.IsSuspended())
      return true;
   bool result=false;
   double sl_line = 0;
   double tp_line = 0;
   if(CheckPointer(m_objsl))
      sl_line=m_objsl.GetPrice();
   if(CheckPointer(m_objtp))
      tp_line=m_objtp.GetPrice();
   if((sl_line>0 && sl_line!=StopLoss()) || (tp_line>0 && tp_line!=TakeProfit()))
     {
      Sleep(m_stop.Delay());
      double stoploss=0,takeprofit=0;
      if(CheckPointer(m_objsl))
         stoploss=m_objsl.GetPrice();
      if(CheckPointer(m_objtp))
         takeprofit=m_objtp.GetPrice();
      result=UpdateOrderStop(stoploss,takeprofit);
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopPendingBase::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   bool modify_sl=false,modify_tp=false;
   if(stoploss>0)
      modify_sl=m_stop.OrderModify(m_stoploss_ticket,stoploss);
   if(takeprofit>0)
      modify_tp=m_stop.OrderModify(m_takeprofit_ticket,takeprofit);
   return modify_tp||modify_sl;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStopPending.mqh"
#else
#include "..\..\MQL4\Order\OrderStopPending.mqh"
#endif
//+------------------------------------------------------------------+
