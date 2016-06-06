//+------------------------------------------------------------------+
//|                                     MoneyFixedFractionalBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedFractionalBase : public CMoney
  {
public:
                     CMoneyFixedFractionalBase(void);
                    ~CMoneyFixedFractionalBase(void);
   virtual void      UpdateLotSize(const double price,const ENUM_ORDER_TYPE type,const double sl);
   virtual bool      Validate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedFractionalBase::CMoneyFixedFractionalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedFractionalBase::~CMoneyFixedFractionalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedFractionalBase::Validate(void)
  {
   if (m_percent<=0)
   {
      PrintFormat(__FUNCTION__+": invalid percentage: "+(string)m_percent);
      return false;
   }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyFixedFractionalBase::UpdateLotSize(const double price,const ENUM_ORDER_TYPE type,const double sl)
  {
   if(m_symbol==NULL || m_account==NULL)
      return;
   double balance=m_equity==false?m_account.Balance():m_account.Equity();  
   if(price==0.0)
   {
      if(type==ORDER_TYPE_BUY)
         m_volume = ((balance*(m_percent/100))/(MathAbs(m_symbol.Ask()-sl)/m_symbol.TickSize()))/m_symbol.TickValue();
      else if(type==ORDER_TYPE_SELL)
         m_volume = ((balance*(m_percent/100))/(MathAbs(m_symbol.Bid()-sl)/m_symbol.TickSize()))/m_symbol.TickValue();
   }   
   else m_volume = ((balance*(m_percent/100))/(MathAbs(price-sl)/m_symbol.TickSize()))/m_symbol.TickValue();  
   OnLotSizeUpdated();   
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\MoneyFixedFractional.mqh"
#else
#include "..\..\MQL4\Money\MoneyFixedFractional.mqh"
#endif
//+------------------------------------------------------------------+
