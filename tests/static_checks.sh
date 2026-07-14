#!/usr/bin/env bash
set -euo pipefail

test -f Gold_AI_Scalper_Pro_X.mq4
test -f Include/GASPX_Config.mqh
test -f Include/GASPX_Verification.mqh
grep -q '#property strict' Gold_AI_Scalper_Pro_X.mq4
grep -q '#property version   "1.019"' Gold_AI_Scalper_Pro_X.mq4
grep -q '#define GASPX_BUILD         "1.0.019"' Include/GASPX_Config.mqh
grep -q 'MarketInfo(Symbol(),MODE_SPREAD)' Include/GASPX_Market.mqh
grep -q 'void Performance(' Include/GASPX_Logger.mqh
grep -q 'm_cumulativeProfit' Include/GASPX_TradeEngine.mqh
grep -q 'm_grossProfit/m_grossLoss' Include/GASPX_TradeEngine.mqh
grep -q 'void Equity(' Include/GASPX_Logger.mqh
grep -q 'TrackVirtualEquity' Include/GASPX_TradeEngine.mqh
grep -q 'max_drawdown_percent' Include/GASPX_Logger.mqh
grep -q 'InpSimulationCommissionPerLot = 7.0' Include/GASPX_Config.mqh
grep -q 'InpSimulationSlippagePoints = 5' Include/GASPX_Config.mqh
grep -q 'gross_realized' Include/GASPX_Logger.mqh
grep -q 'SlippageCostForLots' Include/GASPX_TradeEngine.mqh
grep -q 'void Diagnostic(' Include/GASPX_Logger.mqh
grep -q 'basket_id=' Include/GASPX_Logger.mqh
grep -q 'm_entryAdx=signal.adx' Include/GASPX_TradeEngine.mqh
grep -q 'InpMaxPositions      = 3' Include/GASPX_Config.mqh
grep -q 'InpMaxPositions=3' Presets/XM_XAUUSD_M1_Simulation.set
grep -q 'm_virtualPeakEquity' Include/GASPX_RiskManager.mqh
grep -q 'riskEquity=balance+trade.CumulativeProfit()+basket' Include/GASPX_RiskManager.mqh
grep -q 'InpLossCooldownMinutes = 0' Include/GASPX_Config.mqh
grep -q 'ADAPTIVE_ENTRY_BLOCK' Include/GASPX_TradeEngine.mqh
grep -q 'RequiredEntryScore' Include/GASPX_TradeEngine.mqh
grep -q 'InpAdaptiveEntryScore = true' Include/GASPX_Config.mqh
grep -q 'ENTRY_SCORE_ADAPTIVE' Include/GASPX_Verification.mqh
grep -q 'ATR_STOP' Include/GASPX_RiskManager.mqh
grep -q 'g_riskManager.Process(g_tradeEngine)' Gold_AI_Scalper_Pro_X.mq4
grep -q 'InpSimulationMode = true' Include/GASPX_Config.mqh
grep -q 'InpEnableLiveTrading = false' Include/GASPX_Config.mqh
test "$(grep -R -l 'OrderSend(' Include | tr '\n' ' ')" = "Include/GASPX_OrderEngine.mqh "
test "$(grep -R -l 'OrderModify(' Include | tr '\n' ' ')" = "Include/GASPX_RiskManager.mqh "
test "$(grep -R -l 'OrderClose(' Include | tr '\n' ' ')" = "Include/GASPX_RiskManager.mqh "
echo "GASPX static checks passed"
