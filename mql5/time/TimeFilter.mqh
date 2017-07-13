//+------------------------------------------------------------------+
//|                                                   TimeFilter.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimeFilter : public CTimeFilterBase
  {
public:
                     CTimeFilter(const int,const int,const int,const int,const int,const int,const int);
                    ~CTimeFilter(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeFilter::CTimeFilter(const int gmt,const int starthour,const int endhour,const int startminute=0,const int endminute=0,const int startseconds=0,const int endseconds=0) : CTimeFilterBase(gmt,starthour,endhour,startminute,endminute,startseconds,endseconds)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeFilter::~CTimeFilter(void)
  {
  }
//+------------------------------------------------------------------+
