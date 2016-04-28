//+------------------------------------------------------------------+
//|                                                     Strategy.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStrategy : public JStrategyBase
  {
public:
                     JStrategy(void);
                    ~JStrategy(void);
   //virtual bool      CloseOrder(JOrder *order,const int index);
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(const MqlTradeTransaction&,const MqlTradeRequest&,const MqlTradeResult&)
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::JStrategy(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStrategy::~JStrategy(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStrategy::OnTick(void)
  {
   bool ret=JStrategyBase::OnTick();
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JStrategy::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   m_order_man.OnTradeTransaction(trans,request,result);
  }  
//+------------------------------------------------------------------+
