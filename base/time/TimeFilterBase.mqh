//+------------------------------------------------------------------+
//|                                               TimeFilterBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "TimeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimeFilterBase : public JTime
  {
protected:
   MqlDateTime       m_filter_start;
   MqlDateTime       m_filter_end;
   bool              m_sun;
   bool              m_mon;
   bool              m_tue;
   bool              m_wed;
   bool              m_thu;
   bool              m_fri;
   bool              m_sat;
public:
                     JTimeFilterBase(void);
                    ~JTimeFilterBase(void);
   virtual bool      Validate(void);
   virtual bool      Evaluate(void);
   virtual bool      Init(const int gmt,const int starthour,const int endhour,const int startminute=0,const int endminute=0,const int startseconds=0,const int endseconds=0);
   virtual void      SetDays(const bool sun,const bool mon,const bool tue,const bool wed,const bool thu,const bool fri,const bool sat);
   virtual bool      Sunday(void) const {return(m_sun);}
   virtual void      Sunday(const bool t) {m_sun=t;}
   virtual bool      Monday(void) const {return(m_mon);}
   virtual void      Monday(const bool t) {m_mon=t;}
   virtual bool      Tuesday(void) const {return(m_tue);}
   virtual void      Tuesday(const bool t) {m_tue=t;}
   virtual bool      Wednesday(void) const {return(m_wed);}
   virtual void      Wednesday(const bool t) {m_wed=t;}
   virtual bool      Thursday(void) const {return(m_thu);}
   virtual void      Thursday(const bool t) {m_thu=t;}
   virtual bool      Friday(void) const {return(m_fri);}
   virtual void      Friday(const bool t) {m_fri=t;}
   virtual bool      Saturday(void) const {return(m_sat);}
   virtual void      Saturday(const bool t) {m_sat=t;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeFilterBase::JTimeFilterBase(void) : m_sun(false),
                                         m_mon(true),
                                         m_tue(true),
                                         m_wed(true),
                                         m_thu(true),
                                         m_fri(true),
                                         m_sat(false)                                         
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeFilterBase::~JTimeFilterBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeFilterBase::Validate(void)
  {
   datetime t_start=StructToTime(m_filter_start);
   datetime t_end=StructToTime(m_filter_end);
   if(t_end<t_start)
     {
      PrintFormat("Invalid setting for start and end times.");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeFilterBase::Init(const int gmt,const int starthour,const int endhour,const int startminute=0,const int endminute=0,const int startseconds=0,const int endseconds=0)
  {
   m_filter_start.hour=starthour+gmt;
   m_filter_start.min=startminute;
   m_filter_start.sec=startseconds;
   m_filter_end.hour=endhour+gmt;
   m_filter_end.min=endminute;
   m_filter_end.sec=endseconds;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeFilterBase::Evaluate(void)
  {
   if(!Active()) return(true);
   bool result=true;
   MqlDateTime time;
   datetime current=TimeCurrent();
   TimeToStruct(current,time);
   switch(time.day_of_week)
     {
      case 0:
        {
         if(!m_sun) result=false;
         break;
        }
      case 1:
        {
         if(!m_mon) result=false;
         break;
        }
      case 2:
        {
         if(!m_tue) result=false;
         break;
        }
      case 3:
        {
         if(!m_wed) result=false;
         break;
        }
      case 4:
        {
         if(!m_thu) result=false;
         break;
        }
      case 5:
        {
         if(!m_fri) result=false;
         break;
        }
      case 6:
        {
         if(!m_sat) result=false;
         break;
        }
     }
   if(result)
     {
      m_filter_start.year= time.year;
      m_filter_start.mon = time.mon;
      m_filter_start.day = time.day;
      m_filter_start.day_of_week = time.day_of_week;
      m_filter_start.day_of_year = time.day_of_year;
      m_filter_end.year= time.year;
      m_filter_end.mon = time.mon;
      m_filter_end.day = time.day;
      m_filter_end.day_of_week = time.day_of_week;
      m_filter_end.day_of_year = time.day_of_year;
      datetime f_start=StructToTime(m_filter_start);
      datetime f_end=StructToTime(m_filter_end);
      if(!(current>=f_start && current<=f_end))
         result=false;
     }
   return(m_filter_type==TIME_FILTER_INCLUDE?result:!result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTimeFilterBase::SetDays(const bool sun=false,const bool mon=true,const bool tue=true,const bool wed=true,const bool thu=true,const bool fri=true,const bool sat=false)
  {
   m_sun = sun;
   m_mon = mon;
   m_tue = tue;
   m_wed = wed;
   m_thu = thu;
   m_fri = fri;
   m_sat = sat;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\TimeFilter.mqh"
#else
#include "..\..\mql4\time\TimeFilter.mqh"
#endif
//+------------------------------------------------------------------+
