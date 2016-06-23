//+------------------------------------------------------------------+
//|                                                  CommentBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCommentBase : public CObject
  {
protected:
   bool              m_active;
   string            m_comment;
   CObject          *m_container;
public:
                     CCommentBase(void);
                    ~CCommentBase(void);
   CObject          *GetContainer(void);
   void              SetContainer(CObject *container);
   bool              Active(void) const;
   void              Active(bool);
   virtual void      Init(const string);
   string            Text(void) const;
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
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CCommentBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::Active(bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCommentBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentBase::Init(const string comment)
  {
   m_comment=comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CCommentBase::Text(void) const
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
