//+------------------------------------------------------------------+
//|                                                   MoneysBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
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
   virtual bool      Validate(void);
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
bool JMoneysBase::Validate(void)
  {
   for(int i=0;i<Total();i++)
     {
      JMoney *money=At(i);
      if (money==NULL) continue;
      if(!money.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JMoneysBase::Volume(double price,ENUM_ORDER_TYPE type,double sl)
  {
   JMoney *money=m_data[m_selected];
   return(money==NULL?0:money.Volume(price,type,sl));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\Moneys.mqh"
#else
#include "..\..\mql4\money\Moneys.mqh"
#endif
//+------------------------------------------------------------------+
