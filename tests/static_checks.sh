#!/usr/bin/env bash
set -euo pipefail

test -f Gold_AI_Scalper_Pro_X.mq4
test -f Include/GASPX_Config.mqh
test -f Include/GASPX_Verification.mqh
grep -q '#property strict' Gold_AI_Scalper_Pro_X.mq4
grep -q '#property version   "1.012"' Gold_AI_Scalper_Pro_X.mq4
grep -q '#define GASPX_BUILD         "1.0.012"' Include/GASPX_Config.mqh
grep -q 'MarketInfo(Symbol(),MODE_SPREAD)' Include/GASPX_Market.mqh
grep -q 'void Performance(' Include/GASPX_Logger.mqh
grep -q 'm_cumulativeProfit' Include/GASPX_TradeEngine.mqh
grep -q 'm_grossProfit/m_grossLoss' Include/GASPX_TradeEngine.mqh
grep -q 'void Equity(' Include/GASPX_Logger.mqh
grep -q 'TrackVirtualEquity' Include/GASPX_TradeEngine.mqh
grep -q 'max_drawdown_percent' Include/GASPX_Logger.mqh
grep -q 'InpSimulationMode = true' Include/GASPX_Config.mqh
grep -q 'InpEnableLiveTrading = false' Include/GASPX_Config.mqh
test "$(grep -R -l 'OrderSend(' Include | tr '\n' ' ')" = "Include/GASPX_OrderEngine.mqh "
test "$(grep -R -l 'OrderModify(' Include | tr '\n' ' ')" = "Include/GASPX_RiskManager.mqh "
test "$(grep -R -l 'OrderClose(' Include | tr '\n' ' ')" = "Include/GASPX_RiskManager.mqh "
echo "GASPX static checks passed"
