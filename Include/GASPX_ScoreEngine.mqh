#ifndef __GASPX_SCORE_ENGINE_MQH__
#define __GASPX_SCORE_ENGINE_MQH__

bool GASPX_RetestEma20(const int direction,const int shift)
{
   double ema=iMA(Symbol(),PERIOD_M1,InpEmaFastPeriod,0,MODE_EMA,PRICE_CLOSE,shift);
   double atr=GASPX_AtrPrice(shift);
   if(atr<=0.0) return(false);
   double low=iLow(Symbol(),PERIOD_M1,shift);
   double high=iHigh(Symbol(),PERIOD_M1,shift);
   double tolerance=atr*InpRetestAtrRatio;
   if(direction>0) return(low<=ema+tolerance && iClose(Symbol(),PERIOD_M1,shift)>=ema-tolerance);
   return(high>=ema-tolerance && iClose(Symbol(),PERIOD_M1,shift)<=ema+tolerance);
}

bool GASPX_DirectionalCandle(const int direction,const int shift)
{
   double open=iOpen(Symbol(),PERIOD_M1,shift);
   double close=iClose(Symbol(),PERIOD_M1,shift);
   return(direction>0 ? close>open : close<open);
}

int GASPX_DirectionScore(const int direction,const int shift)
{
   int score=0;
   bool ema=(direction>0 ? GASPX_BullishEmaAlignment(shift) : GASPX_BearishEmaAlignment(shift));
   if(ema) score+=20;
   if(GASPX_AdxSupports(direction,shift)) score+=20;
   if(GASPX_AtrAllowed(shift)) score+=10;
   if(GASPX_RetestEma20(direction,shift)) score+=20;
   if(GASPX_DirectionalCandle(direction,shift)) score+=15;
   if(GASPX_CandleVolatilityAllowed(shift)) score+=15;
   return(score);
}

#endif
