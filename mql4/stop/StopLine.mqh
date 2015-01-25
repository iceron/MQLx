//+------------------------------------------------------------------+
//|                                                     StopLine.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStopLine : public JStopLineBase
  {
public:
                     JStopLine(void);
                    ~JStopLine(void);
   bool              Create(long chart_id,const string name,const int window,const double price);
  };
//+------------------------------------------------------------------+
JStopLine::JStopLine(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine::~JStopLine(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopLine::Create(long chart_id,const string name,const int window,const double price)
  {
   JStopLineBase::Create(chart_id,name,window,price);
   if (IsTesting() || IsOptimization())
      m_chart_id = 0;
   return(true);
  }
//+------------------------------------------------------------------+
