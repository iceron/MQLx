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
   virtual bool      NewOrderStop(COrder*,CStop*);
   virtual void      UpdateVolume(double);
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
COrderStop::UpdateVolume(double factor)
  {
   if(m_stop.VolumeType()!=VOLUME_TYPE_FIXED)
      return;
   ENUM_ORDER_TYPE type=m_order.OrderType();
   double volume_min=0,new_lotsize=0;

   if(m_stop.Main())
      new_lotsize=m_order.Volume();
   else
     {
      volume_min=SymbolInfoDouble(m_order.Symbol(),SYMBOL_VOLUME_MIN);
      new_lotsize=NormalizeDouble(Volume()*factor,(int)-MathLog10(volume_min));
      if(new_lotsize<volume_min)
         new_lotsize=volume_min;
     }
   Volume(new_lotsize);
   if(new_lotsize<=0)
      return;
   if(m_stop_type==STOP_TYPE_VIRTUAL)
      return;
   if(COrder::IsOrderTypeLong(type))
     {
      if(m_stoploss_ticket>0 && m_stop.DeleteStopOrder(m_stoploss_ticket) && !m_stoploss_closed)
        {
         ulong ticket=m_stop.Sell(new_lotsize,StopLoss());
         if(ticket>0)
            StopLossTicket(ticket);
         else
           {
            Print(__FUNCTION__+": error updating stoploss for #"+(string)m_order.Ticket());
            StopLossClosed(true);
            DeleteStopLoss();
           }
        }
      if(m_takeprofit_ticket>0 && m_stop.DeleteStopOrder(m_takeprofit_ticket) && !m_takeprofit_closed)
        {
         ulong ticket=m_stop.Sell(new_lotsize,TakeProfit());
         if(ticket>0)
            TakeProfitTicket(ticket);
         else
           {
            Print(__FUNCTION__+": error updating takeprofit for #"+(string)m_order.Ticket());
            TakeProfitTicket(true);
            DeleteTakeProfit();
           }
        }
     }
   else if(COrder::IsOrderTypeShort(type))
     {
      if(m_stoploss_ticket>0 && m_stop.DeleteStopOrder(m_stoploss_ticket) && !m_stoploss_closed)
        {
         ulong ticket=m_stop.Buy(new_lotsize,StopLoss());
         if(ticket>0)
            StopLossTicket(ticket);
         else
           {
            Print(__FUNCTION__+": error updating stoploss for #"+(string)m_order.Ticket());
            StopLossClosed(true);
            DeleteStopLoss();
           }
        }
      if(m_takeprofit_ticket>0 && m_stop.DeleteStopOrder(m_takeprofit_ticket) && !m_takeprofit_closed)
        {
         ulong ticket=m_stop.Buy(new_lotsize,TakeProfit());
         if(ticket>0)
            TakeProfitTicket(ticket);
         else
           {
            Print(__FUNCTION__+": error updating takeprofit for #"+(string)m_order.Ticket());
            TakeProfitTicket(true);
            DeleteTakeProfit();
           }
        }
     }
  }
//+------------------------------------------------------------------+
