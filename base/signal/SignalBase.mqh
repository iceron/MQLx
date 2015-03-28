//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_CMD.mqh"
#include <Arrays\ArrayDouble.mqh>
#include <Files\FileBin.mqh>
#include "..\indicator\IndicatorsBase.mqh"
class JStrategy;
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
   bool              m_exit;
   JIndicators      *m_indicators;
   JStrategy        *m_strategy;
   CArrayDouble      m_empty_value;
   JSignals         *m_signals;
   JEvent           *m_event;
public:
                     JSignalBase();
                    ~JSignalBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_SIGNAL);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JSignals *signals){m_signals=signals;}
   virtual bool      Validate(void) const;
   //--- getters and setters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual bool      ExitSignal(void) const{return(m_exit);}
   virtual void      ExitSignal(const bool exit) {m_exit=exit;}
   virtual string    Name(void) const {return(m_name);}
   virtual void      Name(const string name) {m_name=name;}
   virtual bool      Reverse(void) const {return(m_reverse);}
   virtual void      Reverse(const bool reverse) {m_reverse=reverse;}
   virtual int       LastEntry(void) const {return(m_signal);}
   virtual int       LastValidSignal(void) const {return(m_signal_valid);}
   virtual string    ToString(bool last_valid=false) const;
   //--- indicators
   JIndicator       *IndicatorAt(const int idx) const;
   void              AddIndicator(JIndicator *indicator);
   //--- signal methods
   virtual void      AddEmptyValue(const double val);
   virtual int       CheckSignal(void);
   virtual bool      IsEmpty(const double val);
   virtual ENUM_CMD  LongCondition(void) {return(0);}
   virtual ENUM_CMD  ShortCondition(void) {return(0);}
   //--- static methods
   static bool       IsOrderAgainstSignal(const ENUM_ORDER_TYPE type,const ENUM_CMD res,const bool exact=false);
   static bool       IsSignalTypeLong(const ENUM_CMD type);
   static bool       IsSignalTypeShort(const ENUM_CMD type);
   static int        SignalReverse(const int signal);
   static ENUM_ORDER_TYPE SignalToOrderType(const int signal);
   //--- recovery
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalBase::JSignalBase() : m_activate(true),
                                 m_name(NULL),
                                 m_signal(CMD_NEUTRAL),
                                 m_signal_valid(CMD_VOID),
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
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JSignalBase::AddIndicator(JIndicator *indicator)
  {
   m_indicators.Add(indicator);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JIndicator *JSignalBase::IndicatorAt(const int idx) const
  {
   return(m_indicators.At(idx));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JSignalBase::AddEmptyValue(double val)
  {
   m_empty_value.InsertSort(val);
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
   if(m_reverse) res=JSignalBase::SignalReverse(res);
   if(res>CMD_NEUTRAL) m_signal_valid=res;
   m_signal=res;
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::IsOrderAgainstSignal(const ENUM_ORDER_TYPE type,const ENUM_CMD res,const bool exact=false)
  {
   if(exact)
     {
      switch(type)
        {
         case ORDER_TYPE_BUY:
           {
            if(res==CMD_BUY)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_SELL:
           {
            if(res==CMD_SELL)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_BUY_LIMIT:
           {
            if(res==CMD_BUYLIMIT)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_BUY_STOP:
           {
            if(res==CMD_BUYSTOP)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_SELL_LIMIT:
           {
            if(res==CMD_SELLLIMIT)
               return(true);
            else
               return(false);
           }
         case ORDER_TYPE_SELL_STOP:
           {
            if(res==CMD_SELLSTOP)
               return(true);
            else
               return(false);
           }
         default:
           {
            PrintFormat(__FUNCTION__+": unknown order type");
           }
        }
     }
   return((IsSignalTypeShort((ENUM_CMD) res) && JOrder::IsOrderTypeLong(type))
          ||(IsSignalTypeLong((ENUM_CMD)res) && JOrder::IsOrderTypeShort(type))
          || (res==CMD_VOID));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::IsSignalTypeLong(const ENUM_CMD type)
  {
   return(type==CMD_LONG || type==CMD_BUY || type==CMD_BUYLIMIT || type==CMD_BUYSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::IsSignalTypeShort(const ENUM_CMD type)
  {
   return(type==CMD_SHORT || type==CMD_SELL || type==CMD_SELLLIMIT || type==CMD_SELLSTOP);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string JSignalBase::ToString(bool last_valid=false) const
  {
   int signal=last_valid?m_signal_valid:m_signal;
   switch(signal)
     {
      case CMD_VOID:       return("VOID");
      case CMD_NEUTRAL:    return("NEUTRAL");
      case CMD_BUY:        return("BUY");
      case CMD_SELL:       return("SELL");
      case CMD_BUYLIMIT:   return("BUYLIMIT");
      case CMD_SELLLIMIT:  return("SELLLIMIT");
      case CMD_BUYSTOP:    return("BUYSTOP");
      case CMD_SELLSTOP:   return("SELLSTOP");
      case CMD_LONG:       return("LONG");
      case CMD_SHORT:      return("SHORT");
      case CMD_LIMIT:      return("LIMIT");
      case CMD_STOP:       return("STOP");
      case CMD_MARKET:     return("MARKET");
      case CMD_PENDING:    return("PENDING");
      case CMD_ALL:        return("ALL");
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSignalBase::SignalReverse(const int signal)
  {
   switch(signal)
     {
      case CMD_VOID:       return(CMD_ALL);
      case CMD_NEUTRAL:    return(CMD_NEUTRAL);
      case CMD_BUY:        return(CMD_SELL);
      case CMD_SELL:       return(CMD_BUY);
      case CMD_BUYLIMIT:   return(CMD_SELLLIMIT);
      case CMD_SELLLIMIT:  return(CMD_BUYLIMIT);
      case CMD_BUYSTOP:    return(CMD_SELLSTOP);
      case CMD_SELLSTOP:   return(CMD_BUYSTOP);
      case CMD_LONG:       return(CMD_SHORT);
      case CMD_SHORT:      return(CMD_LONG);
      case CMD_LIMIT:      return(CMD_STOP);
      case CMD_STOP:       return(CMD_LIMIT);
      case CMD_MARKET:     return(CMD_PENDING);
      case CMD_PENDING:    return(CMD_MARKET);
      case CMD_ALL:        return(CMD_VOID);
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE JSignalBase::SignalToOrderType(const int signal)
  {
   switch(signal)
     {
      case CMD_BUY:        return(ORDER_TYPE_BUY);
      case CMD_SELL:       return(ORDER_TYPE_SELL);
      case CMD_BUYLIMIT:   return(ORDER_TYPE_BUY_LIMIT);
      case CMD_SELLLIMIT:  return(ORDER_TYPE_SELL_LIMIT);
      case CMD_BUYSTOP:    return(ORDER_TYPE_BUY_STOP);
      case CMD_SELLSTOP:   return(ORDER_TYPE_SELL_STOP);
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::Backup(CFileBin *file)
  {
   file.WriteChar(m_activate);
   file.WriteString(m_name);
   file.WriteInteger(m_signal);
   file.WriteInteger(m_signal_valid);
   file.WriteChar(m_reverse);
   file.WriteChar(m_exit);
   file.WriteObject(GetPointer(m_indicators));
   file.WriteObject(GetPointer(m_empty_value));
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalBase::Restore(CFileBin *file)
  {
   file.ReadChar(m_activate);
   file.ReadString(m_name);
   file.ReadInteger(m_signal);
   file.ReadInteger(m_signal_valid);
   file.ReadChar(m_reverse);
   file.ReadChar(m_exit);
   file.ReadObject(GetPointer(m_indicators));
   file.ReadObject(GetPointer(m_empty_value));
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\signal\Signal.mqh"
#else
#include "..\..\mql4\signal\Signal.mqh"
#endif
//+------------------------------------------------------------------+
