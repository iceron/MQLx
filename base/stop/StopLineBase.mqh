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
class JStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStopLineBase : public CChartObjectHLine
  {
protected:
   JStop            *m_stop;
public:
                     JStopLineBase();
                    ~JStopLineBase();
   virtual double    GetPrice(int point=0);
   virtual bool      Move(double price);
   virtual void      SetContainer(JStop *stop){m_stop=stop;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLineBase::JStopLineBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLineBase::~JStopLineBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopLineBase::Move(double price)
  {
   return(ObjectSetDouble(0,m_name,OBJPROP_PRICE,0,price));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopLineBase::GetPrice(int point)
  {
   return(ObjectGetDouble(0,m_name,OBJPROP_PRICE,point));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\stop\StopLine.mqh"
#else
#include "..\..\mql4\stop\StopLine.mqh"
#endif
//+------------------------------------------------------------------+
