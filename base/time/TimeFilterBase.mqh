//+------------------------------------------------------------------+
//|                                               TimeFilterBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "TimeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimeFilterBase : public CTime
  {
protected:
   MqlDateTime       m_filter_start;
   MqlDateTime       m_filter_end;
   CArrayObj         m_time_filters;
public:
                     CTimeFilterBase(void);
                     CTimeFilterBase(const int,const int,const int,const int,const int,const int,const int);
                    ~CTimeFilterBase(void);
   virtual bool      Init(CSymbolManager*,CEventAggregator*);
   virtual bool      Validate(void);
   virtual bool      Evaluate(datetime);
   virtual bool      Set(const int,const int,const int,const int,const int,const int,const int);
   virtual bool      AddFilter(CTimeFilterBase*);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeFilterBase::CTimeFilterBase(const int gmt,const int starthour,const int endhour,const int startminute=0,const int endminute=0,const int startseconds=0,const int endseconds=0)
  {
   Set(gmt,starthour,endhour,startminute,endminute,startseconds,endseconds);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeFilterBase::CTimeFilterBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeFilterBase::~CTimeFilterBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeFilterBase::Init(CSymbolManager *symbol_man,CEventAggregator *event_man=NULL)
  {
   CTime::Init(symbol_man,event_man);
   for(int i=0;i<m_time_filters.Total();i++)
     {
      CTimeFilter *filter=m_time_filters.At(i);
      if(!filter.Init(symbol_man,event_man))
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeFilterBase::Validate(void)
  {
   datetime t_start=StructToTime(m_filter_start);
   datetime t_end=StructToTime(m_filter_end);
   if(m_filter_start.hour==m_filter_end.hour && m_filter_start.min==m_filter_end.min && m_filter_start.sec==m_filter_end.sec)
     {
      //Active(false);
      PrintFormat("Warning: time filter has default setting");
     }
   if(!CheckPointer(m_symbol_man))
     {
      PrintFormat("NULL pointer: symbol manager");
      return false;
     }
   if(m_symbol_man.Total()==0)
     {
      PrintFormat("no entry under symbol manager");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeFilterBase::AddFilter(CTimeFilterBase *time)
  {
   if (CheckPointer(time))
      return m_time_filters.Add(time);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeFilterBase::Set(const int gmt,const int starthour,const int endhour,const int startminute=0,const int endminute=0,const int startseconds=0,const int endseconds=0)
  {
   m_filter_start.hour=starthour+gmt;
   m_filter_start.min=startminute;
   m_filter_start.sec=startseconds;
   m_filter_end.hour=endhour+gmt;
   m_filter_end.min=endminute;
   m_filter_end.sec=endseconds;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeFilterBase::Evaluate(datetime current=0)
  {
   if(!Active())
      return true;
   bool result=true;
   MqlDateTime time;
   if(current==0)
      current=TimeCurrent();
   TimeToStruct(current,time);
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
   if(m_filter_start.hour>=m_filter_end.hour)
     {
      if(time.hour>=m_filter_start.hour)
        {
         m_filter_end.day++;
         m_filter_end.day_of_week++;
         m_filter_end.day_of_year++;
        }
      else if(time.hour<=m_filter_end.hour)
        {
         m_filter_start.day--;
         m_filter_start.day_of_week--;
         m_filter_start.day_of_year--;
        }
     }
   datetime f_start=StructToTime(m_filter_start);
   datetime f_end=StructToTime(m_filter_end);      
   result=current>=f_start && current<f_end;   
   result=Reverse()?!result:result;
   if(!result)
     {
      for(int i=0;i<m_time_filters.Total();i++)
        {
         CTimeFilter *filter=m_time_filters.At(i);
         if(filter.Evaluate(current))
         {
            return true;
         }   
        }
     }
   return result;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\TimeFilter.mqh"
#else
#include "..\..\MQL4\Time\TimeFilter.mqh"
#endif
//+------------------------------------------------------------------+
