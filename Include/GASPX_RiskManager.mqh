#ifndef __GASPX_RISK_MANAGER_MQH__
#define __GASPX_RISK_MANAGER_MQH__

class GASPX_RiskManager
{
private:
   double m_dayStartBalance;
   int m_dayOfYear;
   bool m_virtualPartialDone;
   int m_partialTickets[100];
   int m_partialCount;

   bool IsSimulation(void) { return(InpSimulationMode || !InpEnableLiveTrading); }

   bool WasPartial(const int ticket)
   {
      for(int i=0;i<m_partialCount;i++) if(m_partialTickets[i]==ticket) return(true);
      return(false);
   }

   void MarkPartial(const int ticket)
   {
      if(m_partialCount<100) m_partialTickets[m_partialCount++]=ticket;
   }

   double CurrentAtr(void) { return(iATR(Symbol(),PERIOD_M1,InpAtrPeriod,1)); }

   double VirtualProfit(GASPX_TradeEngine &trade)
   {
      if(trade.VirtualCount()<=0) return(0.0);
      double exitPrice=trade.VirtualDirection()>0 ? Bid : Ask;
      double difference=(exitPrice-trade.VirtualAveragePrice())*trade.VirtualDirection();
      double tickSize=MarketInfo(Symbol(),MODE_TICKSIZE);
      double tickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
      if(tickSize<=0.0) return(0.0);
      return((difference/tickSize)*tickValue*trade.VirtualTotalLots());
   }

   double LiveBasketProfit(void)
   {
      double profit=0.0;
      for(int i=OrdersTotal()-1;i>=0;i--)
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==InpMagicNumber &&
            OrderSymbol()==Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL))
            profit+=OrderProfit()+OrderSwap()+OrderCommission();
      return(profit);
   }

   void CloseAllLive(const string reason)
   {
      for(int i=OrdersTotal()-1;i>=0;i--)
      {
         if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES) || OrderMagicNumber()!=InpMagicNumber ||
            OrderSymbol()!=Symbol() || (OrderType()!=OP_BUY && OrderType()!=OP_SELL)) continue;
         RefreshRates();
         double price=OrderType()==OP_BUY ? Bid : Ask;
         ResetLastError();
         if(OrderClose(OrderTicket(),OrderLots(),price,InpSlippagePoints,clrGold))
            g_logger.Trade("BASKET_CLOSE",OrderType()==OP_BUY ? 1 : -1,OrderLots(),price,0,false,reason);
         else g_logger.Risk("CLOSE_ERROR",GetLastError(),reason);
      }
   }

   void ManageLiveOrders(void)
   {
      double atr=CurrentAtr();
      if(atr<=0.0) return;
      double stopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;
      for(int i=OrdersTotal()-1;i>=0;i--)
      {
         if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES) || OrderMagicNumber()!=InpMagicNumber ||
            OrderSymbol()!=Symbol() || (OrderType()!=OP_BUY && OrderType()!=OP_SELL)) continue;
         int direction=OrderType()==OP_BUY ? 1 : -1;
         double marketPrice=direction>0 ? Bid : Ask;
         double favorable=(marketPrice-OrderOpenPrice())*direction;
         double desiredSl=OrderStopLoss();
         double desiredTp=OrderTakeProfit();

         if(desiredSl<=0.0) desiredSl=OrderOpenPrice()-direction*atr*InpStopLossAtrMultiplier;
         if(desiredTp<=0.0) desiredTp=OrderOpenPrice()+direction*atr*InpTakeProfitAtrMultiplier;

         if(favorable>=atr*InpBreakEvenTriggerAtr)
         {
            double be=OrderOpenPrice()+direction*InpBreakEvenOffsetPoints*Point;
            if((direction>0 && be>desiredSl) || (direction<0 && (desiredSl<=0.0 || be<desiredSl))) desiredSl=be;
            double trail=marketPrice-direction*atr*InpTrailingAtrMultiplier;
            if((direction>0 && trail>desiredSl) || (direction<0 && trail<desiredSl)) desiredSl=trail;
         }

         if(direction>0) desiredSl=MathMin(desiredSl,Bid-stopLevel);
         else desiredSl=MathMax(desiredSl,Ask+stopLevel);
         desiredSl=NormalizeDouble(desiredSl,Digits);
         desiredTp=NormalizeDouble(desiredTp,Digits);

         if(MathAbs(OrderStopLoss()-desiredSl)>Point || MathAbs(OrderTakeProfit()-desiredTp)>Point)
         {
            ResetLastError();
            if(!OrderModify(OrderTicket(),OrderOpenPrice(),desiredSl,desiredTp,0,clrNONE))
               g_logger.Risk("MODIFY_ERROR",GetLastError(),"ticket="+IntegerToString(OrderTicket()));
         }

         if(favorable>=atr*InpPartialTriggerAtr && !WasPartial(OrderTicket()))
         {
            double closeLots=GASPX_NormalizeLots(OrderLots()*(InpPartialClosePercent/100.0));
            double minLot=MarketInfo(Symbol(),MODE_MINLOT);
            if(closeLots>=minLot && OrderLots()-closeLots>=minLot)
            {
               ResetLastError();
               if(OrderClose(OrderTicket(),closeLots,marketPrice,InpSlippagePoints,clrGold))
               { MarkPartial(OrderTicket()); g_logger.Trade("PARTIAL_CLOSE",direction,closeLots,marketPrice,0,false,"ATR_TRIGGER"); }
               else g_logger.Risk("PARTIAL_ERROR",GetLastError(),"ticket="+IntegerToString(OrderTicket()));
            }
            else MarkPartial(OrderTicket());
         }
      }
   }

