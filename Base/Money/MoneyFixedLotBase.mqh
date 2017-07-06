//+------------------------------------------------------------------+
//|                                            MoneyFixedLotBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedLotBase : public CMoney
  {
public:
                     CMoneyFixedLotBase(double);
                    ~CMoneyFixedLotBase(void);
   virtual bool      Validate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedLotBase::CMoneyFixedLotBase(double volume)
  {
   Volume(volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedLotBase::~CMoneyFixedLotBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedLotBase::Validate(void)
  {
   if(m_volume<0)
     {
      PrintFormat("invalid volume: "+(string)m_volume);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\MoneyFixedLot.mqh"
#else
#include "..\..\MQL4\Money\MoneyFixedLot.mqh"
#endif
//+------------------------------------------------------------------+
