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
   //virtual bool      CloseOrder(JOrder *order,const int index);
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(const MqlTradeTransaction&,const MqlTradeRequest&,const MqlTradeResult&);
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
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategy::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   Print(__FUNCTION__);
   m_order_man.OnTradeTransaction(trans,request,result);
  }  
//+------------------------------------------------------------------+
