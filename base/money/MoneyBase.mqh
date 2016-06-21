//+------------------------------------------------------------------+
//|                                                    MoneyBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
#include "..\..\Common\Enum\ENUM_MONEY_UPDATE_TYPE.mqh"
#include "..\Symbol\SymbolManagerBase.mqh"
#include "..\Lib\AccountInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyBase : public CObject
  {
protected:
   bool              m_active;
   ENUM_MONEY_UPDATE_TYPE m_update;
   double            m_volume;
   double            m_risk;
   double            m_balance;
   double            m_balance_inc;
   int               m_period;
   datetime          m_last_update;
   bool              m_equity;
   string            m_name;
   CSymbolManager   *m_symbol_man;
   CSymbolInfo      *m_symbol;
   CAccountInfo     *m_account;
   CObject          *m_container;
public:
                     CMoneyBase(void);
                    ~CMoneyBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_MONEY;}
   //--- initialization
   virtual bool      Init(CSymbolManager*,CAccountInfo*);
   virtual bool      InitAccount(CAccountInfo*);
   virtual bool      InitSymbol(CSymbolManager*);
   virtual void      SetContainer(CObject *container) {m_container=container;}
   virtual bool      Validate(void) const {return true;}
   //--- getters and setters
   bool              Active(void) const {return m_active;}
   void              Active(const bool activate) {m_active=activate;}
   void              Balance(const double balance) {m_balance=balance;}
   double            Balance(void) const {return m_balance;}
   void              BalanceIncrement(const double balance) {m_balance_inc=balance;}
   double            BalanceIncrement(void) const {return m_balance_inc;}
   void              Equity(const bool equity) {m_equity=equity;}
   bool              Equity(void) const {return m_equity;}
   void              LastUpdate(const datetime update) {m_last_update=update;}
   datetime          LastUpdate(void) const {return m_last_update;}
   void              Name(const string name) {m_name=name;}
   string            Name(void) const {return m_name;}
   void              Period(const int period) {m_period=period;}
   int               Period(void) const {return m_period;}
   void              UpdateType(const ENUM_MONEY_UPDATE_TYPE type) {m_update=type;}
   double            Volume(const string,const double,const ENUM_ORDER_TYPE,const double);
   double            Volume(void) {return m_volume;}
   void              Volume(double volume) {m_volume = volume;}
protected:
   virtual void      OnLotSizeUpdated(void);
   virtual bool      UpdateByMargin(void);
   virtual bool      UpdateByPeriod(void);
   virtual void      UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double) {}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyBase::CMoneyBase(void) : m_active(true),
                               m_update(MONEY_UPDATE_ALWAYS),
                               m_volume(0.2),
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
   double maxvol=m_symbol.LotsMax();
   double minvol=m_symbol.LotsMin();
   if(m_volume<minvol)
      m_volume=minvol;
   if(m_volume>maxvol)
      m_volume=maxvol;
   m_last_update=TimeCurrent();
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\Money.mqh"
#else
#include "..\..\MQL4\Money\Money.mqh"
#endif
//+------------------------------------------------------------------+
