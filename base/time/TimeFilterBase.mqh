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
                    ~CTimeFilterBase(void);
   virtual bool      Init(CTimes*);
   virtual bool      Validate(void);
   virtual bool      Evaluate(void);
   virtual bool      Set(const int,const int,const int,const int,const int,const int,const int);
  };
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
bool CTimeFilterBase::Init(CTimes *times)
  {
   CTimeFilterBase::Init(times);
   for(int i=0;i<m_time_filters.Total();i++)
     {
      CTimeFilter *filter=m_time_filters.At(i);
      filter.Reverse(!Reverse());
      if(!filter.Init(times))
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
   if(t_end<t_start)
     {
      PrintFormat("Invalid setting for start and end times.");
      return false;
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
bool CTimeFilterBase::Evaluate(void)
  {
   if(!Active())
      return true;
   bool result=true;
   MqlDateTime time;
   CSymbolInfo *symbol=m_symbol_man.GetPrimary();
   datetime current=symbol.Time();
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
   datetime f_start=StructToTime(m_filter_start);
   datetime f_end=StructToTime(m_filter_end);
   if(!(current>=f_start && current<=f_end))
      result=false;
   result=Reverse()?result:!result;
   if(!result)
     {
      for(int i=0;i<m_time_filters.Total();i++)
        {
         CTimeFilter *filter=m_time_filters.At(i);
         if(filter.Evaluate())
            return true;
        }
     }
   return result;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\TimeFilter.mqh"
#else
#include "..\..\MQL5\Time\TimeFilter.mqh"
#endif
//+------------------------------------------------------------------+
