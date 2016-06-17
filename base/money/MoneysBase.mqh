//+------------------------------------------------------------------+
//|                                                   MoneysBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "MoneyFixedFractionalBase.mqh"
#include "MoneyFixedRatioBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneysBase : public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_selected;
   CExpertAdvisor   *m_strategy;
public:
                     CMoneysBase(void);
                    ~CMoneysBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_MONEYS;}
   virtual bool      Validate(void) const;
   //--- initialization
   virtual bool      Init(CExpertAdvisor *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo);
   virtual void      SetContainer(CExpertAdvisor *s) {m_strategy=s;}
   //--- setters and getters
   virtual bool      Active(void) const {return m_activate;}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual int       Selected(void) const {return m_selected;}
   virtual void      Selected(const bool select) {m_selected=select;}
   virtual bool      Selected(const string select);
   //--- volume calculation
   virtual double    Volume(const string,const double,const ENUM_ORDER_TYPE,const double);
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
bool CMoneysBase::Init(CExpertAdvisor *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   for(int i=0;i<Total();i++)
     {
      CMoney *money=At(i);
      money.Init(GetPointer(symbolmanager),GetPointer(accountinfo));
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
      if(money==NULL) continue;
      if(!money.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneysBase::Volume(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl=0)
  {
   CMoney *money=At(m_selected);
   if(money!=NULL)
      return money.Volume(symbol,price,type,sl);
   Print(__FUNCTION__+": currently selected money management method does not exist");
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneysBase::Selected(const string select)
  {
   for(int i=0;i<Total();i++)
     {
      CMoney *money=At(i);
      if(money==NULL) continue;
      if(StringCompare(money.Name(),select))
        {
         Selected(i);
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\Moneys.mqh"
#else
#include "..\..\MQL4\Money\Moneys.mqh"
#endif
//+------------------------------------------------------------------+
