//+------------------------------------------------------------------+
//|                                                  SignalsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Files\FileBin.mqh>
#include "SignalBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JSignalsBase: public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_last_entry;
   int               m_last_exit;
   bool              m_new_signal;
   bool              m_reverse;
   JStrategy        *m_strategy;
public:
                     JSignalsBase(void);
                    ~JSignalsBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_SIGNALS);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Validate() const;
   //--- checking   
   virtual bool      Active(void) const{return(m_activate);}
   virtual void      Active(const bool active) {m_activate=active;}
   virtual int       CheckEntry() const;
   virtual int       CheckExit() const;
   virtual bool      CheckSignals(int &entry,int &exit);
   virtual int       NewSignal(void) const {return(m_new_signal);}
   virtual void      NewSignal(const int signal) {m_new_signal=signal;}
   virtual int       LastEntry(void) const {return(m_last_entry);}
   virtual void      LastEntry(const int signal) {m_last_entry=signal;}
   virtual int       LastExit(void) const {return(m_last_exit);}
   virtual void      LastExit(const int signal) {m_last_exit=signal;}
   virtual int       LastValidEntry(void) const {return(m_last_entry);}
   virtual bool      Reverse(void) const{return(m_reverse);}
   virtual void      Reverse(const bool reverse) {m_reverse=reverse;}
   //--- recovery
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalsBase::JSignalsBase(void) : m_activate(true),
                                   m_last_entry(0),
                                   m_last_exit(0),
                                   m_new_signal(false),
                                   m_reverse(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalsBase::~JSignalsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalsBase::Init(JStrategy *s)
  {
   for(int i=0;i<Total();i++)
     {
      JSignal *signal=At(i);
      signal.Init(s);
     }
   SetContainer(s);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalsBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      JSignal *signal=At(i);
      if(!signal.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalsBase::CheckSignals(int &entry,int &exit)
  {
   if(!Active()) return(false);
   entry= CheckEntry();
   exit = CheckExit();
   if(m_reverse)
     {
      entry = JSignal::SignalReverse(entry);
      exit = JSignal::SignalReverse(exit);
     }
   if(m_new_signal)
      if(entry==m_last_entry)
         entry=CMD_NEUTRAL;
   if(entry>0)
      m_last_entry=entry;      
   if(entry>0 && entry==JSignal::SignalReverse(exit))
     {      
      entry= CMD_VOID;
      exit = CMD_VOID;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSignalsBase::CheckEntry() const
  {
   int res=CMD_NEUTRAL;
   for(int i=0;i<Total();i++)
     {
      JSignal *signal=At(i);
      if(signal==NULL) continue;
      if(signal.ExitSignal()) continue;
      int ret=signal.CheckSignal();
      if (ret==CMD_ALL) continue;
      if(ret==CMD_VOID || ret==CMD_NEUTRAL)
        {
         return(ret);
        }
      if(res>0 && ret!=res)
        {
         return(CMD_NEUTRAL);
        }
      if(ret>0) res=ret;
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JSignalsBase::CheckExit() const
  {
   int res=CMD_NEUTRAL;
   for(int i=0;i<Total();i++)
     {
      JSignal *signal=At(i);
      if(signal==NULL) continue;
      if(!signal.ExitSignal()) continue;
      int ret=signal.CheckSignal();
      if (ret==CMD_ALL) continue;
      if(ret==CMD_VOID || ret==CMD_NEUTRAL)
        {
         return(ret);
        }
      if(res>0 && ret!=res)
        {
         return (CMD_NEUTRAL);
        }
      if(ret>0) res=ret;
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalsBase::Backup(CFileBin *file)
  {
   file.WriteChar(m_activate);
   file.WriteInteger(m_last_entry);
   file.WriteInteger(m_last_exit);
   file.WriteChar(m_new_signal);
   file.WriteChar(m_reverse);
   CArrayObj::Save(file.Handle());
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalsBase::Restore(CFileBin *file)
  {
   file.ReadChar(m_activate);
   file.ReadInteger(m_last_entry);
   file.ReadInteger(m_last_exit);
   file.ReadChar(m_new_signal);
   file.ReadChar(m_reverse);
   CArrayObj::Load(file.Handle());
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\signal\Signals.mqh"
#else
#include "..\..\mql4\signal\Signals.mqh"
#endif
//+------------------------------------------------------------------+
