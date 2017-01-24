//+------------------------------------------------------------------+
//|                                                   ExpertFile.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Files\FileBin.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertFileBase : public CFileBin
  {
public:
                     CExpertFileBase(void);
                    ~CExpertFileBase(void);
   void              Handle(const int handle) { m_handle=handle; };
   uint              WriteBool(const bool value);
   bool              ReadBool(bool &value);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertFileBase::CExpertFileBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertFileBase::~CExpertFileBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CExpertFileBase::WriteBool(const bool value)
  {
//--- check handle
   if(m_handle!=INVALID_HANDLE)
     {
      int int_val=value;
      return(FileWriteInteger(m_handle,int_val,sizeof(int)));
     }
//--- failure
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CExpertFileBase::ReadBool(bool &value)
  {
//--- check handle
   if(m_handle!=INVALID_HANDLE)
     {
      ResetLastError();
      int int_val=FileReadInteger(m_handle,sizeof(int));
      value=(bool) int_val;
      return(GetLastError()==0);
     }
//--- failure
   return(false);
  }
/*
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool CExpertFileBase::WriteObject(T *object)
  {
//--- check handle & object
   if(m_handle!=INVALID_HANDLE)
      if(CheckPointer(object))
         return(object.Save(GetPointer(this)));
//--- failure
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool CExpertFileBase::ReadObject(T *object)
  {
//--- check handle & object
   if(m_handle!=INVALID_HANDLE)
      if(CheckPointer(object))
         return(object.Load(GetPointer(this)));
//--- failure
   return(false);
  }
*/
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\File\ExpertFile.mqh"
#else
#include "..\..\MQL4\File\ExpertFile.mqh"
#endif
//+------------------------------------------------------------------+
CExpertFile file;
//+------------------------------------------------------------------+
