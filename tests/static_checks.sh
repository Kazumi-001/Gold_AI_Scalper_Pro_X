#!/usr/bin/env bash
set -euo pipefail

test -f Gold_AI_Scalper_Pro_X.mq4
test -f Include/GASPX_Config.mqh
test -f Include/GASPX_Verification.mqh
grep -q '#property strict' Gold_AI_Scalper_Pro_X.mq4
grep -q '#property version   "1.010"' Gold_AI_Scalper_Pro_X.mq4
grep -q '#define GASPX_BUILD         "1.0.010"' Include/GASPX_Config.mqh
grep -q 'MarketInfo(Symbol(),MODE_SPREAD)' Include/GASPX_Market.mqh
grep -q 'InpSimulationMode = true' Include/GASPX_Config.mqh
grep -q 'InpEnableLiveTrading = false' Include/GASPX_Config.mqh
test "$(grep -R -l 'OrderSend(' Include | tr '\n' ' ')" = "Include/GASPX_OrderEngine.mqh "
test "$(grep -R -l 'OrderModify(' Include | tr '\n' ' ')" = "Include/GASPX_RiskManager.mqh "
test "$(grep -R -l 'OrderClose(' Include | tr '\n' ' ')" = "Include/GASPX_RiskManager.mqh "
echo "GASPX static checks passed"
