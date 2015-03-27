//+------------------------------------------------------------------+
//|                                                    TimesBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include <Files\FileBin.mqh>
#include "TimeBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTimesBase : public CArrayObj
  {
protected:
   bool              m_activate;
   JStrategy        *m_strategy;
public:
                     JTimesBase(void);
                    ~JTimesBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_TIMES);}
   //-- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Validate(void) const;
   //--- activation and deactivation
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   //--- checking
   virtual bool      Evaluate(void) const;
   //--- recovery
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
   virtual bool      CreateElement(const int index);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimesBase::JTimesBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTimesBase::~JTimesBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Init(JStrategy *s)
  {
   for(int i=0;i<Total();i++)
     {
      JTime *time=At(i);
      time.Init(s,GetPointer(this));
     }
   SetContainer(s);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      JTime *time=At(i);
      if(!time.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Evaluate(void) const
  {
   if(!Active()) return(true);
   for(int i=0;i<Total();i++)
     {
      JTime *time=At(i);
      if(CheckPointer(time))
         if(!time.Evaluate()) return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Backup(CFileBin *file)
  {
   file.WriteChar(m_activate);
   CArrayObj::Save(file.Handle());
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::Restore(CFileBin *file)
  {
   file.ReadChar(m_activate);
   CArrayObj::Load(file.Handle());
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTimesBase::CreateElement(const int index)
  {
   JTime * time = new JTime();
   time.SetContainer(GetPointer(this));
   return(Insert(GetPointer(time),index));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\Times.mqh"
#else
#include "..\..\mql4\time\Times.mqh"
#endif
//+------------------------------------------------------------------+
