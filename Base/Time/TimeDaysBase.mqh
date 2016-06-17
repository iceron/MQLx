//+------------------------------------------------------------------+
//|                                                 CTimeDaysBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "TimeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_TIME_DAY_FLAGS
  {
   TIME_DAY_FLAG_SUN,
   TIME_DAY_FLAG_MON,
   TIME_DAY_FLAG_TUE,
   TIME_DAY_FLAG_WED,
   TIME_DAY_FLAG_THU,
   TIME_DAY_FLAG_FRI,
   TIME_DAY_FLAG_SAT
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimeDaysBase : public CTime
  {
protected:
   long              m_day_flags;
public:
                     CTimeDaysBase(void);
                    ~CTimeDaysBase(void);
   //--- initialization                    
   virtual bool      Validate(void);
   virtual bool      Evaluate(void);
   virtual void      Init(const bool,const bool,const bool,const bool,const bool,const bool,const bool);
   //--- setters and getters
   bool              Sunday(void) const {return(m_day_flags&TIME_DAY_FLAG_SUN)!=0;}
   void              Sunday(const bool);
   bool              Monday(void) const {return(m_day_flags&TIME_DAY_FLAG_MON)!=0;}
   void              Monday(const bool);
   bool              Tuesday(void) const {return(m_day_flags&TIME_DAY_FLAG_TUE)!=0;}
   void              Tuesday(const bool);
   bool              Wednesday(void) const {return(m_day_flags&TIME_DAY_FLAG_WED)!=0;}
   void              Wednesday(const bool);
   bool              Thursday(void) const {return(m_day_flags&TIME_DAY_FLAG_THU)!=0;}
   void              Thursday(const bool);
   bool              Friday(void) const {return(m_day_flags&TIME_DAY_FLAG_FRI)!=0;}
   void              Friday(const bool);
   bool              Saturday(void) const {return(m_day_flags&TIME_DAY_FLAG_SAT)!=0;}
   void              Saturday(const bool);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeDaysBase::CTimeDaysBase(void) : m_day_flags(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeDaysBase::~CTimeDaysBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeDaysBase::Validate(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Sunday(const bool set)
  {
   if(set)
      m_day_flags|=TIME_DAY_FLAG_SUN;
   else
      m_day_flags &=~TIME_DAY_FLAG_SUN;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Monday(const bool set)
  {
   if(set)
      m_day_flags|=TIME_DAY_FLAG_MON;
   else
      m_day_flags &=~TIME_DAY_FLAG_MON;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Tuesday(const bool set)
  {
   if(set)
      m_day_flags|=TIME_DAY_FLAG_TUE;
   else
      m_day_flags &=~TIME_DAY_FLAG_TUE;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Wednesday(const bool set)
  {
   if(set)
      m_day_flags|=TIME_DAY_FLAG_WED;
   else
      m_day_flags &=~TIME_DAY_FLAG_WED;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Thursday(const bool set)
  {
   if(set)
      m_day_flags|=TIME_DAY_FLAG_THU;
   else
      m_day_flags &=~TIME_DAY_FLAG_THU;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Friday(const bool set)
  {
   if(set)
      m_day_flags|=TIME_DAY_FLAG_FRI;
   else
      m_day_flags &=~TIME_DAY_FLAG_FRI;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Saturday(const bool set)
  {
   if(set)
      m_day_flags|=TIME_DAY_FLAG_SAT;
   else
      m_day_flags &=~TIME_DAY_FLAG_SAT;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimeDaysBase::Evaluate(void)
  {
   if(!Active()) return true;
   bool result=false;
   MqlDateTime time;
   datetime current=TimeCurrent();
   TimeToStruct(current,time);
   switch(time.day_of_week)
     {
      case 0: result=Sunday();      break;
      case 1: result=Monday();      break;
      case 2: result=Tuesday();     break;
      case 3: result=Wednesday();   break;
      case 4: result=Thursday();    break;
      case 5: result=Friday();      break;
      case 6: result=Saturday();    break;
     }
   return Reverse()?result:!result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimeDaysBase::Init(const bool sun=false,const bool mon=true,const bool tue=true,const bool wed=true,const bool thu=true,const bool fri=true,const bool sat=false)
  {
/*
   m_sun = sun;
   m_mon = mon;
   m_tue = tue;
   m_wed = wed;
   m_thu = thu;
   m_fri = fri;
   m_sat = sat;
   */
   if(sun)
      m_day_flags|=TIME_DAY_FLAG_SUN;
   if(mon)
      m_day_flags|=TIME_DAY_FLAG_MON;
   if(tue)
      m_day_flags|=TIME_DAY_FLAG_TUE;
   if(wed)
      m_day_flags|=TIME_DAY_FLAG_WED;
   if(thu)
      m_day_flags|=TIME_DAY_FLAG_THU;
   if(fri)
      m_day_flags|=TIME_DAY_FLAG_FRI;
   if(sat)
      m_day_flags|=TIME_DAY_FLAG_SAT;

  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\TimeDays.mqh"
#else
#include "..\..\MQL5\Time\TimeDays.mqh"
#endif
//+------------------------------------------------------------------+
