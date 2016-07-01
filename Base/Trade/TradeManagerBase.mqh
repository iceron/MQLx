//+------------------------------------------------------------------+
//|                                             TradeManagerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "ExpertTradeXBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTradeManagerBase : public CArrayObj
  {
public:
                     CTradeManagerBase(void);
                    ~CTradeManagerBase(void);
   virtual int       Search(string);
   virtual bool      Add(CExpertTradeX*);
   virtual void      Deinit(void);
   CExpertTrade     *Get(const string);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeManagerBase::CTradeManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeManagerBase::~CTradeManagerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeManagerBase::Deinit(void)
  {
   Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTradeManagerBase::Add(CExpertTradeX *node)
  {
   if(Search(node.Name())==-1)
      return CArrayObj::Add(node);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CTradeManagerBase::Search(string symbol=NULL)
  {
   if(symbol==NULL)
      symbol= Symbol();
   for(int i=0;i<Total();i++)
     {
      CExpertTradeX *item=At(i);
      if(StringCompare(item.Name(),symbol)==0)
         return i;
     }
   return -1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertTrade *CTradeManagerBase::Get(const string name=NULL)
  {
   if(name==NULL && Total()>0)
      return At(0);
   for(int i=0;i<Total();i++)
     {
      CExpertTradeX *item=At(i);
      if(StringCompare(item.Name(),name)==0)
         return item;
     }
   return NULL;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Trade\TradeManager.mqh"
#else
#include "..\..\MQL4\Trade\TradeManager.mqh"
#endif
//+------------------------------------------------------------------+
