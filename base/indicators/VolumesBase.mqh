//+------------------------------------------------------------------+
//|                                                  VolumesBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "IndicatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiADBase : public JIndicator
  {
protected:
   ENUM_APPLIED_VOLUME m_applied;

public:
                     JiADBase(const string name);
                    ~JiADBase(void);
   virtual int       Type(void) const { return(IND_AD); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
   ENUM_APPLIED_VOLUME Applied(void) const { return(m_applied);   }

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADBase::JiADBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADBase::~JiADBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMFIBase : public JIndicator
  {
protected:
   int               m_ma_period;
   ENUM_APPLIED_VOLUME m_applied;
public:
                     JiMFIBase(const string name);
                    ~JiMFIBase(void);
   virtual int       Type(void) const { return(IND_MFI); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
   ENUM_APPLIED_VOLUME Applied(void) const { return(m_applied); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMFIBase::JiMFIBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMFIBase::~JiMFIBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiOBVBase : public JIndicator
  {
protected:
   int               m_applied;

public:
                     JiOBVBase(const string name);
                    ~JiOBVBase(void);
   virtual int       Type(void) const { return(IND_OBV); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
   int               Applied(void) const { return(m_applied); }

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOBVBase::JiOBVBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOBVBase::~JiOBVBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiVolumesBase : public JIndicator
  {
protected:
   int               m_applied;

public:
                     JiVolumesBase(const string name);
                    ~JiVolumesBase(void);
   virtual int       Type(void) const { return(IND_VOLUMES); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int applied);
   virtual double    Main(const int index) const;
   int               Applied(void) const { return(m_applied); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVolumesBase::JiVolumesBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVolumesBase::~JiVolumesBase()
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Volumes.mqh"
#else
#include "..\..\mql4\indicators\Volumes.mqh"
#endif
//+------------------------------------------------------------------+
