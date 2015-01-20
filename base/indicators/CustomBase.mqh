//+------------------------------------------------------------------+
//|                                               IndicatorsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "IndicatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiCustomBase : public JIndicator
  {
protected:
   int               m_num_params;       // number of creation parameters
   MqlParam          m_params[];         // creation parameters
   string            m_filename;
public:
                     JiCustomBase(const string name);
                    ~JiCustomBase(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            string indicator_name,int num_params,MqlParam &params[]);
   bool              NumBuffers(const int buffers);
   int               NumParams(void) const { return(m_num_params); }
   ENUM_DATATYPE     ParamType(const int ind) const;
   long              ParamLong(const int ind) const;
   double            ParamDouble(const int ind) const;
   string            ParamString(const int ind) const;
   virtual int       Type(void) const { return(IND_CUSTOM); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiCustomBase::JiCustomBase(const string name) : JIndicator(name),
                                                m_filename(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiCustomBase::~JiCustomBase()
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Custom.mqh"
#else
#include "..\..\mql4\indicators\Custom.mqh"
#endif
//+------------------------------------------------------------------+
