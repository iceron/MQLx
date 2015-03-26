//+------------------------------------------------------------------+
//|                                                  CommentBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Files\FileBin.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JCommentBase : public CObject
  {
protected:
   string            m_comment;
public:
                     JCommentBase(void);
                    ~JCommentBase(void);
   virtual void      Init(string &comment);
   string            Text();
   virtual bool      Backup(CFileBin *file);
   virtual bool      Restore(CFileBin *file);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentBase::JCommentBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentBase::~JCommentBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentBase::Init(string &comment)
  {
   m_comment=comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string JCommentBase::Text(void)
  {
   return(m_comment);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCommentBase::Backup(CFileBin *file)
  {
   file.WriteString(m_comment);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCommentBase::Restore(CFileBin *file)
  {
   file.ReadString(m_comment);
   return(true);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\comment\Comment.mqh"
#else
#include "..\..\mql4\comment\Comment.mqh"
#endif
//+------------------------------------------------------------------+
