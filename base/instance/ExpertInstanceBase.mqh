//+------------------------------------------------------------------+
//|                                           ExpertInstanceBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#property strict
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertInstanceBase : public CObject
  {
protected:
   string            m_name;
   bool              m_active;
   bool              m_primary;
   string            m_symbol;
   int               m_timeframe;
   bool              m_every_tick;
   bool              m_one_trade_per_candle;
   int               m_magic;
   bool              m_position_reverse;
public:
                     CExpertInstanceBase(string,string,int,bool,bool,int,bool,bool);
                    ~CExpertInstanceBase(void);
   string            Name() {return m_name;}
   bool              Active() {return m_active;}
   bool              Primary() {return m_primary;}
   string            Symbol() {return m_symbol;}
   int               Timeframe() {return m_timeframe;}
   bool              EveryTick() {return m_every_tick;}
   bool              OnTradePerCandle() {return m_one_trade_per_candle;}
   int               Magic() {return m_magic;}
   bool              PositionReverse() {return m_position_reverse;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstanceBase::CExpertInstanceBase(string name,string symbol,int timeframe,
                                         bool every_tick,bool one_trade_per_candle,
                                         int magic,bool position_reverse,bool primary=true):
                                         m_active(true)
  {
   m_name=name;
   m_primary=primary;
   m_symbol=symbol;
   m_timeframe=timeframe;
   m_every_tick=every_tick;
   m_one_trade_per_candle=one_trade_per_candle;
   m_magic=magic;
   m_position_reverse=position_reverse;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertInstanceBase::~CExpertInstanceBase(void)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\instance\ExpertInstance.mqh"
#else
#include "..\..\mql4\instance\ExpertInstance.mqh"
#endif
//+------------------------------------------------------------------+
