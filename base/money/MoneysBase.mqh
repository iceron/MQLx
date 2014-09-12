//+------------------------------------------------------------------+
//|                                                   MoneysBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "MoneyFixedMarginBase.mqh"
#include "MoneyFixedRiskBase.mqh"
#include "MoneyFixedRiskPerPipBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JMoneysBase : public CArrayObj
  {
public:
                     JMoneysBase();
                    ~JMoneysBase();
   virtual int       Type() {return(CLASS_TYPE_MONEYS);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneysBase::JMoneysBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneysBase::~JMoneysBase()
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\Moneys.mqh"
#else
#include "..\..\mql4\money\Moneys.mqh"
#endif
//+------------------------------------------------------------------+
