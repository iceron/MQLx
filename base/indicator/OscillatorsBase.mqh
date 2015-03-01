//+------------------------------------------------------------------+
//|                                               IndicatorsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "IndicatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiATRBase : public JIndicator
  {
protected:
   int               m_ma_period;

public:
                     JiATRBase(const string name);
                    ~JiATRBase();
   virtual int       Type(void) const { return(IND_ATR); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiATRBase::JiATRBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiATRBase::~JiATRBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiBearsPowerBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;
public:
                     JiBearsPowerBase(const string name);
                    ~JiBearsPowerBase();
   virtual int       Type(void) const { return(IND_BEARS); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
   int               Applied(void) const { return(m_applied); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBearsPowerBase::JiBearsPowerBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBearsPowerBase::~JiBearsPowerBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiBullsPowerBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;
public:
                     JiBullsPowerBase(const string name);
                    ~JiBullsPowerBase();
   virtual int       Type(void) const { return(IND_BULLS); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBullsPowerBase::JiBullsPowerBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBullsPowerBase::~JiBullsPowerBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiCCIBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;
public:
                     JiCCIBase(const string name);
                    ~JiCCIBase();
   virtual int       Type(void) const { return(IND_CCI); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void)        const { return(m_ma_period); }
   int               Applied(void)         const { return(m_applied);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiCCIBase::JiCCIBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiCCIBase::~JiCCIBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiChaikinBase : public JIndicator
  {
protected:
   int               m_fast_ma_period;
   int               m_slow_ma_period;
   ENUM_MA_METHOD    m_ma_method;
   ENUM_APPLIED_VOLUME m_applied;
public:
                     JiChaikinBase(const string name);
                    ~JiChaikinBase();
   virtual int       Type(void) const { return(IND_ATR); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int fast_ma_period,const int slow_ma_period,
                            const ENUM_MA_METHOD ma_method,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
   int               FastMaPeriod(void)    const { return(m_fast_ma_period); }
   int               SlowMaPeriod(void)    const { return(m_slow_ma_period); }
   ENUM_MA_METHOD    MaMethod(void)        const { return(m_ma_method);      }
   ENUM_APPLIED_VOLUME Applied(void)       const { return(m_applied);        }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiChaikinBase::JiChaikinBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiChaikinBase::~JiChaikinBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiDeMarkerBase : public JIndicator
  {
protected:
   int               m_ma_period;
public:
                     JiDeMarkerBase(const string name);
                    ~JiDeMarkerBase();
   virtual int       Type(void) const { return(IND_CHAIKIN); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDeMarkerBase::JiDeMarkerBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDeMarkerBase::~JiDeMarkerBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiForceBase : public JIndicator
  {
protected:
   int               m_ma_period;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;
public:
                     JiForceBase(const string name);
                    ~JiForceBase();
   virtual int       Type(void) const { return(IND_DEMARKER); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const ENUM_MA_METHOD ma_method,const ENUM_APPLIED_VOLUME applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void)        const { return(m_ma_period); }
   ENUM_MA_METHOD    MaMethod(void)        const { return(m_ma_method); }
   ENUM_APPLIED_VOLUME Applied(void)       const { return((ENUM_APPLIED_VOLUME) m_applied);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiForceBase::JiForceBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiForceBase::~JiForceBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMACDBase : public JIndicator
  {
protected:
   int               m_fast_ema_period;
   int               m_slow_ema_period;
   int               m_signal_period;
   int               m_applied;
public:
                     JiMACDBase(const string name);
                    ~JiMACDBase();
   virtual int       Type(void) const { return(IND_MACD); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int fast_ema_period,const int slow_ema_period,
                            const int signal_period,const int applied);
   virtual double    Main(const int index) const;
   virtual double    Signal(const int index) const;
   int               FastEmaPeriod(void)     const { return(m_fast_ema_period); }
   int               SlowEmaPeriod(void)     const { return(m_slow_ema_period); }
   int               SignalPeriod(void)      const { return(m_signal_period);   }
   int               Applied(void)           const { return(m_applied);         }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMACDBase::JiMACDBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMACDBase::~JiMACDBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMomentumBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;
public:
                     JiMomentumBase(const string name);
                    ~JiMomentumBase();
   virtual int       Type(void) const { return(IND_MOMENTUM); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
   int               Applied(void) const { return(m_applied); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMomentumBase::JiMomentumBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMomentumBase::~JiMomentumBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiOsMaBase : public JIndicator
  {
protected:
   int               m_fast_ema_period;
   int               m_slow_ema_period;
   int               m_signal_period;
   int               m_applied;
public:
                     JiOsMaBase(const string name);
                    ~JiOsMaBase();
   virtual int       Type(void) const { return(IND_OSMA); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int fast_ema_period,const int slow_ema_period,
                            const int signal_period,const int applied);
   double            Main(const int index) const;
   int               FastEmaPeriod(void)     const { return(m_fast_ema_period); }
   int               SlowEmaPeriod(void)     const { return(m_slow_ema_period); }
   int               SignalPeriod(void)      const { return(m_signal_period);   }
   int               Applied(void)           const { return(m_applied);         }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOsMaBase::JiOsMaBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiOsMaBase::~JiOsMaBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiRSIBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;
public:
                     JiRSIBase(const string name);
                    ~JiRSIBase();
   virtual int       Type(void) const { return(IND_RSI); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
   int               Applied(void) const { return(m_applied); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRSIBase::JiRSIBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRSIBase::~JiRSIBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiRVIBase : public JIndicator
  {
protected:
   int               m_ma_period;
public:
                     JiRVIBase(const string name);
                    ~JiRVIBase();
   virtual int       Type(void) const { return(IND_RVI); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   virtual double    Main(const int index) const;
   virtual double    Signal(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRVIBase::JiRVIBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiRVIBase::~JiRVIBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiStochasticBase : public JIndicator
  {
protected:
   int               m_Kperiod;
   int               m_Dperiod;
   int               m_slowing;
   ENUM_MA_METHOD    m_ma_method;
   ENUM_STO_PRICE    m_price_field;
public:
                     JiStochasticBase(const string name);
                    ~JiStochasticBase();
   virtual int       Type(void) const { return(IND_STOCHASTIC); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int Kperiod,const int Dperiod,const int slowing,
                            const ENUM_MA_METHOD ma_method,const ENUM_STO_PRICE price_field);
   virtual double    Main(const int index) const;
   virtual double    Signal(const int index) const;
   int               Kperiod(void)           const { return(m_Kperiod);     }
   int               Dperiod(void)           const { return(m_Dperiod);     }
   int               Slowing(void)           const { return(m_slowing);     }
   ENUM_MA_METHOD    MaMethod(void)          const { return(m_ma_method);   }
   ENUM_STO_PRICE    PriceField(void)        const { return(m_price_field); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStochasticBase::JiStochasticBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStochasticBase::~JiStochasticBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiWPRBase : public JIndicator
  {
protected:
   int               m_calc_period;
public:
                     JiWPRBase(const string name);
                    ~JiWPRBase();
   virtual int       Type(void) const { return(IND_WPR); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int calc_period);
   virtual double    Main(const int index) const;
   int               CalcPeriod(void) const { return(m_calc_period); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiWPRBase::JiWPRBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiWPRBase::~JiWPRBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiTrixBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;
public:
                     JiTrixBase(const string name);
                    ~JiTrixBase();
   virtual int       Type(void) const { return(IND_TRIX); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void)        const { return(m_ma_period); }
   int               Applied(void)         const { return(m_applied);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTrixBase::JiTrixBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTrixBase::~JiTrixBase()
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Oscillators.mqh"
#else
#include "..\..\mql4\indicators\Oscillators.mqh"
#endif
//+------------------------------------------------------------------+
