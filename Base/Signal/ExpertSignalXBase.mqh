//+------------------------------------------------------------------+
//|                                                ExpertSignalX.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "ExpertSignalBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertSignalXBase : public CExpertSignal
  {
public:
                     CExpertSignalXBase(void);
                    ~CExpertSignalXBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_SIGNAL;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertSignalXBase::CExpertSignalXBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertSignalXBase::~CExpertSignalXBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Signal\ExpertSignalX.mqh"
#else
#include "..\..\MQL4\Signal\ExpertSignalX.mqh"
#endif
//+------------------------------------------------------------------+
