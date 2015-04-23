//+------------------------------------------------------------------+
//|                                                   TrailsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "TrailBase.mqh"
class JStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTrailsBase : public CArrayObj
  {
protected:
   bool              m_activate;
   JStop            *m_stop;
public:
                     JTrailsBase(void);
                    ~JTrailsBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_TRAILS);}   
   //--- initialization
   virtual bool      Init(JStrategy *s,JStop *stop);
   virtual void      SetContainer(JStop *stop){m_stop=stop;}
   //--- getters and setters
   bool              Active(void) const {return(m_activate);}
   void              Active(const bool activate) {m_activate=activate;}  
   //--- checking
   virtual double    Check(const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode);
   //--- recovery
   virtual bool      CreateElement(const int index);
protected:

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrailsBase::JTrailsBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrailsBase::~JTrailsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrailsBase::Init(JStrategy *s,JStop *stop)
  {
   if(!Active()) return(true);
   for(int i=0;i<Total();i++)
     {
      JTrail *trail=At(i);
      trail.Init(s,GetPointer(this));
     }
   SetContainer(stop);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JTrailsBase::Check(const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode)
  {
   if(!Active()) return(0.0);
   double val=0.0,ret=0.0;
   for(int i=0;i<Total();i++)
     {
      JTrail *trail=At(i);
      if(!CheckPointer(trail)) continue;
      int trail_target=trail.TrailTarget();
      if (mode!=trail_target) continue;
      val=trail.Check(type,entry_price,price,mode);
      if((type==ORDER_TYPE_BUY && trail_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_SELL && trail_target==TRAIL_TARGET_TAKEPROFIT))
        {
         if(val>ret || ret==0.0) ret=val;
        }
      else if((type==ORDER_TYPE_SELL && trail_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_BUY && trail_target==TRAIL_TARGET_TAKEPROFIT))
        {
         if(val<ret || ret==0.0) ret=val;
        }
     }
   return(ret);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrailsBase::CreateElement(const int index)
  {
   JTrail * trail = new JTrail();
   trail.SetContainer(GetPointer(this));
   return(Insert(GetPointer(trail),index));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\trailing\Trails.mqh"
#else
#include "..\..\mql4\trailing\Trails.mqh"
#endif
//+------------------------------------------------------------------+
