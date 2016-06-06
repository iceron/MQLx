//+------------------------------------------------------------------+
//|                                                    StopsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "StopBase.mqh"
class CExpert;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStopsBase : public CArrayObj
  {
protected:
   bool              m_activate;
   CExpert        *m_strategy;
public:
                     CStopsBase(void);
                    ~CStopsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOPS;}
   //--- initialization
   virtual bool      Init(CExpert *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo);
   virtual void      SetContainer(CExpert *s){m_strategy=s;}
   virtual bool      Validate(void) const;
   //--- setters and getters
   virtual bool      Active(void) const {return m_activate;}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual CStop    *Main();
   //--- recovery
   virtual bool      CreateElement(const int index);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopsBase::CStopsBase(void) : m_activate(true)
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
bool CStopsBase::Init(CExpert *s,CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      stop.Init(symbolmanager,accountinfo);
     }
   SetContainer(s);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CStop *stop=At(i);
      if(!stop.Validate())
         return false;
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
      if(stop.Main()) return stop;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopsBase::CreateElement(const int index)
  {
   CStop * stop = new CStop();
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
