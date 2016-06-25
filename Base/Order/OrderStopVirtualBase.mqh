//+------------------------------------------------------------------+
//|                                         OrderStopVirtualBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "OrderStopBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopVirtualBase : public COrderStop
  {
public:
                     COrderStopVirtualBase(void);
                    ~COrderStopVirtualBase(void);
   virtual void      Check(double&);                    
   virtual bool      Update(void);
   virtual bool      UpdateOrderStop(const double,const double);
protected:
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopVirtualBase::COrderStopVirtualBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopVirtualBase::~COrderStopVirtualBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopVirtualBase::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_closed || m_order.IsClosed() || m_order.IsSuspended())
     {
      m_closed = true;
      bool delete_sl=DeleteStopLoss();
      bool delete_tp=DeleteTakeProfit();
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }   
   if(/*CheckPointer(m_objsl) && */!m_stoploss_closed)
      if(m_stop.CheckStopLoss(m_order,GetPointer(this)))
         m_stoploss_closed=true;   
   if(/*CheckPointer(m_objtp) && */!m_takeprofit_closed)
      if(m_stop.CheckTakeProfit(m_order,GetPointer(this)))
         m_takeprofit_closed=true;
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      if(m_stop.OCO())
        {
         if(m_stoploss_closed && !m_takeprofit_closed)
            m_takeprofit_closed=true;
         if(m_takeprofit_closed && !m_stoploss_closed)
            m_stoploss_closed=true;
        }
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if(((m_stoploss_closed/* || !CheckPointer(m_objsl)*/) && (m_takeprofit_closed/* || !CheckPointer(m_objtp)*/)) || volume<=0)
     {
      m_closed = true;
      DeleteStopLines();
      if(m_stop.Main())
         m_order.IsSuspended(true);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopVirtualBase::ModifyStopLoss(const double stoploss)
  {
   return MoveStopLoss(stoploss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopVirtualBase::ModifyTakeProfit(const double takeprofit)
  {
   return MoveTakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopVirtualBase::Update(void)
  {
   if (!CheckPointer(m_stop))
      return true;
   if(m_order.IsClosed() || m_order.IsSuspended())
      return false;
   double stoploss=0.0,takeprofit=0.0;
   if (CheckPointer(m_objsl))
     {
      double sl_line=m_objsl.GetPrice();
      if(sl_line!=StopLoss())
         stoploss = sl_line;
     }
   if (CheckPointer(m_objtp))
     {
      double tp_line=m_objtp.GetPrice();
      if(tp_line!=TakeProfit())
         takeprofit = tp_line;         
     }   
   if (stoploss>0 || takeprofit>0)
      return UpdateOrderStop(stoploss,takeprofit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopVirtualBase::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   if(stoploss>0)
      if (!StopLoss(stoploss))
         return false;
   if(takeprofit>0)
      if (!TakeProfit(takeprofit))
         return false;
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStopVirtual.mqh"
#else
#include "..\..\MQL4\Order\OrderStopVirtual.mqh"
#endif
//+------------------------------------------------------------------+
