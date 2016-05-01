//+------------------------------------------------------------------+
//|                                                     TickBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Files\FileBin.mqh>
#include "..\lib\SymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JTickBase : public CObject
  {
protected:
   MqlTick           m_last;
   CSymbolInfo      *m_symbol;
   JEvents          *m_events;
public:
                     JTickBase(void);
                    ~JTickBase(void);
   //--- setters and getters
   MqlTick           LastTick() const {return m_last;}
   datetime          Time() const {return m_last.time;}
   double            Bid() const {return m_last.bid;}
   double            Ask() const {return m_last.ask;}
   double            Last() const {return m_last.last;}
   ulong             Volume() const {return m_last.volume;}
   virtual bool      IsNewTick(CSymbolInfo *symbol);
   //---recovery
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
protected:
   virtual bool      Compare(MqlTick &current);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
   virtual void      CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTickBase::JTickBase(void)
  {
   m_last.time= 0;
   m_last.bid = 0;
   m_last.ask = 0;
   m_last.last= 0;
   m_last.volume=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JTickBase::~JTickBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTickBase::IsNewTick(CSymbolInfo *symbol)
  {
   if(symbol!=NULL)
     {
      if(CheckPointer(m_symbol)==POINTER_INVALID)
         m_symbol=symbol;
      MqlTick current;
      if(SymbolInfoTick(symbol.Name(),current))
        {
         if(Compare(current))
           {
            m_last=current;
            CreateEvent(EVENT_CLASS_STANDARD,ACTION_TICK);
            return true;
           }
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTickBase::Compare(MqlTick &current)
  {
   return m_last.time==0 || m_last.time<current.time;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTickBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JTickBase::CreateEvent(const ENUM_EVENT_CLASS type,const ENUM_ACTION action,string message_add)
  {
   if(m_events!=NULL)
      m_events.CreateEvent(type,action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTickBase::Save(const int handle)
  {
   ADT::WriteStruct(handle,m_last);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JTickBase::Load(const int handle)
  {
   ADT::ReadStruct(handle,m_last);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\tick\Tick.mqh"
#else
#include "..\..\mql4\tick\Tick.mqh"
#endif
//+------------------------------------------------------------------+
