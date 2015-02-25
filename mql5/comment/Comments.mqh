//+------------------------------------------------------------------+
//|                                                 CommentsBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JComments : public JCommentsBase
  {
public:
                     JComments(void);
                    ~JComments(void);
   virtual void      Display(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JComments::JComments(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JComments::~JComments(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JComment::Display(void)
  {
   string str="";
   JComment *comment=GetFirstNode();
   while(CheckPointer(comment)==POINTER_DYNAMIC)
     {
      StringConcatenate(str,comment.Text(),"\n");
      comment=GetNextNode();
     }
   Comment(str);
  }
//+------------------------------------------------------------------+
