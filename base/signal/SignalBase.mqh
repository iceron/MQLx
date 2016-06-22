//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Indicators\Indicators.mqh>
class CSignal;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSignalBase : public CObject
  {
   bool              m_active;
   double            m_direction;
   int               m_threshold_open;
   int               m_threshold_close;
   int               m_weight;
   bool              m_invert;
   CArrayObj         m_filters;
   CSymbolManager   *m_symbol_man;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CSignalBase(void);
                    ~CSignalBase(void);
   virtual bool      Init(CSymbolManager*,CEventAggregator*);
   virtual CObject  *GetContainer(void) {return m_container;}
   virtual void      SetContainer(CObject *container) {m_container=container;}
   virtual bool      Validate(void);
   virtual bool      AddFilter(CSignal*);

   virtual double    Check(void);
   virtual double    GetDirection(void) {return m_direction;}
   virtual int       LongCondition(void);
   virtual int       ShortCondition(void);
   bool              Active(void);
   void              Active(const bool);
   bool              Invert(void);
   int               ThresholdOpen(void) {return m_threshold_open;}
   int               ThresholdClose(void){return m_threshold_close;}
   virtual bool      CheckOpenLong(void);
   virtual bool      CheckOpenShort(void);
   virtual bool      CheckCloseLong(void);
   virtual bool      CheckCloseShort(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalBase::CSignalBase(void) : m_active(true),
                                 m_direction(0),
                                 m_threshold_open(50),
                                 m_threshold_close(100),
                                 m_weight(1.0),
                                 m_invert(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalBase::~CSignalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Init(CSymbolManager *symbol_man,CEventAggregator *event_man=NULL)
  {
   m_symbol_man= symbol_man;
   m_event_man = event_man;
   if (!CheckPointer(m_symbol_man))
      return false;
   for (int i=0;i<m_filters.Total();i++)
   {
      CSignal *filter = m_filters.At(i);
      if (!CheckPointer(filter))
         continue;
      if (!filter.Init(m_symbol_man,m_event_man))
         return false;
   }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Validate(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::AddFilter(CSignal *filter)
  {
   if(CheckPointer(filter))
     {
      filter.SetContainer(GetPointer(this));
      return m_filters.Add(filter);
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CSignalBase::Check(void)
  {
   if(!Active())
      return 0;
   double result=m_weight*(LongCondition()-ShortCondition());
   int votes= result==0.0?0:1;
   for(int i=0;i<m_filters.Total();i++)
     {
      CSignal *signal=m_filters.At(i);
      if(!signal.Active())
         continue;
      double direction=signal.Check();
      if(!signal.Invert())
         direction=-direction;
      result+=direction;
      votes++;
     }
   if(votes>1)
      result/=votes;
   m_direction=result;
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSignalBase::LongCondition(void)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSignalBase::ShortCondition(void)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Active(void)
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::Active(const bool toggle)
  {
   m_active=toggle;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Invert(void)
  {
   return m_invert;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckOpenLong(void)
  {
   return m_direction>=m_threshold_open;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckOpenShort(void)
  {
   return -m_direction>=m_threshold_open;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckCloseLong(void)
  {
   return m_direction>=m_threshold_close;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::CheckCloseShort(void)
  {
   return -m_direction>=m_threshold_close;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Signal\Signal.mqh"
#else
#include "..\..\MQL4\Signal\Signal.mqh"
#endif
//+------------------------------------------------------------------+
