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
                     JComments();
                    ~JComments(void);
   virtual void      Display(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JComments::JComments()
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
JComments::Display(void)
  {
   string str="";
   JComment *comment=GetFirstNode();
   while(CheckPointer(comment)==POINTER_DYNAMIC)
     {
      str=StringConcatenate(str,comment.Text(),"\n");
      comment=GetNextNode();
     }
   Comment(str);
  }
//+------------------------------------------------------------------+
