//+------------------------------------------------------------------+
//|                                                    TrailBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
#include "..\..\Common\Enum\ENUM_TRAIL_TARGET.mqh"
#include "..\..\Base\Symbol\SymbolManagerBase.mqh"
#include "..\Event\EventAggregatorBase.mqh"
class CTrails;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTrailBase : public CObject
  {
protected:
   bool              m_active;
   ENUM_TRAIL_TARGET m_target;
   double            m_trail;
   double            m_start;
   double            m_end;
   double            m_step;
   CSymbolManager   *m_symbol_man;
   CSymbolInfo      *m_symbol;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CTrailBase(void);
                    ~CTrailBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TRAIL;}
   //--- initialization                    
   virtual bool      Init(CSymbolManager*,CEventAggregator*);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   virtual bool      Validate(void) const;
   //--- getters and setters    
   bool              Active(void) const;
   void              Active(const bool);
   double            End(void) const;
   void              End(const double);
   void              Set(const double,const double,const double,const double);
   double            Start(void) const;
   void              Start(const double);
   double            Step(void) const;
   void              Step(const double);
   double            Trail(void) const;
   void              Trail(const double);
   int               TrailTarget(void) const;
   void              TrailTarget(const ENUM_TRAIL_TARGET);
   //--- checking
   virtual double    Check(const string,const ENUM_ORDER_TYPE,const double,const double,const ENUM_TRAIL_TARGET);
protected:
   //--- price calculation
   virtual double    ActivationPrice(const ENUM_ORDER_TYPE,const double);
   virtual double    DeactivationPrice(const ENUM_ORDER_TYPE,const double);
   virtual double    Price(const ENUM_ORDER_TYPE);
   virtual bool      Refresh(const string);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrailBase::CTrailBase(void) : m_active(true),
                               m_target(TRAIL_TARGET_STOPLOSS),
                               m_start(0.0),
                               m_end(0.0),
                               m_trail(0.0),
                               m_step(0.0)
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
CObject *CTrailBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrailBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrailBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::Active(const bool activate)
  {
   m_active=activate;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::End(void) const
  {
   return m_end;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::End(const double end)
  {
   m_end=end;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::Start(void) const
  {
   return m_start;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::Start(const double st)
  {
   m_start=st;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::Step(void) const
  {
   return m_step;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::Step(const double step)
  {
   m_step=step;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailBase::Trail(void) const
  {
   return m_trail;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::Trail(const double trail)
  {
   m_trail=trail;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CTrailBase::TrailTarget(void) const
  {
   return m_target;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTrailBase::TrailTarget(const ENUM_TRAIL_TARGET target)
  {
   m_target=target;
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
bool CTrailBase::Init(CSymbolManager *symbolmanager,CEventAggregator *event_man=NULL)
  {
   if(!CheckPointer(symbolmanager))
     {
      Print(__FUNCTION__+": symbol object is NULL");
      return false;
     }
   m_symbol_man=symbolmanager;
   m_event_man = event_man;
   return CheckPointer(m_symbol_man);
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
   if(!Active())
      return 0;
   if(!Refresh(symbol))
      return 0;
   if(m_start==0 || m_trail==0)
      return 0;
   double next_stop=0.0,activation=0.0,deactivation=0.0,new_price=0.0,point=m_symbol.Point();
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
bool CTrailBase::Refresh(const string symbol)
  {
   if(!CheckPointer(m_symbol) || StringCompare(m_symbol.Name(),symbol)!=0)
      m_symbol=m_symbol_man.Get(symbol);
   return CheckPointer(m_symbol);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Trail\Trail.mqh"
#else
#include "..\..\MQL4\Trail\Trail.mqh"
#endif
//+------------------------------------------------------------------+
