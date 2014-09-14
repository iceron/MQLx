//+------------------------------------------------------------------+
//|                                                    OrderStop.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrderStop : public JOrderStopBase
  {
public:
                     JOrderStop(void);
                    ~JOrderStop(void);
   virtual void      Check(double &volume);
protected:
   virtual bool      ModifyOrderStop(double stoploss,double takeprofit);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStop::JOrderStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrderStop::~JOrderStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrderStop::ModifyOrderStop(double stoploss,double takeprofit)
  {
   bool modify=false;
   bool stoploss_modified=false,takeprofit_modified=false;
   if(stoploss>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && stoploss>m_stoploss) || (m_order.OrderType()==ORDER_TYPE_SELL && stoploss<m_stoploss)))
     {
      if(m_stop.Pending() || m_stop.Main())
        {
         modify=m_stop.OrderModify(m_stoploss_ticket,stoploss);
        }
      else modify=true;
      if(modify)
        {
         if(CheckPointer(m_objsl))
           {
            if(m_objsl.Move(stoploss))
              {
               m_stoploss=stoploss;
               stoploss_modified=true;
              }
           }
        }
     }
   if(takeprofit>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && takeprofit<m_takeprofit) || (m_order.OrderType()==ORDER_TYPE_SELL && takeprofit>m_takeprofit)))
     {
      if(m_stop.Pending() || m_stop.Main())
        {
         modify=m_stop.OrderModify(m_takeprofit_ticket,stoploss);
        }
      else modify=true;
      if(modify)
        {
         if(CheckPointer(m_objtp))
           {
            if(m_objtp.Move(takeprofit))
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
void JOrderStop::Check(double &volume)
  {
   if(m_stop==NULL) return;
   if(m_order.IsClosed())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stop.Pending())
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
      if(m_stop.Pending())
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
      if(m_stop.Pending())
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
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if(((m_stoploss_closed || m_objsl==NULL) && (m_takeprofit_closed || m_objtp==NULL)) || volume<=0)
     {
      DeleteStopLines();
      if(m_stop.Main())
         m_order.IsClosed(true);
     }
  }
//+------------------------------------------------------------------+
