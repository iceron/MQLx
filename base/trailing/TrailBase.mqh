//+------------------------------------------------------------------+
//|                                                    TrailBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_TRAIL_TARGET.mqh"
#include "..\..\common\enum\ENUM_TRAIL_MODE.mqh"
#include <Object.mqh>
#include "..\lib\SymbolInfo.mqh"
class JTrails;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTrailBase : public CObject
  {
protected:
   bool              m_activate;
   ENUM_TRAIL_TARGET m_target;
   ENUM_TRAIL_MODE   m_mode;
   double            m_trail;
   double            m_start;
   double            m_end;
   double            m_step;
   double            m_points_adjust;
   int               m_digits_adjust;
   CSymbolInfo      *m_symbol;
   JTrails          *m_trails;
public:
                     JTrailBase(void);
                    ~JTrailBase(void);
   virtual int       Type(void) const {return(CLASS_TYPE_TRAIL);}
   //--- initialization                    
   virtual bool      Init(JStrategy *s,JTrails *t);
   virtual void      SetContainer(JTrails *trails){m_trails=trails;}
   virtual bool      Validate(void) const;
   //--- getters and setters    
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(const bool activate) {m_activate=activate;}
   virtual int       DigitsAdjust(void) const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(const int adjust) {m_digits_adjust=adjust;}
   virtual double    End(void) const {return(m_end);}
   virtual void      End(const double end) {m_end=end;}
   virtual double    PointsAdjust(void) const {return(m_points_adjust);}
   virtual void      PointsAdjust(const double adjust) {m_points_adjust=adjust;}
   virtual void      Set(const double trail,const double st,const double step=1,const double end=0);
   virtual double    Start(void) const {return(m_start);}
   virtual void      Start(const double st) {m_start=st;}
   virtual double    Step(void) const {return(m_step);}
   virtual void      Step(const double step) {m_step=step;}
   virtual double    Trail(void) const {return(m_trail);}
   virtual void      Trail(const double trail) {m_trail=trail;}
   virtual int       TrailMode(void) const {return(m_mode);}
   virtual void      TrailMode(const ENUM_TRAIL_MODE mode) {m_mode=mode;}
   virtual int       TrailTarget(void) const {return(m_target);}
   virtual void      TrailTarget(const ENUM_TRAIL_TARGET target) {m_target=target;}
   //--- checking
   virtual double    Check(const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode);
protected:
   //--- price calculation
   virtual double    ActivationPrice(const ENUM_ORDER_TYPE type,const double entry_price);
   virtual double    DeactivationPrice(const ENUM_ORDER_TYPE type,const double entry_price);
   virtual double    Price(const ENUM_ORDER_TYPE type);
   //--- deinitialization
   virtual bool      Deinit(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrailBase::JTrailBase(void) : m_activate(true),
                               m_target(TRAIL_TARGET_STOPLOSS),
                               m_mode(TRAIL_MODE_TRAILING),
                               m_start(0.0),
                               m_end(0.0),
                               m_trail(0.0),
                               m_step(0.0),
                               m_points_adjust(0),
                               m_digits_adjust(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrailBase::~JTrailBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrailBase::Validate(void) const
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrailBase::Init(JStrategy *s,JTrails *t)
  {
   if (s==NULL || t==NULL) return(false);
   m_symbol=s.SymbolInfo();
   m_points_adjust = s.PointsAdjust();
   m_digits_adjust = s.DigitsAdjust();
   SetContainer(t);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTrailBase::Deinit(void)
  {
   if(m_symbol!=NULL) delete m_symbol;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTrailBase::Set(const double trail,const double st,const double step=1,const double end=0)
  {
   m_trail=trail;
   m_start=st;
   m_end=end;
   m_step=step;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JTrailBase::ActivationPrice(const ENUM_ORDER_TYPE type,const double entry_price)
  {
   if(type==ORDER_TYPE_BUY)
      return(entry_price+m_start*m_points_adjust);
   else if(type==ORDER_TYPE_SELL)
      return(entry_price-m_start*m_points_adjust);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JTrailBase::DeactivationPrice(const ENUM_ORDER_TYPE type,const double entry_price)
  {
   if(type==ORDER_TYPE_BUY)
      return(m_end==0?0:entry_price+m_end*m_points_adjust);
   else if(type==ORDER_TYPE_SELL)
      return(m_end==0?0:entry_price-m_end*m_points_adjust);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JTrailBase::Check(const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode)
  {
   if(!Active()) return(0.0);
   if (m_start==0 || m_trail==0) return(0.0);
   double next_stop=0.0,activation=0.0,deactivation=0.0,new_price=0.0;
   activation=ActivationPrice(type,entry_price);
   deactivation=DeactivationPrice(type,entry_price);
   new_price=Price(type);
   if((type==ORDER_TYPE_BUY && m_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_SELL && m_target==TRAIL_TARGET_TAKEPROFIT))
     {
      if((price>=activation-m_trail*m_points_adjust || activation==0.0) && (new_price>price+m_step*m_points_adjust))
         next_stop=new_price-m_trail*m_points_adjust;
      else next_stop=activation-m_trail*m_points_adjust;
      if((deactivation>0 && next_stop>=deactivation && next_stop>0.0) || (deactivation==0))
         if(next_stop<=new_price)
            return(next_stop);
     }
   if((type==ORDER_TYPE_SELL && m_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_BUY && m_target==TRAIL_TARGET_TAKEPROFIT))
     {
      if((price<=activation+m_trail*m_points_adjust || activation==0.0) && (new_price<price-m_step*m_points_adjust))
         next_stop=new_price+m_trail*m_points_adjust;
      else next_stop=activation+m_trail*m_points_adjust;
      if((deactivation>0 && next_stop<=deactivation && next_stop>0.0) || (deactivation==0))
         if(next_stop>=new_price)
            return(next_stop);
     }
   return(0.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JTrailBase::Price(const ENUM_ORDER_TYPE type)
  {
   if(type==ORDER_TYPE_BUY)
     {
      if(m_target==TRAIL_TARGET_STOPLOSS)
         return(m_symbol.Bid()-m_trail*m_points_adjust);
     }
   else if(type==ORDER_TYPE_SELL)
     {
      if(m_target==TRAIL_TARGET_STOPLOSS)
         return(m_symbol.Ask()+m_trail*m_points_adjust);
     }
   return(0);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\trailing\Trail.mqh"
#else
#include "..\..\mql4\trailing\Trail.mqh"
#endif
//+------------------------------------------------------------------+
