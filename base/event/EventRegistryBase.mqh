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
      if(!CheckPointer(m_print))
         m_print=new CArrayInt();
      m_print.AddArray(print);
      m_print.Sort();
     }
   if(sound!=NULL)
     {
      if(!CheckPointer(m_sound))
         m_sound=new CArrayInt();
      m_sound.AddArray(sound);
      m_sound.Sort();
     }
   if(popup!=NULL)
     {
      if(!CheckPointer(m_popup))
         m_popup=new CArrayInt();
      m_popup.AddArray(popup);
      m_popup.Sort();
     }
   if(email!=NULL)
     {
      if(!CheckPointer(m_email))
         m_email=new CArrayInt();
      m_email.AddArray(email);
      m_email.Sort();
     }
   if(push!=NULL)
     {
      if(!CheckPointer(m_push))
         m_push=new CArrayInt();
      m_push.AddArray(push);
      m_push.Sort();
     }
   if(ftp!=NULL)
     {
      if(!CheckPointer(m_ftp))
         m_ftp=new CArrayInt();
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
      if(!CheckPointer(m_print))
         m_print=new CArrayInt();
      m_print.AddArray(print);
      m_print.Sort();
     }
   if(ArraySize(sound)>0)
     {
      if(!CheckPointer(m_sound))
         m_sound=new CArrayInt();
      m_sound.AddArray(sound);
      m_sound.Sort();
     }
   if(ArraySize(popup)>0)
     {
      if(!CheckPointer(m_popup))
         m_popup=new CArrayInt();
      m_popup.AddArray(popup);
      m_popup.Sort();
     }
   if(ArraySize(email)>0)
     {
      if(!CheckPointer(m_email))
         m_email=new CArrayInt();
      m_email.AddArray(email);
      m_email.Sort();
     }
   if(ArraySize(push)>0)
     {
      if(!CheckPointer(m_push))
         m_push=new CArrayInt();
      m_push.AddArray(push);
      m_push.Sort();
     }
   if(ArraySize(ftp)>0)
     {
      if(!CheckPointer(m_ftp))
         m_ftp=new CArrayInt();
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
   return(m_debug||(CheckPointer(m_print)?m_print.Search(id)>=0:false));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsSound(int id)
  {
   return(CheckPointer(m_sound)?m_sound.Search(id)>=0:false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsPopup(int id)
  {
   return(CheckPointer(m_popup)?m_popup.Search(id)>=0:false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsEmail(int id)
  {
   return(CheckPointer(m_email)?m_email.Search(id)>=0:false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsPush(int id)
  {
   return(CheckPointer(m_push)?m_push.Search(id)>=0:false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventRegistryBase::IsFTP(int id)
  {
   return(CheckPointer(m_ftp)?m_ftp.Search(id)>=0:false);
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
         if(!CheckPointer(m_print))
            m_print=new CArrayInt();
         m_print.InsertSort(id);
         break;
        }
      case ALERT_MODE_SOUND:
        {
         if(!CheckPointer(m_sound))
            m_sound=new CArrayInt();
         m_sound.InsertSort(id);
         break;
        }
      case ALERT_MODE_POPUP:
        {
         if(!CheckPointer(m_popup))
            m_popup=new CArrayInt();
         m_popup.InsertSort(id);
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         if(!CheckPointer(m_email))
            m_email=new CArrayInt();
         m_email.InsertSort(id);
         break;
        }
      case ALERT_MODE_PUSH:
        {
         if(!CheckPointer(m_push))
            m_push=new CArrayInt();
         m_push.InsertSort(id);
         break;
        }
      case ALERT_MODE_FTP:
        {
         if(!CheckPointer(m_ftp))
            m_ftp=new CArrayInt();
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
         PrintFormat(__FUNCTION__+": unknown alert mode");
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
         if(CheckPointer(m_print))
            m_print.Clear();
         break;
        }
      case ALERT_MODE_SOUND:
        {
         if(CheckPointer(m_print))
            m_sound.Clear();
         break;
        }
      case ALERT_MODE_POPUP:
        {
         if(CheckPointer(m_print))
            m_popup.Clear();
         break;
        }
      case ALERT_MODE_EMAIL:
        {
         if(CheckPointer(m_print))
            m_email.Clear();
         break;
        }
      case ALERT_MODE_PUSH:
        {
         if(CheckPointer(m_print))
            m_push.Clear();
         break;
        }
      case ALERT_MODE_FTP:
        {
         if(CheckPointer(m_print))
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
   if(CheckPointer(m_print))
      m_print.Clear();
   if(CheckPointer(m_print))
      m_sound.Clear();
   if(CheckPointer(m_print))
      m_popup.Clear();
   if(CheckPointer(m_print))
      m_email.Clear();
   if(CheckPointer(m_print))
      m_push.Clear();
   if(CheckPointer(m_print))
      m_ftp.Clear();
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventRegistry.mqh"
#else
#include "..\..\mql4\event\EventRegistry.mqh"
#endif
//+------------------------------------------------------------------+
