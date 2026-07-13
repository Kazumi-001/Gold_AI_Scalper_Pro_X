#ifndef __GASPX_TRADE_ENGINE_MQH__
#define __GASPX_TRADE_ENGINE_MQH__

class GASPX_TradeEngine
{
private:
   int m_virtualDirection;
   int m_virtualCount;
   double m_virtualLastPrice;
   datetime m_lastAction;

   bool IsSimulation(void) { return(InpSimulationMode || !InpEnableLiveTrading); }

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
      m_virtualLastPrice=price;
      m_lastAction=TimeCurrent();
   }

public:
   GASPX_TradeEngine(void)
   { m_virtualDirection=0; m_virtualCount=0; m_virtualLastPrice=0.0; m_lastAction=0; }

   void OnSignal(const GASPX_SignalResult &signal)
   {
      if(signal.direction==GASPX_SIGNAL_NONE || !CooldownPassed()) return;
      int direction=(int)signal.direction;
      int type=(direction>0 ? OP_BUY : OP_SELL);
      int opposite=(direction>0 ? OP_SELL : OP_BUY);

      if(IsSimulation())
      {
         if(m_virtualCount>0) return;
         RefreshRates();
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
      if(!CooldownPassed() || !GASPX_SpreadAllowed()) return;
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
