//+------------------------------------------------------------------+
//|                                                IndicatorBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JIndicator : public JIndicatorBase
  {
protected:
   int               m_handle;
public:
                     JIndicator(const string name);
                    ~JIndicator(void);
   virtual double    Get(const int buffer_num,const int index) const;
   int Handle(void) const {return(m_handle);};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JIndicator::JIndicator(const string name) : JIndicatorBase(name)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JIndicator::~JIndicator(void)
  {
   IndicatorRelease(m_handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JIndicator::Get(const int buffer_num,const int index) const
  {
   double arr[1];
   int copied=CopyBuffer(m_handle,buffer_num,index,1,arr);
   return(copied!=-1?arr[0]:0);
  }
//+------------------------------------------------------------------+
