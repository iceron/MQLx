//+------------------------------------------------------------------+
//|                                                      JTrailsBase.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
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
   virtual int       Type(void) {return(CLASS_TYPE_TRAILS);}
   virtual double    Check(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit);
   //--- initialization
   virtual bool      Init(JStrategy *s,JStop *stop);
   virtual void      SetContainer(JStop *stop){m_stop=stop;}
   //--- activation and deactivation
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}  
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
double JTrailsBase::Check(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit)
  {
   if(!Active()) return(0.0);
   double val=0.0,ret=0.0;
   for(int i=0;i<Total();i++)
     {
      JTrail *trail=At(i);
      if(!CheckPointer(trail)) continue;
      int trail_target=trail.TrailTarget();
      val=trail.Check(type,entry_price,stoploss,takeprofit);
      if((type==ORDER_TYPE_BUY && trail_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_SELL && trail_target==TRAIL_TARGET_TAKEPROFIT))
        {
         if(val>ret) ret=val;
        }
      else if((type==ORDER_TYPE_SELL && trail_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_BUY && trail_target==TRAIL_TARGET_TAKEPROFIT))
        {
         if(val<ret) ret=val;
        }
     }
   return(ret);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\trailing\Trails.mqh"
#else
#include "..\..\mql4\trailing\Trails.mqh"
#endif
//+------------------------------------------------------------------+
