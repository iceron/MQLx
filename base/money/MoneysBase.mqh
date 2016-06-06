//+------------------------------------------------------------------+
//|                                                   MoneysBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "MoneyFixedFractionalBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneysBase : public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_selected;
   CExpert        *m_strategy;
public:
                     CMoneysBase(void);
                    ~CMoneysBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_MONEYS;}
   virtual bool      Validate(void) const;
   //--- initialization
   virtual bool      Init(CExpert *s,CSymbolInfo *symbolinfo,CAccountInfo *accountinfo);
   virtual void      SetContainer(CExpert *s) {m_strategy=s;}
   //--- setters and getters
   virtual bool      Active(void) const {return m_activate;}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual int       Selected(void) const {return m_selected;}
   virtual void      Selected(const bool select) {m_selected=select;}
   //--- volume calculation
   virtual double    Volume(const double price,const ENUM_ORDER_TYPE type,const double sl);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneysBase::CMoneysBase() : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneysBase::~CMoneysBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneysBase::Init(CExpert *s,CSymbolInfo *symbolinfo,CAccountInfo *accountinfo)
  {
   for(int i=0;i<Total();i++)
     {
      CMoney *money=At(i);
      money.Init(GetPointer(symbolinfo),GetPointer(accountinfo));
     }
   SetContainer(s);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneysBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CMoney *money=At(i);
      if (money==NULL) continue;
      if(!money.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneysBase::Volume(const double price,const ENUM_ORDER_TYPE type,const double sl)
  {
   CMoney *money=m_data[m_selected];
   return money==NULL?0:money.Volume(price,type,sl);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\Moneys.mqh"
#else
#include "..\..\mql4\money\Moneys.mqh"
#endif
//+------------------------------------------------------------------+
