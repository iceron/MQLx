//+------------------------------------------------------------------+
//|                                                 StopLineBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <ChartObjects\ChartObjectsLines.mqh>
#include <Files\FileBin.mqh>
class JStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStopLineBase : public CChartObjectHLine
  {
protected:
   JStop            *m_stop;
public:
                     JStopLineBase(void);
                    ~JStopLineBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_STOPLINE);}
   virtual void      SetContainer(JStop *stop){m_stop=stop;}
   virtual double    GetPrice(const int point=0);
   virtual bool      Move(const double price);
   virtual bool      SetStyle(const ENUM_LINE_STYLE style);
   virtual bool      SetColor(const color clr);   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLineBase::JStopLineBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopLineBase::~JStopLineBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopLineBase::Move(const double price)
  {
   return(ObjectSetDouble(0,m_name,OBJPROP_PRICE,0,price));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JStopLineBase::GetPrice(const int point=0)
  {
   return(ObjectGetDouble(0,m_name,OBJPROP_PRICE,point));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopLineBase::SetColor(const color clr)
  {
   return(ObjectSetInteger(0,m_name,OBJPROP_COLOR,clr));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopLineBase::SetStyle(const ENUM_LINE_STYLE style)
  {
   return(ObjectSetInteger(0,m_name,OBJPROP_STYLE,style));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\stop\StopLine.mqh"
#else
#include "..\..\mql4\stop\StopLine.mqh"
#endif
//+------------------------------------------------------------------+
