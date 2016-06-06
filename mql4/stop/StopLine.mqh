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
class CStopLine : public CStopLineBase
  {
public:
                     CStopLine(void);
                    ~CStopLine(void);
   bool              Create(long chart_id,const string name,const int window,const double price);
  };
//+------------------------------------------------------------------+
CStopLine::CStopLine(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLine::~CStopLine(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLine::Create(long chart_id,const string name,const int window,const double price)
  {
   CStopLineBase::Create(chart_id,name,window,price);
   if (IsTesting() || IsOptimization())
      m_chart_id = 0;
   return true;
  }
//+------------------------------------------------------------------+
