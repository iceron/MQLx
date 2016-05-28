//+------------------------------------------------------------------+
//|                                    ExpertInstanceManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "ExpertInstanceBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertInstanceManagerBase : public CArrayObj
  {
protected:
public:
                     CExpertInstanceManagerBase(void);
                    ~CExpertInstanceManagerBase(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstanceManagerBase::CExpertInstanceManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstanceManagerBase::~CExpertInstanceManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\instance\ExpertInstanceManager.mqh"
#else
#include "..\..\mql4\instance\ExpertInstanceManager.mqh"
#endif
//+------------------------------------------------------------------+