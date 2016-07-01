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
   virtual bool      NewTicket(void);
   virtual void      NewTicket(const bool);
   virtual bool      RecreateStops(void);
   virtual void      UpdateTicket(const ulong);
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
bool COrderStop::RecreateStops(void)
  {
   if(m_order.IsClosed() || m_order.IsSuspended() || m_closed)
      return true;
   if(!m_takeprofit_closed && CheckPointer(m_objtp))
      m_objtp.Name(TakeProfitName());
   if(!m_stoploss_closed && CheckPointer(m_objsl))
      m_objsl.Name(StopLossName());
   if((!m_stoploss_closed || !m_takeprofit_closed) && CheckPointer(m_objentry))
      m_objentry.Name(EntryName());
   return true;
  }
//+------------------------------------------------------------------+
