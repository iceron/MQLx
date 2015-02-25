//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayDouble.mqh>
#include "..\..\common\enum\ENUM_CMD.mqh"
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
   JStrategy        *m_strategy;
   CArrayDouble      m_empty_value;
   JSignals         *m_signals;
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
   virtual bool      ExitSignal(void) const{return(m_exit);}
   virtual void      ExitSignal(const bool exit) {m_exit=exit;}
   virtual string    Name(void) const {return(m_name);}
   virtual void      Name(const string name) {m_name=name;}
   virtual bool      Reverse(void) const {return(m_reverse);}
   virtual void      Reverse(const bool reverse) {m_reverse=reverse;}
   virtual int       LastEntry(void) const {return(m_signal);}
   virtual int       LastValidSignal(void) const {return(m_signal_valid);}
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
   static int        SignalReverse(const int s);
   static ENUM_ORDER_TYPE SignalToOrderType(const int s);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalBase::JSignalBase(void) : m_activate(true),
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
            Print(__FUNCTION__+": unknown order type");
           }
        }
     }
   return((IsSignalTypeShort((ENUM_CMD) res) && JOrder::IsOrderTypeLong(type))
          || (IsSignalTypeLong((ENUM_CMD)res) && JOrder::IsOrderTypeShort(type))
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
int JSignalBase::SignalReverse(const int s)
  {
   switch(s)
     {
      case CMD_VOID:
        {
         return(CMD_ALL);
        }
      case CMD_NEUTRAL:
        {
         return(CMD_NEUTRAL);
        }
      case CMD_BUY:
        {
         return(CMD_SELL);
        }
      case CMD_SELL:
        {
         return(CMD_BUY);
        }
      case CMD_BUYLIMIT:
        {
         return(CMD_SELLLIMIT);
        }
      case CMD_SELLLIMIT:
        {
         return(CMD_BUYLIMIT);
        }
      case CMD_BUYSTOP:
        {
         return(CMD_SELLSTOP);
        }
      case CMD_SELLSTOP:
        {
         return(CMD_BUYSTOP);
        }
      case CMD_LONG:
        {
         return(CMD_SHORT);
        }
      case CMD_SHORT:
        {
         return(CMD_LONG);
        }
      case CMD_LIMIT:
        {
         return(CMD_STOP);
        }
      case CMD_STOP:
        {
         return(CMD_LIMIT);
        }
      case CMD_MARKET:
        {
         return(CMD_PENDING);
        }
      case CMD_PENDING:
        {
         return(CMD_MARKET);
        }
      case CMD_ALL:
        {
         return(CMD_VOID);
        }
     }
   return(s);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE JSignalBase::SignalToOrderType(const int s)
  {
   ENUM_ORDER_TYPE ret=ORDER_TYPE_BUY;
   switch(s)
     {
      case CMD_BUY:
         ret=ORDER_TYPE_BUY;
         break;
      case CMD_SELL:
         ret=ORDER_TYPE_SELL;
         break;
      case CMD_BUYLIMIT:
         ret=ORDER_TYPE_BUY_LIMIT;
         break;
      case CMD_SELLLIMIT:
         ret=ORDER_TYPE_SELL_LIMIT;
         break;
      case CMD_BUYSTOP:
         ret=ORDER_TYPE_BUY_STOP;
         break;
      case CMD_SELLSTOP:
         ret=ORDER_TYPE_SELL_STOP;
         break;
     }
   return(ret);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\signal\Signal.mqh"
#else
#include "..\..\mql4\signal\Signal.mqh"
#endif
//+------------------------------------------------------------------+
