//+------------------------------------------------------------------+
//|                                                    TrendBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiADX : public JiADXBase
  {
public:
                     JiADX(const string name);
                    ~JiADX(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied);
   virtual double    Main(const int index) const;
   virtual double    Plus(const int index) const;
   virtual double    Minus(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADX::JiADX(const string name) : JiADXBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADX::~JiADX(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiADX::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,const int applied)
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
double JiADX::Main(const int index) const
  {
   return(iADX(m_symbol,m_timeframe,m_ma_period,m_applied,MODE_MAIN,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiADX::Plus(const int index) const
  {
   return(iADX(m_symbol,m_timeframe,m_ma_period,m_applied,MODE_PLUSDI,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiADX::Minus(const int index) const
  {
   return(iADX(m_symbol,m_timeframe,m_ma_period,m_applied,MODE_MINUSDI,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiADXWilder : public JiADXWilderBase
  {
public:
                     JiADXWilder(const string name);
                    ~JiADXWilder(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period);
   double            Main(const int index) const;
   double            Plus(const int index) const;
   double            Minus(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADXWilder::JiADXWilder(const string name) : JiADXWilderBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiADXWilder::~JiADXWilder(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiADXWilder::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiADXWilder::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiADXWilder::Plus(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiADXWilder::Minus(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiBands : public JiBandsBase
  {
public:
                     JiBands(const string name);
                    ~JiBands(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,
                            const int ma_shift,const double deviation,const int applied);
   virtual double    Base(const int index) const;
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBands::JiBands(const string name) : JiBandsBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiBands::~JiBands(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiBands::Create(const string symbol,const ENUM_TIMEFRAMES period,const int ma_period,
                     const int ma_shift,const double deviation,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ma_shift=ma_shift;
   m_deviation=deviation;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiBands::Base(const int index) const
  {
   return(iBands(m_symbol,m_timeframe,m_ma_period,m_deviation,m_ma_shift,m_applied,MODE_BASE,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiBands::Upper(const int index) const
  {
   return(iBands(m_symbol,m_timeframe,m_ma_period,m_deviation,m_ma_shift,m_applied,MODE_UPPER,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiBands::Lower(const int index) const
  {
   return(iBands(m_symbol,m_timeframe,m_ma_period,m_deviation,m_ma_shift,m_applied,MODE_LOWER,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiEnvelopes : public JiEnvelopesBase
  {
public:
                     JiEnvelopes(const string name);
                    ~JiEnvelopes(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ma_shift,const ENUM_MA_METHOD ma_method,
                            const int applied,const double deviation);
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiEnvelopes::JiEnvelopes(const string name) : JiEnvelopesBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiEnvelopes::~JiEnvelopes(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiEnvelopes::Create(const string symbol,const ENUM_TIMEFRAMES period,
                         const int ma_period,const int ma_shift,const ENUM_MA_METHOD ma_method,
                         const int applied,const double deviation)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ma_shift=ma_shift;
   m_ma_method=ma_method;
   m_applied=applied;
   m_deviation=deviation;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiEnvelopes::Upper(const int index) const
  {
   return(iEnvelopes(m_symbol,m_timeframe,m_ma_period,m_ma_method,m_ma_shift,
          m_applied,m_deviation,MODE_UPPER,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiEnvelopes::Lower(const int index) const
  {
   return(iEnvelopes(m_symbol,m_timeframe,m_ma_period,m_ma_method,m_ma_shift,
          m_applied,m_deviation,MODE_LOWER,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiIchimoku : public JiIchimokuBase
  {
public:
                     JiIchimoku(const string name);
                    ~JiIchimoku(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int tenkan_sen,const int kijun_sen,const int senkou_span_b);
   virtual double    TenkanSen(const int index) const;
   virtual double    KijunSen(const int index) const;
   virtual double    SenkouSpanA(const int index) const;
   virtual double    SenkouSpanB(const int index) const;
   virtual double    ChinkouSpan(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiIchimoku::JiIchimoku(const string name) : JiIchimokuBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiIchimoku::~JiIchimoku(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiIchimoku::Create(const string symbol,const ENUM_TIMEFRAMES period,
                        const int tenkan_sen,const int kijun_sen,const int senkou_span_b)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_tenkan_sen= tenkan_sen;
   m_kijun_sen = kijun_sen;
   m_senkou_span_b=senkou_span_b;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiIchimoku::TenkanSen(const int index) const
  {
   return(iIchimoku(m_symbol,m_timeframe,m_tenkan_sen,m_kijun_sen,m_senkou_span_b,MODE_TENKANSEN,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiIchimoku::KijunSen(const int index) const
  {
   return(iIchimoku(m_symbol,m_timeframe,m_tenkan_sen,m_kijun_sen,m_senkou_span_b,MODE_KIJUNSEN,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiIchimoku::SenkouSpanA(const int index) const
  {
   return(iIchimoku(m_symbol,m_timeframe,m_tenkan_sen,m_kijun_sen,m_senkou_span_b,MODE_SENKOUSPANA,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiIchimoku::SenkouSpanB(const int index) const
  {
   return(iIchimoku(m_symbol,m_timeframe,m_tenkan_sen,m_kijun_sen,m_senkou_span_b,MODE_SENKOUSPANB,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiIchimoku::ChinkouSpan(const int index) const
  {
   return(iIchimoku(m_symbol,m_timeframe,m_tenkan_sen,m_kijun_sen,m_senkou_span_b,MODE_CHINKOUSPAN,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiMA : public JiMABase
  {
public:
                     JiMA(const string name);
                    ~JiMA(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ma_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMA::JiMA(const string name) : JiMABase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiMA::~JiMA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiMA::Create(const string symbol,const ENUM_TIMEFRAMES period,
                  const int ma_period,const int ma_shift,
                  const ENUM_MA_METHOD ma_method,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ma_shift=ma_shift;
   m_ma_method=ma_method;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiMA::Main(const int index) const
  {
   return(iMA(m_symbol,m_timeframe,m_ma_period,m_ma_shift,m_ma_method,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiSAR : public JiSARBase
  {
public:
                     JiSAR(const string name);
                    ~JiSAR(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,const double step,const double maximum);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiSAR::JiSAR(const string name) : JiSARBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiSAR::~JiSAR(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiSAR::Create(const string symbol,const ENUM_TIMEFRAMES period,const double step,const double maximum)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_step=step;
   m_maximum=maximum;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiSAR::Main(const int index) const
  {
   return(iSAR(m_symbol,m_timeframe,m_step,m_maximum,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiStdDev : public JiStdDevBase
  {
public:
                     JiStdDev(const string name);
                    ~JiStdDev(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ma_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStdDev::JiStdDev(const string name) : JiStdDevBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiStdDev::~JiStdDev(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiStdDev::Create(const string symbol,const ENUM_TIMEFRAMES period,
                      const int ma_period,const int ma_shift,
                      const ENUM_MA_METHOD ma_method,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ma_shift=ma_shift;
   m_ma_method=ma_method;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiStdDev::Main(const int index) const
  {
   return(iStdDev(m_symbol,m_timeframe,m_ma_period,m_ma_shift,m_ma_method,m_applied,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiDEMA : public JiDEMABase
  {
public:
                     JiDEMA(const string name);
                    ~JiDEMA(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDEMA::JiDEMA(const string name) : JiDEMABase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiDEMA::~JiDEMA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiDEMA::Create(const string symbol,const ENUM_TIMEFRAMES period,
                    const int ma_period,const int ind_shift,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ind_shift = ind_shift;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiDEMA::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiTEMA : public JiTEMABase
  {
public:
                     JiTEMA(const string name);
                    ~JiTEMA(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTEMA::JiTEMA(const string name) : JiTEMABase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiTEMA::~JiTEMA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiTEMA::Create(const string symbol,const ENUM_TIMEFRAMES period,
                    const int ma_period,const int ind_shift,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ind_shift = ind_shift;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiTEMA::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiFraMA : public JiFraMABase
  {
public:
                     JiFraMA(const string name);
                    ~JiFraMA(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFraMA::JiFraMA(const string name) : JiFraMABase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFraMA::~JiFraMA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiFraMA::Create(const string symbol,const ENUM_TIMEFRAMES period,
                     const int ma_period,const int ind_shift,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_ind_shift = ind_shift;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiFraMA::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAMA : public JiAMABase
  {
public:
                     JiAMA(const string name);
                    ~JiAMA(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int ma_period,const int fast_ema_period,const int slow_ema_period,
                            const int ind_shift,const int applied);
   double            Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAMA::JiAMA(const string name) : JiAMABase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAMA::~JiAMA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiAMA::Create(const string symbol,const ENUM_TIMEFRAMES period,
                   const int ma_period,const int fast_ema_period,const int slow_ema_period,
                   const int ind_shift,const int applied)
  {
   m_symbol=symbol;
   m_timeframe = period;
   m_ma_period = ma_period;
   m_fast_ema_period = fast_ema_period;
   m_slow_ema_period = m_slow_ema_period;
   m_ind_shift=ind_shift;
   m_applied=applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiAMA::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiVIDyA : public JiVIDyABase
  {
public:
                     JiVIDyA(const string name);
                    ~JiVIDyA(void);
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int cmo_period,const int ema_period,
                            const int ind_shift,const int applied);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVIDyA::JiVIDyA(const string name) : JiVIDyABase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiVIDyA::~JiVIDyA(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiVIDyA::Create(const string symbol,const ENUM_TIMEFRAMES period,
                const int cmo_period,const int ema_period,
                const int ind_shift,const int applied)
  {
   m_symbol = symbol;
   m_timeframe = period;
   m_cmo_period = cmo_period;
   m_ema_period = ema_period;
   m_ind_shift = ind_shift;
   m_applied = applied;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiVIDyA::Main(const int index) const
  {
   return(0);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\Trend.mqh"
#else
#include "..\..\mql4\indicators\Trend.mqh"
#endif
//+------------------------------------------------------------------+
