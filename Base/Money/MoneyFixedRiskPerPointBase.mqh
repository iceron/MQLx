//+------------------------------------------------------------------+
//|                                          MoneyFixedRatioBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedRiskPerPointBase : public CMoney
  {
public:
                     CMoneyFixedRiskPerPointBase(void);
                    ~CMoneyFixedRiskPerPointBase(void);
   virtual bool      Validate(void);
   virtual void      UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double);
   void              Risk(const double risk) {m_risk=risk;}
   double            Risk(void) const {return m_risk;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskPerPointBase::CMoneyFixedRiskPerPointBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskPerPointBase::~CMoneyFixedRiskPerPointBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedRiskPerPointBase::Validate(void)
  {
   if(m_risk<=0)
     {
      PrintFormat("invalid risk amount: "+(string)m_risk);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskPerPointBase::UpdateLotSize(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl=0)
  {
   m_symbol = m_symbol_man.Get(symbol);
   if (CheckPointer(m_symbol))
     {
      double balance=m_equity==false?m_account.Balance():m_account.Equity();
      m_volume = (m_risk/m_symbol.TickValue());
      OnLotSizeUpdated();
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\MoneyFixedRiskPerPoint.mqh"
#else
#include "..\..\MQL4\Money\MoneyFixedRiskPerPoint.mqh"
#endif
//+------------------------------------------------------------------+