#ifndef __GASPX_TRADE_ENGINE_MQH__
#define __GASPX_TRADE_ENGINE_MQH__

class GASPX_TradeEngine
{
private:
   int m_virtualDirection;
   int m_virtualCount;
   double m_virtualLastPrice;
   double m_virtualAveragePrice;
   double m_virtualTotalLots;
   double m_basketRealized;
   double m_cumulativeProfit;
   double m_grossProfit;
   double m_grossLoss;
   double m_peakCumulative;
   double m_maxDrawdown;
   double m_peakEquityProfit;
   double m_maxEquityDrawdown;
   double m_cumulativeCosts;
   int m_wins;
   int m_losses;
   int m_consecutiveLosses;
   int m_basketId;
   datetime m_entryTime;
   double m_entryPrice;
   int m_maxBasketPositions;
   double m_entryAdx;
   double m_entryAtr;
   double m_entryMarketScore;
   double m_entryDangerScore;
   int m_entryBuyScore;
   int m_entrySellScore;
   int m_entryConfidence;
   datetime m_lossCooldownUntil;
   datetime m_lastAction;

   bool IsSimulation(void) { return(InpSimulationMode || !InpEnableLiveTrading); }

   double ProfitForLots(const int direction,const double openPrice,
                        const double closePrice,const double lots)
   {
      double tickSize=MarketInfo(Symbol(),MODE_TICKSIZE);
      double tickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
      if(tickSize<=0.0 || tickValue<=0.0 || direction==0 || lots<=0.0) return(0.0);
      return(((closePrice-openPrice)*direction/tickSize)*tickValue*lots);
   }

   double SlippageCostForLots(const double lots)
   {
      double tickSize=MarketInfo(Symbol(),MODE_TICKSIZE);
      double tickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
      if(tickSize<=0.0 || tickValue<=0.0 || Point<=0.0 || lots<=0.0) return(0.0);
      double oneSide=((InpSimulationSlippagePoints*Point)/tickSize)*tickValue*lots;
      return(oneSide*2.0);
   }

   void UpdateDrawdown(void)
   {
      if(m_cumulativeProfit>m_peakCumulative) m_peakCumulative=m_cumulativeProfit;
      double drawdown=m_peakCumulative-m_cumulativeProfit;
      if(drawdown>m_maxDrawdown) m_maxDrawdown=drawdown;
   }

   void LogPerformance(const string action,const double realized,const double grossRealized,
                       const double commission,const double slippage,const string reason)
   {
      double pf=(m_grossLoss>0.0 ? m_grossProfit/m_grossLoss : 0.0);
      g_logger.Performance(action,realized,grossRealized,commission,slippage,m_cumulativeCosts,
                           m_basketRealized,m_cumulativeProfit,
                           m_grossProfit,m_grossLoss,pf,m_maxDrawdown,
                           m_wins,m_losses,reason);
   }

   double GridDistancePoints(void)
   {
      double distance=(double)InpGridStepPoints;
      if(InpUseAtrGrid && Point>0.0)
      {
         double atrPoints=iATR(Symbol(),PERIOD_M1,InpAtrPeriod,1)/Point;
         distance=MathMax(distance,atrPoints*InpGridAtrMultiplier);
      }
      return(distance);
   }

   bool CooldownPassed(void)
   {
      return(m_lastAction==0 || TimeCurrent()-m_lastAction>=InpTradeCooldownSeconds);
   }

   void RecordSimulation(const string action,const int direction,const int level,const double price)
   {
      double lots=GASPX_NormalizeLots(GASPX_LevelLots(level));
      g_logger.Trade(action,direction,lots,price,level,true,"VIRTUAL");
      m_virtualDirection=direction;
      m_virtualCount=level+1;
      if(m_virtualCount>m_maxBasketPositions) m_maxBasketPositions=m_virtualCount;
      m_virtualLastPrice=price;
      double previousLots=m_virtualTotalLots;
      m_virtualTotalLots+=lots;
      if(m_virtualTotalLots>0.0)
         m_virtualAveragePrice=(m_virtualAveragePrice*previousLots+price*lots)/m_virtualTotalLots;
      m_lastAction=TimeCurrent();
   }

public:
   GASPX_TradeEngine(void)
   { m_virtualDirection=0; m_virtualCount=0; m_virtualLastPrice=0.0;
     m_virtualAveragePrice=0.0; m_virtualTotalLots=0.0; m_basketRealized=0.0;
     m_cumulativeProfit=0.0; m_grossProfit=0.0; m_grossLoss=0.0;
     m_peakCumulative=0.0; m_maxDrawdown=0.0; m_peakEquityProfit=0.0;
     m_maxEquityDrawdown=0.0; m_cumulativeCosts=0.0;
     m_wins=0; m_losses=0; m_consecutiveLosses=0; m_basketId=0; m_entryTime=0; m_entryPrice=0.0;
     m_maxBasketPositions=0;
     m_entryAdx=0.0; m_entryAtr=0.0; m_entryMarketScore=0.0; m_entryDangerScore=0.0;
     m_entryBuyScore=0; m_entrySellScore=0; m_entryConfidence=0;
     m_lossCooldownUntil=0; m_lastAction=0; }
     

