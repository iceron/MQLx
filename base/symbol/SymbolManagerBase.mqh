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
public:
                     CSymbolManagerBase(void);
                    ~CSymbolManagerBase(void);
   virtual bool      Add(CSymbolInfo *symbolinfo);
   virtual void      Deinit(void);
   CSymbolInfo      *Get(const string name);
   virtual bool      RefreshRates(void);
   virtual bool      Search(const string symbol);
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
CSymbolManagerBase::Deinit(void)
  {
   Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSymbolManagerBase::Add(CSymbolInfo *node)
  {
   if(Search(node)==-1)
      return CArrayObj::Add(node);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolInfo *CSymbolManagerBase::Get(const string name=NULL)
  {
   if(name==NULL && Total()>0)
      return At(0);
   for(int i=0;i<Total();i++)
     {
      CSymbolInfo *item=At(i);
      if(StringCompare(item.Name(),name)==0)
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
      if(!symbol.RefreshRates())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSymbolManagerBase::Search(const string symbol)
  {
   for(int i=0;i<Total();i++)
     {
      CSymbolInfo *item=At(i);
      if(StringCompare(item.Name(),symbol)==0)
         return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Symbol\SymbolManager.mqh"
#else
#include "..\..\MQL4\Symbol\SymbolManager.mqh"
#endif
//+------------------------------------------------------------------+
