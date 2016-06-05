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
   virtual bool      Add(CObject *);
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
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertInstanceManagerBase::Add(CObject *instance)
  {
   CExpertInstance *arg = (CExpertInstance*) instance;
   string symbol = arg.Symbol();
   int timeframe = arg.Timeframe();
   for(int i=0;i<Total();i++)
     {
      CExpertInstance *item=At(i);
      if(StringCompare(symbol,item.Symbol())==0 && timeframe==item.Timeframe())
      {
        Print("instance with symbol and timeframe already exists: "+symbol+" "+(string)timeframe);
        return false;
      }  
     }
   return Add(arg);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\instance\ExpertInstanceManager.mqh"
#else
#include "..\..\mql4\instance\ExpertInstanceManager.mqh"
#endif
//+------------------------------------------------------------------+
