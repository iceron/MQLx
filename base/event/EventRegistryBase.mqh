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
   CArrayInt         m_print;
   CArrayInt         m_sound;
   CArrayInt         m_popup;
   CArrayInt         m_email;
   CArrayInt         m_push;
   CArrayInt         m_ftp;
public:
                     JEventRegistryBase(void);
                    ~JEventRegistryBase(void);
   virtual void      Register(const ENUM_ALERT_MODE alert_mode,const int id);
   virtual bool      IsAllowed(const ENUM_ALERT_MODE alert_mode,const int id);
   virtual void      Clear(const ENUM_ALERT_MODE alert_mode);
   virtual void      Clear();
   virtual bool      Init(CArrayInt *print,CArrayInt *sound,CArrayInt *popup,CArrayInt *email,CArrayInt *push,CArrayInt *ftp);
   virtual bool      Init(int &print[],int &sound[],int &popup[],int &email[],int &push[],int &ftp[]);
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
bool JEventRegistryBase::Init(CArrayInt *print,CArrayInt *sound,CArrayInt *popup,CArrayInt *email,CArrayInt *push,CArrayInt *ftp)
  {
   if(print!=NULL)
      m_print.AddArray(print);
   if(sound!=NULL)
      m_sound.AddArray(sound);
   if(popup!=NULL)
      m_popup.AddArray(popup);
   if(email!=NULL)
      m_email.AddArray(email);
   if(push!=NULL)
      m_push.AddArray(push);
   if(ftp!=NULL)
      m_ftp.AddArray(ftp);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::Init(int &print[],int &sound[],int &popup[],int &email[],int &push[],int &ftp[])
  {
   if(ArraySize(print)>0)
      m_print.AddArray(print);
   if(ArraySize(sound)>0)
      m_sound.AddArray(sound);
   if(ArraySize(popup)>0)
      m_popup.AddArray(popup);
   if(ArraySize(email)>0)
      m_email.AddArray(email);
   if(ArraySize(push)>0)
      m_push.AddArray(push);
   if(ArraySize(ftp)>0)
      m_ftp.AddArray(ftp);
   return(true);
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
         m_print.Add(id);
         break;
        }
      case ALERT_MODE_SOUND:
        {
         m_sound.Add(id);
         break;
        }
      case ALERT_MODE_POPUP:
        {
         m_popup.Add(id);
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         m_email.Add(id);
         break;
        }
      case ALERT_MODE_PUSH:
        {
         m_push.Add(id);
         break;
        }
      case ALERT_MODE_FTP:
        {
         m_ftp.Add(id);
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
   switch(alert_mode)
     {
      case ALERT_MODE_PRINT:
        {
         return(IsPrint(id));
         break;
        }
      case ALERT_MODE_SOUND:
        {
         return(IsSound(id));
         break;
        }
      case ALERT_MODE_POPUP:
        {
         return(IsPopup(id));
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         return(IsEmail(id));
         break;
        }
      case ALERT_MODE_PUSH:
        {
         return(IsPush(id));
         break;
        }
      case ALERT_MODE_FTP:
        {
         return(IsFTP(id));
         break;
        }
      default:
        {
         Print(__FUNCTION__+": unknown alert mode");
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventRegistryBase::Clear(const ENUM_ALERT_MODE alert_mode)
  {
   switch(alert_mode)
     {
      case ALERT_MODE_PRINT:
        {
         m_print.Clear();
         break;
        }
      case ALERT_MODE_SOUND:
        {
         m_sound.Clear();
         break;
        }
      case ALERT_MODE_POPUP:
        {
         m_popup.Clear();
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         m_email.Clear();
         break;
        }
      case ALERT_MODE_PUSH:
        {
         m_push.Clear();
         break;
        }
      case ALERT_MODE_FTP:
        {
         m_ftp.Clear();
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
