//+------------------------------------------------------------------+
//|                                              OrderStopBroker.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBroker : public COrderStopBrokerBase
  {
public:
                     COrderStopBroker(void);
                    ~COrderStopBroker(void);
   virtual void      Check(double&);
   virtual bool      Update(void);
protected:
   virtual bool      ModifyStopLoss(const double);
   virtual bool      ModifyTakeProfit(const double);
   virtual bool      UpdateOrderStop(const double,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBroker::COrderStopBroker(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBroker::~COrderStopBroker(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBroker::Check(double &volume)
  {
   if(!CheckPointer(m_stop) || !Active())
      return;
   if(m_order.IsClosed() || m_order.IsSuspended())
     {
      bool delete_sl=false,delete_tp=false;
      if(m_stoploss_ticket>0 && !m_stoploss_closed)
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
           {
            StopLossClosed(true);
            delete_sl=DeleteStopLoss();
           }
      if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
           {
            TakeProfitClosed(true);
            delete_tp=DeleteTakeProfit();
           }
      if(delete_sl && delete_tp)
         DeleteEntry();
      return;
     }
   if(!m_stoploss_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_stoploss_ticket))
        {
         StopLossClosed(true);
         if(CheckPointer(m_order_stops))
            m_order_stops.UpdateVolume(Volume());

        }
     }
   if(!m_takeprofit_closed)
     {
      if(m_stop.CheckStopOrder(volume,m_takeprofit_ticket))
        {
         TakeProfitClosed(true);
         if(CheckPointer(m_order_stops))
            m_order_stops.UpdateVolume(Volume());

        }
     }
   if(m_stoploss_closed || m_takeprofit_closed)
     {
      if(m_stoploss_closed && !m_takeprofit_closed)
        {
         if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
            TakeProfitClosed(true);
        }
      if(m_takeprofit_closed && !m_stoploss_closed)
        {
         if(m_stop.DeleteStopOrder(m_stoploss_ticket))
            StopLossClosed(true);
        }
      if(m_stoploss_closed)
         DeleteStopLoss();
      if(m_takeprofit_closed)
         DeleteTakeProfit();
     }
   if((m_stoploss_closed && m_takeprofit_closed) || volume<=0)
     {
      DeleteStopLines();
      if(m_stop.Main())
        {
         m_order.IsSuspended(true);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyStopLoss(const double stoploss)
  {
   if(m_stop.OrderModify(m_stoploss_ticket,stoploss))
      return MoveStopLoss(stoploss);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::ModifyTakeProfit(const double takeprofit)
  {
   if(m_stop.OrderModify(m_takeprofit_ticket,takeprofit))
      return MoveTakeProfit(takeprofit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::UpdateOrderStop(const double stoploss,const double takeprofit)
  {
   bool modify_sl=true,modify_tp=true;
   if(stoploss>0)
     {
      modify_sl=m_stop.MoveStopLoss(StopLossTicket(),stoploss);
      if(modify_sl)
         StopLoss(stoploss);
     }
   if(takeprofit>0)
     {
      modify_tp=m_stop.MoveTakeProfit(TakeProfitTicket(),takeprofit);
      if(modify_tp)
         TakeProfit(takeprofit);
     }
   return modify_sl && modify_tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBroker::Update(void)
  {
   if(!CheckPointer(m_stop))
      return true;
   if(m_order.IsClosed() || m_order.IsSuspended())
      return true;
   bool result=false;
   if(!CheckPointer(m_objsl) && !CheckPointer(m_objtp))
     {
      double order_stoploss=0,order_takeprofit=0;
      double ticksize=SymbolInfoDouble(m_order.Symbol(),SYMBOL_TRADE_TICK_SIZE);
      if(OrderSelect(m_stoploss_ticket))
        {
         order_stoploss=OrderGetDouble(ORDER_PRICE_OPEN);
         if(MathAbs(order_stoploss-StopLoss())>=ticksize)
            StopLoss(order_stoploss);
        }
      if(OrderSelect(m_takeprofit_ticket))
        {
         order_takeprofit=OrderGetDouble(ORDER_PRICE_OPEN);
         if(MathAbs(order_takeprofit-TakeProfit())>=ticksize)
            TakeProfit(order_takeprofit);
        }
      return true;
     }
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
