//+------------------------------------------------------------------+
//|                                                MoneyFixedLot.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedLot : public CMoneyFixedLotBase
  {
public:
                     CMoneyFixedLot(double);
                    ~CMoneyFixedLot(void);
   virtual bool      Validate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedLot::CMoneyFixedLot(double volume) : CMoneyFixedLotBase(volume)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedLot::~CMoneyFixedLot(void)
  {
  }
//+------------------------------------------------------------------+
