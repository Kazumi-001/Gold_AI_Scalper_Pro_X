#property strict
#property version   "1.017"
#property description "Gold AI Scalper Pro X - Build 1.0.017 Anchored Basket Stop"

#include "Include/GASPX_Config.mqh"
#include "Include/GASPX_Types.mqh"
#include "Include/GASPX_Logger.mqh"
#include "Include/GASPX_Market.mqh"
#include "Include/GASPX_TrendFilter.mqh"
#include "Include/GASPX_ATRFilter.mqh"
#include "Include/GASPX_SpreadFilter.mqh"
#include "Include/GASPX_SessionFilter.mqh"
#include "Include/GASPX_ScoreEngine.mqh"
#include "Include/GASPX_SignalEngine.mqh"
#include "Include/GASPX_OrderEngine.mqh"
GASPX_Logger g_logger;
bool g_riskAllowsTrading=true;
#include "Include/GASPX_TradeEngine.mqh"
#include "Include/GASPX_RiskManager.mqh"
#include "Include/GASPX_PositionManager.mqh"
#include "Include/GASPX_Integration.mqh"
#include "Include/GASPX_Verification.mqh"
#include "Include/GASPX_Dashboard.mqh"

datetime g_lastSnapshot=0;
datetime g_lastSignalBar=0;
GASPX_SignalResult g_lastSignal;
GASPX_TradeEngine g_tradeEngine;
GASPX_RiskManager g_riskManager;
GASPX_PositionManager g_positionManager;
GASPX_Integration g_integration;
GASPX_Verification g_verification;
GASPX_Dashboard g_dashboard;

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
   if(InpRunStartupSelfTest && !g_verification.Run())
   {
      g_logger.Event("INIT_FAILED","Startup self-test failed");
      g_logger.Close();
      return(INIT_FAILED);
   }
   g_riskManager.Initialize();
   g_logger.Event("INIT","Build "+GASPX_BUILD+" started");
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   g_logger.Event("DEINIT","Reason="+IntegerToString(reason));
   g_logger.Close();
   g_dashboard.Clear();
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
   bool pipelineReady=g_integration.Update(snapshot);

   datetime closedBar=iTime(Symbol(),PERIOD_M1,1);
   if(pipelineReady && closedBar>0 && closedBar!=g_lastSignalBar)
   {
      g_lastSignalBar=closedBar;
      GASPX_EvaluateSignal(snapshot,g_lastSignal);
      g_logger.Signal(g_lastSignal);
      g_tradeEngine.OnSignal(g_lastSignal);
   }
   g_riskManager.Process(g_tradeEngine);
   if(pipelineReady && g_riskAllowsTrading) g_tradeEngine.ProcessGrid();
   g_positionManager.Refresh(g_tradeEngine);
   GASPX_PositionSummary position=g_positionManager.Summary();

   g_dashboard.Render(snapshot,g_lastSignal,position,g_riskAllowsTrading,g_integration.State());
}
