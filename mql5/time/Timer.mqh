//+------------------------------------------------------------------+
//|                                                        Timer.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimer : public CTimerBase
  {
public:
                     CTimer(const int);
                     CTimer(const uint,const uint,const uint,const uint,const uint,const uint);
                    ~CTimer(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimer::CTimer(const uint years,const uint months,const uint days,const uint hours,const uint minutes,const uint seconds) : CTimerBase(years,months,days,hours,minutes,seconds)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimer::CTimer(const int total) : CTimerBase(total)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimer::~CTimer(void)
  {
  }
//+------------------------------------------------------------------+
