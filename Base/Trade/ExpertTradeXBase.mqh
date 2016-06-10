//+------------------------------------------------------------------+
//|                                             ExpertTradeXBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertTradeXBase : public CExpertTrade
  {
public:
                     CExpertTradeXBase(void);
                    ~CExpertTradeXBase(void);
   string            Name(void) {return m_symbol.Name();}
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
#ifdef __MQL5__
#include "..\..\MQL5\Trade\ExpertTradeX.mqh"
#else 
#include "..\..\MQL4\Trade\ExpertTradeX.mqh"
#endif
//+------------------------------------------------------------------+
