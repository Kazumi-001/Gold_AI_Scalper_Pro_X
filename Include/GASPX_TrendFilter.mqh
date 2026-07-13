#ifndef __GASPX_TREND_FILTER_MQH__
#define __GASPX_TREND_FILTER_MQH__

bool GASPX_BullishEmaAlignment(const int shift)
{
   double fast=iMA(Symbol(),PERIOD_M1,InpEmaFastPeriod,0,MODE_EMA,PRICE_CLOSE,shift);
   double medium=iMA(Symbol(),PERIOD_M1,InpEmaMediumPeriod,0,MODE_EMA,PRICE_CLOSE,shift);
   double slow=iMA(Symbol(),PERIOD_M1,InpEmaSlowPeriod,0,MODE_EMA,PRICE_CLOSE,shift);
   return(fast>medium && medium>slow);
}

bool GASPX_BearishEmaAlignment(const int shift)
{
   double fast=iMA(Symbol(),PERIOD_M1,InpEmaFastPeriod,0,MODE_EMA,PRICE_CLOSE,shift);
   double medium=iMA(Symbol(),PERIOD_M1,InpEmaMediumPeriod,0,MODE_EMA,PRICE_CLOSE,shift);
   double slow=iMA(Symbol(),PERIOD_M1,InpEmaSlowPeriod,0,MODE_EMA,PRICE_CLOSE,shift);
   return(fast<medium && medium<slow);
}

bool GASPX_AdxSupports(const int direction,const int shift)
{
   double adx=iADX(Symbol(),PERIOD_M1,InpAdxPeriod,PRICE_CLOSE,MODE_MAIN,shift);
   double plus=iADX(Symbol(),PERIOD_M1,InpAdxPeriod,PRICE_CLOSE,MODE_PLUSDI,shift);
   double minus=iADX(Symbol(),PERIOD_M1,InpAdxPeriod,PRICE_CLOSE,MODE_MINUSDI,shift);
   if(adx<InpAdxMinimum) return(false);
   return(direction>0 ? plus>minus : minus>plus);
}

#endif
