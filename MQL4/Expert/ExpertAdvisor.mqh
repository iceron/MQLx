//+------------------------------------------------------------------+
//|                                                       Expert.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisor : public CExpertAdvisorBase
  {
public:
                     CExpertAdvisor(void);
                    ~CExpertAdvisor(void);              
   virtual bool      OnTick(void);
   virtual void      OnTradeTransaction(void) {m_order_man.OnTradeTransaction();}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisor::CExpertAdvisor(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisor::~CExpertAdvisor(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisor::OnTick(void)
  {
   bool ret=CExpertAdvisorBase::OnTick();
   if(ret) OnTradeTransaction();
   return ret;
  }
//+------------------------------------------------------------------+
