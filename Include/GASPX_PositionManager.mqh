#ifndef __GASPX_POSITION_MANAGER_MQH__
#define __GASPX_POSITION_MANAGER_MQH__

class GASPX_PositionManager
{
private:
   GASPX_PositionSummary m_summary;
   int m_previousCount;

   bool IsSimulation(void) { return(InpSimulationMode || !InpEnableLiveTrading); }

   double ProfitFromPrice(const int direction,const double average,const double price,const double lots)
   {
      double tickSize=MarketInfo(Symbol(),MODE_TICKSIZE);
      double tickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
      if(tickSize<=0.0 || direction==0 || lots<=0.0) return(0.0);
      return(((price-average)*direction/tickSize)*tickValue*lots);
   }

public:
   GASPX_PositionManager(void) { m_previousCount=0; Clear(); }

   void Clear(void)
   {
      m_summary.direction=0; m_summary.count=0; m_summary.totalLots=0.0;
      m_summary.averagePrice=0.0; m_summary.floatingProfit=0.0;
      m_summary.latestPrice=0.0; m_summary.simulated=true;
   }

   void Refresh(GASPX_TradeEngine &trade)
   {
      Clear();
      m_summary.simulated=IsSimulation();
      if(m_summary.simulated)
      {
         m_summary.direction=trade.VirtualDirection();
         m_summary.count=trade.VirtualCount();
         m_summary.totalLots=trade.VirtualTotalLots();
         m_summary.averagePrice=trade.VirtualAveragePrice();
         m_summary.latestPrice=m_summary.direction>0 ? Bid : (m_summary.direction<0 ? Ask : 0.0);
         m_summary.floatingProfit=ProfitFromPrice(m_summary.direction,m_summary.averagePrice,
                                                  m_summary.latestPrice,m_summary.totalLots);
      }
      else
      {
         double weightedPrice=0.0;
         int buyCount=0;
         int sellCount=0;
         for(int i=OrdersTotal()-1;i>=0;i--)
         {
            if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES) || OrderMagicNumber()!=InpMagicNumber ||
               OrderSymbol()!=Symbol() || (OrderType()!=OP_BUY && OrderType()!=OP_SELL)) continue;
            int direction=OrderType()==OP_BUY ? 1 : -1;
            if(direction>0) buyCount++; else sellCount++;
            m_summary.count++;
            m_summary.totalLots+=OrderLots();
            weightedPrice+=OrderOpenPrice()*OrderLots();
            m_summary.floatingProfit+=OrderProfit()+OrderSwap()+OrderCommission();
         }
         if(m_summary.totalLots>0.0) m_summary.averagePrice=weightedPrice/m_summary.totalLots;
         if(buyCount>0 && sellCount==0) m_summary.direction=1;
         else if(sellCount>0 && buyCount==0) m_summary.direction=-1;
         else m_summary.direction=0;
         m_summary.latestPrice=m_summary.direction>0 ? Bid : (m_summary.direction<0 ? Ask : 0.0);
      }

      if(m_summary.count!=m_previousCount)
      {
         g_logger.Position(m_summary,m_summary.count>m_previousCount ? "COUNT_INCREASE" : "COUNT_DECREASE");
         m_previousCount=m_summary.count;
      }
   }

   GASPX_PositionSummary Summary(void) { return(m_summary); }
   bool HasBasket(void) { return(m_summary.count>0); }
};

#endif
