//+------------------------------------------------------------------+
//|                                                IndicatorBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_INDICATOR.mqh"
#include "..\..\common\enum\ENUM_APPLIED_VOLUME.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JIndicator : public JIndicatorBase
  {
public:
                     JIndicator(const string name);
                    ~JIndicator(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JIndicator::JIndicator(const string name) : JIndicatorBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JIndicator::~JIndicator(void)
  {
  }
//+------------------------------------------------------------------+