   int VirtualDirection(void) { return(m_virtualDirection); }
   int VirtualCount(void) { return(m_virtualCount); }
   double VirtualAveragePrice(void) { return(m_virtualAveragePrice); }
   double VirtualTotalLots(void) { return(m_virtualTotalLots); }
   double CumulativeProfit(void) { return(m_cumulativeProfit); }
   double GrossProfit(void) { return(m_grossProfit); }
   double GrossLoss(void) { return(m_grossLoss); }
   double ProfitFactor(void) { return(m_grossLoss>0.0 ? m_grossProfit/m_grossLoss : 0.0); }
   double MaximumDrawdown(void) { return(m_maxDrawdown); }
   int WinningBaskets(void) { return(m_wins); }
   int LosingBaskets(void) { return(m_losses); }
   int ConsecutiveLosses(void) { return(m_consecutiveLosses); }
   int RequiredEntryScore(void)
   {
      int required=InpSignalThreshold;
      if(InpAdaptiveEntryScore)
      {
         if(m_consecutiveLosses>=2) required+=InpLossPenalty2;
         else if(m_consecutiveLosses==1) required+=InpLossPenalty1;
      }
      if(required>100) required=100;
      return(required);
   }
   datetime LossCooldownUntil(void) { return(m_lossCooldownUntil); }
   bool LossCooldownActive(void) { return(TimeCurrent()<m_lossCooldownUntil); }
   double VirtualInitialPrice(void) { return(m_entryPrice); }
   double VirtualEntryAtrPoints(void) { return(m_entryAtr); }

   double NetVirtualProfit(const double grossFloating)
   {
      double liquidationCosts=0.0;
      if(m_virtualCount>0 && m_virtualTotalLots>0.0)
         liquidationCosts=m_virtualTotalLots*InpSimulationCommissionPerLot+
                          SlippageCostForLots(m_virtualTotalLots);
      return(grossFloating-liquidationCosts);
   }

   void TrackVirtualEquity(const double floatingProfit)
   {
      if(!IsSimulation()) return;
      double netFloating=NetVirtualProfit(floatingProfit);
      double equityProfit=m_cumulativeProfit+netFloating;
      if(equityProfit>m_peakEquityProfit) m_peakEquityProfit=equityProfit;
      double drawdown=m_peakEquityProfit-equityProfit;
      if(drawdown>m_maxEquityDrawdown) m_maxEquityDrawdown=drawdown;
      double balance=MathMax(1.0,AccountBalance());
      double maxDrawdownPercent=m_maxEquityDrawdown/balance*100.0;
      double recovery=(m_maxEquityDrawdown>0.0 ? m_cumulativeProfit/m_maxEquityDrawdown : 0.0);
      g_logger.Equity(m_cumulativeProfit,netFloating,equityProfit,m_peakEquityProfit,
                      drawdown,m_maxEquityDrawdown,maxDrawdownPercent,recovery);
   }

   void ResetVirtual(const string reason)
   {
      if(m_virtualCount>0)
      {
         double exitPrice=m_virtualDirection>0 ? Bid : Ask;
         double grossRealized=ProfitForLots(m_virtualDirection,m_virtualAveragePrice,
                                            exitPrice,m_virtualTotalLots);
         double commission=m_virtualTotalLots*InpSimulationCommissionPerLot;
         double slippage=SlippageCostForLots(m_virtualTotalLots);
         double realized=grossRealized-commission-slippage;
         g_logger.Trade("BASKET_CLOSE",m_virtualDirection,m_virtualTotalLots,
                        exitPrice,m_virtualCount-1,true,reason);
         m_basketRealized+=realized;
         m_cumulativeProfit+=realized;
         m_cumulativeCosts+=commission+slippage;
         if(m_basketRealized>0.0)
         {
            m_grossProfit+=m_basketRealized;
            m_wins++;
            m_consecutiveLosses=0;
         }
         else if(m_basketRealized<0.0)
         {
            m_grossLoss+=-m_basketRealized;
            m_losses++;
            m_consecutiveLosses++;
            if(InpLossCooldownMinutes>0)
            {
               m_lossCooldownUntil=TimeCurrent()+InpLossCooldownMinutes*60;
               g_logger.Risk("LOSS_COOLDOWN",InpLossCooldownMinutes,
                             "basket_id="+IntegerToString(m_basketId)+
                             ",until="+TimeToString(m_lossCooldownUntil,TIME_DATE|TIME_MINUTES));
            }
         }
         UpdateDrawdown();
         LogPerformance("BASKET_CLOSE",realized,grossRealized,commission,slippage,reason);
         g_logger.Diagnostic(m_basketId,m_virtualDirection,m_entryTime,
                             (int)MathMax(0,TimeCurrent()-m_entryTime),m_maxBasketPositions,
                             m_entryAdx,m_entryAtr,m_entryMarketScore,m_entryDangerScore,
                             m_entryBuyScore,m_entrySellScore,m_entryConfidence,
                             m_basketRealized,reason);
      }
      m_virtualDirection=0; m_virtualCount=0; m_virtualLastPrice=0.0;
      m_virtualAveragePrice=0.0; m_virtualTotalLots=0.0; m_basketRealized=0.0;
      m_entryTime=0; m_entryPrice=0.0; m_maxBasketPositions=0;
      m_lastAction=TimeCurrent();
      TrackVirtualEquity(0.0);
   }

