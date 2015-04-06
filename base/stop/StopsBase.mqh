//+------------------------------------------------------------------+
//|                                                    StopsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "StopBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JStopsBase : public CArrayObj
  {
protected:
   bool              m_activate;
   JStrategy        *m_strategy;
public:
                     JStopsBase(void);
                    ~JStopsBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_STOPS);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Validate(void) const;
   //--- setters and getters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual JStop    *Main();
   //--- recovery
   virtual bool      CreateElement(const int index);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopsBase::JStopsBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStopsBase::~JStopsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopsBase::Init(JStrategy *s)
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      stop.Init(s);
     }
   SetContainer(s);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopsBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(!stop.Validate())
         return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JStop *JStopsBase::Main()
  {
   for(int i=0;i<Total();i++)
     {
      JStop *stop=At(i);
      if(stop.Main()) return(stop);
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JStopsBase::CreateElement(const int index)
  {
   JStop * stop = new JStop();
   stop.SetContainer(GetPointer(this));
   return(Insert(GetPointer(stop),index));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\stop\Stops.mqh"
#else
#include "..\..\mql4\stop\Stops.mqh"
#endif
//+------------------------------------------------------------------+
