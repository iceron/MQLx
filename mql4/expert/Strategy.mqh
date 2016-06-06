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
class CStrategy : public CStrategyBase
  {
public:
                     CStrategy(void);
                    ~CStrategy(void);              
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(void) {m_order_man.OnTradeTransaction();}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStrategy::CStrategy(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStrategy::~CStrategy(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategy::OnTick(void)
  {
   bool ret=CStrategyBase::OnTick();
   if(ret) OnTradeTransaction();
   return ret;
  }
//+------------------------------------------------------------------+
