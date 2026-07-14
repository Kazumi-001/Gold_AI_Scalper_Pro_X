#ifndef __GASPX_VERIFICATION_MQH__
#define __GASPX_VERIFICATION_MQH__

class GASPX_Verification
{
private:
   int m_passed;
   int m_failed;

   void Check(const string name,const bool condition,const string details)
   {
      if(condition) m_passed++; else m_failed++;
      g_logger.Verification(name,condition,details);
   }

public:
   GASPX_Verification(void) { m_passed=0; m_failed=0; }

   bool Run(void)
   {
      m_passed=0; m_failed=0;
      Check("SYMBOL_GOLD",GASPX_IsGoldSymbol(),Symbol());
      Check("TIMEFRAME_M1",Period()==PERIOD_M1,IntegerToString(Period()));
      Check("POINT_VALID",Point>0.0,DoubleToString(Point,Digits));
      Check("SPREAD_INTEGER_SOURCE",GASPX_CurrentSpreadPoints()>=0.0,
            DoubleToString(GASPX_CurrentSpreadPoints(),1));
      Check("LOT_SEQUENCE",
            GASPX_LevelLots(0)==0.01 && GASPX_LevelLots(1)==0.02 &&
            GASPX_LevelLots(2)==0.03 && GASPX_LevelLots(3)==0.05 &&
            GASPX_LevelLots(4)==0.08 && GASPX_LevelLots(5)==0.13,
            "0.01,0.02,0.03,0.05,0.08,0.13");
      Check("POSITION_CAP",InpMaxPositions>=1 && InpMaxPositions<=6,IntegerToString(InpMaxPositions));
      Check("SIGNAL_THRESHOLD",InpSignalThreshold>=0 && InpSignalThreshold<=100,
            IntegerToString(InpSignalThreshold));
      Check("RISK_LIMIT_ORDER",InpDailyLossLimitPercent<InpMaximumDrawdownPercent,
            DoubleToString(InpDailyLossLimitPercent,1)+"/"+DoubleToString(InpMaximumDrawdownPercent,1));
      Check("SIMULATION_COSTS",InpSimulationCommissionPerLot>=0.0 && InpSimulationSlippagePoints>=0,
            DoubleToString(InpSimulationCommissionPerLot,2)+"/"+
            IntegerToString(InpSimulationSlippagePoints));
      Check("LIVE_DOUBLE_LOCK",InpSimulationMode || !InpEnableLiveTrading ||
            (!InpSimulationMode && InpEnableLiveTrading),
            InpSimulationMode ? "SIMULATION" : (InpEnableLiveTrading ? "LIVE_CONFIRMED" : "LIVE_DISABLED"));
      g_logger.Verification("SUMMARY",m_failed==0,
                            "passed="+IntegerToString(m_passed)+",failed="+IntegerToString(m_failed));
      return(m_failed==0);
   }
};

#endif
