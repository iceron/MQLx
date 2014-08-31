//+------------------------------------------------------------------+
//|                                                       JTrail.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <traderjet-cross\common\enum\ENUM_TRAIL_TARGET.mqh>
#include <traderjet-cross\common\enum\ENUM_TRAIL_MODE.mqh>
#include <Object.mqh>
#include <Trade\SymbolInfo.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTrail : public CObject
  {
protected:
   bool              m_activate;
private:
   ENUM_TRAIL_TARGET m_target;
   ENUM_TRAIL_MODE   m_mode;
   double            m_trail;
   double            m_start;
   double            m_end;
   double            m_step;
   double            m_points_adjust;
   int               m_digits_adjust;
   CSymbolInfo      *m_symbol;
public:
                     JTrail();
                    ~JTrail();
   //--- initialization                    
   virtual void      Init(CSymbolInfo *symbol=NULL);
   //--- getters and setters    
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   virtual int       DigitsAdjust() const {return(m_digits_adjust);}
   virtual void      DigitsAdjust(int adjust) {m_digits_adjust=adjust;}
   virtual double    End() const {return(m_end);}
   virtual void      End(double end) {m_end=end;}
   virtual double    PointsAdjust() const {return(m_points_adjust);}
   virtual void      PointsAdjust(double adjust) {m_points_adjust=adjust;}
   virtual void      Set(double trail,double start,double step=1,double end=0);
   virtual double    Start() const {return(m_start);}
   virtual void      Start(double start) {m_start=start;}
   virtual double    Step() const {return(m_step);}
   virtual void      Step(double step) {m_step=step;}
   virtual double    Trail() const {return(m_trail);}
   virtual void      Trail(double trail) {m_trail=trail;}
   virtual int       TrailMode() const {return(m_mode);}
   virtual void      TrailMode(ENUM_TRAIL_MODE mode) {m_mode=mode;}
   virtual int       TrailTarget() const {return(m_target);}
   virtual void      TrailTarget(ENUM_TRAIL_TARGET target) {m_target=target;}
   //--- checking
   virtual double    Check(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit);
protected:
   //--- price calculation
   virtual double    ActivationPrice(ENUM_ORDER_TYPE type,double entry_price);
   virtual double    DeactivationPrice(ENUM_ORDER_TYPE type,double entry_price);
   virtual double    Price(ENUM_ORDER_TYPE type);
   //--- deinitialization
   virtual bool      Deinit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrail::JTrail() : m_activate(true),
                   m_target(TRAIL_TARGET_STOPLOSS),
                   m_mode(TRAIL_MODE_TRAILING),
                   m_start(0.0),
                   m_end(0.0),
                   m_trail(0.0),
                   m_step(0.0),
                   m_points_adjust(0),
                   m_digits_adjust(0),
                   m_symbol(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrail::~JTrail()
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool JTrail::Deinit(void)
  {
   if(m_symbol!=NULL) delete m_symbol;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTrail::Init(CSymbolInfo *symbol=NULL)
  {
   m_symbol=symbol;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTrail::Set(double trail,double start,double step=1,double end=0)
  {
   m_trail=trail;
   m_start=start;
   m_end=end;
   m_step=step;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JTrail::ActivationPrice(ENUM_ORDER_TYPE type,double entry_price)
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
double JTrail::DeactivationPrice(ENUM_ORDER_TYPE type,double entry_price)
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
double JTrail::Check(ENUM_ORDER_TYPE type,double entry_price,double stoploss,double takeprofit)
  {
   if(!Activate()) return(0.0);
   double next_stop=0.0,activation=0.0,deactivation=0.0,new_price=0.0;
   activation=ActivationPrice(type,entry_price);
   deactivation=DeactivationPrice(type,entry_price);
   new_price=Price(type);
   if((type==ORDER_TYPE_BUY && m_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_SELL && m_target==TRAIL_TARGET_TAKEPROFIT))
     {
      if(stoploss>=activation-m_trail*m_points_adjust || activation==0.0)
        {
         if(new_price>stoploss+m_step*m_points_adjust)
            next_stop=new_price-m_trail*m_points_adjust;
        }
      else next_stop=activation-m_trail*m_points_adjust;
      if((deactivation>0 && next_stop>=deactivation && next_stop>0.0) || (deactivation==0))
         if(next_stop<=new_price)
            return(next_stop);
     }
   if((type==ORDER_TYPE_SELL && m_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_BUY && m_target==TRAIL_TARGET_TAKEPROFIT))
     {
      if(stoploss<=activation+m_trail*m_points_adjust || activation==0.0)
        {
         if(new_price<stoploss-m_step*m_points_adjust)
            next_stop=new_price+m_trail*m_points_adjust;
        }
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
double JTrail::Price(ENUM_ORDER_TYPE type)
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
