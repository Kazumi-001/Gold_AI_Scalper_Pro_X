#ifndef __GASPX_CONFIG_MQH__
#define __GASPX_CONFIG_MQH__

#define GASPX_NAME          "Gold AI Scalper Pro X"
#define GASPX_VERSION       "1.0"
#define GASPX_BUILD         "1.0.018"
#define GASPX_MAGIC_DEFAULT 777

input bool   InpSimulationMode = true;
input bool   InpEnableCsvLog   = true;
input int    InpMagicNumber    = GASPX_MAGIC_DEFAULT;
input int    InpMaxSpreadPoints = 30;
input int    InpAtrPeriod       = 14;
input int    InpSnapshotSeconds = 10;
input double InpAtrLowPoints    = 80.0;
input double InpAtrHighPoints   = 1200.0;
input int    InpEmaFastPeriod    = 20;
input int    InpEmaMediumPeriod  = 50;
input int    InpEmaSlowPeriod    = 200;
input int    InpAdxPeriod        = 14;
input double InpAdxMinimum       = 25.0;
input double InpRetestAtrRatio   = 0.25;
input double InpCandleMinAtrRatio = 0.10;
input double InpCandleMaxAtrRatio = 1.50;
input double InpMinimumMarketScore = 60.0;
input double InpMaximumDangerScore = 70.0;
input int    InpSignalThreshold  = 80;
input int    InpSessionStartHour = 0;
input int    InpSessionEndHour   = 24;
input bool   InpEnableLiveTrading = false;
input int    InpSlippagePoints    = 5;
input int    InpGridStepPoints    = 300;
input bool   InpUseAtrGrid        = true;
input double InpGridAtrMultiplier = 1.0;
input int    InpMaxPositions      = 3;
input int    InpTradeCooldownSeconds = 30;
input double InpStopLossAtrMultiplier = 2.0;
input double InpTakeProfitAtrMultiplier = 1.5;
input double InpBreakEvenTriggerAtr = 1.0;
input int    InpBreakEvenOffsetPoints = 10;
input double InpTrailingAtrMultiplier = 1.0;
input double InpPartialTriggerAtr = 1.0;
input double InpPartialClosePercent = 50.0;
input double InpDailyLossLimitPercent = 5.0;
input double InpMaximumDrawdownPercent = 10.0;
input double InpBasketProfitPercent = 2.0;
input double InpBasketLossPercent = 5.0;
input bool   InpShowDashboard = true;
input int    InpMinimumHistoryBars = 250;
input bool   InpRunStartupSelfTest = true;
input double InpSimulationCommissionPerLot = 7.0;
input int    InpSimulationSlippagePoints = 5;
input int    InpLossCooldownMinutes = 30;

bool GASPX_ValidateInputs(string &reason)
{
   if(InpMagicNumber <= 0)       { reason="MagicNumber must be positive"; return(false); }
   if(InpMaxSpreadPoints <= 0)   { reason="MaxSpreadPoints must be positive"; return(false); }
   if(InpAtrPeriod < 2)          { reason="AtrPeriod must be at least 2"; return(false); }
   if(InpSnapshotSeconds < 1)    { reason="SnapshotSeconds must be positive"; return(false); }
   if(InpAtrLowPoints < 0.0 || InpAtrHighPoints <= InpAtrLowPoints)
   { reason="ATR thresholds are invalid"; return(false); }
   if(InpEmaFastPeriod<2 || InpEmaMediumPeriod<=InpEmaFastPeriod || InpEmaSlowPeriod<=InpEmaMediumPeriod)
   { reason="EMA periods must be Fast < Medium < Slow"; return(false); }
   if(InpAdxPeriod<2 || InpAdxMinimum<0.0) { reason="ADX settings are invalid"; return(false); }
   if(InpRetestAtrRatio<=0.0 || InpCandleMinAtrRatio<0.0 || InpCandleMaxAtrRatio<=InpCandleMinAtrRatio)
   { reason="Signal ratios are invalid"; return(false); }
   if(InpSignalThreshold<0 || InpSignalThreshold>100) { reason="SignalThreshold must be 0..100"; return(false); }
   if(InpSessionStartHour<0 || InpSessionStartHour>23 || InpSessionEndHour<1 || InpSessionEndHour>24)
   { reason="Session hours are invalid"; return(false); }
   if(InpSlippagePoints<0 || InpGridStepPoints<1 || InpGridAtrMultiplier<=0.0)
   { reason="Trade execution settings are invalid"; return(false); }
   if(InpMaxPositions<1 || InpMaxPositions>6) { reason="MaxPositions must be 1..6"; return(false); }
   if(InpTradeCooldownSeconds<0) { reason="TradeCooldownSeconds must not be negative"; return(false); }
   if(InpStopLossAtrMultiplier<=0.0 || InpTakeProfitAtrMultiplier<=0.0 ||
      InpBreakEvenTriggerAtr<=0.0 || InpTrailingAtrMultiplier<=0.0 || InpPartialTriggerAtr<=0.0)
   { reason="ATR risk multipliers must be positive"; return(false); }
   if(InpPartialClosePercent<=0.0 || InpPartialClosePercent>=100.0)
   { reason="PartialClosePercent must be between 0 and 100"; return(false); }
   if(InpDailyLossLimitPercent<=0.0 || InpMaximumDrawdownPercent<=0.0 ||
      InpBasketProfitPercent<=0.0 || InpBasketLossPercent<=0.0)
   { reason="Risk percentage limits must be positive"; return(false); }
   if(InpMinimumHistoryBars<InpEmaSlowPeriod+10)
   { reason="MinimumHistoryBars must exceed slow EMA period"; return(false); }
   if(InpSimulationCommissionPerLot<0.0 || InpSimulationSlippagePoints<0)
   { reason="Simulation transaction costs must not be negative"; return(false); }
   if(InpLossCooldownMinutes<0 || InpLossCooldownMinutes>1440)
   { reason="LossCooldownMinutes must be 0..1440"; return(false); }
   reason="";
   return(true);
}

#endif
