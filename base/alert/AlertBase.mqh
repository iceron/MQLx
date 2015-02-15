//+------------------------------------------------------------------+
//|                                                    AlertBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayInt.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JAlertBase : public CObject
  {
protected:
   CArrayInt        *m_print;
   CArrayInt        *m_sound;
   CArrayInt        *m_popup;
   CArrayInt        *m_email;
   CArrayInt        *m_push;
   CArrayInt        *m_ftp;
public:
                     JAlertBase(void);
                    ~JAlertBase(void);
   virtual bool      Run(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JAlertBase::JAlertBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JAlertBase::~JAlertBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JAlertBase::Run(void)
  {
   return(false);
  }
//+------------------------------------------------------------------+
