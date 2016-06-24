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
   bool              m_active;
   CObject          *m_container;
public:
                     CEventAggregatorBase(void);
                    ~CEventAggregatorBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_EVENT_AGGREGATOR);}
   virtual bool      Init(void);
   virtual bool      Validate(void) const;
   void              Active(bool);
   bool              Active(void) const;
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject *container);
   virtual void      Publish(string,CObject*);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventAggregatorBase::CEventAggregatorBase(void) : m_active(true)
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
CEventAggregatorBase::Active(bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CEventAggregatorBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CEventAggregatorBase::Validate(void) const
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventAggregatorBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CEventAggregatorBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CEventAggregatorBase::Init(void)
  {
   for(int i=0;i<Total();i++)
     {
      CEventSubscriber *subscriber=At(i);
      if(CheckPointer(subscriber))
         if(!subscriber.Init())
            return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventAggregatorBase::Publish(string name,CObject *subject=NULL)
  {
   if(Active())
     {
      for(int i=0;i<Total();i++)
        {
         CEventSubscriber *subscriber=At(i);
         if(CheckPointer(subscriber))
            subscriber.Notify(name,subject);
        }
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Event\EventAggregator.mqh"
#else
#include "..\..\MQL4\Event\EventAggregator.mqh"
#endif
//+------------------------------------------------------------------+
