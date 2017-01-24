//+------------------------------------------------------------------+
//|                                                    StopsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "StopBase.mqh"
class CExpertAdvisor;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStopsBase : public CArrayObj
  {
protected:
   bool              m_active;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CStopsBase(void);
                    ~CStopsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOPS;}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   virtual bool      Validate(void) const;
   //--- setters and getters
   virtual bool      Active(void) const;
   virtual void      Active(const bool);
   virtual CStop    *Main(void);
   //--- recovery
   virtual bool      CreateElement(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopsBase::CStopsBase(void) : m_active(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopsBase::~CStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject  *CStopsBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopsBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStopsBase::Active(const bool activate)
  {
   m_active=activate;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo,CEventAggregator *event_man=NULL)
  {
   m_event_man=event_man;
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      if(CheckPointer(stop))
         if(!stop.Init(symbolmanager,accountinfo,event_man))
            return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::Validate(void) const
  {
   bool main= false;
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      if(CheckPointer(stop))
        {
         if(stop.Main())
           {
            if(main)
              {
               PrintFormat(__FUNCTION__+": more than one main stop is not allowed");
               return false;
              }
           }
         if(!stop.Validate())
            return false;
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop *CStopsBase::Main()
  {
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      if(!CheckPointer(stop))
         continue;
      if(stop.Main())
         return stop;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::CreateElement(const int index)
  {
   CStop*stop=new CStop();
   stop.SetContainer(GetPointer(this));
   return Insert(GetPointer(stop),index);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Stop\Stops.mqh"
#else
#include "..\..\MQL4\Stop\Stops.mqh"
#endif
//+------------------------------------------------------------------+
