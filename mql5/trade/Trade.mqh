//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Expert\ExpertTrade.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTrade : public CExpertTrade
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  {
protected:
   bool              m_activate;
public:
                     JTrade(void);
                    ~JTrade(void);
   virtual int Type() const {return(CLASS_TYPE_TRADE);}                   
   //--- activation and deactivation
   virtual bool      Activate(void) const {return(m_activate);}
   virtual void      Activate(const bool activate) {m_activate=activate;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrade::JTrade(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTrade::~JTrade(void)
  {
  }
//+------------------------------------------------------------------+
