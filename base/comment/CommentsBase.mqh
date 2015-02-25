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
public:
                     JCommentsBase(void);
                    ~JCommentsBase(void);
   virtual void      Display(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentsBase::JCommentsBase(void)
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
   string str = "";
   JComment *comment = GetFirstNode();
   while(CheckPointer(comment)==POINTER_DYNAMIC)
   {
      str = StringConcatenate(str,comment.Text(),"\n");
      comment = GetNextNode();
   }
   Comment(str);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\comment\Comments.mqh"
#else
#include "..\..\mql4\comment\Comments.mqh"
#endif
//+------------------------------------------------------------------+