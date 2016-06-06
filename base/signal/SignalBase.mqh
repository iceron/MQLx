//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_CMD.mqh"
#include <Arrays\ArrayDouble.mqh>
#include "..\comment\CommentsBase.mqh"
class CStrategy;
class CSignals;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSignalBase : public CObject
  {
protected:
   bool              m_activate;
   string            m_name;
   int               m_signal;
   int               m_signal_valid;
   bool              m_new_signal;
   bool              m_reverse;
   bool              m_exit;
   CStrategy        *m_strategy;
   CArrayDouble      m_empty_value;
   CSignals         *m_signals;
   CComments        *m_comments;
public:
                     CSignalBase();
                    ~CSignalBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_SIGNAL;}
   //--- initialization
   virtual bool      Init(CStrategy *s,CComments *comments);
   virtual void      SetContainer(CSignals *signals){m_signals=signals;}
   virtual bool      Validate(void) const;
   //--- getters and setters
   virtual bool      Active(void) const {return m_activate;}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual bool      ExitSignal(void) const{return m_exit;}
   virtual void      ExitSignal(const bool exit) {m_exit=exit;}
   virtual string    Name(void) const {return m_name;}
   virtual void      Name(const string name) {m_name=name;}
   virtual int       NewSignal(void) const {return m_new_signal;}
   virtual void      NewSignal(const int signal) {m_new_signal=signal;}
   virtual bool      Reverse(void) const {return m_reverse;}
   virtual void      Reverse(const bool reverse) {m_reverse=reverse;}
   virtual int       LastEntry(void) const {return m_signal;}
   virtual int       LastValidSignal(void) const {return m_signal_valid;}
   virtual string    ToString(bool last_valid=false) const;
   //--- signal methods
   virtual void      AddEmptyValue(const double val);
   virtual int       CheckSignal(void);
   virtual bool      IsEmpty(const double val);
   virtual ENUM_CMD  LongCondition(void) {return 0;}
   virtual ENUM_CMD  ShortCondition(void) {return 0;}
   //-- comments
   virtual void      AddComment(const string comment);
   //--- static methods
   static bool       IsOrderAgainstSignal(const ENUM_ORDER_TYPE type,const ENUM_CMD res,const bool exact=false);
   static bool       IsSignalTypeLong(const ENUM_CMD type);
   static bool       IsSignalTypeShort(const ENUM_CMD type);
   static int        SignalReverse(const int signal);
   static ENUM_ORDER_TYPE SignalToOrderType(const int signal);
   //---recovery
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalBase::CSignalBase() : m_activate(true),
                             m_name(NULL),
                             m_signal(CMD_NEUTRAL),
                             m_signal_valid(CMD_VOID),
                             m_new_signal(false),
                             m_reverse(false),
                             m_exit(false)

  {
   if(!m_empty_value.IsSorted())
      m_empty_value.Sort();
   AddEmptyValue(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalBase::~CSignalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Validate(void) const
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Init(CStrategy *s,CComments *comments)
  {
   m_strategy=s;
   m_comments=comments;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::AddEmptyValue(double val)
  {
   m_empty_value.InsertSort(val);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::IsEmpty(double val)
  {
   return m_empty_value.Search(val)>=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSignalBase::CheckSignal(void)
  {
   if(!Active()) return CMD_ALL;
   int res=CMD_NEUTRAL;
   bool long_cond=LongCondition();
   bool short_cond=ShortCondition();
   if(long_cond>0 && short_cond>0) res=CMD_ALL;
   else
     {
      if(long_cond) res=CMD_LONG;
      else if(short_cond) res=CMD_SHORT;
     }
   if(m_reverse) res=CSignalBase::SignalReverse(res);
   if(res>CMD_NEUTRAL) m_signal_valid=res;
   if (m_new_signal)
   {
      if (m_signal==res)
         res = CMD_NEUTRAL;
      else m_signal = res;
   }
   else m_signal=res;
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::IsOrderAgainstSignal(const ENUM_ORDER_TYPE type,const ENUM_CMD res,const bool exact=false)
  {
   if(exact)
     {
      switch(type)
        {
         case ORDER_TYPE_BUY:          return res==CMD_BUY;
         case ORDER_TYPE_SELL:         return res==CMD_SELL;
         case ORDER_TYPE_BUY_LIMIT:    return res==CMD_BUYLIMIT;
         case ORDER_TYPE_BUY_STOP:     return res==CMD_BUYSTOP;
         case ORDER_TYPE_SELL_LIMIT:   return res==CMD_SELLLIMIT;
         case ORDER_TYPE_SELL_STOP:    return res==CMD_SELLSTOP;
         default: PrintFormat(__FUNCTION__+": unknown order type");
        }
     }
   return (IsSignalTypeShort((ENUM_CMD) res) && COrder::IsOrderTypeLong(type))
          ||(IsSignalTypeLong((ENUM_CMD)res) && COrder::IsOrderTypeShort(type))
          || (res==CMD_VOID);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::IsSignalTypeLong(const ENUM_CMD type)
  {
   return type==CMD_LONG || type==CMD_BUY || type==CMD_BUYLIMIT || type==CMD_BUYSTOP;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::IsSignalTypeShort(const ENUM_CMD type)
  {
   return type==CMD_SHORT || type==CMD_SELL || type==CMD_SELLLIMIT || type==CMD_SELLSTOP;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSignalBase::ToString(bool last_valid=false) const
  {
   int signal=last_valid?m_signal_valid:m_signal;
   switch(signal)
     {
      case CMD_VOID:       return "VOID";
      case CMD_NEUTRAL:    return "NEUTRAL";
      case CMD_BUY:        return "BUY";
      case CMD_SELL:       return "SELL";
      case CMD_BUYLIMIT:   return "BUYLIMIT";
      case CMD_SELLLIMIT:  return "SELLLIMIT";
      case CMD_BUYSTOP:    return "BUYSTOP";
      case CMD_SELLSTOP:   return "SELLSTOP";
      case CMD_LONG:       return "LONG";
      case CMD_SHORT:      return "SHORT";
      case CMD_LIMIT:      return "LIMIT";
      case CMD_STOP:       return "STOP";
      case CMD_MARKET:     return "MARKET";
      case CMD_PENDING:    return "PENDING";
      case CMD_ALL:        return "ALL";
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSignalBase::SignalReverse(const int signal)
  {
   switch(signal)
     {
      case CMD_VOID:       return CMD_ALL;
      case CMD_NEUTRAL:    return CMD_NEUTRAL;
      case CMD_BUY:        return CMD_SELL;
      case CMD_SELL:       return CMD_BUY;
      case CMD_BUYLIMIT:   return CMD_SELLLIMIT;
      case CMD_SELLLIMIT:  return CMD_BUYLIMIT;
      case CMD_BUYSTOP:    return CMD_SELLSTOP;
      case CMD_SELLSTOP:   return CMD_BUYSTOP;
      case CMD_LONG:       return CMD_SHORT;
      case CMD_SHORT:      return CMD_LONG;
      case CMD_LIMIT:      return CMD_STOP;
      case CMD_STOP:       return CMD_LIMIT;
      case CMD_MARKET:     return CMD_PENDING;
      case CMD_PENDING:    return CMD_MARKET;
      case CMD_ALL:        return CMD_VOID;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CSignalBase::SignalToOrderType(const int signal)
  {
   switch(signal)
     {
      case CMD_BUY:        return ORDER_TYPE_BUY;
      case CMD_SELL:       return ORDER_TYPE_SELL;
      case CMD_BUYLIMIT:   return ORDER_TYPE_BUY_LIMIT;
      case CMD_SELLLIMIT:  return ORDER_TYPE_SELL_LIMIT;
      case CMD_BUYSTOP:    return ORDER_TYPE_BUY_STOP;
      case CMD_SELLSTOP:   return ORDER_TYPE_SELL_STOP;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Save(const int handle)
  {
   ADT::WriteInteger(handle,m_signal);
   ADT::WriteInteger(handle,m_signal_valid);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalBase::Load(const int handle)
  {
   ADT::ReadInteger(handle,m_signal);
   ADT::ReadInteger(handle,m_signal_valid);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new CComment(comment));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\signal\Signal.mqh"
#else
#include "..\..\mql4\signal\Signal.mqh"
#endif
//+------------------------------------------------------------------+
