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
   string            Name(void) const {return(m_name);}
   string            Symbol(void) const {return(m_symbol);}
   ENUM_TIMEFRAMES   TimeFrame(void) const {return(m_timeframe);}
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
#include "..\..\mql5\indicator\Indicator.mqh"
#else
#include "..\..\mql4\indicator\Indicator.mqh"
#endif
//+------------------------------------------------------------------+
