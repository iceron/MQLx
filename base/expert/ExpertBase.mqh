//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
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
                     JExpertBase(void);
                    ~JExpertBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_EXPERT);}
   virtual bool      Validate(void) const;
   //--- events
   virtual void      OnTick(void);
   virtual void      OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- getters and setters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual int       OrdersTotal(void) const;
   virtual int       OrdersHistoryTotal(void) const;
   virtual int       TradesTotal(void) const;
   //--- deinitialization
   virtual void      OnDeinit(const int reason=0);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpertBase::JExpertBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpertBase::~JExpertBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JExpertBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      if(!strat.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::OrdersTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strat.OrdersTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::OnTick(void)
  {   
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      strat.OnTick();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      strat.OnChartEvent(id,lparam,dparam,sparam);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::OrdersHistoryTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strat.OrdersHistoryTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::TradesTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strat.TradesTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::OnDeinit(const int reason=0)
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=Detach(i);
      ADT::Delete(strat);
     }
   if(m_data_max!=0)
      Shutdown();
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Expert.mqh"
#else
#include "..\..\mql4\expert\Expert.mqh"
#endif
//+------------------------------------------------------------------+
