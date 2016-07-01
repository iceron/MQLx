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
class CMoneyFixedRatioBase : public CMoney
  {
protected:
   double            m_volume_base;
   double            m_volume_inc;
public:
                     CMoneyFixedRatioBase(void);
                    ~CMoneyFixedRatioBase(void);
   virtual bool      Validate(void);
   virtual bool      UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double);
   void              VolumeBase(const double);
   double            VolumeBase(void) const;
   void              VolumeIncrement(const double);
   double            VolumeIncrement(void) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRatioBase::CMoneyFixedRatioBase(void) : m_volume_base(0),
                                                   m_volume_inc(0)

  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRatioBase::~CMoneyFixedRatioBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedRatioBase::Validate(void)
  {
   if(m_volume_base<0)
     {
      PrintFormat("invalid volume: "+(string)m_volume_base);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRatioBase::VolumeBase(const double value)
  {
   m_volume_base=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyFixedRatioBase::VolumeBase(void) const
  {
   return m_volume_base;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedRatioBase::VolumeIncrement(const double value)
  {
   m_volume_inc=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyFixedRatioBase::VolumeIncrement(void) const
  {
   return m_volume_inc;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedRatioBase::UpdateLotSize(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl=0)
  {
   m_symbol=m_symbol_man.Get(symbol);
   double last_volume=m_volume;
   if(CheckPointer(m_symbol))
     {
      double balance=m_equity==false?m_account.Balance():m_account.Equity();
      m_volume=m_volume_base+((int)(balance/m_balance_inc))*m_volume_inc;
      m_balance=balance;
     }
   return NormalizeDouble(last_volume-m_volume,2)==0;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\MoneyFixedRatio.mqh"
#else
#include "..\..\MQL4\Money\MoneyFixedRatio.mqh"
#endif
//+------------------------------------------------------------------+
