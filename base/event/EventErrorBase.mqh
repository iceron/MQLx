//+------------------------------------------------------------------+
//|                                               EventErrorBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "EventBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JEventErrorBase : public JEvent
  {
protected:
   int               m_error;
   string            m_error_string;
public:
                     JEventErrorBase(void);
                     JEventErrorBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL);
                     JEventErrorBase(const ENUM_ACTION action,string message_add);
                    ~JEventErrorBase(void);
   virtual int       Type(void) {return(CLASS_TYPE_EVENT_ERROR);}
   virtual bool      Run(JEventRegistry *registry);
   virtual bool      Execute(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventErrorBase::JEventErrorBase(void) : m_error(GetLastError())
  {
   ResetLastError();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventErrorBase::JEventErrorBase(const ENUM_ACTION action,CObject *object1=NULL,CObject *object2=NULL,CObject *object3=NULL)
  {
   Init(action,object1,object2,object3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventErrorBase::JEventErrorBase(const ENUM_ACTION action,string message_add)
  {
   Init(action,message_add);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JEventErrorBase::~JEventErrorBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventErrorBase::Run(JEventRegistry *registry)
  {
   switch(m_error)
     {
      case 0:   m_error_string="no error";
      break;
      case 1:   m_error_string="no error, trade conditions not changed";
      break;
      case 2:   m_error_string="common error";
      break;
      case 3:   m_error_string="invalid trade parameters";
      break;
      case 4:   m_error_string="trade server is busy";
      break;
      case 5:   m_error_string="old version of the client terminal";
      break;
      case 6:   m_error_string="no connection with trade server";
      break;
      case 7:   m_error_string="not enough rights";
      break;
      case 8:   m_error_string="too frequent requests";
      break;
      case 9:   m_error_string="malfunctional trade operation (never returned error)";
      break;
      case 64:  m_error_string="account disabled";
      break;
      case 65:  m_error_string="invalid account";
      break;
      case 128: m_error_string="trade timeout";
      break;
      case 129: m_error_string="invalid price";
      break;
      case 130: m_error_string="invalid stops";
      break;
      case 131: m_error_string="invalid trade volume";
      break;
      case 132: m_error_string="market is closed";
      break;
      case 133: m_error_string="trade is disabled";
      break;
      case 134: m_error_string="not enough money";
      break;
      case 135: m_error_string="price changed";
      break;
      case 136: m_error_string="off quotes";
      break;
      case 137: m_error_string="broker is busy (never returned error)";
      break;
      case 138: m_error_string="requote";
      break;
      case 139: m_error_string="order is locked";
      break;
      case 140: m_error_string="long positions only allowed";
      break;
      case 141: m_error_string="too many requests";
      break;
      case 145: m_error_string="modification denied because order is too close to market";
      break;
      case 146: m_error_string="trade context is busy";
      break;
      case 147: m_error_string="expirations are denied by broker";
      break;
      case 148: m_error_string="amount of open and pending orders has reached the limit";
      break;
      case 149: m_error_string="hedging is prohibited";
      break;
      case 150: m_error_string="prohibited by FIFO rules";
      break;
      case 4000: m_error_string="no error (never generated code)";
      break;
      case 4001: m_error_string="wrong function pointer";
      break;
      case 4002: m_error_string="array index is out of range";
      break;
      case 4003: m_error_string="no memory for function call stack";
      break;
      case 4004: m_error_string="recursive stack overflow";
      break;
      case 4005: m_error_string="not enough stack for parameter";
      break;
      case 4006: m_error_string="no memory for parameter string";
      break;
      case 4007: m_error_string="no memory for temp string";
      break;
      case 4008: m_error_string="non-initialized string";
      break;
      case 4009: m_error_string="non-initialized string in array";
      break;
      case 4010: m_error_string="no memory for array\' string";
      break;
      case 4011: m_error_string="too long string";
      break;
      case 4012: m_error_string="remainder from zero divide";
      break;
      case 4013: m_error_string="zero divide";
      break;
      case 4014: m_error_string="unknown command";
      break;
      case 4015: m_error_string="wrong jump (never generated error)";
      break;
      case 4016: m_error_string="non-initialized array";
      break;
      case 4017: m_error_string="dll calls are not allowed";
      break;
      case 4018: m_error_string="cannot load library";
      break;
      case 4019: m_error_string="cannot call function";
      break;
      case 4020: m_error_string="expert function calls are not allowed";
      break;
      case 4021: m_error_string="not enough memory for temp string returned from function";
      break;
      case 4022: m_error_string="system is busy (never generated error)";
      break;
      case 4023: m_error_string="dll-function call critical error";
      break;
      case 4024: m_error_string="internal error";
      break;
      case 4025: m_error_string="out of memory";
      break;
      case 4026: m_error_string="invalid pointer";
      break;
      case 4027: m_error_string="too many formatters in the format function";
      break;
      case 4028: m_error_string="parameters count is more than formatters count";
      break;
      case 4029: m_error_string="invalid array";
      break;
      case 4030: m_error_string="no reply from chart";
      break;
      case 4050: m_error_string="invalid function parameters count";
      break;
      case 4051: m_error_string="invalid function parameter value";
      break;
      case 4052: m_error_string="string function internal error";
      break;
      case 4053: m_error_string="some array error";
      break;
      case 4054: m_error_string="incorrect series array usage";
      break;
      case 4055: m_error_string="custom indicator error";
      break;
      case 4056: m_error_string="arrays are incompatible";
      break;
      case 4057: m_error_string="global variables processing error";
      break;
      case 4058: m_error_string="global variable not found";
      break;
      case 4059: m_error_string="function is not allowed in testing mode";
      break;
      case 4060: m_error_string="function is not confirmed";
      break;
      case 4061: m_error_string="send mail error";
      break;
      case 4062: m_error_string="string parameter expected";
      break;
      case 4063: m_error_string="integer parameter expected";
      break;
      case 4064: m_error_string="double parameter expected";
      break;
      case 4065: m_error_string="array as parameter expected";
      break;
      case 4066: m_error_string="requested history data is in update state";
      break;
      case 4067: m_error_string="internal trade error";
      break;
      case 4068: m_error_string="resource not found";
      break;
      case 4069: m_error_string="resource not supported";
      break;
      case 4070: m_error_string="duplicate resource";
      break;
      case 4071: m_error_string="cannot initialize custom indicator";
      break;
      case 4072: m_error_string="cannot load custom indicator";
      break;
      case 4099: m_error_string="end of file";
      break;
      case 4100: m_error_string="some file error";
      break;
      case 4101: m_error_string="wrong file name";
      break;
      case 4102: m_error_string="too many opened files";
      break;
      case 4103: m_error_string="cannot open file";
      break;
      case 4104: m_error_string="incompatible access to a file";
      break;
      case 4105: m_error_string="no order selected";
      break;
      case 4106: m_error_string="unknown symbol";
      break;
      case 4107: m_error_string="invalid price parameter for trade function";
      break;
      case 4108: m_error_string="invalid ticket";
      break;
      case 4109: m_error_string="trade is not allowed in the expert properties";
      break;
      case 4110: m_error_string="longs are not allowed in the expert properties";
      break;
      case 4111: m_error_string="shorts are not allowed in the expert properties";
      break;
      case 4200: m_error_string="object already exists";
      break;
      case 4201: m_error_string="unknown object property";
      break;
      case 4202: m_error_string="object does not exist";
      break;
      case 4203: m_error_string="unknown object type";
      break;
      case 4204: m_error_string="no object name";
      break;
      case 4205: m_error_string="object coordinates error";
      break;
      case 4206: m_error_string="no specified subwindow";
      break;
      case 4207: m_error_string="graphical object error";
      break;
      case 4210: m_error_string="unknown chart property";
      break;
      case 4211: m_error_string="chart not found";
      break;
      case 4212: m_error_string="chart subwindow not found";
      break;
      case 4213: m_error_string="chart indicator not found";
      break;
      case 4220: m_error_string="symbol select error";
      break;
      case 4250: m_error_string="notification error";
      break;
      case 4251: m_error_string="notification parameter error";
      break;
      case 4252: m_error_string="notifications disabled";
      break;
      case 4253: m_error_string="notification send too frequent";
      break;
      case 5001: m_error_string="too many opened files";
      break;
      case 5002: m_error_string="wrong file name";
      break;
      case 5003: m_error_string="too long file name";
      break;
      case 5004: m_error_string="cannot open file";
      break;
      case 5005: m_error_string="text file buffer allocation error";
      break;
      case 5006: m_error_string="cannot delete file";
      break;
      case 5007: m_error_string="invalid file handle (file closed or was not opened)";
      break;
      case 5008: m_error_string="wrong file handle (handle index is out of handle table)";
      break;
      case 5009: m_error_string="file must be opened with FILE_WRITE flag";
      break;
      case 5010: m_error_string="file must be opened with FILE_READ flag";
      break;
      case 5011: m_error_string="file must be opened with FILE_BIN flag";
      break;
      case 5012: m_error_string="file must be opened with FILE_TXT flag";
      break;
      case 5013: m_error_string="file must be opened with FILE_TXT or FILE_CSV flag";
      break;
      case 5014: m_error_string="file must be opened with FILE_CSV flag";
      break;
      case 5015: m_error_string="file read error";
      break;
      case 5016: m_error_string="file write error";
      break;
      case 5017: m_error_string="string size must be specified for binary file";
      break;
      case 5018: m_error_string="incompatible file (for string arrays-TXT, for others-BIN)";
      break;
      case 5019: m_error_string="file is directory, not file";
      break;
      case 5020: m_error_string="file does not exist";
      break;
      case 5021: m_error_string="file cannot be rewritten";
      break;
      case 5022: m_error_string="wrong directory name";
      break;
      case 5023: m_error_string="directory does not exist";
      break;
      case 5024: m_error_string="specified file is not directory";
      break;
      case 5025: m_error_string="cannot delete directory";
      break;
      case 5026: m_error_string="cannot clean directory";
      break;
      case 5027: m_error_string="array resize error";
      break;
      case 5028: m_error_string="string resize error";
      break;
      case 5029: m_error_string="structure contains strings or dynamic arrays";
      break;
      default:   m_error_string="unknown error";
     }
   m_subject=m_error_string;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JEventErrorBase::Execute(JEventRegistry *registry,string sound_file=NULL,string file_name=NULL,string ftp_path=NULL)
  {
   if(registry.IsPrint(m_error))
      Print(m_message+m_message_add);
   if(registry.IsSound(m_error))
      PlaySound(sound_file);
   if(registry.IsPopup(m_error))
      Alert(m_message+m_message_add);
   if(registry.IsEmail(m_error))
      SendMail(m_subject,m_message+m_message_add);
   if(registry.IsPush(m_error))
      SendNotification(m_message+m_message_add);
   if(registry.IsFTP(m_error))
      SendFTP(file_name,ftp_path);
   return(false);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\event\EventError.mqh"
#else
#include "..\..\mql4\event\EventError.mqh"
#endif
//+------------------------------------------------------------------+
