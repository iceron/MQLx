//+------------------------------------------------------------------+
//|                                                  ExpertsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "ExpertAdvisorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisorsBase : public CArrayObj
  {
protected:
   bool              m_active;
   int               m_uninit_reason;
   CObject          *m_container;
public:
                     CExpertAdvisorsBase(void);
                    ~CExpertAdvisorsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_EXPERTS;}
   //--- getters and setters
   void              SetContainer(CObject *container);
   CObject          *GetContainer(void);
   bool              Active(void) const;
   void              Active(const bool);
   int               OrdersTotal(void) const;
   int               OrdersHistoryTotal(void) const;
   int               TradesTotal(void) const;
   //--- initialization
   virtual bool      Validate(void) const;
   virtual bool      InitComponents(void) const;
   //--- events
   virtual void      OnTick(void);
   virtual void      OnChartEvent(const int,const long&,const double&,const string&);
   virtual void      OnTimer(void);
   virtual void      OnTrade(void);
   //--- deinitialization
   virtual void      OnDeinit(const int reason=0);
   //--- recovery
   virtual bool      CreateElement(const int);
   virtual bool      Save(const int);
   virtual bool      Load(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorsBase::CExpertAdvisorsBase(void) : m_active(true),
                                                 m_uninit_reason(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorsBase::~CExpertAdvisorsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisorsBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CExpertAdvisorsBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      if(!e.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::InitComponents(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      e.InitComponents();
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::Active(const bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorsBase::OrdersTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      total+=e.OrdersTotal();
     }
   return total;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::OnTick(void)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      e.OnTick();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::OnTrade(void)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      e.OnTrade();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::OnTimer(void)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      e.OnTimer();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      e.OnChartEvent(id,lparam,dparam,sparam);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorsBase::OrdersHistoryTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      total+=e.OrdersHistoryTotal();
     }
   return total;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertAdvisorsBase::TradesTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      total+=e.TradesTotal();
     }
   return total;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::OnDeinit(const int reason=0)
  {
   m_uninit_reason=reason;
   Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::CreateElement(const int index)
  {
   CExpertAdvisor*expert_advisor=new CExpertAdvisor();
   if(!CheckPointer(expert_advisor))
      return(false);
   expert_advisor.SetContainer(GetPointer(this));
   if(!Reserve(1))
      return(false);
   m_data[index]=expert_advisor;
   m_sort_mode=-1;
   return CheckPointer(m_data[index]);;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::Save(const int handle)
  {
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      if(!e.Save(handle))
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::Load(const int handle)
  {
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      if(!e.Load(handle))
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Expert\ExpertAdvisors.mqh"
#else
#include "..\..\MQL4\Expert\ExpertAdvisors.mqh"
#endif
//+------------------------------------------------------------------+
