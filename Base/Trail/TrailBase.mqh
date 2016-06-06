//+------------------------------------------------------------------+
//|                                                    TrailBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\common\enum\ENUM_TRAIL_TARGET.mqh"
#include "..\..\base\symbol\SymbolManagerBase.mqh"
class CTrails;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTrailBase : public CObject
  {
protected:
   bool              m_activate;
   ENUM_TRAIL_TARGET m_target;
   double            m_trail;
   double            m_start;
   double            m_end;
   double            m_step;
   CSymbolManager   *m_symbol_man;
   CSymbolInfo      *m_symbol;
   CTrails          *m_trails;
public:
                     CTrailBase(void);
                    ~CTrailBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TRAIL;}
   //--- initialization                    
   virtual bool      Init(CSymbolManager *symbolmanager,CTrails *t);
   virtual void      SetContainer(CTrails *trails){m_trails=trails;}
   virtual bool      Validate(void) const;
   //--- getters and setters    
   bool              Active(void) const {return m_activate;}
   void              Active(const bool activate) {m_activate=activate;}
   //int               DigitsAdjust(void) const {return m_digits_adjust;}
   //void              DigitsAdjust(const int adjust) {m_digits_adjust=adjust;}
   double            End(void) const {return m_end;}
   void              End(const double end) {m_end=end;}
   //double            PointsAdjust(void) const {return m_points_adjust;}
   //void              PointsAdjust(const double adjust) {m_points_adjust=adjust;}
   void              Set(const double trail,const double st,const double step=1,const double end=0);
   double            Start(void) const {return m_start;}
   void              Start(const double st) {m_start=st;}
   double            Step(void) const {return m_step;}
   void              Step(const double step) {m_step=step;}
   double            Trail(void) const {return m_trail;}
   void              Trail(const double trail) {m_trail=trail;}
   int               TrailTarget(void) const {return m_target;}
   void              TrailTarget(const ENUM_TRAIL_TARGET target) {m_target=target;}
   //--- checking
   virtual double    Check(const string symbol,const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode);
protected:
   //--- price calculation
   virtual double    ActivationPrice(const ENUM_ORDER_TYPE type,const double entry_price);
   virtual double    DeactivationPrice(const ENUM_ORDER_TYPE type,const double entry_price);
   virtual double    Price(const ENUM_ORDER_TYPE type);
   virtual void      Refresh(const string symbol);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrailBase::CTrailBase(void) : m_activate(true),
                               m_target(TRAIL_TARGET_STOPLOSS),
                               m_start(0.0),
                               m_end(0.0),
                               m_trail(0.0),
                               m_step(0.0)
                               //m_points_adjust(0),
                               //m_digits_adjust(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrailBase::~CTrailBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrailBase::Validate(void) const
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrailBase::Init(CSymbolManager *symbolmanager,CTrails *trail)
  {
   if(symbolmanager==NULL || trail==NULL) return false;
   m_symbol_man=symbolmanager;
   SetContainer(trail);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::Set(const double trail,const double st,const double step=1,const double end=0)
  {
   m_trail=trail;
   m_start=st;
   m_end=end;
   m_step=step;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::ActivationPrice(const ENUM_ORDER_TYPE type,const double entry_price)
  {
   if(type==ORDER_TYPE_BUY)
      return entry_price+m_start*m_symbol.Point();
   else if(type==ORDER_TYPE_SELL)
      return entry_price-m_start*m_symbol.Point();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::DeactivationPrice(const ENUM_ORDER_TYPE type,const double entry_price)
  {
   if(type==ORDER_TYPE_BUY)
      return m_end==0?0:entry_price+m_end*m_symbol.Point();
   else if(type==ORDER_TYPE_SELL)
      return m_end==0?0:entry_price-m_end*m_symbol.Point();
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::Check(const string symbol,const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode)
  {
   if(!Active()) return 0;
   Refresh(symbol);
   if(m_start==0 || m_trail==0) return 0;
   double next_stop=0.0,activation=0.0,deactivation=0.0,new_price=0.0,point = m_symbol.Point();
   activation=ActivationPrice(type,entry_price);
   deactivation=DeactivationPrice(type,entry_price);
   new_price=Price(type);   
   if((type==ORDER_TYPE_BUY && m_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_SELL && m_target==TRAIL_TARGET_TAKEPROFIT))
     {
      if(m_step>0 && (price>=activation-m_trail*point || activation==0.0) && (new_price>price+m_step*point))
         next_stop=new_price;
      else next_stop=activation-m_trail*point;
      if((deactivation>0 && next_stop>=deactivation && next_stop>0.0) || (deactivation==0))
         if(next_stop<=new_price)
            return next_stop;
     }
   if((type==ORDER_TYPE_SELL && m_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_BUY && m_target==TRAIL_TARGET_TAKEPROFIT))
     {
      if(m_step>0 && (price<=activation+m_trail*point || activation==0.0) && (new_price<price-m_step*point))
         next_stop=new_price;
      else next_stop=activation+m_trail*point;
      if((deactivation>0 && next_stop<=deactivation && next_stop>0.0) || (deactivation==0))
         if(next_stop>=new_price)
            return next_stop;
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::Price(const ENUM_ORDER_TYPE type)
  {
   if(type==ORDER_TYPE_BUY)
     {
      if(m_target==TRAIL_TARGET_STOPLOSS)
         return m_symbol.Bid()-m_trail*m_symbol.Point();;
     }
   else if(type==ORDER_TYPE_SELL)
     {
      if(m_target==TRAIL_TARGET_STOPLOSS)
         return m_symbol.Ask()+m_trail*m_symbol.Point();;
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::Refresh(const string symbol)
  {
   if(m_symbol==NULL|| StringCompare(m_symbol.Name(),symbol)!=0)
      m_symbol= m_symbol_man.Get(symbol);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Trail\Trail.mqh"
#else
#include "..\..\MQL4\Trail\Trail.mqh"
#endif
//+------------------------------------------------------------------+
