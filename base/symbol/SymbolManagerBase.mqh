//+------------------------------------------------------------------+
//|                                                SymbolManager.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "..\Lib\SymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSymbolManagerBase : public CArrayObj
  {
protected:
   CSymbolInfo      *m_symbol_primary;
   CObject          *m_container;
public:
                     CSymbolManagerBase(void);
                    ~CSymbolManagerBase(void);
   virtual bool      Add(CSymbolInfo*);
   virtual void      Deinit(void);
   CSymbolInfo      *Get(string);
   virtual bool      RefreshRates(void);
   virtual int       Search(string);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   virtual void      SetPrimary(string);
   virtual void      SetPrimary(const int);
   virtual CSymbolInfo *GetPrimary(void);
   virtual string    GetPrimaryName(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolManagerBase::CSymbolManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolManagerBase::~CSymbolManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CSymbolManagerBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolManagerBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolManagerBase::Deinit(void)
  {
   Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSymbolManagerBase::Add(CSymbolInfo *node)
  {
   if(Search(node.Name())==-1)
      return CArrayObj::Add(node);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolInfo *CSymbolManagerBase::Get(string symbol=NULL)
  {
   if(symbol==NULL)
      symbol= Symbol();
   for(int i=0;i<Total();i++)
     {
      CSymbolInfo *item=At(i);
      if(!CheckPointer(item))
         continue;
      if(StringCompare(item.Name(),symbol)==0)
         return item;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSymbolManagerBase::RefreshRates(void)
  {
   for(int i=0;i<Total();i++)
     {
      CSymbolInfo *symbol=At(i);
      if(!CheckPointer(symbol))
         continue;
      if(!symbol.RefreshRates())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSymbolManagerBase::Search(string symbol=NULL)
  {
   if(symbol==NULL)
      symbol= Symbol();
   for(int i=0;i<Total();i++)
     {
      CSymbolInfo *item=At(i);
      if(StringCompare(item.Name(),symbol)==0)
         return i;
     }
   return -1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSymbolManagerBase::SetPrimary(string symbol=NULL)
  {
   if(symbol==NULL)
      symbol= Symbol();
   m_symbol_primary=Get(symbol);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSymbolManagerBase::SetPrimary(const int idx)
  {
   m_symbol_primary=At(idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolInfo *CSymbolManagerBase::GetPrimary(void)
  {
   if(!CheckPointer(m_symbol_primary) && Total()>0)
      SetPrimary(0);
   return m_symbol_primary;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSymbolManagerBase::GetPrimaryName(void)
  {
   if(CheckPointer(m_symbol_primary))
      return m_symbol_primary.Name();
   return NULL;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Symbol\SymbolManager.mqh"
#else
#include "..\..\MQL4\Symbol\SymbolManager.mqh"
#endif
//+------------------------------------------------------------------+
