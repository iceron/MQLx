//+------------------------------------------------------------------+
//|                                                  CommentBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Files\FileBin.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCommentBase : public CObject
  {
protected:
   string            m_comment;
public:
                     CCommentBase(void);
                    ~CCommentBase(void);
   virtual void      Init(string comment);
   string            Text();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::CCommentBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::~CCommentBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::Init(string comment)
  {
   m_comment=comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CCommentBase::Text(void)
  {
   return m_comment;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Comment\Comment.mqh"
#else
#include "..\..\MQL4\Comment\Comment.mqh"
#endif
//+------------------------------------------------------------------+
