//+------------------------------------------------------------------+
//|                                                     TimeDays.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimeDays : public CTimeDaysBase
  {
public:
                     CTimeDays(const bool,const bool,const bool,const bool,const bool,const bool,const bool);
                    ~CTimeDays(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeDays::CTimeDays(const bool sun=false,const bool mon=true,const bool tue=true,const bool wed=true,const bool thu=true,
                     const bool fri=true,const bool sat=false) : CTimeDaysBase(sun,mon,tue,wed,thu,fri,sat)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeDays::~CTimeDays(void)
  {
  }
//+------------------------------------------------------------------+
