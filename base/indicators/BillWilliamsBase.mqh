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
class JiACBase : public JIndicator
  {
public:
                     JiACBase(const string name);
                    ~JiACBase();
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period);
   virtual double    Main(const int index) const;
   virtual int       Type(void) const { return(IND_AC); }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiACBase::JiACBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiACBase::~JiACBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAlligatorBase : public JIndicator
  {
protected:
   int               m_jaw_period;
   int               m_jaw_shift;
   int               m_teeth_period;
   int               m_teeth_shift;
   int               m_lips_period;
   int               m_lips_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;
public:
                     JiAlligatorBase(const string name);
                    ~JiAlligatorBase();
   virtual int       Type(void) const { return(IND_ALLIGATOR); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int jaw_period,const int jaw_shift,
                            const int teeth_period,const int teeth_shift,
                            const int lips_period,const int lips_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   virtual double    Jaw(const int index) const;
   virtual double    Teeth(const int index) const;
   virtual double    Lips(const int index) const;
   int               JawPeriod(void)        const { return(m_jaw_period);   }
   int               JawShift(void)         const { return(m_jaw_shift);    }
   int               TeethPeriod(void)      const { return(m_teeth_period); }
   int               TeethShift(void)       const { return(m_teeth_shift);  }
   int               LipsPeriod(void)       const { return(m_lips_period);  }
   int               LipsShift(void)        const { return(m_lips_shift);   }
   ENUM_MA_METHOD    MaMethod(void)         const { return(m_ma_method);    }
   int               Applied(void)          const { return(m_applied);      }


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAlligatorBase::JiAlligatorBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAlligatorBase::~JiAlligatorBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiAOBase : public JIndicator
  {
public:
                     JiAOBase(const string name);
                    ~JiAOBase();
   virtual int       Type(void) const { return(IND_AO); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period);
   virtual double    Main(const int index) const;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAOBase::JiAOBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiAOBase::~JiAOBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiFractalsBase : public JIndicator
  {
public:
                     JiFractalsBase(const string name);
                    ~JiFractalsBase();
   virtual int       Type(void) const { return(IND_FRACTALS); }
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period);
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFractalsBase::JiFractalsBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiFractalsBase::~JiFractalsBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JiGatorBase : public JIndicator
  {
protected:
   int               m_jaw_period;
   int               m_jaw_shift;
   int               m_teeth_period;
   int               m_teeth_shift;
   int               m_lips_period;
   int               m_lips_shift;
   ENUM_MA_METHOD    m_ma_method;
   int               m_applied;
public:
                     JiGatorBase(const string name);
                    ~JiGatorBase();
   virtual int       Type(void) const { return(IND_GATOR); }
   virtual double    Upper(const int index) const;
   virtual double    Lower(const int index) const;
   virtual bool      Create(const string symbol,const ENUM_TIMEFRAMES period,
                            const int jaw_period,const int jaw_shift,
                            const int teeth_period,const int teeth_shift,
                            const int lips_period,const int lips_shift,
                            const ENUM_MA_METHOD ma_method,const int applied);
   int               JawPeriod(void)        const { return(m_jaw_period);   }
   int               JawShift(void)         const { return(m_jaw_shift);    }
   int               TeethPeriod(void)      const { return(m_teeth_period); }
   int               TeethShift(void)       const { return(m_teeth_shift);  }
   int               LipsPeriod(void)       const { return(m_lips_period);  }
   int               LipsShift(void)        const { return(m_lips_shift);   }
   ENUM_MA_METHOD    MaMethod(void)         const { return(m_ma_method);    }
   int               Applied(void)          const { return(m_applied);      }


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiGatorBase::JiGatorBase(const string name) : JIndicator(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JiGatorBase::~JiGatorBase()
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\indicators\BillWilliams.mqh"
#else
#include "..\..\mql4\indicators\BillWilliams.mqh"
#endif
//+------------------------------------------------------------------+
