//+------------------------------------------------------------------+
//|                                                  JTimeFilterBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "Time.mqh"
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
   virtual bool      Evaluate(void);
   virtual bool      Init(int gmt,int starthour,int endhour,int startminute=0,int endminute=0,int startseconds=0,int endseconds=0);
   virtual void      SetDays(bool sun,bool mon,bool tue,bool wed,bool thu,bool fri,bool sat);
   virtual bool      Sunday(void) const {return(m_mon);}
   virtual void      Sunday(bool mon) {m_mon=mon;}
   virtual bool      Monday(void) const {return(m_mon);}
   virtual void      Monday(bool mon) {m_mon=mon;}
   virtual bool      Tuesday(void) const {return(m_mon);}
   virtual void      Tuesday(bool mon) {m_mon=mon;}
   virtual bool      Wednesday(void) const {return(m_mon);}
   virtual void      Wednesday(bool mon) {m_mon=mon;}
   virtual bool      Thursday(void) const {return(m_mon);}
   virtual void      Thursday(bool mon) {m_mon=mon;}
   virtual bool      Friday(void) const {return(m_mon);}
   virtual void      Friday(bool mon) {m_mon=mon;}
   virtual bool      Saturday(void) const {return(m_mon);}
   virtual void      Saturday(bool mon) {m_mon=mon;}
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
bool JTimeFilterBase::Init(int gmt,int starthour,int endhour,int startminute=0,int endminute=0,int startseconds=0,int endseconds=0)
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
   datetime current=TimeCurrent(),start=0,end=0;
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
      start=StructToTime(m_filter_start);
      end=StructToTime(m_filter_end);
      if(!(current>=start && current<=end))
         result=false;
     }
   return(m_filter_type==TIME_FILTER_INCLUDE?result:!result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTimeFilterBase::SetDays(bool sun=false,bool mon=true,bool tue=true,bool wed=true,bool thu=true,bool fri=true,bool sat=false)
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
