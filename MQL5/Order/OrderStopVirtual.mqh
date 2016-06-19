//+------------------------------------------------------------------+
//|                                             OrderStopVirtual.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopVirtual : public COrderStopVirtualBase
  {
public:
                     COrderStopVirtual(void);
                    ~COrderStopVirtual(void);
   virtual void      Check(double &);
protected:
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopVirtual::COrderStopVirtual(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopVirtual::~COrderStopVirtual(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStop::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=DeleteStopLoss();
      bool delete_tp=DeleteTakeProfit();
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(CheckPointer(m_objsl) && !m_stoploss_closed)
     {
      if(m_stop.CheckStopLoss(m_order,GetPointer(this)))
         m_stoploss_closed=true;
     }
   if(CheckPointer(m_objtp) && !m_takeprofit_closed)
     {
      if(m_stop.CheckTakeProfit(m_order,GetPointer(this)))
         m_takeprofit_closed=true;
     }
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
bool COrderStop::ModifyStops(const double stoploss,const double takeprofit)
  {
   return ModifyStopLoss(stoploss) && ModifyTakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::ModifyStopLoss(const double stoploss)
  {
   MoveStopLoss(stoploss);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::ModifyTakeProfit(const double takeprofit)
  {
   MoveTakeProfit(takeprofit);
   return true;
  }
//+------------------------------------------------------------------+
