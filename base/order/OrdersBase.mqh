//+------------------------------------------------------------------+
//|                                                   OrdersBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include "OrderBase.mqh"
class JStrategy;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrdersBase : public CArrayObj
  {
protected:
   bool              m_activate;
   bool              m_clean;
   JStops           *m_stops;
   JStrategy        *m_strategy;
public:
                     JOrdersBase(void);
                    ~JOrdersBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERS;}
   //--- initialization
   virtual bool      Init(JStrategy *s=NULL,JStops *stops=NULL);
   virtual void      SetContainer(JStrategy *s);
   virtual void      SetStops(JStops *stops);
   //--- getters and setters
   bool              Activate(void) const {return m_activate;}
   void              Activate(const bool activate) {m_activate=activate;}
   bool              Clean(void) const {return m_clean;}
   void              Clean(const bool clean) {m_clean=clean;}
   //void              Magic(int magic) {m_magic=magic;}
   //int               Magic() {return m_magic;}
   //--- events                  
   virtual void      OnTick(void);
   //--- order creation
   virtual bool      NewOrder(const int ticket,const string symbol,const int magic,const ENUM_ORDER_TYPE type,const double volume,const double price);
   //--- archiving
   virtual bool      CloseStops(void);
   //--- recovery
   virtual bool      CreateElement(const int index);
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::JOrdersBase(void) : m_activate(true),
                                 m_clean(false)
                                 //m_magic(0)
  {
   if(!IsSorted())
      Sort();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::~JOrdersBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::Init(JStrategy *s=NULL,JStops *stops=NULL)
  {
   SetContainer(s);
   SetStops(stops);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::SetContainer(JStrategy *s)
  {
   if(s!=NULL) m_strategy=s;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrdersBase::SetStops(JStops *stops)
  {
   if(stops!=NULL) m_stops=stops;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::NewOrder(const int ticket,const string symbol,const int magic,const ENUM_ORDER_TYPE type,const double volume,const double price)
  {
   JOrder *order=new JOrder(ticket,symbol,type,volume,price);
   if(CheckPointer(order)==POINTER_DYNAMIC)
      if(InsertSort(GetPointer(order)))
         return order.Init(magic,GetPointer(this),m_stops);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JOrdersBase::OnTick(void)
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
bool JOrdersBase::CloseStops(void)
  {
   bool res=true;
   for(int i=0;i<Total();i++)
     {
      JOrder *order=At(i);
      if(CheckPointer(order))
         if(!order.CloseStops())
            res=false;
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::CreateElement(const int index)
  {
   JOrder*order=new JOrder();
   order.Init(0,GetPointer(this),m_stops,true);
   return Insert(GetPointer(order),index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::Save(const int handle)
  {
   CArrayObj::Save(handle);
   ADT::WriteBool(handle,m_clean);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrdersBase::Load(const int handle)
  {
   CArrayObj::Load(handle);
   ADT::ReadBool(handle,m_clean);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\order\Orders.mqh"
#else
#include "..\..\mql4\order\Orders.mqh"
#endif
//+------------------------------------------------------------------+
