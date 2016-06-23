//+------------------------------------------------------------------+
//|                                                 CommentsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\List.mqh>
#include "CommentBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCommentsBase : public CList
  {
protected:
   bool              m_active;
   CObject          *m_container;
public:
                     CCommentsBase(void);
                    ~CCommentsBase(void);
   CObject          *GetContainer(void);
   void              SetContainer(CObject*);
   bool              Active(void) const;
   void              Active(bool);
   virtual void      Display(void);
   virtual void      Concatenate(string&,string)=0;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::CCommentsBase(void) : m_active(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::~CCommentsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::SetContainer(CObject *container)
  {
   m_container=container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CObject *CCommentsBase::GetContainer(void)
  {
   return m_container;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::Active(bool value)
  {
   m_active=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCommentsBase::Active(void) const
  {
   return m_active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::Display(void)
  {
   if(MQLInfoInteger(MQL_OPTIMIZATION) || (MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE)))
   {
   }
   else
   {
   Comment("");
   string str="";
   CComment *comment=GetFirstNode();
   while(CheckPointer(comment)==POINTER_DYNAMIC)
     {
      Concatenate(str,comment.Text());
      comment=GetNextNode();
     }
   Comment(str);
   Clear();
   }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Comment\Comments.mqh"
#else
#include "..\..\MQL4\Comment\Comments.mqh"
#endif
//+------------------------------------------------------------------+
