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
                     JTrailsBase();
                    ~JTrailsBase();
   virtual double    Check(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit);
   virtual bool      Init(JStrategy *s);
   //--- activation and deactivation
   virtual bool      Active() {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   virtual void      SetContainer(JStop *stop){m_stop=stop;}
   virtual int       Type() {return(CLASS_TYPE_TRAILS);}
protected:

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrailsBase::JTrailsBase() : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrailsBase::~JTrailsBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrailsBase::Init(JStrategy *s)
  {
   if(!Active()) return(true);
   for(int i=0;i<Total();i++)
     {
      JTrail *trail=At(i);
      trail.Init(s);
     }
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
