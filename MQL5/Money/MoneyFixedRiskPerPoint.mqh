//+------------------------------------------------------------------+
//|                                       MoneyFixedRiskPerPoint.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedRiskPerPoint : public CMoneyFixedRiskPerPointBase
  {
public:
                     CMoneyFixedRiskPerPoint(double);
                    ~CMoneyFixedRiskPerPoint(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskPerPoint::CMoneyFixedRiskPerPoint(double risk) : CMoneyFixedRiskPerPointBase(risk)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskPerPoint::~CMoneyFixedRiskPerPoint(void)
  {
  }
//+------------------------------------------------------------------+
