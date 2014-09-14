//+------------------------------------------------------------------+
//|                                                    MoneyBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
#include "..\lib\SymbolInfo.mqh"
#include "..\lib\AccountInfo.mqh"
#include "..\..\common\enum\ENUM_MONEY_UPDATE_TYPE.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JMoneyBase : public CObject
  {
protected:
   bool              m_activate;
   ENUM_MONEY_UPDATE_TYPE m_update;
   double            m_volume;
   double            m_percent;
   double            m_volume_base;
   double            m_volume_inc;
   double            m_balance;
   double            m_balance_inc;
   int               m_period;
   datetime          m_last_update;
   bool              m_equity;
   CSymbolInfo      *m_symbol;
   CAccountInfo     *m_account;
   JStrategy        *m_strategy;
public:
                     JMoneyBase(void);
                    ~JMoneyBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_MONEY);}
   //--- initialization
   virtual bool      Init(JStrategy *s);
   virtual bool      InitAccount(CAccountInfo *account);
   virtual bool      InitSymbol(CSymbolInfo *symbol);
   virtual void      SetContainer(JStrategy *s){m_strategy=s;}
   virtual bool      Validate(void);
   //--- getters and setters
   virtual bool      Active(void) const {return(m_activate);}
   virtual void      Active(bool activate) {m_activate=activate;}
   virtual void      Balance(double balance) {m_balance=balance;}
   virtual double    Balance(void) const {return(m_balance);}
   virtual void      BalanceIncrement(double balance) {m_balance_inc=balance;}
   virtual double    BalanceIncrement(void) const {return(m_balance_inc);}
   virtual void      Equity(bool equity) {m_equity=equity;}
   virtual bool      Equity(void) const {return(m_equity);}
   virtual void      LastUpdate(datetime update) {m_last_update=update;}
   virtual datetime  LastUpdate(void) const {return(m_last_update);}
   virtual void      Percent(double percent) {m_percent=percent;}
   virtual double    Percent(void) const {return(m_percent);}
   virtual void      Period(int period) {m_period=period;}
   virtual int       Period(void) const {return(m_period);}
   virtual void      UpdateType(ENUM_MONEY_UPDATE_TYPE type) {m_update=type;}
   virtual double    Volume(double price,ENUM_ORDER_TYPE type,double sl);
   virtual void      VolumeCurrent(double volume) {m_volume=volume;}
   virtual double    VolumeCurrent(void) const {return(m_volume);}
   virtual void      VolumeBase(double volume_base) {m_volume_base=volume_base;}
   virtual double    VolumeBase(void) const {return(m_volume_base);}
protected:
   virtual bool      UpdateByMargin(void);
   virtual bool      UpdateByPeriod(void);
   virtual void      UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyBase::JMoneyBase(void) : m_activate(true),
                               m_update(MONEY_UPDATE_NONE),
                               m_volume(0.2),
                               m_percent(0.0),
                               m_volume_base(0.0),
                               m_volume_inc(0.0),
                               m_balance(0.0),
                               m_balance_inc(0.0),
                               m_period(0),
                               m_last_update(0),
                               m_equity(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyBase::~JMoneyBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyBase::Init(JStrategy *s)
  {
   InitSymbol(s.SymbolInfo());
   InitAccount(s.AccountInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyBase::Validate(void)
  {
   if (m_volume_base>0)
   {
      Print("invalid volume: "+(string)m_volume_base);
      return(false);
   }   
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyBase::InitSymbol(CSymbolInfo *symbol)
  {
   m_symbol=symbol;
   return(CheckPointer(m_symbol));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyBase::InitAccount(CAccountInfo *account)
  {
   if(m_account!=NULL)
      delete m_account;
   if(account==NULL)
     {
      if((m_account=new CAccountInfo)==NULL)
         return(false);
     }
   else m_account=account;
   return(CheckPointer(m_account));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JMoneyBase::Volume(double price,ENUM_ORDER_TYPE type,double sl)
  {
   if(!Active()) return(0.0);
   if(m_volume==0.0) UpdateLotSize(price,type,sl);
   switch(m_update)
     {
      case(MONEY_UPDATE_NONE):
        {
         break;
        }
      case(MONEY_UPDATE_PERIOD):
        {
         if(UpdateByPeriod())
            UpdateLotSize(price,type,sl);
         break;
        }
      case(MONEY_UPDATE_MARGIN):
        {
         if(UpdateByMargin())
            UpdateLotSize(price,type,sl);
         break;
        }
     }
   return(m_volume);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JMoneyBase::UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl)
  {
   double balance=m_equity==false?m_account.Margin():m_account.Equity();
   m_volume=m_volume_base+((int)(balance/m_balance_inc))*m_volume_inc;
   m_balance=balance;
   m_last_update=TimeCurrent();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyBase::UpdateByMargin(void)
  {
   double balance=m_equity==false?m_account.Margin():m_account.Equity();
   if(balance>=m_balance+m_balance_inc || balance<=m_balance-m_balance_inc)
      return(true);
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyBase::UpdateByPeriod(void)
  {
   if(TimeCurrent()>=m_last_update+m_period)
      return(true);
   return(false);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\Money.mqh"
#else
#include "..\..\mql4\money\Money.mqh"
#endif
//+------------------------------------------------------------------+
