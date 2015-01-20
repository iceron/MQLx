//+------------------------------------------------------------------+
//|                                                  Oscillators.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiATR : public JiATRBase
  {
public:
                     JiATR(const string name);
                    ~JiATR();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiATR::JiATR(const string name) : JiATRBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiATR::~JiATR()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiATR::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiATR::Main(const int index) const
  {
   return(iATR(m_symbol,m_timeframe,m_ma_period,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiBearsPower : public JiBearsPowerBase
  {
public:
                     JiBearsPower(const string name);
                    ~JiBearsPower();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBearsPower::JiBearsPower(const string name) : JiBearsPowerBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBearsPower::~JiBearsPower()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiBearsPower::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiBearsPower::Main(const int index) const
  {
   return(iBearsPower(m_symbol,m_timeframe,m_ma_period,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiBullsPower : public JiBullsPowerBase
  {
public:
                     JiBullsPower(const string name);
                    ~JiBullsPower();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBullsPower::JiBullsPower(const string name) : JiBullsPowerBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBullsPower::~JiBullsPower()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiBullsPower::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiBullsPower::Main(const int index) const
  {
   return(iBullsPower(m_symbol,m_timeframe,m_ma_period,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiCCI : public JiCCIBase
  {
public:
                     JiCCI(const string name);
                    ~JiCCI();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiCCI::JiCCI(const string name) : JiCCIBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiCCI::~JiCCI()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiCCI::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiCCI::Main(const int index) const
  {
   return(iCCI(m_symbol,m_timeframe,m_ma_period,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiChaikin : public JiChaikinBase
  {
public:
                     JiChaikin(const string name);
                    ~JiChaikin();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int fast_ma_period,const int slow_ma_period,
                            const ENUM_MA_METHOD ma_method,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiChaikin::JiChaikin(const string name) : JiChaikinBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiChaikin::~JiChaikin()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiChaikin::Create(const string symbol,const ENUM_TIMEFRAMES period,
                       const int fast_ma_period,const int slow_ma_period,
                       const ENUM_MA_METHOD ma_method,const ENUM_APPLIED_VOLUME applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_fast_ma_period = fast_ma_period;
   m_slow_ma_period = slow_ma_period;
   m_ma_method=ma_method;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiChaikin::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiDeMarker : public JiDeMarkerBase
  {
public:
                     JiDeMarker(const string name);
                    ~JiDeMarker();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDeMarker::JiDeMarker(const string name) : JiDeMarkerBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDeMarker::~JiDeMarker()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiDeMarker::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiDeMarker::Main(const int index) const
  {
   return(iDeMarker(m_symbol,m_timeframe,m_ma_period,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiForce : public JiForceBase
  {
public:
                     JiForce(const string name);
                    ~JiForce();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const ENUM_MA_METHOD ma_method,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiForce::JiForce(const string name) : JiForceBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiForce::~JiForce()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiForce::Create(const string symbol,const ENUM_TIMEFRAMES period,
                     const int ma_period,const ENUM_MA_METHOD ma_method,const ENUM_APPLIED_VOLUME applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ma_method = ma_method;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiForce::Main(const int index) const
  {
   return(iForce(m_symbol,m_timeframe,m_ma_period,m_ma_method,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMACD : public JiMACDBase
  {
public:
                     JiMACD(const string name);
                    ~JiMACD();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int fast_ema_period,const int slow_ema_period,
                            const int signal_period,const int applied);
   virtual double    Main(const int index) const;
   virtual double    Signal(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMACD::JiMACD(const string name) : JiMACDBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMACD::~JiMACD()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiMACD::Create(const string symbol,const ENUM_TIMEFRAMES period,
                    const int fast_ema_period,const int slow_ema_period,
                    const int signal_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_fast_ema_period = fast_ema_period;
   m_slow_ema_period = slow_ema_period;
   m_signal_period=signal_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiMACD::Main(const int index) const
  {
   return(iMACD(m_symbol,m_timeframe,m_fast_ema_period,m_slow_ema_period,
          m_signal_period,m_applied,MODE_MAIN,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiMACD::Signal(const int index) const
  {
   return(iMACD(m_symbol,m_timeframe,m_fast_ema_period,m_slow_ema_period,
          m_signal_period,m_applied,MODE_SIGNAL,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMomentum : public JiMomentumBase
  {
public:
                     JiMomentum(const string name);
                    ~JiMomentum();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   virtual double    Signal(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMomentum::JiMomentum(const string name) : JiMomentumBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMomentum::~JiMomentum()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiMomentum::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiMomentum::Main(const int index) const
  {
   return(iMomentum(m_symbol,m_timeframe,m_ma_period,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiOsMa : public JiOsMaBase
  {
public:
                     JiOsMa(const string name);
                    ~JiOsMa();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int fast_ema_period,const int slow_ema_period,
                            const int signal_period,const int applied);
   double            Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOsMa::JiOsMa(const string name) : JiOsMaBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOsMa::~JiOsMa()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiOsMa::Create(const string symbol,const ENUM_TIMEFRAMES period,
                    const int fast_ema_period,const int slow_ema_period,
                    const int signal_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_fast_ema_period = fast_ema_period;
   m_slow_ema_period = slow_ema_period;
   m_signal_period=signal_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiOsMa::Main(const int index) const
  {
   return(iOsMA(m_symbol,m_timeframe,m_fast_ema_period,m_slow_ema_period,m_signal_period,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiRSI : public JiRSIBase
  {
public:
                     JiRSI(const string name);
                    ~JiRSI();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRSI::JiRSI(const string name) : JiRSIBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRSI::~JiRSI()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiRSI::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiRSI::Main(const int index) const
  {
   return(iRSI(m_symbol,m_timeframe,m_ma_period,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiRVI : public JiRVIBase
  {
public:
                     JiRVI(const string name);
                    ~JiRVI();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   virtual double    Main(const int index) const;
   virtual double    Signal(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRVI::JiRVI(const string name) : JiRVIBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRVI::~JiRVI()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiRVI::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiRVI::Main(const int index) const
  {
   return(iRVI(m_symbol,m_timeframe,m_ma_period,MODE_MAIN,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiRVI::Signal(const int index) const
  {
   return(iRVI(m_symbol,m_timeframe,m_ma_period,MODE_SIGNAL,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiStochastic : public JiStochasticBase
  {
public:
                     JiStochastic(const string name);
                    ~JiStochastic();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int Kperiod,const int Dperiod,const int slowing,
                            const ENUM_MA_METHOD ma_method,const ENUM_STO_PRICE price_field);
   virtual double    Main(const int index) const;
   virtual double    Signal(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStochastic::JiStochastic(const string name) : JiStochasticBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStochastic::~JiStochastic()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiStochastic::Create(const string symbol,const ENUM_TIMEFRAMES period,
                          const int Kperiod,const int Dperiod,const int slowing,
                          const ENUM_MA_METHOD ma_method,const ENUM_STO_PRICE price_field)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_Kperiod = Kperiod;
   m_Dperiod = Dperiod;
   m_slowing = slowing;
   m_ma_method=ma_method;
   m_price_field=price_field;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiStochastic::Main(const int index) const
  {
   return(iStochastic(m_symbol,m_timeframe,m_Kperiod,m_Dperiod,m_slowing,
          m_ma_method,m_price_field,MODE_MAIN,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiStochastic::Signal(const int index) const
  {
   return(iStochastic(m_symbol,m_timeframe,m_Kperiod,m_Dperiod,m_slowing,
          m_ma_method,m_price_field,MODE_SIGNAL,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiWPR : public JiWPRBase
  {
public:
                     JiWPR(const string name);
                    ~JiWPR();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int calc_period);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiWPR::JiWPR(const string name) : JiWPRBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiWPR::~JiWPR()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiWPR::Create(const string symbol,const ENUM_TIMEFRAMES period,const int calc_period)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_calc_period=calc_period;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiWPR::Main(const int index) const
  {
   return(iWPR(m_symbol,m_timeframe,m_calc_period,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiTrix : public JiTrixBase
  {
public:
                     JiTrix(const string name);
                    ~JiTrix();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTrix::JiTrix(const string name) : JiTrixBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTrix::~JiTrix()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiTrix::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_ma_period=ma_period;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiTrix::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Oscillators.mqh"
#else
#include "..\..\mql4\indicators\Oscillators.mqh"
#endif
//+------------------------------------------------------------------+
