//+------------------------------------------------------------------+
//|                                         MoneyFixedFractional.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedFractional : public CMoneyFixedFractionalBase
  {
public:
                     CMoneyFixedFractional(double);
                    ~CMoneyFixedFractional(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedFractional::CMoneyFixedFractional(double risk_percent) : CMoneyFixedFractionalBase(risk_percent)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedFractional::~CMoneyFixedFractional(void)
  {
  }
//+------------------------------------------------------------------+
