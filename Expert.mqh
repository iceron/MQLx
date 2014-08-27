//+------------------------------------------------------------------+
//|                                                       Expert.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "Strategy.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JExpert : public CArrayObj
  {
private:

public:
                     JExpert();
                    ~JExpert();
   //--- events
   virtual void      OnTick(void);
   virtual void      OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result);
   //--- orders
   virtual int       OrdersTotal(void);
   virtual int       OrdersHistoryTotal(void);
   virtual int       TradesTotal(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpert::JExpert()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpert::~JExpert()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpert::OnTick(void)
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strategy=At(i);
      bool res=strategy.OnTick();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpert::OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strategy=At(i);
      strategy.OnTradeTransaction(trans,request,result);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpert::OrdersTotal()
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strategy=At(i);
      total+=strategy.OrdersTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpert::OrdersHistoryTotal()
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strategy=At(i);
      total+=strategy.OrdersHistoryTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpert::TradesTotal()
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strategy=At(i);
      total+=strategy.TradesTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
