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
protected:
   double            m_risk;
public:
                     CMoneyFixedRiskPerPointBase(void);
                    ~CMoneyFixedRiskPerPointBase(void);
   virtual bool      Validate(void);
   virtual bool      UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double);
   void              Risk(const double);
   double            Risk(void) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskPerPointBase::CMoneyFixedRiskPerPointBase(void) : m_risk(0)
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
CMoneyFixedRiskPerPointBase::Risk(const double value)
  {
   m_risk=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyFixedRiskPerPointBase::Risk(void) const
  {
   return m_risk;
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
bool CMoneyFixedRiskPerPointBase::UpdateLotSize(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl=0)
  {
   m_symbol=m_symbol_man.Get(symbol);
   double last_volume=m_volume;
   if(CheckPointer(m_symbol))
     {
      double balance=m_equity==false?m_account.Balance():m_account.Equity();
      m_volume=(m_risk/m_symbol.TickValue());
     }
   return NormalizeDouble(last_volume-m_volume,2)==0;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\MoneyFixedRiskPerPoint.mqh"
#else
#include "..\..\MQL4\Money\MoneyFixedRiskPerPoint.mqh"
#endif
//+------------------------------------------------------------------+
