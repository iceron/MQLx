//+------------------------------------------------------------------+
//|                                                       JSignalBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Object.mqh>
#include <Arrays\ArrayDouble.mqh>
#include <traderjet-cross\common\enum\ENUM_CMD.mqh>
#include <traderjet-cross\common\common.mqh>
class JSignals;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JSignalBase : public CObject
  {
protected:
   bool              m_activate;
   string            m_name;
   int               m_signal;
   int               m_signal_valid;
   bool              m_reverse;
   CArrayDouble      m_empty_value;
   JSignals         *m_signals;
public:
                     JSignalBase();
                    ~JSignalBase();
   //--- initialization
   virtual void      SetContainer(JSignals *signals){m_signals=signals;}
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- signal parameters
   virtual string    Name() const {return(m_name);}
   virtual void      Name(string name) {m_name=name;}
   virtual bool      Reverse() const {return(m_reverse);}
   virtual void      Reverse(bool reverse) {m_reverse=reverse;}
   virtual int       LastSignal() const {return(m_signal);}
   virtual int       LastValidSignal() const {return(m_signal);}
   //--- signal methods
   virtual ENUM_CMD  LongCondition() {return(0);}
   virtual ENUM_CMD  ShortCondition() {return(0);}
   virtual void      AddEmptyValue(double);
   virtual int       CheckSignal();
   virtual bool      IsEmpty(double val);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalBase::JSignalBase() : m_activate(true),
                             m_name(NULL),
                             m_signal(CMD_NEUTRAL),
                             m_signal_valid(CMD_VOID),
                             m_reverse(false)

  {
   AddEmptyValue(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalBase::~JSignalBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JSignalBase::AddEmptyValue(double val)
  {
   if(m_empty_value.Add(val)) m_empty_value.Sort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::IsEmpty(double val)
  {
   return(m_empty_value.Search(val)>=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSignalBase::CheckSignal()
  {
   int res=CMD_NEUTRAL;
   bool long_cond=LongCondition();
   bool short_cond=ShortCondition();
   if(long_cond>0 && short_cond>0) res=CMD_ALL;
   else
     {
      if(long_cond) res=CMD_LONG;
      else if(short_cond) res=CMD_SHORT;
     }
   if(m_reverse) res=SignalReverse(res);
   if(res!=CMD_NEUTRAL) m_signal_valid=res;
   m_signal=res;
   return(res);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\signal\Signal.mqh"
#else
#include "..\..\mql4\signal\Signal.mqh"
#endif
//+------------------------------------------------------------------+
