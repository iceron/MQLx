//+------------------------------------------------------------------+
//|                                                    EventBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Object.mqh>
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
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
   virtual int       Type(void) const {return(CLASS_TYPE_EVENT_SUBSCRIBER);}
   virtual bool      Init(void);
   virtual bool      Validate(void) const;
   virtual CEventAggregator *GetContainer(void);
   virtual void      SetContainer(CEventAggregator *aggregator);
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
bool CEventSubscriberBase::Validate(void) const
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventSubscriberBase::SetContainer(CEventAggregator *aggregator)
  {
   m_container=aggregator;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventAggregator *CEventSubscriberBase::GetContainer(void)
  {
   return m_container;
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
