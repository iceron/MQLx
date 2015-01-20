//+------------------------------------------------------------------+
//|                                                IndicatorBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JIndicatorBase : public CObject
  {
protected:
   string            m_name;
   string            m_symbol;
   ENUM_TIMEFRAMES   m_timeframe;
public:
                     JIndicatorBase(const string name);
                    ~JIndicatorBase(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JIndicatorBase::JIndicatorBase(const string name) : m_name(name),
                                                    m_symbol(NULL),
                                                    m_timeframe(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JIndicatorBase::~JIndicatorBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Indicator.mqh"
#else
#include "..\..\mql4\indicators\Indicator.mqh"
#endif
//+------------------------------------------------------------------+
