//+------------------------------------------------------------------+
//|                                                        Timer.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#define YEAR_SECONDS 31536000
#define MONTH_SECONDS 2419200
#define DAY_SECONDS 86400
#define HOUR_SECONDS 3600
#define MINUTE_SECONDS 60
#include "TimeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimerBase : public JTime
  {
protected:
   uint              m_years;
   uint              m_months;
   uint              m_days;
   uint              m_hours;
   uint              m_minutes;
   uint              m_seconds;
   int               m_total;
   int               m_elapsed;
public:
                     JTimerBase();
                    ~JTimerBase();
   //--- initialization
   virtual bool      Init(uint years,uint months,uint days,uint hours,uint minutes,uint seconds);
   //--- getters and setters
   virtual uint      Year() const {return(m_years);}
   virtual void      Year(uint years) {m_years=years;}
   virtual uint      Month() const {return(m_months);}
   virtual void      Month(uint months) {m_months=months;}
   virtual uint      Days() const {return(m_days);}
   virtual void      Days(uint days) {m_days=days;}
   virtual uint      Hours() const {return(m_hours);}
   virtual void      Hours(uint hours) {m_hours=hours;}
   virtual uint      Minutes() const {return(m_minutes);}
   virtual void      Minutes(uint minutes) {m_minutes=minutes;}
   virtual uint      Seconds() const {return(m_seconds);}
   virtual void      Seconds(uint seconds) {m_seconds=seconds;}
   //--- evaluation   
   virtual bool      Elapsed() const {return(m_elapsed);}
   virtual bool      Evaluate();
   virtual void      RecalculateTotal();
   virtual bool      Total() const {return(m_total);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimerBase::JTimerBase() : m_years(0),
                           m_months(0),
                           m_days(0),
                           m_hours(0),
                           m_minutes(0),
                           m_seconds(0),
                           m_total(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimerBase::~JTimerBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimerBase::Init(uint years,uint months,uint days,uint hours,uint minutes,uint seconds)
  {
   m_years=years;
   m_months=months;
   m_days=days;
   m_hours=hours;
   m_minutes=minutes;
   m_seconds=seconds;
   RecalculateTotal();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTimerBase::RecalculateTotal()
  {
   m_total=(int)((m_years*YEAR_SECONDS)+(m_months*MONTH_SECONDS)+(m_days*DAY_SECONDS)+(m_hours*HOUR_SECONDS)+(m_minutes*MINUTE_SECONDS));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimerBase::Evaluate()
  {
   if(!Activate()) return(true);
   bool result=true;
   m_elapsed=(int)(TimeCurrent()-m_time_start);
   if(m_elapsed>=m_total) result=false;
   return(m_filter_type==TIME_FILTER_INCLUDE?result:!result);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\Timer.mqh"
#else
#include "..\..\mql4\time\Timer.mqh"
#endif
//+------------------------------------------------------------------+
