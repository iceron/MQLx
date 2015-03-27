//+------------------------------------------------------------------+
//|                                                 CommentsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\List.mqh>
#include "CommentBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JCommentsBase : public CList
  {
protected:
   bool              m_activate;
public:
                     JCommentsBase(void);
                    ~JCommentsBase(void);
   bool              Active(){return(m_activate);}
   virtual void      Display(void);
   virtual void      Concatenate(string &str,string comment);
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
   virtual CObject  *CreateElement(void) {return(new JComment(""));}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentsBase::JCommentsBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentsBase::~JCommentsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentsBase::Display(void)
  {
   Comment("");
   string str="";
   JComment *comment=GetFirstNode();
   while(CheckPointer(comment)==POINTER_DYNAMIC)
     {
      Concatenate(str,comment.Text());
      comment=GetNextNode();
     }
   Comment(str);
   Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentsBase::Concatenate(string &str,string comment)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCommentsBase::Backup(CFileBin *file)
  {
   file.WriteChar(m_activate);
   CList::Save(file.Handle());
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCommentsBase::Restore(CFileBin *file)
  {
   file.ReadChar(m_activate);
   CList::Load(file.Handle());
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\comment\Comments.mqh"
#else
#include "..\..\mql4\comment\Comments.mqh"
#endif
//+------------------------------------------------------------------+
