//+------------------------------------------------------------------+
//|                                                      Volumes.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAD : public JiADBase
  {
public:
                     JiAD(const string name);
                    ~JiAD(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAD::JiAD(const string name) : JiADBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAD::~JiAD()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiAD::Create(const string symbol,const ENUM_TIMEFRAMES period,
                  const int applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_applied=applied;
   m_handle=iAD(m_symbol,m_timeframe,(ENUM_APPLIED_VOLUME)m_applied);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiAD::Main(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMFI : public JiMFIBase
  {
public:
                     JiMFI(const string name);
                    ~JiMFI(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMFI::JiMFI(const string name) : JiMFIBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMFI::~JiMFI()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiMFI::Create(const string symbol,const ENUM_TIMEFRAMES period,
                   const int ma_period,const ENUM_APPLIED_VOLUME applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_ma_period= ma_period;
   m_applied=applied;
   m_handle = iMFI(m_symbol,m_timeframe,m_ma_period,m_applied);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiMFI::Main(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiOBV : public JiOBVBase
  {
public:
                     JiOBV(const string name);
                    ~JiOBV(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOBV::JiOBV(const string name) : JiOBVBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOBV::~JiOBV()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiOBV::Create(const string symbol,const ENUM_TIMEFRAMES period,const ENUM_APPLIED_VOLUME applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_applied=applied;
   m_handle = iOBV(m_symbol,m_timeframe,(ENUM_APPLIED_VOLUME)m_applied);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiOBV::Main(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiVolumes : public JiVolumesBase
  {
public:
                     JiVolumes(const string name);
                    ~JiVolumes(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVolumes::JiVolumes(const string name) : JiVolumesBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVolumes::~JiVolumes()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiVolumes::Create(const string symbol,const ENUM_TIMEFRAMES period,
                       const int applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_applied=applied;
   m_handle = iVolumes(m_symbol,m_timeframe,(ENUM_APPLIED_VOLUME)m_applied);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiVolumes::Main(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Volumes.mqh"
#else
#include "..\..\mql4\indicators\Volumes.mqh"
#endif
//+------------------------------------------------------------------+
