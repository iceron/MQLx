//+------------------------------------------------------------------+
//|                                                        Stops.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "StopBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStopsBase : public CArrayObj
  {
protected:
   bool              m_activate;
   JStrategy        *m_strategy;
public:
                     JStopsBase(void);
                    ~JStopsBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_STOPS);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Validate(void);
   //--- setters and getters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   virtual JStop    *Main();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopsBase::JStopsBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopsBase::~JStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopsBase::Init(JStrategy *s)
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      stop.Init(s);
     }
   SetContainer(s);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopsBase::Validate(void)
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(!stop.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop *JStopsBase::Main()
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(stop.Main()) return(stop);
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\stop\Stops.mqh"
#else
#include "..\..\mql4\stop\Stops.mqh"
#endif
//+------------------------------------------------------------------+
