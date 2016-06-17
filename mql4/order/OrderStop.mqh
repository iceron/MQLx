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
   virtual void      Check(double &);
   virtual bool      NewTicket(void);
   virtual void      NewTicket(const bool);
   virtual bool      Recreate(void);
   virtual void      UpdateTicket(const ulong);
protected:
   virtual bool      ModifyStops(const double,const double);
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   virtual bool      UpdateOrderStop(const double,const double);
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::NewTicket(void)
  {
   return m_order.NewTicket();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStop::NewTicket(const bool value)
  {
   m_order.NewTicket(value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStop::UpdateTicket(const ulong ticket)
  {
   m_order.Ticket(ticket);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::Recreate(void)
  {
   if(!m_order.IsClosed())
     {
      if(!m_takeprofit_closed)
         m_objtp.Name(TakeProfitName());
      if(!m_stoploss_closed)
         m_objsl.Name(StopLossName());
      if(!m_stoploss_closed || !m_takeprofit_closed)
         m_objentry.Name(EntryName());
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   bool modify_sl=false,modify_tp=false;
   if(stoploss>0)
     {
      if(m_stop.Pending())
         modify_sl=m_stop.OrderModify(m_stoploss_ticket,stoploss);
      else if(m_stop.Main() && !m_stop.Virtual())
         modify_sl=m_stop.MoveStopLoss(m_order.Ticket(),stoploss);
      else StopLoss(stoploss);
     }
   if(takeprofit>0)
     {
      if(m_stop.Pending())
         modify_tp=m_stop.OrderModify(m_takeprofit_ticket,stoploss);
      else if(m_stop.Main() && !m_stop.Virtual())
         modify_tp=m_stop.MoveTakeProfit(m_order.Ticket(),takeprofit);
      else TakeProfit(takeprofit);

     }
   return modify_tp||modify_sl;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStop::Check(double &volume)
  {
   if(m_stop==NULL) return;
   CheckInit();
   if(m_order.IsClosed())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stop.Pending() && !m_stop.Main())
        {
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
            delete_sl=DeleteStopLoss();
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
            delete_tp=DeleteTakeProfit();
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
   if(m_stop.Pending() && m_stop.Main())
     {
      if(OrderSelect((int)m_order.Ticket(),SELECT_BY_TICKET))
        {
         if(OrderCloseTime()>0)
           {
            m_stoploss_closed=true;
            m_takeprofit_closed=true;
           }
        }
     }
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
     {
      if(m_stop.Pending())
         m_stoploss_closed=m_stop.CheckStopOrder(volume,m_stoploss_ticket);
      else
         m_stoploss_closed=m_stop.CheckStopLoss(m_order,GetPointer(this));
     }
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
     {
      if(m_stop.Pending())
         m_takeprofit_closed=m_stop.CheckStopOrder(volume,m_takeprofit_ticket);
      else
         m_takeprofit_closed=m_stop.CheckTakeProfit(m_order,GetPointer(this));
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
      if(m_stop.Main() && m_stop.Virtual() && (StopLoss()>0 || TakeProfit()>0))
        {
         m_order.IsSuspended(true);
         //m_order.CloseStops();
        }
     }
   CheckDeinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::ModifyStopLoss(const double stoploss)
  {
   bool modify=false;
   if(m_stop.Pending())
      modify=m_stop.OrderModify(m_stoploss_ticket,stoploss);
   else if(m_stop.Main() && !m_stop.Virtual())
      modify=m_stop.MoveStopLoss(m_order.Ticket(),stoploss);
   else modify=true;
   if(modify)
      MoveStopLoss(stoploss);
   return modify;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::ModifyTakeProfit(const double takeprofit)
  {
   bool modify=false;
   if(m_stop.Pending())
      modify=m_stop.OrderModify(m_takeprofit_ticket,takeprofit);
   else if(m_stop.Main() && !m_stop.Virtual())
      modify=m_stop.MoveTakeProfit(m_order.Ticket(),takeprofit);
   else modify=true;
   if(modify)
      MoveTakeProfit(takeprofit);
   return modify;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStop::ModifyStops(const double stoploss,const double takeprofit)
  {
   bool modify=false;
   if(m_stop.Pending())
      return ModifyStopLoss(stoploss) && ModifyTakeProfit(takeprofit);
   if(m_stop.Main() && !m_stop.Virtual())
      modify=m_stop.Move(m_order.Ticket(),stoploss,takeprofit);
   else modify=true;
   if(modify)
     {
      MoveStopLoss(stoploss);
      MoveTakeProfit(takeprofit);
     }
   return modify;
  }
//+------------------------------------------------------------------+
