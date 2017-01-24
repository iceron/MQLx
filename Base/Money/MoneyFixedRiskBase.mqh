//+------------------------------------------------------------------+
//|                                          MoneyFixedRatioBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "MoneyFixedRiskPerPointBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedRiskBase : public CMoneyFixedRiskPerPoint
  {
public:
                     CMoneyFixedRiskBase(void);
                    ~CMoneyFixedRiskBase(void);
   virtual bool      Validate(void);
   virtual void      UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskBase::CMoneyFixedRiskBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRiskBase::~CMoneyFixedRiskBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedRiskBase::Validate(void)
  {
   return CMoneyFixedRiskPerPoint::Validate();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedRiskBase::UpdateLotSize(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl)
  {
   m_symbol=m_symbol_man.Get(symbol);
   double last_volume=m_volume;
   if(CheckPointer(m_symbol))
     {
      double balance=m_equity==false?m_account.Balance():m_account.Equity();
      double ticks=0;
      if(price==0.0)
        {
         if(type==ORDER_TYPE_BUY)
            ticks=MathAbs(m_symbol.Bid()-sl)/m_symbol.TickSize();
         else if(type==ORDER_TYPE_SELL)
            ticks=MathAbs(m_symbol.Ask()-sl)/m_symbol.TickSize();
        }
      else ticks=MathAbs(price-sl)/m_symbol.TickSize();
      m_volume=(m_risk/m_symbol.TickValue())/ticks;
     }
   return NormalizeDouble(last_volume-m_volume,2)==0;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\MoneyFixedRisk.mqh"
#else
#include "..\..\MQL4\Money\MoneyFixedRisk.mqh"
#endif
//+------------------------------------------------------------------+
