//+------------------------------------------------------------------+
//|                                                    StopLines.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#include <ChartObjects\ChartObjectsLines.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStopLine : public CChartObjectHLine
  {
private:

public:
                     JStopLine();
                    ~JStopLine();
   virtual bool      Attach(long chart_id,const string name,const int window,const int points);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine::JStopLine()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLine::~JStopLine()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopLine::Attach(long chart_id,const string name,const int window,const int points)
  {
//--- check
   if(ObjectFind(chart_id,name)<0)
      return(false);
//--- attach
   if(chart_id==0)
      chart_id=ChartID();
   m_chart_id  =chart_id;
   m_window    =window;
   m_name      =name;
   m_num_points=points;
//--- successful
   return(true);
  }

//+------------------------------------------------------------------+
