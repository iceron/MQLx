//+------------------------------------------------------------------+
//|                                                     StopLine.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStopLine : public CStopLineBase
  {
public:
                     CStopLine(void);
                    ~CStopLine(void);
   bool              Create(long,const string,const int,const double);
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
   if(IsTesting() || IsOptimization())
      m_chart_id=0;
   return true;
  }
//+------------------------------------------------------------------+
