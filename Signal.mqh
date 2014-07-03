//+------------------------------------------------------------------+
//|                                                       JSignal.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Object.mqh>
#include <Arrays\ArrayDouble.mqh>
#include <Arrays\ArrayObj.mqh>
/*
#define CMD_VOID        -1
#define CMD_NEUTRAL     0
#define CMD_BUY         1
#define CMD_SELL        2
#define CMD_BUYLIMIT    3
#define CMD_SELLLIMIT   4
#define CMD_BUYSTOP     5
#define CMD_SELLSTOP    6
#define CMD_LONG        7
#define CMD_SHORT       8
#define CMD_LIMIT       9
#define CMD_STOP        10
#define CMD_MARKET      11
#define CMD_PENDING     12
#define CMD_ALL         13
*/
enum cmd {
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
private:

protected:
   string            m_name;
   int               m_signal;
   bool              m_reverse;   
   CArrayDouble      m_empty_value;
public:
                     JSignal();
                    ~JSignal();

   void              AddEmptyValue(double);
   virtual int       LastSignal();
   virtual int       SignalReverse(int);
   virtual bool      IsEmpty(double);
   virtual int       CheckSignal();
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


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
   return(res);
  }
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
//|                                                                  |
//+------------------------------------------------------------------+
