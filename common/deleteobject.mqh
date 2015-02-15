//+------------------------------------------------------------------+
//|                                                EventStandard.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool DeleteObject(CObject *object)
  {
   delete object;
   object=NULL;
   return(object==NULL);
  }
//+------------------------------------------------------------------+
