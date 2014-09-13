//+------------------------------------------------------------------+
//|                                                        Times.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Init(JStrategy *s);
   //--- activation and deactivation
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   //--- evaluation
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
      time.Init(s);
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
