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
   bool              m_debug;
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
   virtual bool      IsAllowed(const int id);
   virtual void      Clear(const ENUM_ALERT_MODE alert_mode);
   virtual void      Clear();
   virtual void      DebugMode(bool debug=true);
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
JEventRegistryBase::JEventRegistryBase(void) : m_debug(false)
  {
   m_print.Sort();
   m_sound.Sort();
   m_popup.Sort();
   m_email.Sort();
   m_push.Sort();
   m_ftp.Sort();
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
JEventRegistryBase::DebugMode(bool debug=true)
  {
   m_debug=debug;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::Init(CArrayInt *print,CArrayInt *sound,CArrayInt *popup,CArrayInt *email,CArrayInt *push,CArrayInt *ftp)
  {
   if(print!=NULL)
   {
      m_print.AddArray(print);
      m_print.Sort();
   }   
   if(sound!=NULL)
   {
      m_sound.AddArray(sound);
      m_sound.Sort();
   }   
   if(popup!=NULL)
   {
      m_popup.AddArray(popup);
      m_popup.Sort();
   }   
   if(email!=NULL)
   {
      m_email.AddArray(email);
      m_email.Sort();
   }   
   if(push!=NULL)
   {
      m_push.AddArray(push);
      m_push.Sort();
   }   
   if(ftp!=NULL)
   {
      m_ftp.AddArray(ftp);
      m_ftp.Sort();
   }   
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::Init(int &print[],int &sound[],int &popup[],int &email[],int &push[],int &ftp[])
  {
   if(ArraySize(print)>0)
   {
      m_print.AddArray(print);
      m_print.Sort();
   }  
   if(ArraySize(sound)>0)
   {
      m_sound.AddArray(sound);
      m_sound.Sort();
   }   
   if(ArraySize(popup)>0)
   {
      m_popup.AddArray(popup);
      m_popup.Sort();
   }   
   if(ArraySize(email)>0)
   {
      m_email.AddArray(email);
      m_email.Sort();
   }   
   if(ArraySize(push)>0)
   {
      m_push.AddArray(push);
      m_push.Sort();
   }   
   if(ArraySize(ftp)>0)
   {
      m_ftp.AddArray(ftp);
      m_ftp.Sort();
   }   
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsPrint(int id)
  {
   return(m_debug||m_print.Search(id)>=0);
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
         m_print.InsertSort(id);
         break;
        }
      case ALERT_MODE_SOUND:
        {
         m_sound.InsertSort(id);
         break;
        }
      case ALERT_MODE_POPUP:
        {
         m_popup.InsertSort(id);
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         m_email.InsertSort(id);
         break;
        }
      case ALERT_MODE_PUSH:
        {
         m_push.InsertSort(id);
         break;
        }
      case ALERT_MODE_FTP:
        {
         m_ftp.InsertSort(id);
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
bool JEventRegistryBase::IsAllowed(const int id)
  {
   return(IsPrint(id)||IsSound(id)||IsPopup(id)||IsEmail(id)||IsPush(id)||IsFTP(id));
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
