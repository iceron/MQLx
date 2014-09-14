//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
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
   CSymbolInfo      *m_symbol;
   CAccountInfo     *m_account;
public:
                     JSignalBase(void);
                    ~JSignalBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_SIGNAL);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual bool      InitSymbol(CSymbolInfo *symbolinfo=NULL);
   virtual bool      InitAccount(CAccountInfo *accountinfo=NULL);
   virtual void      SetContainer(JSignals *signals){m_signals=signals;}
   virtual bool      Validate(void);
   //--- getters and setters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   virtual string    Name(void) const {return(m_name);}
   virtual void      Name(string name) {m_name=name;}
   virtual bool      Reverse(void) const {return(m_reverse);}
   virtual void      Reverse(bool reverse) {m_reverse=reverse;}
   virtual int       LastSignal(void) const {return(m_signal);}
   virtual int       LastValidSignal(void) const {return(m_signal);}
   //--- signal methods
   virtual void      AddEmptyValue(double);
   virtual int       CheckSignal(void);
   virtual bool      IsEmpty(double val);
   virtual ENUM_CMD  LongCondition(void) {return(0);}
   virtual ENUM_CMD  ShortCondition(void) {return(0);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalBase::JSignalBase(void) : m_activate(true),
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
JSignalBase::~JSignalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::Validate(void)
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::Init(JStrategy *s)
  {
   InitSymbol(s.SymbolInfo());
   InitAccount(s.AccountInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::InitSymbol(CSymbolInfo *symbolinfo=NULL)
  {
   m_symbol=symbolinfo;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::InitAccount(CAccountInfo *accountinfo=NULL)
  {
   m_account=accountinfo;
   return(true);
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
int JSignalBase::CheckSignal(void)
  {
   if(!Active()) return(CMD_NEUTRAL);
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
