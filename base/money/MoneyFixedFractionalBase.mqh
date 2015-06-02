//+------------------------------------------------------------------+
//|                                         MoneyFixedMarginBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JMoneyFixedFractionalBase : public JMoney
  {
public:
                     JMoneyFixedFractionalBase(void);
                    ~JMoneyFixedFractionalBase(void);
   virtual void      UpdateLotSize(const double price,const ENUM_ORDER_TYPE type,const double sl);
   virtual bool      Validate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedFractionalBase::JMoneyFixedFractionalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedFractionalBase::~JMoneyFixedFractionalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyFixedFractionalBase::Validate(void)
  {
   if (m_percent<=0)
   {
      PrintFormat(__FUNCTION__+": invalid percentage: "+(string)m_percent);
      return(false);
   }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JMoneyFixedFractionalBase::UpdateLotSize(const double price,const ENUM_ORDER_TYPE type,const double sl)
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
   m_last_update=TimeCurrent();
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\MoneyFixedFractional.mqh"
#else
#include "..\..\mql4\money\MoneyFixedFractional.mqh"
#endif
//+------------------------------------------------------------------+
