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
protected:
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
