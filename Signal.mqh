//+------------------------------------------------------------------+
//|                                                       JSignal.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayDouble.mqh>
#include <Arrays\ArrayObj.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_CMD
  {
   CMD_VOID=-1,
   CMD_NEUTRAL,
   CMD_BUY,
   CMD_SELL,
   CMD_BUYLIMIT,
   CMD_SELLLIMIT,
   CMD_BUYSTOP,
   CMD_SELLSTOP,
   CMD_LONG,
   CMD_SHORT,
   CMD_LIMIT,
   CMD_STOP,
   CMD_MARKET,
   CMD_PENDING,
   CMD_ALL
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JSignal : public CArrayObj
  {
protected:
   string            m_name;
   int               m_signal;
   int               m_signal_valid;
   bool              m_reverse;
   CArrayDouble      m_empty_value;
public:
                     JSignal();
                    ~JSignal();
   //--- signal parameters
   virtual string    Name() const {return(m_name);}
   virtual void      Name(string name) {m_name=name;}
   virtual bool      Reverse() const {return(m_reverse);}
   virtual void      Reverse(bool reverse) {m_reverse=reverse;}
   virtual int       LastSignal() const {return(m_signal);}
   virtual int       LastValidSignal() const {return(m_signal);}
   //--- signal methods
   virtual void      AddEmptyValue(double);
   virtual int       CheckSignal();
   virtual bool      IsEmpty(double val);
protected:
   virtual int       SignalReverse(int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignal::JSignal()
  {
   AddEmptyValue(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignal::~JSignal()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JSignal::AddEmptyValue(double val)
  {
   m_empty_value.Add(val);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignal::IsEmpty(double val)
  {
   if(m_empty_value.Search(val)>=0) return(true);
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSignal::CheckSignal()
  {
   int res=CMD_NEUTRAL;
   bool long_cond=false;
   bool short_cond=false;
   if(long_cond>0 && short_cond>0)
      res=CMD_ALL;
   else
     {
      if(long_cond)
         res=CMD_LONG;
      else if(short_cond)
         res=CMD_SHORT;
     }
   if(m_reverse)
      res=SignalReverse(res);
   if(res!=CMD_NEUTRAL)
      m_signal_valid=res;
   m_signal=res;
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSignal::SignalReverse(int s)
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
