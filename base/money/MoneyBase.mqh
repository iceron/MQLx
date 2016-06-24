//+------------------------------------------------------------------+
//|                                                    MoneyBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Lib\AccountInfo.mqh"
#include "..\Event\EventAggregatorBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyBase : public CObject
  {
protected:
   bool              m_active;
   //ENUM_MONEY_UPDATE_TYPE m_update;
   double            m_volume;
   double            m_balance;
   double            m_balance_inc;
   int               m_period;
   //datetime          m_last_update;
   bool              m_equity;
   string            m_name;
   CSymbolManager   *m_symbol_man;
   CSymbolInfo      *m_symbol;
   CAccountInfo     *m_account;
   CEventAggregator *m_event_man;
   CObject          *m_container;
public:
                     CMoneyBase(void);
                    ~CMoneyBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_MONEY;}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CAccountInfo*,CEventAggregator*);
   bool              InitAccount(CAccountInfo*);
   bool              InitSymbol(CSymbolManager*);
   CObject          *GetContainer(void);
   void              SetContainer(CObject*);
   virtual bool      Validate(void);
   //--- getters and setters
   bool              Active(void) const;
   void              Active(const bool);
   //void              Balance(const double);
   //double            Balance(void) const;
   //void              BalanceIncrement(const double);
   //double            BalanceIncrement(void) const;
   void              Equity(const bool);
   bool              Equity(void) const;
   void              LastUpdate(const datetime);
   datetime          LastUpdate(void) const;
   void              Name(const string);
   string            Name(void) const;
   //void              Period(const int);
   //int               Period(void) const;
   //void              UpdateType(const ENUM_MONEY_UPDATE_TYPE);
   //ENUM_MONEY_UPDATE_TYPE UpdateType(void) const;
   double            Volume(const string,const double,const ENUM_ORDER_TYPE,const double);
   void              Volume(const double);
   double            Volume(void) const;
protected:
   virtual void      OnLotSizeUpdated(void);
   //virtual bool      UpdateByMargin(void);
   //virtual bool      UpdateByPeriod(void);
   virtual bool      UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyBase::CMoneyBase(void) : m_active(true),
                               //m_update(MONEY_UPDATE_ALWAYS),
                               m_volume(0.2),
                               m_period(0),
                               //m_last_update(0),
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
CMoneyBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CMoneyBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::Validate(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::Active(const bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::Balance(const double value)
  {
   m_balance=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyBase::Balance(void) const
  {
   return m_balance;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::BalanceIncrement(const double value)
  {
   m_balance_inc=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyBase::BalanceIncrement(void) const
  {
   return m_balance_inc;
  }
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::Equity(const bool value)
  {
   m_equity=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::Equity(void) const
  {
   return m_equity;
  }
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::LastUpdate(const datetime value)
  {
   m_last_update=value;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CMoneyBase::LastUpdate(void) const
  {
   return m_last_update;
  }
*/  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::Name(const string value)
  {
   m_name=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CMoneyBase::Name(void) const
  {
   return m_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::Period(const int value)
  {
   m_period=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CMoneyBase::Period(void) const
  {
   return m_period;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::UpdateType(const ENUM_MONEY_UPDATE_TYPE value)
  {
   m_update=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_MONEY_UPDATE_TYPE CMoneyBase::UpdateType(void) const
  {
   return m_update;
  }
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::Volume(const double value)
  {
   m_volume=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyBase::Volume(void) const
  {
   return m_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::Init(CSymbolManager *symbolmanager,CAccountInfo *accountinfo,CEventAggregator *event_man=NULL)
  {
   m_event_man=event_man;
   return InitSymbol(symbolmanager) && InitAccount(accountinfo);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::InitSymbol(CSymbolManager *symbolmanager)
  {
   m_symbol_man=symbolmanager;
   return CheckPointer(m_symbol_man);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::InitAccount(CAccountInfo *account)
  {
   m_account=account;
   return CheckPointer(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CMoneyBase::Volume(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl=0)
  {
   if(!Active())
      return 0;
   if(UpdateLotSize(symbol,price,type,sl))
      OnLotSizeUpdated();
   return m_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyBase::UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double)
  {
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
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
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyBase::OnLotSizeUpdated(void)
  {
   double maxvol=m_symbol.LotsMax();
   double minvol=m_symbol.LotsMin();
   if(m_volume<minvol)
      m_volume=minvol;
   if(m_volume>maxvol)
      m_volume=maxvol;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\Money.mqh"
#else
#include "..\..\MQL4\Money\Money.mqh"
#endif
//+------------------------------------------------------------------+
