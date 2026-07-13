#ifndef __GASPX_CONFIG_MQH__
#define __GASPX_CONFIG_MQH__

#define GASPX_NAME          "Gold AI Scalper Pro X"
#define GASPX_VERSION       "1.0"
#define GASPX_BUILD         "1.0.004"
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
input int    InpMaxPositions      = 6;
input int    InpTradeCooldownSeconds = 30;

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
   reason="";
   return(true);
}

#endif
