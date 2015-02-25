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
   virtual void      Concatenate(string &str,string comment);
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
#ifdef __MQL5__
#include "..\..\mql5\comment\Comments.mqh"
#else
#include "..\..\mql4\comment\Comments.mqh"
#endif
//+------------------------------------------------------------------+
