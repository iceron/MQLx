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
   bool              m_active;
   string            m_comment;
public:
                     CCommentBase(void);
                    ~CCommentBase(void);
   bool              Active(){return m_active;}
   void              Active(bool active){m_active=active;}
   virtual void      Init(const string comment) {m_comment=comment;}
   string            Text(void) const {return m_comment;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::CCommentBase(void) : m_active(true),
                                   m_comment(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::~CCommentBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Comment\Comment.mqh"
#else
#include "..\..\MQL4\Comment\Comment.mqh"
#endif
//+------------------------------------------------------------------+
