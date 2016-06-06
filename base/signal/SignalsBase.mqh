//+------------------------------------------------------------------+
//|                                                  SignalsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Files\FileBin.mqh>
#include "SignalBase.mqh"
class CExpert;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSignalsBase: public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_last_entry;
   int               m_last_exit;
   bool              m_new_signal;
   bool              m_reverse;
   CExpert        *m_strategy;
   CComments        *m_comments;
public:
                     CSignalsBase(void);
                    ~CSignalsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_SIGNALS;}
   //--- initialization
   virtual bool      Init(CExpert *s,CComments *comments);
   virtual void      SetContainer(CExpert *s){m_strategy=s;}
   virtual bool      Validate() const;
   //--- checking   
   virtual bool      Active(void) const{return m_activate;}
   virtual void      Active(const bool active) {m_activate=active;}
   virtual int       CheckEntry() const;
   virtual int       CheckExit() const;
   virtual bool      CheckSignals(int &entry,int &exit);
   virtual int       NewSignal(void) const {return m_new_signal;}
   virtual void      NewSignal(const int signal) {m_new_signal=signal;}
   virtual int       LastEntry(void) const {return m_last_entry;}
   virtual void      LastEntry(const int signal) {m_last_entry=signal;}
   virtual int       LastExit(void) const {return m_last_exit;}
   virtual void      LastExit(const int signal) {m_last_exit=signal;}
   virtual int       LastValidEntry(void) const {return m_last_entry;}
   virtual bool      Reverse(void) const{return m_reverse;}
   virtual void      Reverse(const bool reverse) {m_reverse=reverse;}
   //-- comments
   virtual void AddComment(const string comment);
   //--- recovery
   virtual bool      CreateElement(const int index);
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalsBase::CSignalsBase(void) : m_activate(true),
                                   m_last_entry(0),
                                   m_last_exit(0),
                                   m_new_signal(false),
                                   m_reverse(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSignalsBase::~CSignalsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::Init(CExpert *s,CComments *comments)
  {
   for(int i=0;i<Total();i++)
     {
      CSignal *signal=At(i);
      signal.Init(GetPointer(s),GetPointer(comments));
     }
   SetContainer(s);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CSignal *signal=At(i);
      if(!signal.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CheckSignals(int &entry,int &exit)
  {
   if(!Active()) return false;
   entry= CheckEntry();
   exit = CheckExit();
   if(m_reverse)
     {
      entry = CSignal::SignalReverse(entry);
      exit = CSignal::SignalReverse(exit);
     }
   if(m_new_signal)
      if(entry==m_last_entry)
         entry=CMD_NEUTRAL;
   if(entry>0)
      m_last_entry=entry;      
   if((entry>0 && entry==CSignal::SignalReverse(exit)) || exit==CMD_VOID)
     {      
      entry= CMD_VOID;
      exit = CMD_VOID;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSignalsBase::CheckEntry() const
  {
   int res=CMD_NEUTRAL;
   for(int i=0;i<Total();i++)
     {
      CSignal *signal=At(i);
      if(signal==NULL) continue;
      if(signal.ExitSignal()) continue;
      int ret=signal.CheckSignal();
      if (ret==CMD_ALL) continue;
      if(ret==CMD_VOID || ret==CMD_NEUTRAL)
        {
         return ret;
        }
      if(res>0 && ret!=res)
        {
         return CMD_NEUTRAL;
        }
      if(ret>0) res=ret;
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSignalsBase::CheckExit() const
  {
   int res=CMD_NEUTRAL;
   for(int i=0;i<Total();i++)
     {
      CSignal *signal=At(i);
      if(signal==NULL) continue;
      if(!signal.ExitSignal()) continue;
      int ret=signal.CheckSignal();
      if (ret==CMD_ALL) continue;
      if(ret==CMD_VOID || ret==CMD_NEUTRAL)
        {
         return ret;
        }
      if(res>0 && ret!=res)
        {
         return CMD_NEUTRAL;
        }
      if(ret>0) res=ret;
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::CreateElement(const int index)
  {
   CSignal * signal = new CSignal();
   signal.SetContainer(GetPointer(this));
   return Insert(GetPointer(signal),index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::Save(const int handle)
  {
   ADT::WriteInteger(handle,m_last_entry);
   ADT::WriteInteger(handle,m_last_exit);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSignalsBase::Load(const int handle)
  {
   ADT::ReadInteger(handle,m_last_entry);
   ADT::ReadInteger(handle,m_last_exit);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSignalsBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new CComment(comment));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Signal\Signals.mqh"
#else
#include "..\..\MQL4\Signal\Signals.mqh"
#endif
//+------------------------------------------------------------------+
