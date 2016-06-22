//+------------------------------------------------------------------+
//|                                             EventAggregatorBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "EventSubscriberBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CEventAggregatorBase : public CArrayObj
  {
protected:
   CObject          *m_container;
public:
                     CEventAggregatorBase(void);
                    ~CEventAggregatorBase(void);
   virtual CObject  *GetContainer(void) const {return GetPointer(m_container);}                    
   virtual void      SetContainer(CObject *container){m_container=container;}
   virtual void      Publish(string,CObject*);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventAggregatorBase::CEventAggregatorBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventAggregatorBase::~CEventAggregatorBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventAggregatorBase::Publish(string name,CObject *subject=NULL)
  {
   for(int i=0;i<Total();i++)
     {
      CEventSubscriber *subscriber=At(i);
      if(CheckPointer(subscriber))
         subscriber.Notify(name,subject);
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Event\EventAggregator.mqh"
#else
#include "..\..\MQL4\Event\EventAggregator.mqh"
#endif
//+------------------------------------------------------------------+
