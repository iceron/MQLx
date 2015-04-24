//+------------------------------------------------------------------+
//|                                                   ExpertBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include <Files\FileBin.mqh>
#include "StrategyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JExpertBase : public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_uninit_reason;
   JComments        *m_comments;
public:
                     JExpertBase(void);
                    ~JExpertBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_EXPERT);}
   //--- getters and setters
   bool              Active(void) const {return(m_activate);}
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
   virtual bool      CreateElement(const int index);
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpertBase::JExpertBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JExpertBase::~JExpertBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JExpertBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      if(!strat.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::ChartComment(const bool enable=true)
  {
   if(enable) m_comments=new JComments();     
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JExpertBase::InitComponents(void) const
  {
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      if (CheckPointer(m_comments))
         strat.ChartComment(GetPointer(m_comments));
      strat.InitComponents();
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::OrdersTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strat.OrdersTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::OnTick(void)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      strat.OnTick();
     }
   DisplayComment();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new JComment(comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::DisplayComment(void) const
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Display();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(!Active()) return;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      strat.OnChartEvent(id,lparam,dparam,sparam);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::OrdersHistoryTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strat.OrdersHistoryTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JExpertBase::TradesTotal(void) const
  {
   int total=0;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=At(i);
      total+=strat.TradesTotal();
     }
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JExpertBase::OnDeinit(const int reason=0)
  {
   m_uninit_reason=reason;
   for(int i=0;i<Total();i++)
     {
      JStrategy *strat=Detach(i);
      ADT::Delete(strat);
     }
   if(m_data_max!=0)
      Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JExpertBase::CreateElement(const int index)
  {
   JStrategy*strat=new JStrategy();
   strat.SetContainer(GetPointer(this));
   return(Insert(GetPointer(strat),index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JExpertBase::Save(const int handle)
  {
   CArrayObj::Save(handle);
   ADT::WriteInteger(handle,m_uninit_reason);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JExpertBase::Load(const int handle)
  {
   CArrayObj::Load(handle);
   ADT::ReadInteger(handle,m_uninit_reason);
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Expert.mqh"
#else
#include "..\..\mql4\expert\Expert.mqh"
#endif
//+------------------------------------------------------------------+
