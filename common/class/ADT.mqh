//+------------------------------------------------------------------+
//|                                                          ADT.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ADT
  {
public:
                     ADT(void);
                    ~ADT(void);
   static void       Delete(CObject *object);
   static string     GetParentDir(string filename);
   //--- methods for writing data
   static uint       WriteBool(const int handle,const bool value);
   static uint       WriteChar(const int handle,const char value);
   static uint       WriteShort(const int handle,const short value);
   static uint       WriteInteger(const int handle,const int value);
   static uint       WriteLong(const int handle,const long value);
   static uint       WriteFloat(const int handle,const float value);
   static uint       WriteDouble(const int handle,const double value);
   static uint       WriteString(const int handle,const string value);
   static uint       WriteString(const int handle,const string value,const int size);
   static uint       WriteCharArray(const int handle,const char &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       WriteShortArray(const int handle,const short& array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       WriteIntegerArray(const int handle,const int& array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       WriteLongArray(const int handle,const long &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       WriteFloatArray(const int handle,const float &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       WriteDoubleArray(const int handle,const double &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   template<typename T>
   static uint       WriteArray(const int handle,T &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   template<typename T>
   static uint       WriteStruct(const int handle,T &data);
   static bool       WriteObject(const int handle,CObject *object);
   //--- methods for reading data
   static bool       ReadBool(const int handle,bool &value);
   static bool       ReadChar(const int handle,char &value);
   static bool       ReadShort(const int handle,short &value);
   static bool       ReadInteger(const int handle,int &value);
   static bool       ReadLong(const int handle,long &value);
   static bool       ReadFloat(const int handle,float &value);
   static bool       ReadDouble(const int handle,double &value);
   static bool       ReadString(const int handle,string &value);
   static bool       ReadString(const int handle,string &value,const int size);
   static uint       ReadCharArray(const int handle,char &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       ReadShortArray(const int handle,short& array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       ReadIntegerArray(const int handle,int& array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       ReadLongArray(const int handle,long &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       ReadFloatArray(const int handle,float &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   static uint       ReadDoubleArray(const int handle,double &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   template<typename T>
   static uint       ReadArray(const int handle,T &array[],const int start_item=0,const int items_count=WHOLE_ARRAY);
   template<typename T>
   static uint       ReadStruct(const int handle,T &data);
   static bool       ReadObject(const int handle,CObject *object);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ADT::ADT(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ADT::~ADT(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ADT::Delete(CObject *object)
  {
   if(object!=NULL)
     {
      delete object;
      object=NULL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ADT::GetParentDir(string filename)
  {
   int pos=0;
   int last_pos=0;
   while(pos!=-1)
     {
      last_pos=pos;
      pos=StringFind(filename,"\\",pos+1);
     }
   return StringSubstr(filename,0,last_pos+1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteBool(const int handle,const bool value)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteInteger(handle,value,sizeof(bool));
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteChar(const int handle,const char value)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteInteger(handle,value,sizeof(char));
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteShort(const int handle,const short value)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteInteger(handle,value,sizeof(short));
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteInteger(const int handle,const int value)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteInteger(handle,value,sizeof(int));
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteLong(const int handle,const long value)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteLong(handle,value);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteFloat(const int handle,const float value)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteFloat(handle,value);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteDouble(const int handle,const double value)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteDouble(handle,value);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteString(const int handle,const string value)
  {
   if(handle!=INVALID_HANDLE)
     {
      //--- size of string
      int size=StringLen(value);
      //--- write
      if(FileWriteInteger(handle,size)==sizeof(int))
         return FileWriteString(handle,value,size);
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteString(const int handle,const string value,const int size)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteString(handle,value,size);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteCharArray(const int handle,const char &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteShortArray(const int handle,const short &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteIntegerArray(const int handle,const int &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteLongArray(const int handle,const long &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteFloatArray(const int handle,const float &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::WriteDoubleArray(const int handle,const double &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
static uint ADT::WriteArray(const int handle,T &array[],const int start_item=0,const int items_count=WHOLE_ARRAY)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
static uint ADT::WriteStruct(const int handle,T &data)
  {
   if(handle!=INVALID_HANDLE)
      return FileWriteStruct(handle,data);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::WriteObject(const int handle,CObject *object)
  {
   if(handle!=INVALID_HANDLE)
      if(CheckPointer(object))
         return object.Save(handle);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadBool(const int handle,bool &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      value=(bool)FileReadInteger(handle,sizeof(bool));
      return GetLastError()==0;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadChar(const int handle,char &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      value=(char)FileReadInteger(handle,sizeof(char));
      return GetLastError()==0;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadShort(const int handle,short &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      value=(short)FileReadInteger(handle,sizeof(short));
      return GetLastError()==0;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadInteger(const int handle,int &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      value=FileReadInteger(handle,sizeof(int));
      return GetLastError()==0;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadLong(const int handle,long &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      value=FileReadLong(handle);
      return GetLastError()==0;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadFloat(const int handle,float &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      value=FileReadFloat(handle);
      return GetLastError()==0;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadDouble(const int handle,double &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      value=FileReadDouble(handle);
      return GetLastError()==0;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadString(const int handle,string &value)
  {
   if(handle!=INVALID_HANDLE)
     {
      ResetLastError();
      int size=FileReadInteger(handle);
      if(GetLastError()==0)
        {
         value=FileReadString(handle,size);
         return size==StringLen(value);
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadString(const int handle,string &value,const int size)
  {
   if(handle!=INVALID_HANDLE)
     {
      value=FileReadString(handle,size);
      return size==StringLen(value);
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::ReadCharArray(const int handle,char &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileReadArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::ReadShortArray(const int handle,short &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileReadArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::ReadIntegerArray(const int handle,int &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileReadArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::ReadLongArray(const int handle,long &array[],const int start_item,const int items_count)
  {

   if(handle!=INVALID_HANDLE)
      return FileReadArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::ReadFloatArray(const int handle,float &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileReadArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static uint ADT::ReadDoubleArray(const int handle,double &array[],const int start_item,const int items_count)
  {
   if(handle!=INVALID_HANDLE)
      return FileReadArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
static uint ADT::ReadArray(const int handle,T &array[],const int start_item=0,const int items_count=WHOLE_ARRAY)
  {
   if(handle!=INVALID_HANDLE)
      return FileReadArray(handle,array,start_item,items_count);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
static uint ADT::ReadStruct(const int handle,T &data)
  {
   if(handle!=INVALID_HANDLE)
      return FileReadStruct(handle,data);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool ADT::ReadObject(const int handle,CObject *object)
  {
   if(handle!=INVALID_HANDLE)
      if(CheckPointer(object))
         return object.Load(handle);
   return false;
  }
//+------------------------------------------------------------------+
