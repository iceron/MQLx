//+------------------------------------------------------------------+
//|                                          OrderStopBrokerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "OrderStopBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBrokerBase : public COrderStop
  {
public:
                     COrderStopBrokerBase(void);
                    ~COrderStopBrokerBase(void);
   virtual void      Check(double &);                 
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOP_BROKER;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBrokerBase::COrderStopBrokerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBrokerBase::~COrderStopBrokerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBrokerBase::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      delete_sl=DeleteStopLoss();
      delete_tp=DeleteTakeProfit();
      if(delete_sl && delete_tp)
         if (DeleteEntry())
            m_closed = true;
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStopBroker.mqh"
#else
#include "..\..\MQL4\Order\OrderStopBroker.mqh"
#endif
//+------------------------------------------------------------------+
