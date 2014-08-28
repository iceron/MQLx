//+------------------------------------------------------------------+
//|                                                       JOrders.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include "Order.mqh"

enum ENUM_SORT_MODE {
   SORT_MODE_ASCENDING,
   SORT_MODE_DESCENDING
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrders : public CArrayObj
  {
protected:
   bool              m_activate;
public:
                     JOrders();
                    ~JOrders();
   //--- activation and deactivation
   virtual bool      Activate() {return(m_activate);}
   virtual void      Activate(bool activate) {m_activate=activate;}
   //--- events                  
   virtual void      OnTick();
   //--- archiving
   virtual void      CloseStops();
   virtual void      QuickSort(int beg,int end,const int mode=0);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrders::JOrders() : m_activate(true)
  {
   m_sort_mode = SORT_MODE_ASCENDING;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrders::~JOrders()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrders::OnTick()
  {
   for(int i=0;i<Total();i++)
     {
      JOrder *order=At(i);
      if(CheckPointer(order))
         order.CheckStops();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrders::CloseStops()
  {
   for(int i=0;i<Total();i++)
     {
      JOrder *order=At(i);
      if(CheckPointer(order))
         order.CloseStops();
     }
  }
  
void JOrders::QuickSort(int beg,int end,const int mode=0)
{
   
}
//+------------------------------------------------------------------+
