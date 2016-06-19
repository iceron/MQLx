//+------------------------------------------------------------------+
//|                                                    OrderStop.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStop : public COrderStopBase
  {
public:
                     COrderStop(void);
                    ~COrderStop(void);
   //virtual void      Check(double &);
/*
protected:
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
*/   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStop::COrderStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStop::~COrderStop(void)
  {
  }
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStop::Check(double &volume)
  {
   if(m_stop==NULL || !Active()) 
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stop.Pending() || m_stop.Broker())
        {
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
        }
      else
        {
         delete_sl=DeleteStopLoss();
         delete_tp=DeleteTakeProfit();
        }
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC && !m_stoploss_closed)
     {
      if(m_stop.Pending() || m_stop.Broker())
        {
         if(m_stop.CheckStopOrder(volume,m_stoploss_ticket))
            m_stoploss_closed=true;
        }
      else
        {
         if(m_stop.CheckStopLoss(m_order,GetPointer(this)))
           {
            m_stoploss_closed=true;
           }
        }
     }
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC && !m_takeprofit_closed)
     {
      if(m_stop.Pending() || m_stop.Broker())
        {
         if(m_stop.CheckStopOrder(volume,m_takeprofit_ticket))
            m_takeprofit_closed=true;
        }
      else
        {
         if(m_stop.CheckTakeProfit(m_order,GetPointer(this)))
            m_takeprofit_closed=true;
        }
     }
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      if(m_stop.OCO())
        {
         if(m_stoploss_closed && !m_takeprofit_closed)
           {
            if(m_stop.Pending() || m_stop.Broker())
              {
               if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
                  m_takeprofit_closed=true;
              }
            else m_takeprofit_closed=true;
           }

         if(m_takeprofit_closed && !m_stoploss_closed)
           {
            if(m_stop.Pending() || m_stop.Broker())
              {
               if(m_stop.DeleteStopOrder(m_stoploss_ticket))
                  m_stoploss_closed=true;
              }
            else m_stoploss_closed=true;
           }
        }
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if(((m_stoploss_closed || m_objsl==NULL) && (m_takeprofit_closed || m_objtp==NULL)) || volume<=0)
     {
      DeleteStopLines();
      if(m_stop.Main())
      {
         m_order.IsSuspended(true);
         //m_order.CloseStops();
      }   
     }
  }
*/
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
/*
bool COrderStop::ModifyStopLoss(const double stoploss)
  {
   bool modify=false;
   if(m_stop.Pending() || m_stop.Main())
      modify=m_stop.OrderModify(m_stoploss_ticket,stoploss);
   else modify=true;
   if(modify)
      MoveStopLoss(stoploss);
   return modify;
  }
*/
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::ModifyTakeProfit(const double takeprofit)
  {
   bool modify=false;
   if(m_stop.Pending() || m_stop.Main())
      modify=m_stop.OrderModify(m_takeprofit_ticket,takeprofit);
   else modify=true;
   if(modify)
      MoveTakeProfit(takeprofit);
   return modify;
  }
  */
//+------------------------------------------------------------------+
