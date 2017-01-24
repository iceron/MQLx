//+------------------------------------------------------------------+
//|                                                   OrdersBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_CLASS_TYPE.mqh"
#include <Arrays\ArrayObj.mqh>
#include "OrderBase.mqh"
class CExpertAdvisor;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrdersBase : public CArrayObj
  {
protected:
   CStops           *m_stops;
   CObject          *m_container;
public:
                     COrdersBase(void);
                    ~COrdersBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERS;}
   //--- initialization
   virtual bool      Init(CStops*);
   virtual CObject *GetContainer(void);
   virtual void      SetContainer(CObject*);
   virtual void      SetStops(CStops*);
   virtual CStops   *Stops(void);
   //--- events                  
   virtual void      OnTick(void);
   //--- order creation
   virtual COrder   *NewOrder(const ulong,const string,const int,const ENUM_ORDER_TYPE,const double,const double);
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
COrdersBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *COrdersBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::Init(CStops *stops=NULL)
  {
   SetStops(stops);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrdersBase::SetStops(CStops *stops)
  {
   if(CheckPointer(stops))
      m_stops=stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStops *COrdersBase::Stops(void)
  {
   return m_stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrder *COrdersBase::NewOrder(const ulong ticket,const string symbol,const int magic,const ENUM_ORDER_TYPE type,const double volume,const double price)
  {
   COrder *order=new COrder(ticket,symbol,type,volume,price);
   if(CheckPointer(order)==POINTER_DYNAMIC)
     {
      order.SetContainer(GetPointer(this));
      if(InsertSort(GetPointer(order)))
        {
         order.Magic(magic);
         if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_SELL)
            order.Init(GetPointer(this),m_stops);
         else order.Initialized(false);
         return order;
        }
     }
   return NULL;
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
   if(!CheckPointer(order))
      return(false);
   order.SetContainer(GetPointer(this));
   if(!Reserve(1))
      return(false);
   m_data[index]=order;
   m_sort_mode=-1;
   return CheckPointer(m_data[index]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::Save(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return false;
   return CArrayObj::Save(handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrdersBase::Load(const int handle)
  {
   if(handle==INVALID_HANDLE)
      return false;
   return CArrayObj::Load(handle);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\Orders.mqh"
#else
#include "..\..\MQL4\Order\Orders.mqh"
#endif
//+------------------------------------------------------------------+
