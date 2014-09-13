//+------------------------------------------------------------------+
//|                                                    TimeRange.mqh |
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
class JTimeRangeBase : public JTime
  {
protected:
   datetime          m_begin;
   datetime          m_end;
public:
                     JTimeRangeBase(void);
                    ~JTimeRangeBase(void);
   virtual bool      Init(datetime begin,datetime end);
   virtual datetime  Begin(void) const  {return(m_begin);}
   virtual void      Begin(datetime begin) {m_begin=begin;}
   virtual datetime  End(void) const  {return(m_end);}
   virtual void      End(datetime end) {m_end=end;}
   virtual bool      Evaluate(void);
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
bool JTimeRangeBase::Evaluate(void)
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
