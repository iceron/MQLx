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
class JMoneyFixedMarginBase : public JMoney
  {
public:
                     JMoneyFixedMarginBase(void);
                    ~JMoneyFixedMarginBase(void);
   virtual void      UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl);
   virtual bool      Validate(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedMarginBase::JMoneyFixedMarginBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedMarginBase::~JMoneyFixedMarginBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyFixedMarginBase::Validate(void)
  {
   if (m_percent<=0)
   {
      Print(__FUNCTION__+": invalid percentage: "+(string)m_percent);
      return(false);
   }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JMoneyFixedMarginBase::UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl)
  {
   if(m_symbol==NULL)
      return;
   if(price==0.0)
     {
      if(type==ORDER_TYPE_BUY)
         m_volume=m_account.MaxLotCheck(m_symbol.Name(),type,m_symbol.Ask(),m_percent);
      else if(type==ORDER_TYPE_SELL)
         m_volume=m_account.MaxLotCheck(m_symbol.Name(),type,m_symbol.Bid(),m_percent);
     }
   else
      m_volume=m_account.MaxLotCheck(m_symbol.Name(),type,price,m_percent);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\MoneyFixedMargin.mqh"
#else
#include "..\..\mql4\money\MoneyFixedMargin.mqh"
#endif
//+------------------------------------------------------------------+
