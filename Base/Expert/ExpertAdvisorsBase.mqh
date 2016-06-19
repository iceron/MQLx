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
   CComments        *m_comments;
   CObject          *m_container;
public:
                     CExpertAdvisorsBase(void);
                    ~CExpertAdvisorsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_EXPERT;}
   virtual void      SetContainer(CObject *container) {m_container=container;}
   //--- getters and setters
   bool              Active(void) const {return m_active;}
   void              Active(const bool activate) {m_active=activate;}
   void              ChartComment(const bool enable=true);
   int               OrdersTotal(void) const;
   int               OrdersHistoryTotal(void) const;
   int               TradesTotal(void) const;
   //--- initialization
   virtual bool      Validate(void) const;
   virtual bool      InitComponents(void) const;
   //--- events
   virtual void      OnTick(void);
   virtual void      OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- chart comments
   virtual void      AddComment(const string comment);
   virtual void      DisplayComment(void) const;
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
void CExpertAdvisorsBase::ChartComment(const bool enable=true)
  {
   if(enable) m_comments=new CComments();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::InitComponents(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CExpertAdvisor *e=At(i);
      if(CheckPointer(m_comments))
         e.ChartComment(GetPointer(m_comments));
      e.InitComponents();
     }
   return true;
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
   DisplayComment();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new CComment(comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertAdvisorsBase::DisplayComment(void) const
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Display();
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
   CExpertAdvisor*e=new CExpertAdvisor();
   e.SetContainer(GetPointer(this));
   return Insert(GetPointer(e),index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::Save(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertAdvisorsBase::Load(const int handle)
  {
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Expert\ExpertAdvisors.mqh"
#else
#include "..\..\MQL4\Expert\ExpertAdvisors.mqh"
#endif
//+------------------------------------------------------------------+
