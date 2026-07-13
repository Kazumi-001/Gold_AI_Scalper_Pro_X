#property strict
#property version   "1.002"
#property description "Gold AI Scalper Pro X - Build 1.0.002 Framework"

#include "Include/GASPX_Config.mqh"
#include "Include/GASPX_Types.mqh"
#include "Include/GASPX_Logger.mqh"
#include "Include/GASPX_Market.mqh"

GASPX_Logger g_logger;
datetime g_lastSnapshot=0;

int OnInit()
{
   string reason;
   if(!GASPX_ValidateInputs(reason))
   {
      Print(GASPX_NAME,": invalid input: ",reason);
      return(INIT_PARAMETERS_INCORRECT);
   }
   if(!GASPX_IsGoldSymbol())
   {
      Print(GASPX_NAME,": XAUUSD/GOLD symbol required. Current=",Symbol());
      return(INIT_FAILED);
   }
   if(Period()!=PERIOD_M1)
   {
      Print(GASPX_NAME,": M1 chart required.");
      return(INIT_FAILED);
   }
   if(!g_logger.Open(InpEnableCsvLog)) return(INIT_FAILED);
   g_logger.Event("INIT","Build "+GASPX_BUILD+" started");
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   g_logger.Event("DEINIT","Reason="+IntegerToString(reason));
   g_logger.Close();
   Comment("");
}

void OnTick()
{
   GASPX_ProcessSnapshot();
}

void OnTimer()
{
   GASPX_ProcessSnapshot();
}

void GASPX_ProcessSnapshot()
{
   datetime now=TimeCurrent();
   if(now<=0 || (g_lastSnapshot>0 && now-g_lastSnapshot<InpSnapshotSeconds)) return;
   g_lastSnapshot=now;

   GASPX_MarketSnapshot snapshot;
   GASPX_ReadMarket(snapshot);
   g_logger.Snapshot(snapshot);

   Comment(GASPX_NAME,"\n",
           "Version ",GASPX_VERSION," / Build ",GASPX_BUILD,"\n",
           "Mode: ",InpSimulationMode ? "SIMULATION" : "FRAMEWORK ONLY","\n",
           "Spread: ",DoubleToString(snapshot.spreadPoints,1)," points\n",
           "ATR(",InpAtrPeriod,"): ",DoubleToString(snapshot.atrPoints,1)," points\n",
           "MarketScore: ",DoubleToString(snapshot.marketScore,1),"\n",
           "DangerScore: ",DoubleToString(snapshot.dangerScore,1),"\n",
           "State: ",GASPX_MarketStateText(snapshot.state));
}
