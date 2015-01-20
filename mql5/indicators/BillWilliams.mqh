//+------------------------------------------------------------------+
//|                                               IndicatorsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAC : public JiACBase
  {
public:
                     JiAC(const string name);
                    ~JiAC();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAC::JiAC(const string name) : JiACBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAC::~JiAC()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiAC::Create(const string symbol,const ENUM_TIMEFRAMES period)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_handle=iAC(m_symbol,m_timeframe);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiAC::Main(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAlligator : public JiAlligatorBase
  {
public:
                     JiAlligator(const string name);
                    ~JiAlligator();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int jaw_period,const int jaw_shift,
                            const int teeth_period,const int teeth_shift,
                            const int lips_period,const int lips_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   virtual double    Jaw(const int index) const;
   virtual double    Teeth(const int index) const;
   virtual double    Lips(const int index) const;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAlligator::JiAlligator(const string name) : JiAlligatorBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAlligator::~JiAlligator()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiAlligator::Create(const string symbol,const ENUM_TIMEFRAMES period,
                         const int jaw_period,const int jaw_shift,
                         const int teeth_period,const int teeth_shift,
                         const int lips_period,const int lips_shift,
                         const ENUM_MA_METHOD ma_method,const int applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_jaw_period= jaw_period;
   m_jaw_shift = jaw_shift;
   m_teeth_period= teeth_period;
   m_teeth_shift = teeth_shift;
   m_lips_period = lips_period;
   m_lips_shift= lips_shift;
   m_ma_method = ma_method;
   m_applied=applied;
   m_handle=iAlligator(m_symbol,m_timeframe,m_jaw_period,m_jaw_shift,m_teeth_period,
                       m_teeth_shift,m_lips_period,m_lips_shift,m_ma_method,m_applied);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiAlligator::Jaw(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiAlligator::Teeth(const int index) const
  {
   return(Get(1,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiAlligator::Lips(const int index) const
  {
   return(Get(2,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAO : public JiAOBase
  {
public:
                     JiAO(const string name);
                    ~JiAO();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period);
   virtual double    Main(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAO::JiAO(const string name) : JiAOBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAO::~JiAO()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiAO::Create(const string symbol,const ENUM_TIMEFRAMES period)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_handle = iAO(m_symbol,m_timeframe);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiAO::Main(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiFractals : public JiFractalsBase
  {
public:
                     JiFractals(const string name);
                    ~JiFractals();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period);
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFractals::JiFractals(const string name) : JiFractalsBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFractals::~JiFractals()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiFractals::Create(const string symbol,const ENUM_TIMEFRAMES period)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_handle = iFractals(m_symbol,m_timeframe);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiFractals::Upper(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiFractals::Lower(const int index) const
  {
   return(Get(1,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiGator : public JiGatorBase
  {
public:
                     JiGator(const string name);
                    ~JiGator();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int jaw_period,const int jaw_shift,
                            const int teeth_period,const int teeth_shift,
                            const int lips_period,const int lips_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiGator::JiGator(const string name) : JiGatorBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiGator::~JiGator()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JiGator::Create(const string symbol,const ENUM_TIMEFRAMES period,
                     const int jaw_period,const int jaw_shift,
                     const int teeth_period,const int teeth_shift,
                     const int lips_period,const int lips_shift,
                     const ENUM_MA_METHOD ma_method,const int applied)
  {
   m_symbol=symbol;
   m_timeframe=period;
   m_jaw_period= jaw_period;
   m_jaw_shift = jaw_shift;
   m_teeth_period= teeth_period;
   m_teeth_shift = teeth_shift;
   m_lips_period = lips_period;
   m_lips_shift= lips_shift;
   m_ma_method = ma_method;
   m_applied=applied;
   m_handle=iGator(m_symbol,m_timeframe,m_jaw_period,m_jaw_shift,m_teeth_period,
                       m_teeth_shift,m_lips_period,m_lips_shift,m_ma_method,m_applied);
   return(m_handle!=INVALID_HANDLE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiGator::Upper(const int index) const
  {
   return(Get(0,index));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JiGator::Lower(const int index) const
  {
   return(Get(1,index));
  }
//+------------------------------------------------------------------+
