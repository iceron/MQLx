//+------------------------------------------------------------------+
//|                                                TimeRangeBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "TimeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimeRangeBase : public CTime
  {
protected:
   datetime          m_begin;
   datetime          m_end;
public:
                     CTimeRangeBase(void);
                    ~CTimeRangeBase(void);
   //--- initialization                    
   virtual bool      Set(datetime,datetime);
   virtual bool      Validate(void);
   //--- setters and getters
   datetime          Begin(void) const;
   void              Begin(const datetime);
   datetime          End(void) const;
   void              End(const datetime);
   //--- processing
   virtual bool      Evaluate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeRangeBase::CTimeRangeBase(void) : m_begin(0),
                                       m_end(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeRangeBase::~CTimeRangeBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CTimeRangeBase::Begin(void) const
  {
   return m_begin;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeRangeBase::Begin(const datetime begin)
  {
   m_begin=begin;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CTimeRangeBase::End(void) const
  {
   return m_end;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeRangeBase::End(const datetime end)
  {
   m_end=end;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeRangeBase::Set(datetime begin,datetime end)
  {
   m_begin=begin;
   m_end=end;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeRangeBase::Validate(void)
  {
   if(m_end<m_begin)
     {
      PrintFormat("Invalid setting for start and end times.");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeRangeBase::Evaluate(void)
  {
   if(!Active())
      return true;
   datetime current=TimeCurrent();
   bool result=current>=m_begin && current<m_end;
   return Reverse()?result:!result;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\TimeRange.mqh"
#else
#include "..\..\MQL4\Time\TimeRange.mqh"
#endif
//+------------------------------------------------------------------+
