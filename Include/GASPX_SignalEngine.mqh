#ifndef __GASPX_SIGNAL_ENGINE_MQH__
#define __GASPX_SIGNAL_ENGINE_MQH__

void GASPX_EvaluateSignal(const GASPX_MarketSnapshot &market,GASPX_SignalResult &result)
{
   const int shift=1;
   result.barTime=iTime(Symbol(),PERIOD_M1,shift);
   result.direction=GASPX_SIGNAL_NONE;
   result.buyScore=GASPX_DirectionScore(1,shift);
   result.sellScore=GASPX_DirectionScore(-1,shift);
   result.confidence=(result.buyScore>result.sellScore ? result.buyScore : result.sellScore);
   result.adx=iADX(Symbol(),PERIOD_M1,InpAdxPeriod,PRICE_CLOSE,MODE_MAIN,shift);
   result.atrPoints=market.atrPoints;
   result.marketScore=market.marketScore;
   result.dangerScore=market.dangerScore;
   result.spreadAllowed=GASPX_SpreadAllowed();
   result.sessionAllowed=GASPX_SessionAllowed(TimeCurrent());
   result.marketAllowed=(market.marketScore>=InpMinimumMarketScore &&
                         market.dangerScore<InpMaximumDangerScore &&
                         market.state==GASPX_MARKET_TRADABLE);

   if(!result.spreadAllowed) { result.reason="SPREAD_BLOCK"; return; }
   if(!result.sessionAllowed) { result.reason="SESSION_BLOCK"; return; }
   if(!result.marketAllowed) { result.reason="MARKET_BLOCK"; return; }

   if(result.buyScore>=InpSignalThreshold && result.buyScore>result.sellScore)
   { result.direction=GASPX_SIGNAL_BUY; result.reason="BUY_SCORE"; return; }
   if(result.sellScore>=InpSignalThreshold && result.sellScore>result.buyScore)
   { result.direction=GASPX_SIGNAL_SELL; result.reason="SELL_SCORE"; return; }
   result.reason="BELOW_THRESHOLD";
}

#endif
