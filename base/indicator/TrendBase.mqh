//+------------------------------------------------------------------+
//|                                                    TrendBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "IndicatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiADXBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_applied;
public:
                     JiADXBase(const string name);
                    ~JiADXBase(void);
   virtual int       Type(void) const {return(IND_ADX);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   virtual double    Plus(const int index) const;
   virtual double    Minus(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADXBase::JiADXBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADXBase::~JiADXBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiADXWilderBase : public JIndicator
  {
protected:
   int               m_ma_period;
public:
                     JiADXWilderBase(const string name);
                    ~JiADXWilderBase(void);
   virtual int       Type(void) const {return(IND_ADXW);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   double            Main(const int index) const;
   double            Plus(const int index) const;
   double            Minus(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADXWilderBase::JiADXWilderBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADXWilderBase::~JiADXWilderBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiBandsBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   double            m_deviation;
   int               m_applied;
public:
                     JiBandsBase(const string name);
                    ~JiBandsBase(void);
   virtual int       Type(void) const {return(IND_BANDS);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,
                            const int ma_shift,const double deviation,const int applied);
   virtual double    Base(const int index) const;
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
   int               MaShift(void) const { return(m_ma_shift);  }
   double            Deviation(void) const { return(m_deviation); }
   int               Applied(void) const { return(m_applied);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBandsBase::JiBandsBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBandsBase::~JiBandsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiEnvelopesBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;
   double            m_deviation;
public:
                     JiEnvelopesBase(const string name);
                    ~JiEnvelopesBase(void);
   virtual int       Type(void) const {return(IND_ENVELOPES);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ma_shift,const ENUM_MA_METHOD ma_method,
                            const int applied,const double deviation);
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
   int               MaPeriod(void)const { return(m_ma_period);   }
   int               MaShift(void) const { return(m_ma_shift);    }
   ENUM_MA_METHOD    MaMethod(void) const { return(m_ma_method);   }
   int               Applied(void) const { return(m_applied);     }
   double            Deviation(void) const { return(m_deviation);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiEnvelopesBase::JiEnvelopesBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiEnvelopesBase::~JiEnvelopesBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiIchimokuBase : public JIndicator
  {
protected:
   int               m_tenkan_sen;
   int               m_kijun_sen;
   int               m_senkou_span_b;
public:
                     JiIchimokuBase(const string name);
                    ~JiIchimokuBase(void);
   virtual int       Type(void) const {return(IND_ICHIMOKU);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int tenkan_sen,const int kijun_sen,const int senkou_span_b);
   virtual double    TenkanSen(const int index) const;
   virtual double    KijunSen(const int index) const;
   virtual double    SenkouSpanA(const int index) const;
   virtual double    SenkouSpanB(const int index) const;
   virtual double    ChinkouSpan(const int index) const;
   int               TenkanSenPeriod(void)        const { return(m_tenkan_sen);    }
   int               KijunSenPeriod(void)         const { return(m_kijun_sen);     }
   int               SenkouSpanBPeriod(void)      const { return(m_senkou_span_b); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiIchimokuBase::JiIchimokuBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiIchimokuBase::~JiIchimokuBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMABase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;
public:
                     JiMABase(const string name);
                    ~JiMABase(void);
   virtual int       Type(void) const {return(IND_MA);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ma_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
   int               MaShift(void) const { return(m_ma_shift);  }
   ENUM_MA_METHOD    MaMethod(void) const { return(m_ma_method); }
   int               Applied(void) const { return(m_applied);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMABase::JiMABase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMABase::~JiMABase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiSARBase : public JIndicator
  {
protected:
   double            m_step;
   double            m_maximum;
public:
                     JiSARBase(const string name);
                    ~JiSARBase(void);
   virtual int       Type(void) const {return(IND_SAR);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const double step,const double maximum);
   virtual double    Main(const int index) const;
   double            SarStep(void)         const { return(m_step);    }
   double            Maximum(void)         const { return(m_maximum); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiSARBase::JiSARBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiSARBase::~JiSARBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiStdDevBase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_ma_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;
public:
                     JiStdDevBase(const string name);
                    ~JiStdDevBase(void);
   virtual int       Type(void) const {return(IND_STDDEV);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ma_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void)        const { return(m_ma_period); }
   int               MaShift(void)         const { return(m_ma_shift);  }
   ENUM_MA_METHOD    MaMethod(void)        const { return(m_ma_method); }
   int               Applied(void)         const { return(m_applied);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStdDevBase::JiStdDevBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStdDevBase::~JiStdDevBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiDEMABase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_ind_shift;
   int               m_applied;
public:
                     JiDEMABase(const string name);
                    ~JiDEMABase(void);
   virtual int       Type(void) const {return(IND_DEMA);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void)        const { return(m_ma_period); }
   int               IndShift(void)        const { return(m_ind_shift); }
   int               Applied(void)         const { return(m_applied);   }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDEMABase::JiDEMABase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDEMABase::~JiDEMABase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiTEMABase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_ind_shift;
   int               m_applied;
public:
                     JiTEMABase(const string name);
                    ~JiTEMABase(void);
   virtual int       Type(void) const {return(IND_TEMA);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void) const { return(m_ma_period); }
   int               IndShift(void) const { return(m_ind_shift); }
   int               Applied(void) const { return(m_applied);   }

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTEMABase::JiTEMABase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTEMABase::~JiTEMABase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiFraMABase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_ind_shift;
   int               m_applied;
public:
                     JiFraMABase(const string name);
                    ~JiFraMABase(void);
   virtual int       Type(void) const {return(IND_FRAMA);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
   int               MaPeriod(void)        const { return(m_ma_period); }
   int               IndShift(void)        const { return(m_ind_shift); }
   int               Applied(void)         const { return(m_applied);   }

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFraMABase::JiFraMABase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFraMABase::~JiFraMABase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAMABase : public JIndicator
  {
protected:
   int               m_ma_period;
   int               m_fast_ema_period;
   int               m_slow_ema_period;
   int               m_ind_shift;
   int               m_applied;
public:
                     JiAMABase(const string name);
                    ~JiAMABase(void);
   virtual int       Type(void) const {return(IND_AMA);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int fast_ema_period,const int slow_ema_period,
                            const int ind_shift,const int applied);
   double            Main(const int index) const;
   virtual int       MaPeriod(void) const { return(m_ma_period);       }
   int               FastEmaPeriod(void) const { return(m_fast_ema_period); }
   int               SlowEmaPeriod(void) const { return(m_slow_ema_period); }
   int               IndShift(void) const { return(m_ind_shift);       }
   int               Applied(void) const { return(m_applied);         }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAMABase::JiAMABase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAMABase::~JiAMABase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiVIDyABase : public JIndicator
  {
protected:
   int               m_cmo_period;
   int               m_ema_period;
   int               m_ind_shift;
   int               m_applied;
public:
                     JiVIDyABase(const string name);
                    ~JiVIDyABase(void);
   virtual int       Type(void) const {return(IND_VIDYA);}
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int cmo_period,const int ema_period,
                            const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
   int               CmoPeriod(void)       const { return(m_cmo_period); }
   int               EmaPeriod(void)       const { return(m_ema_period); }
   int               IndShift(void)        const { return(m_ind_shift);  }
   int               Applied(void)         const { return(m_applied);    }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVIDyABase::JiVIDyABase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVIDyABase::~JiVIDyABase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Trend.mqh"
#else
#include "..\..\mql4\indicators\Trend.mqh"
#endif
//+------------------------------------------------------------------+
