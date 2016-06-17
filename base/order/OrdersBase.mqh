//+------------------------------------------------------------------+
//|                                                   OrdersBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\ArrayObj.mqh>
#include "OrderBase.mqh"
class CExpert;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrdersBase : public CArrayObj
  {
protected:
   CStops           *m_stops;
   CExpert          *m_strategy;
public:
                     COrdersBase(void);
                    ~COrdersBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERS;}
   //--- initialization
   virtual bool      Init(CExpert *s=NULL,CStops *stops=NULL);
   virtual void      SetContainer(CExpert *s);
   virtual void      SetStops(CStops *stops);
   //--- events                  
   virtual void      OnTick(void);
   //--- order creation
   virtual bool      NewOrder(const int,const string,const int,const ENUM_ORDER_TYPE,const double,const double);
   //--- archiving
   virtual bool      CloseStops(void);
   //--- recovery
   virtual bool      CreateElement(const int);
   virtual bool      Save(const int);
   virtual bool      Load(const int);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrdersBase::COrdersBase(void)
  {
   if(!IsSorted())
      Sort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrdersBase::~COrdersBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::Init(CExpert *s=NULL,CStops *stops=NULL)
  {
   SetContainer(s);
   SetStops(stops);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrdersBase::SetContainer(CExpert *s)
  {
   if(s!=NULL) m_strategy=s;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrdersBase::SetStops(CStops *stops)
  {
   if(stops!=NULL) m_stops=stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::NewOrder(const int ticket,const string symbol,const int magic,const ENUM_ORDER_TYPE type,const double volume,const double price)
  {
   COrder *order=new COrder(ticket,symbol,type,volume,price);
   if(CheckPointer(order)==POINTER_DYNAMIC)
      if(InsertSort(GetPointer(order)))
         return order.Init(magic,GetPointer(this),m_stops);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrdersBase::OnTick(void)
  {
   for(int i=0;i<Total();i++)
     {
      COrder *order=At(i);
      if(CheckPointer(order))
         order.OnTick();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::CloseStops(void)
  {
   bool res=true;
   for(int i=0;i<Total();i++)
     {
      COrder *order=At(i);
      if(CheckPointer(order))
         if(!order.CloseStops())
            res=false;
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::CreateElement(const int index)
  {
   COrder*order=new COrder();
   order.Init(0,GetPointer(this),m_stops,true);
   return Insert(GetPointer(order),index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::Save(const int handle)
  {
   CArrayObj::Save(handle);
   //ADT::WriteBool(handle,m_clean);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::Load(const int handle)
  {
   CArrayObj::Load(handle);
   //ADT::ReadBool(handle,m_clean);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\Orders.mqh"
#else
#include "..\..\MQL4\Order\Orders.mqh"
#endif
//+------------------------------------------------------------------+
