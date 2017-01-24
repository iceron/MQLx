//+------------------------------------------------------------------+
//|                                                 StopLineBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <ChartObjects\ChartObjectsLines.mqh>
#include <Files\FileBin.mqh>
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
class CStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStopLineBase : public CChartObjectHLine
  {
protected:
   bool              m_active;
   CStop            *m_stop;
public:
                     CStopLineBase(void);
                    ~CStopLineBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOPLINE;}
   virtual void      SetContainer(CStop*);
   virtual CStop    *GetContainer(void);
   bool              Active(void) const;
   void              Active(const bool);
   virtual bool      ChartObjectExists(void) const;
   virtual double    GetPrice(const int);
   virtual bool      Move(const double);
   virtual bool      SetStyle(const ENUM_LINE_STYLE);
   virtual bool      SetColor(const color);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLineBase::CStopLineBase(void) : m_active(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLineBase::~CStopLineBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopLineBase::SetContainer(CStop *stop)
  {
   m_stop=stop;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop *CStopLineBase::GetContainer(void)
  {
   return m_stop;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopLineBase::Active(const bool active)
  {
   m_active=active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::ChartObjectExists(void) const
  {
   return ObjectFind(0,Name())>=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::Move(const double price)
  {
   return ObjectSetDouble(0,m_name,OBJPROP_PRICE,0,price);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopLineBase::GetPrice(const int point=0)
  {
   return ObjectGetDouble(0,m_name,OBJPROP_PRICE,point);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::SetColor(const color clr)
  {
   return ObjectSetInteger(0,m_name,OBJPROP_COLOR,clr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::SetStyle(const ENUM_LINE_STYLE style)
  {
   return ObjectSetInteger(0,m_name,OBJPROP_STYLE,style);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Stop\StopLine.mqh"
#else
#include "..\..\MQL4\Stop\StopLine.mqh"
#endif
//+------------------------------------------------------------------+
