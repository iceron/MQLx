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
   virtual void      OnTradeTransaction(const MqlTradeTransaction &,const MqlTradeRequest &,const MqlTradeResult &);
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
void CExpertAdvisors::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      e.OnTradeTransaction(trans,request,result);
     }
  }
//+------------------------------------------------------------------+
