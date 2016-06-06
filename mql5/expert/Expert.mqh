//+------------------------------------------------------------------+
//|                                                       Expert.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExperts : public CExpertsBase
  {
public:
                     CExperts(void);
                    ~CExperts(void);
   virtual void      OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExperts::CExperts(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExperts::~CExperts(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExperts::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   Print(__FUNCTION__);
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      strat.OnTradeTransaction(trans,request,result);
     }
  }
//+------------------------------------------------------------------+
