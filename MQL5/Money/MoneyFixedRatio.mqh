//+------------------------------------------------------------------+
//|                                              MoneyFixedRatio.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedRatio : public CMoneyFixedRatioBase
  {
public:
                     CMoneyFixedRatio(double,double,double);
                    ~CMoneyFixedRatio(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRatio::CMoneyFixedRatio(double volume_base,double volume_inc,double balance_inc) : CMoneyFixedRatioBase(volume_base,volume_inc,balance_inc)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRatio::~CMoneyFixedRatio(void)
  {
  }
//+------------------------------------------------------------------+
