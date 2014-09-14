//+------------------------------------------------------------------+
//|                                                    TimesBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "TimeBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimesBase : public CArrayObj
  {
protected:
   bool              m_activate;
   JStrategy        *m_strategy;
public:
                     JTimesBase(void);
                    ~JTimesBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_TIMES);}
   //-- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Validate(void);
   //--- activation and deactivation
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   //--- checking
   virtual bool      Evaluate(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimesBase::JTimesBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimesBase::~JTimesBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Init(JStrategy *s)
  {
   for(int i=0;i<Total();i++)
     {
      JTime *time=At(i);
      time.Init(s,GetPointer(this));
     }
   SetContainer(s);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Validate(void)
  {
   for(int i=0;i<Total();i++)
     {
      JTime *time=At(i);
      if(!time.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Evaluate(void)
  {
   if(!Active()) return(true);
   for(int i=0;i<Total();i++)
     {
      JTime *time=At(i);
      if(CheckPointer(time))
         if(!time.Evaluate()) return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\Times.mqh"
#else
#include "..\..\mql4\time\Times.mqh"
#endif
//+------------------------------------------------------------------+
