//+------------------------------------------------------------------+
//|                                                TimeRangeBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "TimeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimeRangeBase : public JTime
  {
protected:
   datetime          m_begin;
   datetime          m_end;
public:
                     JTimeRangeBase(void);
                    ~JTimeRangeBase(void);
   virtual bool      Init(datetime begin,datetime end);
   virtual bool      Validate(void) const;
   virtual datetime  Begin(void) const  {return(m_begin);}
   virtual void      Begin(const datetime begin) {m_begin=begin;}
   virtual datetime  End(void) const  {return(m_end);}
   virtual void      End(const datetime end) {m_end=end;}
   virtual bool      Evaluate(void) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeRangeBase::JTimeRangeBase(void) : m_begin(0),
                                       m_end(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeRangeBase::~JTimeRangeBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeRangeBase::Init(datetime begin,datetime end)
  {
   m_begin=begin;
   m_end=end;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeRangeBase::Validate(void) const
  {
   if (m_end>m_begin)
   {
      PrintFormat("Invalid setting for start and end times.");
      return(false);
   }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeRangeBase::Evaluate(void) const
  {
   if(!Active()) return(true);
   datetime current=TimeCurrent();
   bool result=current>=m_begin && current<=m_end;
   return(m_filter_type==TIME_FILTER_INCLUDE?result:!result);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\TimeRange.mqh"
#else
#include "..\..\mql4\time\TimeRange.mqh"
#endif
//+------------------------------------------------------------------+
