//+------------------------------------------------------------------+
//|                                                    EventBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Object.mqh>
class CEventAggregator;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CEventSubscriberBase : public CObject
  {
protected:
   string            m_name;
   int               m_object_type;
   CEventAggregator *m_container;
public:
                     CEventSubscriberBase(void);
                    ~CEventSubscriberBase(void);
   virtual bool      Init(void);                    
   virtual CEventAggregator *GetContainer(void) const {return m_container;}
   virtual void      SetContainer(CEventAggregator *aggregator) {m_container=aggregator;}
   virtual void      Notify(string,CObject*);
   virtual bool      CheckName(string);
   virtual bool      CheckSubject(CObject*);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventSubscriberBase::CEventSubscriberBase(void) : m_name(NULL),
                                                   m_object_type(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventSubscriberBase::~CEventSubscriberBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CEventSubscriberBase::Init(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventSubscriberBase::Notify(string name,CObject *subject)
  {
   if(CheckName(name) && CheckSubject(subject))
     {
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CEventSubscriberBase::CheckName(string name)
  {
   return StringCompare(m_name,name)==0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CEventSubscriberBase::CheckSubject(CObject *subject)
  {
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Event\EventSubscriber.mqh"
#else
#include "..\..\MQL4\Event\EventSubscriber.mqh"
#endif
//+------------------------------------------------------------------+
