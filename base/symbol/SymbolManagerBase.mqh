//+------------------------------------------------------------------+
//|                                                SymbolManager.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#property strict
#include <Arrays\ArrayObj.mqh>
//#include "SymbolInfoBase.mqh"
#include "..\lib\SymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSymbolManagerBase : public CArrayObj
  {
protected:
   CSymbolInfo      *m_symbol;
public:
                     CSymbolManagerBase(void);
                    ~CSymbolManagerBase(void);
   virtual bool      Add(CSymbolInfo *symbolinfo);
   virtual void      Deinit(void);
   CSymbolInfo      *Get(const string name);
   virtual bool      RefreshRates(void);
   //virtual bool      Select(const string);
   //virtual CSymbolInfo* Selected(void);
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
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSymbolManagerBase::Select(const string symbol)
  {
   for(int i=0;i<Total();i++)
     {
      CSymbolInfo *item=At(i);
      if(StringCompare(symbol,item.Name())==0)
        {
         m_symbol=item;
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolInfo *CSymbolManagerBase::Selected(void)
  {
   return m_symbol;
  }
*/
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\symbol\SymbolManager.mqh"
#else
#include "..\..\mql4\symbol\SymbolManager.mqh"
#endif
//+------------------------------------------------------------------+
