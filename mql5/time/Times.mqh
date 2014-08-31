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
#include "Time.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimes : public CArrayObj
  {
protected:
   bool              m_activate;
public:
                     JTimes();
                    ~JTimes();
   virtual bool      Evaluate();
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimes::JTimes()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimes::~JTimes()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimes::Evaluate()
  {
   if (!Activate()) return(true);
   for(int i=0;i<Total();i++)
     {
      JTime *time=At(i);
      if(CheckPointer(time))
         if(!time.Evaluate()) return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
