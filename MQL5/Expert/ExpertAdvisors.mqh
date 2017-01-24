//+------------------------------------------------------------------+
//|                                                      Experts.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisors : public CExpertAdvisorsBase
  {
public:
                     CExpertAdvisors(void);
                    ~CExpertAdvisors(void);
   virtual void      OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisors::CExpertAdvisors(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisors::~CExpertAdvisors(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisors::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      e.OnTradeTransaction(trans,request,result);
     }
  }
//+------------------------------------------------------------------+
