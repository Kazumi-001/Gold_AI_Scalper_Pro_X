#ifndef __GASPX_ATR_FILTER_MQH__
#define __GASPX_ATR_FILTER_MQH__

double GASPX_AtrPrice(const int shift)
{
   return(iATR(Symbol(),PERIOD_M1,InpAtrPeriod,shift));
}

bool GASPX_AtrAllowed(const int shift)
{
   if(Point<=0.0) return(false);
   double atrPoints=GASPX_AtrPrice(shift)/Point;
   return(atrPoints>=InpAtrLowPoints && atrPoints<=InpAtrHighPoints);
}

bool GASPX_CandleVolatilityAllowed(const int shift)
{
   double atr=GASPX_AtrPrice(shift);
   if(atr<=0.0) return(false);
   double range=iHigh(Symbol(),PERIOD_M1,shift)-iLow(Symbol(),PERIOD_M1,shift);
   double ratio=range/atr;
   return(ratio>=InpCandleMinAtrRatio && ratio<=InpCandleMaxAtrRatio);
}

#endif