   void PartialVirtual(const string reason)
   {
      if(m_virtualCount<=0 || m_virtualTotalLots<=0.0) return;
      double closed=m_virtualTotalLots*(InpPartialClosePercent/100.0);
      double exitPrice=m_virtualDirection>0 ? Bid : Ask;
      double grossRealized=ProfitForLots(m_virtualDirection,m_virtualAveragePrice,exitPrice,closed);
      double commission=closed*InpSimulationCommissionPerLot;
      double slippage=SlippageCostForLots(closed);
      double realized=grossRealized-commission-slippage;
      m_virtualTotalLots-=closed;
      g_logger.Trade("PARTIAL_CLOSE",m_virtualDirection,closed,
                     exitPrice,m_virtualCount-1,true,reason);
      m_basketRealized+=realized;
      m_cumulativeProfit+=realized;
      m_cumulativeCosts+=commission+slippage;
      UpdateDrawdown();
      LogPerformance("PARTIAL_CLOSE",realized,grossRealized,commission,slippage,reason);
   }

   void OnSignal(const GASPX_SignalResult &signal)
   {
      if(!g_riskAllowsTrading || LossCooldownActive() ||
         signal.direction==GASPX_SIGNAL_NONE || !CooldownPassed()) return;

      int requiredScore=RequiredEntryScore();
      if(signal.confidence<requiredScore)
      {
         g_logger.Risk("ADAPTIVE_ENTRY_BLOCK",requiredScore,
                       "confidence="+IntegerToString(signal.confidence)+
                       ",consecutive_losses="+IntegerToString(m_consecutiveLosses));
         return;
      }

      int direction=(int)signal.direction;
      int type=(direction>0 ? OP_BUY : OP_SELL);
      int opposite=(direction>0 ? OP_SELL : OP_BUY);

      if(IsSimulation())
      {
         if(m_virtualCount>0) return;
         m_basketRealized=0.0;
         m_basketId++;
         m_entryTime=TimeCurrent();
         RefreshRates();
         m_entryPrice=(direction>0 ? Ask : Bid);
         m_maxBasketPositions=0;
         m_entryAdx=signal.adx;
         m_entryAtr=signal.atrPoints;
         m_entryMarketScore=signal.marketScore;
         m_entryDangerScore=signal.dangerScore;
         m_entryBuyScore=signal.buyScore;
         m_entrySellScore=signal.sellScore;
         m_entryConfidence=signal.confidence;
         RecordSimulation("INITIAL",direction,0,direction>0 ? Ask : Bid);
         return;
      }

      if(GASPX_CountOrders(type)>0 || GASPX_CountOrders(opposite)>0) return;
      int ticket; string details;
      double lots=GASPX_LevelLots(0);
      if(GASPX_SendMarketOrder(direction,lots,ticket,details))
      {
         m_lastAction=TimeCurrent();
         g_logger.Trade("INITIAL",direction,GASPX_NormalizeLots(lots),
                        direction>0 ? Ask : Bid,0,false,details);
      }
      else g_logger.Trade("REJECT",direction,GASPX_NormalizeLots(lots),0.0,0,false,details);
   }

   void ProcessGrid(void)
   {
      if(!g_riskAllowsTrading || !CooldownPassed() || !GASPX_SpreadAllowed()) return;
      RefreshRates();
      int direction=0;
      int count=0;
      double lastPrice=0.0;

      if(IsSimulation())
      { direction=m_virtualDirection; count=m_virtualCount; lastPrice=m_virtualLastPrice; }
      else
      {
         int buys=GASPX_CountOrders(OP_BUY);
         int sells=GASPX_CountOrders(OP_SELL);
         if(buys>0 && sells==0) { direction=1; count=buys; lastPrice=GASPX_LastOrderPrice(OP_BUY); }
         else if(sells>0 && buys==0) { direction=-1; count=sells; lastPrice=GASPX_LastOrderPrice(OP_SELL); }
      }

      if(direction==0 || count<=0 || count>=InpMaxPositions || lastPrice<=0.0 || Point<=0.0) return;
      double distance=GridDistancePoints();
      bool add=(direction>0 ? (lastPrice-Ask)/Point>=distance : (Bid-lastPrice)/Point>=distance);
      if(!add) return;

      double price=(direction>0 ? Ask : Bid);
      if(IsSimulation()) { RecordSimulation("GRID",direction,count,price); return; }

      int ticket; string details;
      double lots=GASPX_LevelLots(count);
      if(GASPX_SendMarketOrder(direction,lots,ticket,details))
      {
         m_lastAction=TimeCurrent();
         g_logger.Trade("GRID",direction,GASPX_NormalizeLots(lots),price,count,false,details);
      }
      else g_logger.Trade("REJECT",direction,GASPX_NormalizeLots(lots),price,count,false,details);
   }
};

#endif
