#ifndef __GASPX_DASHBOARD_MQH__
#define __GASPX_DASHBOARD_MQH__

class GASPX_Dashboard
{
private:
   string ModeText(void)
   {
      if(InpSimulationMode || !InpEnableLiveTrading) return("TRADE SIMULATION");
      return("LIVE TRADING");
   }

   string PositionSide(const int direction)
   {
      if(direction>0) return("BUY");
      if(direction<0) return("SELL");
      return("FLAT");
   }

public:
   void Render(const GASPX_MarketSnapshot &market,const GASPX_SignalResult &signal,
               const GASPX_PositionSummary &position,const bool riskAllowed)
   {
      if(!InpShowDashboard) { Comment(""); return; }
      string signalText=(signal.barTime>0 ? GASPX_SignalText(signal.direction) : "WAITING");
      string reason=(signal.barTime>0 ? signal.reason : "WAITING_FOR_CLOSED_BAR");
      string panel=GASPX_NAME+"\n"+
                   "Version "+GASPX_VERSION+" / Build "+GASPX_BUILD+"\n"+
                   "Mode: "+ModeText()+"\n"+
                   "--------------------------------\n"+
                   "Market: "+GASPX_MarketStateText(market.state)+
                   "  Spread: "+DoubleToString(market.spreadPoints,1)+" pt\n"+
                   "MarketScore: "+DoubleToString(market.marketScore,1)+
                   "  DangerScore: "+DoubleToString(market.dangerScore,1)+"\n"+
                   "ATR("+IntegerToString(InpAtrPeriod)+"): "+DoubleToString(market.atrPoints,1)+" pt\n"+
                   "--------------------------------\n"+
                   "Signal: "+signalText+"  Confidence: "+IntegerToString(signal.confidence)+"\n"+
                   "BuyScore: "+IntegerToString(signal.buyScore)+
                   "  SellScore: "+IntegerToString(signal.sellScore)+"\n"+
                   "Reason: "+reason+"\n"+
                   "--------------------------------\n"+
                   "Basket: "+PositionSide(position.direction)+
                   "  Positions: "+IntegerToString(position.count)+"\n"+
                   "Lots: "+DoubleToString(position.totalLots,2)+
                   "  Average: "+DoubleToString(position.averagePrice,Digits)+"\n"+
                   "Floating P/L: "+DoubleToString(position.floatingProfit,2)+"\n"+
                   "--------------------------------\n"+
                   "Risk: "+(riskAllowed ? "ACTIVE" : "BLOCKED")+
                   "  Daily limit: "+DoubleToString(InpDailyLossLimitPercent,1)+"%"+
                   "  Max DD: "+DoubleToString(InpMaximumDrawdownPercent,1)+"%";
      Comment(panel);
   }

   void Clear(void) { Comment(""); }
};

#endif
