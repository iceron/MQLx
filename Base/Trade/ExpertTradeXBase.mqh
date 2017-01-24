//+------------------------------------------------------------------+
//|                                             ExpertTradeXBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "ExpertTradeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertTradeXBase : public CExpertTrade
  {
public:
                     CExpertTradeXBase(void);
                    ~CExpertTradeXBase(void);
   string            Name(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertTradeXBase::CExpertTradeXBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertTradeXBase::~CExpertTradeXBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CExpertTradeXBase::Name(void)
  {
   if(CheckPointer(m_symbol))
      return m_symbol.Name();
   return NULL;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Trade\ExpertTradeX.mqh"
#else 
#include "..\..\MQL4\Trade\ExpertTradeX.mqh"
#endif
//+------------------------------------------------------------------+
