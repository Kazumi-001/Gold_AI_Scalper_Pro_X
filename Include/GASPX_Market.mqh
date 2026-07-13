#ifndef __GASPX_MARKET_MQH__
#define __GASPX_MARKET_MQH__

bool GASPX_IsGoldSymbol()
{
   string symbol=Symbol();
   StringToUpper(symbol);
   return(StringFind(symbol,"XAU")>=0 || StringFind(symbol,"GOLD")>=0);
}

double GASPX_CurrentSpreadPoints()
{
   double brokerSpread=MarketInfo(Symbol(),MODE_SPREAD);
   if(brokerSpread>=0.0) return(brokerSpread);
   if(Point<=0.0) return(0.0);
   return(MathRound((Ask-Bid)/Point));
}

double GASPX_CurrentAtrPoints()
{
   if(Point<=0.0) return(0.0);
   return(iATR(Symbol(),PERIOD_M1,InpAtrPeriod,0)/Point);
}

void GASPX_ReadMarket(GASPX_MarketSnapshot &s)
{
   RefreshRates();
   s.timestamp=TimeCurrent();
   s.bid=Bid;
   s.ask=Ask;
   s.spreadPoints=GASPX_CurrentSpreadPoints();
   s.atrPoints=GASPX_CurrentAtrPoints();

   if(s.atrPoints<=0.0 || s.bid<=0.0 || s.ask<=0.0)
   {
      s.marketScore=0.0;
      s.dangerScore=100.0;
      s.state=GASPX_MARKET_UNKNOWN;
      return;
   }

   double spreadRatio=s.spreadPoints/MathMax(1.0,(double)InpMaxSpreadPoints);
   double volatilityScore=50.0;
   if(s.atrPoints<InpAtrLowPoints)
      volatilityScore=50.0*(s.atrPoints/MathMax(1.0,InpAtrLowPoints));
   else if(s.atrPoints>InpAtrHighPoints)
      volatilityScore=100.0-50.0*((s.atrPoints-InpAtrHighPoints)/MathMax(1.0,InpAtrHighPoints));
   else
      volatilityScore=100.0;

   double spreadScore=100.0-(spreadRatio*70.0);
   s.marketScore=GASPX_ClampScore(volatilityScore*0.60+spreadScore*0.40);

   double spreadDanger=GASPX_ClampScore(spreadRatio*70.0);
   double volatilityDanger=0.0;
   if(s.atrPoints>InpAtrHighPoints)
      volatilityDanger=GASPX_ClampScore(((s.atrPoints-InpAtrHighPoints)/InpAtrHighPoints)*100.0);
   s.dangerScore=GASPX_ClampScore(spreadDanger*0.70+volatilityDanger*0.30);

   if(s.spreadPoints>(double)InpMaxSpreadPoints+0.01 || s.dangerScore>=70.0)
      s.state=GASPX_MARKET_DANGEROUS;
   else if(s.atrPoints<InpAtrLowPoints)
      s.state=GASPX_MARKET_QUIET;
   else
      s.state=GASPX_MARKET_TRADABLE;
}

#endif
