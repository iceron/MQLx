//+------------------------------------------------------------------+
//|                                                    MoneyBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Object.mqh>
#include "..\symbol\SymbolManagerBase.mqh"
#include "..\lib\AccountInfo.mqh"
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
#include "..\..\common\enum\ENUM_MONEY_UPDATE_TYPE.mqh"
class CExpert;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyBase : public CObject
  {
protected:
   bool              m_activate;
   ENUM_MONEY_UPDATE_TYPE m_update;
   double            m_volume;
   double            m_percent;
   double            m_risk;
   double            m_volume_base;
   double            m_volume_inc;
   double            m_balance;
   double            m_balance_inc;
   int               m_period;
   datetime          m_last_update;
   bool              m_equity;
   CSymbolManager   *m_symbol_man;
   CSymbolInfo      *m_symbol;
   CAccountInfo     *m_account;
   CExpert          *m_strategy;
public:
                     CMoneyBase(void);
                    ~CMoneyBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_MONEY;}
   //--- initialization
   virtual bool      Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo);
   virtual bool      InitAccount(CAccountInfo *account);
   virtual bool      InitSymbol(CSymbolManager *symbolmanager);
   virtual void      SetContainer(CExpert *s){m_strategy=s;}
   virtual bool      Validate(void) const;
   //--- getters and setters
   bool              Active(void) const {return m_activate;}
   void              Active(const bool activate) {m_activate=activate;}
   void              Balance(const double balance) {m_balance=balance;}
   double            Balance(void) const {return m_balance;}
   void              BalanceIncrement(const double balance) {m_balance_inc=balance;}
   double            BalanceIncrement(void) const {return m_balance_inc;}
   void              Equity(const bool equity) {m_equity=equity;}
   bool              Equity(void) const {return m_equity;}
   void              LastUpdate(const datetime update) {m_last_update=update;}
   datetime          LastUpdate(void) const {return m_last_update;}
   void              Percent(const double percent) {m_percent=percent;}
   double            Percent(void) const {return m_percent;}
   void              Period(const int period) {m_period=period;}
   int               Period(void) const {return m_period;}
   void              Risk(const double percent) {m_percent=percent;}
   double            Risk(void) const {return m_percent;}
   void              UpdateType(const ENUM_MONEY_UPDATE_TYPE type) {m_update=type;}
   double            Volume(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl);
   void              VolumeCurrent(const double volume) {m_volume=volume;}
   double            VolumeCurrent(void) const {return m_volume;}
   void              VolumeIncrement(const double volume) {m_volume_inc=volume;}
   double            VolumeIncrement(void) const {return m_volume_inc;}
   void              VolumeBase(const double volume_base) {m_volume_base=volume_base;}
   double            VolumeBase(void) const {return m_volume_base;}
protected:
   virtual void      OnLotSizeUpdated();
   virtual bool      UpdateByMargin(void);
   virtual bool      UpdateByPeriod(void);
   virtual void      UpdateLotSize(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl);   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyBase::CMoneyBase(void) : m_activate(true),
                               m_update(MONEY_UPDATE_ALWAYS),
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
CMoneyBase::~CMoneyBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo)
  {
   InitSymbol(symbolmanager);
   InitAccount(accountinfo);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::Validate(void) const
  {
   if(m_volume_base>0)
     {
      PrintFormat("invalid volume: "+(string)m_volume_base);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::InitSymbol(CSymbolManager *symbolmanager)
  {
   if(symbolmanager==NULL) return false;
   m_symbol_man=symbolmanager;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::InitAccount(CAccountInfo *account)
  {
   if(account==NULL)
     {
      if((m_account=new CAccountInfo)==NULL)
         return false;
     }
   else m_account=account;
   return CheckPointer(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyBase::Volume(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl)
  {
   if(!Active()) return 0;
   if(m_volume==0.0) UpdateLotSize(symbol,price,type,sl);
   else
     {
      switch(m_update)
        {
         case(MONEY_UPDATE_ALWAYS):    UpdateLotSize(symbol,price,type,sl);                      break;
         case(MONEY_UPDATE_PERIOD):    if(UpdateByPeriod()) UpdateLotSize(symbol,price,type,sl); break;
         case(MONEY_UPDATE_BALANCE):   if(UpdateByMargin()) UpdateLotSize(symbol,price,type,sl); break;
        }
     }
   return m_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::UpdateLotSize(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl)
  {
   double balance=m_equity==false?m_account.Balance():m_account.Equity();
   m_volume=m_volume_base+((int)(balance/m_balance_inc))*m_volume_inc;
   m_balance=balance;
   m_symbol = m_symbol_man.Get(symbol);
   OnLotSizeUpdated();   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::UpdateByMargin(void)
  {
   double balance=m_equity==false?m_account.Balance():m_account.Equity();
   if(balance>=m_balance+m_balance_inc || balance<=m_balance-m_balance_inc)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::UpdateByPeriod(void)
  {
   if(TimeCurrent()>=m_last_update+m_period)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::OnLotSizeUpdated(void)
  {
   if (m_symbol!=NULL)
   {
      double maxvol=m_symbol.LotsMax();
      double minvol=m_symbol.LotsMin();
      if(m_volume<minvol)
         m_volume=minvol;   
      if(m_volume>maxvol)
         m_volume=maxvol;
   }   
   m_last_update=TimeCurrent();
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\Money.mqh"
#else
#include "..\..\MQL4\Money\Money.mqh"
#endif
//+------------------------------------------------------------------+
