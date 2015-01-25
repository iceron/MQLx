//+------------------------------------------------------------------+
//|                                                   OrdersBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "OrderBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrdersBase : public CArrayObj
  {
protected:
   bool              m_activate;
   bool              m_clean;
   JStrategy        *m_strategy;
public:
                     JOrdersBase(void);
                    ~JOrdersBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_ORDERS);}
   //--- initialization
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   //--- getters and setters
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(const bool activate) {m_activate=activate;}
   virtual bool      Clean(void) const {return(m_clean);}
   virtual void      Clean(const bool clean) {m_clean=clean;} 
   //--- events                  
   virtual void      OnTick(void);
   //--- archiving
   virtual bool      CloseStops(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::JOrdersBase(void) : m_activate(true),
                                 m_clean(false)
  {
   if (!IsSorted()) Sort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::~JOrdersBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrdersBase::OnTick(void)
  {
   for(int i=0;i<Total();i++)
     {
      JOrder *order=At(i);
      if(CheckPointer(order))
         order.CheckStops();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::CloseStops(void)
  {
   bool res=true;
   for(int i=0;i<Total();i++)
     {
      JOrder *order=At(i);
      if(CheckPointer(order))
         if(!order.CloseStops())
            res=false;
     }
   return(res);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\Orders.mqh"
#else
#include "..\..\mql4\order\Orders.mqh"
#endif
//+------------------------------------------------------------------+
