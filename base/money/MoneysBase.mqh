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
#include "MoneyFixedRiskPerPointBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneysBase : public CArrayObj
  {
protected:
   bool              m_active;
   int               m_selected;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CMoneysBase(void);
                    ~CMoneysBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_MONEYS;}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   CObject          *GetContainer(void);
   void              SetContainer(CObject*);
   virtual bool      Validate(void) const;
   //--- setters and getters
   virtual bool      Active(void) const;
   virtual void      Active(const bool);
   virtual int       Selected(void) const;
   virtual void      Selected(const int);
   virtual bool      Selected(const string);
   //--- volume calculation
   virtual double    Volume(const string,const double,const ENUM_ORDER_TYPE,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneysBase::CMoneysBase() : m_active(true)
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
CMoneysBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CMoneysBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneysBase::Active(const bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneysBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneysBase::Selected(const int value)
  {
   m_selected=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CMoneysBase::Selected(void) const
  {
   return m_selected;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneysBase::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo,CEventAggregator *event_man=NULL)
  {
   m_event_man=event_man;
   for(int i=0;i<Total();i++)
     {
      CMoney *money=At(i);
      money.Init(symbolmanager,accountinfo,event_man);
     }
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
      if(!CheckPointer(money))
         continue;
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
   if(CheckPointer(money))
      return money.Volume(symbol,price,type,sl);
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
      if(!CheckPointer(money))
         continue;
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
