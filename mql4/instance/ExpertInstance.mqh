//+------------------------------------------------------------------+
//|                                               ExpertInstance.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#property strict
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertInstance : public CExpertInstanceBase
  {
protected:
public:
                     CExpertInstance(string,string,int,int,bool);
                    ~CExpertInstance(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstance::CExpertInstance(string name,string symbol,int timeframe,
                                 int magic,bool primary=true) 
                                 : CExpertInstanceBase(name,symbol,timeframe,magic,primary)
  {   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstance::~CExpertInstance(void)
  {
  }
//+------------------------------------------------------------------+
