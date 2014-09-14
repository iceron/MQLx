//+------------------------------------------------------------------+
//|                                     MoneyFixedRiskPerPipBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "MoneyFixedRiskBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JMoneyFixedRiskPerPipBase : public JMoney
  {
public:
                     JMoneyFixedRiskPerPipBase(void);
                    ~JMoneyFixedRiskPerPipBase(void);
   virtual void      UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl);
   virtual bool      Validate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedRiskPerPipBase::JMoneyFixedRiskPerPipBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedRiskPerPipBase::~JMoneyFixedRiskPerPipBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyFixedRiskPerPipBase::Validate(void)
  {
   if (m_percent<=0)
   {
      Print("invalid percentage: "+(string)m_percent);
      return(false);
   }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JMoneyFixedRiskPerPipBase::UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl)
  {
   if(m_symbol==NULL)
      return;
   double lot;
   double minvol=m_symbol.LotsMin();
   if(sl==0.0)
      m_volume=minvol;
   else
     {
      double loss;
      if(price==0.0)
        {
         if(type==ORDER_TYPE_BUY)
            loss=-m_account.OrderProfitCheck(m_symbol.Name(),type,1.0,m_symbol.Ask(),sl);
         else if(type==ORDER_TYPE_SELL)
            loss=-m_account.OrderProfitCheck(m_symbol.Name(),type,1.0,m_symbol.Bid(),sl);
        }
      else
         loss=-m_account.OrderProfitCheck(m_symbol.Name(),type,1.0,price,sl);
      double stepvol=m_symbol.LotsStep();
      lot=MathFloor(m_account.Balance()*m_percent/100.0/stepvol)*stepvol;
     }
   m_volume = lot;
   if(m_volume<minvol)
      m_volume=minvol;
   double maxvol=m_symbol.LotsMax();
   if(m_volume>maxvol)
      m_volume=maxvol;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\MoneyFixedRiskPerPip.mqh"
#else
#include "..\..\mql4\money\MoneyFixedRiskPerPip.mqh"
#endif
//+------------------------------------------------------------------+
