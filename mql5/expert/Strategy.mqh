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
class CExpert : public CExpertBase
  {
public:
                     CExpert(void);
                    ~CExpert(void);
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(const MqlTradeTransaction&,const MqlTradeRequest&,const MqlTradeResult&);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpert::CExpert(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpert::~CExpert(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpert::OnTick(void)
  {
   bool ret=CExpertBase::OnTick();
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpert::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   Print(__FUNCTION__);
   m_order_man.OnTradeTransaction(trans,request,result);
  }  
//+------------------------------------------------------------------+
