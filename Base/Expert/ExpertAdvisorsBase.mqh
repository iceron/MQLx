//+------------------------------------------------------------------+
//|                                                  ExpertsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include <Files\FileBin.mqh>
#include "ExpertAdvisorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertsBase : public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_uninit_reason;
   CComments        *m_comments;
public:
                     CExpertsBase(void);
                    ~CExpertsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_EXPERT;}
   //--- getters and setters
   bool              Active(void) const {return m_activate;}
   void              Active(const bool activate) {m_activate=activate;}
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
CExpertsBase::CExpertsBase(void) : m_activate(true),
                                   m_uninit_reason(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertsBase::~CExpertsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertsBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      if(!strat.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertsBase::ChartComment(const bool enable=true)
  {
   if(enable) m_comments=new CComments();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertsBase::InitComponents(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      if(CheckPointer(m_comments))
         strat.ChartComment(GetPointer(m_comments));
      strat.InitComponents();
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertsBase::OrdersTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      total+=strat.OrdersTotal();
     }
   return total;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertsBase::OnTick(void)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      strat.OnTick();
     }
   DisplayComment();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertsBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new CComment(comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertsBase::DisplayComment(void) const
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Display();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertsBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      strat.OnChartEvent(id,lparam,dparam,sparam);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertsBase::OrdersHistoryTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      total+=strat.OrdersHistoryTotal();
     }
   return total;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CExpertsBase::TradesTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      CExpert *strat=At(i);
      total+=strat.TradesTotal();
     }
   return total;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertsBase::OnDeinit(const int reason=0)
  {
   m_uninit_reason=reason;
   Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertsBase::CreateElement(const int index)
  {
   CExpert*strat=new CExpert();
   strat.SetContainer(GetPointer(this));
   return Insert(GetPointer(strat),index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertsBase::Save(const int handle)
  {
   CArrayObj::Save(handle);
   ADT::WriteInteger(handle,m_uninit_reason);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertsBase::Load(const int handle)
  {
   CArrayObj::Load(handle);
   ADT::ReadInteger(handle,m_uninit_reason);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Expert\ExpertAdvisors.mqh"
#else
#include "..\..\MQL4\Expert\ExpertAdvisors.mqh"
#endif
//+------------------------------------------------------------------+
