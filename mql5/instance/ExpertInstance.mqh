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
                     CExpertInstance(string,string,int,bool,bool,int,bool,bool);
                    ~CExpertInstance(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstance::CExpertInstance(string name,string symbol,int timeframe,
                                 bool every_tick,bool one_trade_per_candle,
                                 int magic,bool position_reverse,bool primary=true) 
                                 : CExpertInstanceBase(name,symbol,timeframe,every_tick,
                                 one_trade_per_candle,magic,position_reverse,primary)
  {   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstance::~CExpertInstance(void)
  {
  }
//+------------------------------------------------------------------+
