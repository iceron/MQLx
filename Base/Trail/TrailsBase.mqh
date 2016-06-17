//+------------------------------------------------------------------+
//|                                                   TrailsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "TrailBase.mqh"
class CStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTrailsBase : public CArrayObj
  {
protected:
   bool              m_active;
   CStop            *m_stop;
public:
                     CTrailsBase(void);
                    ~CTrailsBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TRAILS;}   
   //--- initialization
   virtual bool      Init(CSymbolManager *symbolmanager,CStop *stop);
   virtual void      SetContainer(CStop *stop){m_stop=stop;}
   //--- getters and setters
   bool              Active(void) const {return m_active;}
   void              Active(const bool activate) {m_active=activate;}  
   //--- checking
   virtual double    Check(const string,const ENUM_ORDER_TYPE,const double,const double,const ENUM_TRAIL_TARGET);
   //--- recovery
   virtual bool      CreateElement(const int);
protected:

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrailsBase::CTrailsBase(void) : m_active(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrailsBase::~CTrailsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrailsBase::Init(CSymbolManager *symbolmanager,CStop *stop)
  {
   if(!Active()) return true;
   for(int i=0;i<Total();i++)
     {
      CTrail *trail=At(i);
      trail.Init(symbolmanager,GetPointer(this));
     }
   SetContainer(stop);
   return true;
  }  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CTrailsBase::Check(const string symbol,const ENUM_ORDER_TYPE type,const double entry_price,const double price,const ENUM_TRAIL_TARGET mode)
  {
   if(!Active()) 
      return 0;
   double val=0.0,ret=0.0;
   for(int i=0;i<Total();i++)
     {
      CTrail *trail=At(i);
      if(!CheckPointer(trail)) 
         continue;
      if (!trail.Active())
         continue;
      int trail_target=trail.TrailTarget();
      if (mode!=trail_target) 
         continue;
      val=trail.Check(symbol,type,entry_price,price,mode);
      if((type==ORDER_TYPE_BUY && trail_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_SELL && trail_target==TRAIL_TARGET_TAKEPROFIT))
         if(val>ret || ret==0.0) ret=val;
      else if((type==ORDER_TYPE_SELL && trail_target==TRAIL_TARGET_STOPLOSS) || (type==ORDER_TYPE_BUY && trail_target==TRAIL_TARGET_TAKEPROFIT))
         if(val<ret || ret==0.0) ret=val;
     }
   return ret;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrailsBase::CreateElement(const int index)
  {
   CTrail * trail = new CTrail();
   trail.SetContainer(GetPointer(this));
   return Insert(GetPointer(trail),index);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Trail\Trails.mqh"
#else
#include "..\..\MQL4\Trail\Trails.mqh"
#endif
//+------------------------------------------------------------------+
