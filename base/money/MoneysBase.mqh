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
protected:
   bool              m_activate;
   int               m_selected;
   JStrategy        *m_strategy;
public:
                     JMoneysBase(void);
                    ~JMoneysBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_MONEYS);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JStrategy *s) {m_strategy=s;}
   //--- setters and getters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   virtual int       Selected(void) const {return(m_selected);}
   virtual void      Selected(bool select) {m_selected=select;}
   //--- volume calculation
   virtual double    Volume(double price,ENUM_ORDER_TYPE type,double sl);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneysBase::JMoneysBase() : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneysBase::~JMoneysBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneysBase::Init(JStrategy *s)
  {
   for(int i=0;i<Total();i++)
     {
      JMoney *money=At(i);
      money.Init(s);
     }
   SetContainer(s);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JMoneysBase::Volume(double price,ENUM_ORDER_TYPE type,double sl)
  {
   JMoney *money=m_data[m_selected];
   return(money.Volume(price,type,sl));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\Moneys.mqh"
#else
#include "..\..\mql4\money\Moneys.mqh"
#endif
//+------------------------------------------------------------------+
