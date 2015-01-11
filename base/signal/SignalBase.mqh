//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
#include <Arrays\ArrayDouble.mqh>
#include "..\..\common\enum\ENUM_CMD.mqh"
#include "..\..\common\common.mqh"
#include "..\lib\AccountInfo.mqh"
#include "..\lib\SymbolInfo.mqh"
#include "..\event\EventBase.mqh"
#include "..\signal\SignalsBase.mqh"
#include "..\trade\TradeBase.mqh"
#include "..\order\OrdersBase.mqh"
#include "..\stop\StopsBase.mqh"
#include "..\money\MoneysBase.mqh"
#include "..\time\TimesBase.mqh"
#include "..\event\EventBase.mqh"
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
   JStrategy        *m_strategy;
   CArrayDouble      m_empty_value;
   CAccountInfo     *m_account;
   JSignals         *m_signals;
   CSymbolInfo      *m_symbol;
   JStops           *m_stops;
   JStop            *m_main_stop;
   JOrders          *m_orders;
   JOrders          *m_orders_history;
   CArrayInt        *m_other_magic;
   JMoneys          *m_moneys;
   JTimes           *m_times;
   JEvent           *m_event;
public:
                     JSignalBase(void);
                    ~JSignalBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_SIGNAL);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JSignals *signals){m_signals=signals;}
   virtual bool      Validate(void) const;
   //--- getters and setters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual string    Name(void) const {return(m_name);}
   virtual void      Name(const string name) {m_name=name;}
   virtual bool      Reverse(void) const {return(m_reverse);}
   virtual void      Reverse(const bool reverse) {m_reverse=reverse;}
   virtual int       LastSignal(void) const {return(m_signal);}
   virtual int       LastValidSignal(void) const {return(m_signal_valid);}
   //--- signal methods
   virtual void      AddEmptyValue(const double val);
   virtual int       CheckSignal(void);
   virtual bool      IsEmpty(const double val);
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
bool JSignalBase::Validate(void) const
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::Init(JStrategy *s)
  {
   m_strategy=s;
   m_account = m_strategy.AccountInfo();
   m_symbol= m_strategy.SymbolInfo();
   m_stops = m_strategy.Stops();
   m_main_stop=m_strategy.MainStop();
   m_orders=m_strategy.Orders();
   m_orders_history=m_strategy.OrdersHistory();
   m_other_magic=m_strategy.OtherMagic();
   m_moneys= m_strategy.Moneys();
   m_times = m_strategy.Times();
   m_event = m_strategy.Event();
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
