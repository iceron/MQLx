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
                     JStopsBase();
                     JStopsBase(string name,string sl=".sl.",string tp=".tp.");
                    ~JStopsBase();
   virtual bool      Init(JStrategy *s);
   virtual bool      Active() {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual int       Type() {return(CLASS_TYPE_STOPS);}
protected:

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopsBase::JStopsBase() : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopsBase::~JStopsBase()
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
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\stop\Stops.mqh"
#else
#include "..\..\mql4\stop\Stops.mqh"
#endif
//+------------------------------------------------------------------+
