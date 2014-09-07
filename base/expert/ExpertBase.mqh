//+------------------------------------------------------------------+
//|                                                       Expert.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "StrategyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JExpertBase : public CArrayObj
  {
protected:
   bool              m_activate;
public:
                     JExpertBase();
                    ~JExpertBase();
   //--- events
   virtual void      OnTick();
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- orders
   virtual int       OrdersTotal(void);
   virtual int       OrdersHistoryTotal(void);
   virtual int       TradesTotal(void);
   //--- deinitialization
   virtual bool      Deinit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpertBase::JExpertBase() : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpertBase::~JExpertBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::OrdersTotal()
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strategy.OrdersTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::OnTick(void)
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      bool res=strategy.OnTick();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::OrdersHistoryTotal()
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strategy.OrdersHistoryTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::TradesTotal()
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strategy.TradesTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JExpertBase::Deinit(void)
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      bool res=strategy.Deinit();
     }
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Expert.mqh"
#else
#include "..\..\mql4\expert\Expert.mqh"
#endif
//+------------------------------------------------------------------+
