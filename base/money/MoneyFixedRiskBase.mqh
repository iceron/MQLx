//+------------------------------------------------------------------+
//|                                               MoneyFixedRisk.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JMoneyFixedRiskBase : public JMoney
  {
public:
                     JMoneyFixedRiskBase(void);
                    ~JMoneyFixedRiskBase(void);
   virtual void      UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl);
   virtual bool      Validate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedRiskBase::JMoneyFixedRiskBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedRiskBase::~JMoneyFixedRiskBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyFixedRiskBase::Validate(void)
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
void JMoneyFixedRiskBase::UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl)
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
      lot=MathFloor(m_account.Balance()*m_percent/loss/100.0/stepvol)*stepvol;
     }
   if(m_volume<minvol)
      m_volume=minvol;
   double maxvol=m_symbol.LotsMax();
   if(m_volume>maxvol)
      m_volume=maxvol;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\MoneyFixedRisk.mqh"
#else
#include "..\..\mql4\money\MoneyFixedRisk.mqh"
#endif
//+------------------------------------------------------------------+
