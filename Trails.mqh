//+------------------------------------------------------------------+
//|                                                      JTrails.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "Trail.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTrails : public CArrayObj
  {
public:
                     JTrails();
                    ~JTrails();
   virtual double    Check(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrails::JTrails()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrails::~JTrails()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JTrails::Check(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit)
  {
   double val=0.0;
   double ret=0.0;
   for(int i=0;i<Total();i++)
     {
      JTrail *trail=At(i);
      if(!CheckPointer(trail)) continue;
      val=trail.Check(type,entry_price,stoploss,takeprofit);
      if(type==ORDER_TYPE_BUY)
        {
         if(trail.TrailTarget()==TRAIL_TARGET_STOPLOSS)
            if(val>ret)
               ret=val;
        }
      if(type==ORDER_TYPE_SELL)
        {
         if(trail.TrailTarget()==TRAIL_TARGET_STOPLOSS)
            if(val<ret)
               ret=val;
        }
     }
   return(ret);
  }
//+------------------------------------------------------------------+
