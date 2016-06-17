//+------------------------------------------------------------------+
//|                                                      Experts.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\common\enum\ENUM_CMD.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisors : public CExpertAdvisorsBase
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
