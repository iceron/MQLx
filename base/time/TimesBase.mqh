//+------------------------------------------------------------------+
//|                                                    TimesBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include <Files\FileBin.mqh>
#include "TimeFilterBase.mqh"
#include "TimeRangeBase.mqh"
#include "TimerBase.mqh"
class CExpertAdvisor;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimesBase : public CArrayObj
  {
protected:
   bool              m_active;
   int               m_selected;
   CExpertAdvisor   *m_expert;
public:
                     CTimesBase(void);
                    ~CTimesBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TIMES;}
   //-- initialization
   virtual bool      Init(CExpertAdvisor *s);
   virtual void      SetContainer(CExpertAdvisor *s){m_expert=s;}
   virtual bool      Validate(void) const;
   //--- activation and deactivation
   bool              Active(void) const {return m_active;}
   void              Active(const bool activate) {m_active=activate;}
   int               Selected() {return m_selected;}
   //--- checking
   virtual bool      Evaluate(void) const;
   //--- recovery
   virtual bool      CreateElement(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimesBase::CTimesBase(void) : m_active(true),
                               m_selected(-1)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimesBase::~CTimesBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::Init(CExpertAdvisor *s)
  {
   for(int i=0;i<Total();i++)
     {
      CTime *time=At(i);
      time.Init(GetPointer(this));
     }
   SetContainer(s);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CTime *time=At(i);
      if(!time.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::Evaluate(void) const
  {
   if(!Active()) return true;
   for(int i=0;i<Total();i++)
     {
      CTime *time=At(i);
      if(CheckPointer(time))
         if(!time.Evaluate()) return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::CreateElement(const int index)
  {
   CTime*time=new CTime();
   time.SetContainer(GetPointer(this));
   return Insert(GetPointer(time),index);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\Times.mqh"
#else
#include "..\..\MQL4\Time\Times.mqh"
#endif
//+------------------------------------------------------------------+
