//+------------------------------------------------------------------+
//|                                            EventRegistryBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_ALERT_MODE.mqh"
#include <Arrays\ArrayInt.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventRegistryBase : public CObject
  {
protected:
   CArrayInt        *m_print;
   CArrayInt        *m_sound;
   CArrayInt        *m_popup;
   CArrayInt        *m_email;
   CArrayInt        *m_push;
   CArrayInt        *m_ftp;
public:
                     JEventRegistryBase(void);
                    ~JEventRegistryBase(void);
   virtual void      Register(const ENUM_ALERT_MODE alert_mode,const int id);
   virtual bool      IsAllowed(const ENUM_ALERT_MODE alert_mode,const int id);
   virtual void      Clear(const ENUM_ALERT_MODE alert_mode);
   virtual void      Clear();
   bool              IsPrint(int id);
   bool              IsSound(int id);
   bool              IsPopup(int id);
   bool              IsEmail(int id);
   bool              IsPush(int id);
   bool              IsFTP(int id);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventRegistryBase::JEventRegistryBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventRegistryBase::~JEventRegistryBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsPrint(int id)
  {
   return(m_print.Search(id)>=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsSound(int id)
  {
   return(m_sound.Search(id)>=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsPopup(int id)
  {
   return(m_popup.Search(id)>=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsEmail(int id)
  {
   return(m_email.Search(id)>=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsPush(int id)
  {
   return(m_push.Search(id)>=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsFTP(int id)
  {
   return(m_ftp.Search(id)>=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventRegistryBase::Register(ENUM_ALERT_MODE alert_mode,int id)
  {
   switch(alert_mode)
     {
      case ALERT_MODE_PRINT:
        {
         //m_print|=id;
         break;
        }
      case ALERT_MODE_SOUND:
        {
         //m_sound|=id;
         break;
        }
      case ALERT_MODE_POPUP:
        {
         //m_popup|=id;
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         //m_email|=id;
         break;
        }
      case ALERT_MODE_PUSH:
        {
         //m_push|=id;
         break;
        }
      case ALERT_MODE_FTP:
        {
         //m_ftp|=id;
         break;
        }
      default:
        {
         Print(__FUNCTION__+": unknown alert mode");
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsAllowed(const ENUM_ALERT_MODE alert_mode,const int id)
  {
//int value=0;
   switch(alert_mode)
     {
      case ALERT_MODE_PRINT:
        {
         //value=m_print;
         break;
        }
      case ALERT_MODE_SOUND:
        {
         //value=m_sound;
         break;
        }
      case ALERT_MODE_POPUP:
        {
         //value=m_popup;
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         //value=m_email;
         break;
        }
      case ALERT_MODE_PUSH:
        {
         //value=m_push;
         break;
        }
      case ALERT_MODE_FTP:
        {
         //value=m_ftp;
         break;
        }
      default:
        {
         Print(__FUNCTION__+": unknown alert mode");
         //return(value);
        }
     }
//return((value&id)!=0);
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventRegistryBase::Clear(const ENUM_ALERT_MODE alert_mode)
  {
/*
   switch(alert_mode)
     {
      case ALERT_MODE_PRINT:
        {
         m_print=0;
         break;
        }
      case ALERT_MODE_SOUND:
        {
         m_sound=0;
         break;
        }
      case ALERT_MODE_POPUP:
        {
         m_popup=0;
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         m_email=0;
         break;
        }
      case ALERT_MODE_PUSH:
        {
         m_push=0;
         break;
        }
      case ALERT_MODE_FTP:
        {
         m_ftp=0;
         break;
        }
      default:
        {
         Print(__FUNCTION__+": unknown alert mode");
        }
     }
     */
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventRegistryBase::Clear()
  {
/*
   m_print=0;
   m_sound=0;
   m_popup=0;
   m_email=0;
   m_push=0;
   m_ftp=0;
  */
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventRegistry.mqh"
#else
#include "..\..\mql4\event\EventRegistry.mqh"
#endif
//+------------------------------------------------------------------+