public:
   GASPX_RiskManager(void)
   { m_dayStartBalance=0.0; m_dayOfYear=-1; m_virtualPartialDone=false; m_partialCount=0; }

   void Initialize(void)
   { m_dayStartBalance=AccountBalance(); m_dayOfYear=TimeDayOfYear(TimeCurrent()); g_riskAllowsTrading=true; }

   void Process(GASPX_TradeEngine &trade)
   {
      int today=TimeDayOfYear(TimeCurrent());
      if(today!=m_dayOfYear)
      { m_dayOfYear=today; m_dayStartBalance=AccountBalance(); g_riskAllowsTrading=true; m_virtualPartialDone=false; }

      double balance=MathMax(1.0,AccountBalance());
      double dailyLoss=(m_dayStartBalance-AccountEquity())/MathMax(1.0,m_dayStartBalance)*100.0;
      double drawdown=(balance-AccountEquity())/balance*100.0;
      if(dailyLoss>=InpDailyLossLimitPercent || drawdown>=InpMaximumDrawdownPercent)
      {
         g_riskAllowsTrading=false;
         string reason=dailyLoss>=InpDailyLossLimitPercent ? "DAILY_LOSS_LIMIT" : "DRAWDOWN_LIMIT";
         if(IsSimulation()) trade.ResetVirtual(reason); else CloseAllLive(reason);
         return;
      }

      double basket=IsSimulation() ? VirtualProfit(trade) : LiveBasketProfit();
      double basketPercent=basket/balance*100.0;
      if(basketPercent>=InpBasketProfitPercent || basketPercent<=-InpBasketLossPercent)
      {
         string reason=basketPercent>=InpBasketProfitPercent ? "BASKET_PROFIT" : "BASKET_LOSS";
         if(IsSimulation()) trade.ResetVirtual(reason); else CloseAllLive(reason);
         return;
      }

      if(IsSimulation())
      {
         double atr=CurrentAtr();
         if(trade.VirtualCount()<=0 || atr<=0.0) { m_virtualPartialDone=false; return; }
         double price=trade.VirtualDirection()>0 ? Bid : Ask;
         double favorable=(price-trade.VirtualAveragePrice())*trade.VirtualDirection();
         if(favorable<=-atr*InpStopLossAtrMultiplier) { trade.ResetVirtual("ATR_STOP"); m_virtualPartialDone=false; return; }
         if(favorable>=atr*InpTakeProfitAtrMultiplier) { trade.ResetVirtual("ATR_TAKE_PROFIT"); m_virtualPartialDone=false; return; }
         if(favorable>=atr*InpPartialTriggerAtr && !m_virtualPartialDone)
         { trade.PartialVirtual("ATR_TRIGGER"); m_virtualPartialDone=true; }
      }
      else ManageLiveOrders();
   }
};

#endif
