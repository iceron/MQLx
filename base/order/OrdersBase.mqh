//+------------------------------------------------------------------+
//|                                                       JOrdersBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "OrderBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_SORT_MODE
  {
   SORT_MODE_ASCENDING,
   SORT_MODE_DESCENDING
  };
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrdersBase : public CArrayObj
  {
protected:
   bool              m_activate;
   JStrategy        *m_strategy;
public:
                     JOrdersBase(void);
                    ~JOrdersBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_ORDERS);}                    
   //--- initialization
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}                    
   //--- getters and setters
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- events                  
   virtual void      OnTick(void);
   //--- archiving
   virtual bool      CloseStops(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::JOrdersBase(void) : m_activate(true)
  {
   m_sort_mode=SORT_MODE_ASCENDING;
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
