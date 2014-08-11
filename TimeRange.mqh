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
class JTimeRange : public JTime
  {
protected:
   datetime          m_begin;
   datetime          m_end;
public:
                     JTimeRange();
                    ~JTimeRange();
   virtual bool      Init(datetime begin,datetime end);
   virtual bool      Evaluate();
   virtual datetime  Begin() {return(m_begin);}
   virtual void      Begin(datetime begin) {m_begin=begin;}
   virtual datetime  End() {return(m_end);}
   virtual void      End(datetime end) {m_end=end;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeRange::JTimeRange() : m_begin(0),
                           m_end(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimeRange::~JTimeRange()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeRange::Init(datetime begin,datetime end)
  {
   m_begin=begin;
   m_end=end;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimeRange::Evaluate()
  {
   datetime current=TimeCurrent();
   bool result=current>m_begin && current<m_end;
   return(m_filter_type==TIME_FILTER_INCLUDE?result:!result);
  }
//+------------------------------------------------------------------+
