//+------------------------------------------------------------------+
//|                                                SignalManager.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayInt.mqh>
#include "SignalBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JSignalsBase: public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_last_signal;
   bool              m_new_signal;
   bool              m_reverse;
   JStrategy        *m_strategy;
public:
                     JSignalsBase();
                    ~JSignalsBase();
   virtual int       CheckSignals();
   virtual int       LastSignal() const{return(m_last_signal);}
   virtual void      LastSignal(int signal);
   virtual void      SetContainer(CObject *s){m_strategy=s;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalsBase::JSignalsBase() : m_activate(true),
                               m_last_signal(0),
                               m_new_signal(true),
                               m_reverse(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalsBase::~JSignalsBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSignalsBase::CheckSignals()
  {
   int res=CMD_NEUTRAL;
   int total=Total();
   for(int i=0;i<total;i++)
     {
      JSignal *signal=At(i);
      if(signal==NULL) continue;
      int ret=signal.CheckSignal();
      if(ret==CMD_VOID) return(CMD_VOID);
      if(ret==CMD_ALL) return(CMD_ALL);
      if(res>0 && ret!=res) return (CMD_VOID);
      if(ret>0) res=ret;
     }
   if(m_reverse)
      res=SignalReverse(res);
   if(m_new_signal)
      if(res==m_last_signal)
         res=CMD_VOID;
   if(res>0)
      m_last_signal=res;
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JSignalsBase::LastSignal(int signal)
  {
   m_last_signal=signal;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\signal\Signals.mqh"
#else
#include "..\..\mql4\signal\Signals.mqh"
#endif
//+------------------------------------------------------------------+
