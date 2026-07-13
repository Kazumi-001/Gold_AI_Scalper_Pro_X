#ifndef __GASPX_ORDER_ENGINE_MQH__
#define __GASPX_ORDER_ENGINE_MQH__

double GASPX_LevelLots(const int level)
{
   const double lots[6]={0.01,0.02,0.03,0.05,0.08,0.13};
   int index=level;
   if(index<0) index=0;
   if(index>5) index=5;
   return(lots[index]);
}

int GASPX_LotDigits()
{
   double step=MarketInfo(Symbol(),MODE_LOTSTEP);
   if(step>=1.0) return(0);
   if(step>=0.1) return(1);
   if(step>=0.01) return(2);
   return(3);
}

double GASPX_NormalizeLots(const double requested)
{
   double minLot=MarketInfo(Symbol(),MODE_MINLOT);
   double maxLot=MarketInfo(Symbol(),MODE_MAXLOT);
   double step=MarketInfo(Symbol(),MODE_LOTSTEP);
   if(step<=0.0) step=0.01;
   double lots=MathFloor(requested/step+0.0000001)*step;
   lots=MathMax(minLot,MathMin(maxLot,lots));
   return(NormalizeDouble(lots,GASPX_LotDigits()));
}

int GASPX_CountOrders(const int orderType)
{
   int count=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) &&
         OrderMagicNumber()==InpMagicNumber && OrderSymbol()==Symbol() && OrderType()==orderType)
         count++;
   return(count);
}

double GASPX_LastOrderPrice(const int orderType)
{
   double price=0.0;
   datetime latest=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) &&
         OrderMagicNumber()==InpMagicNumber && OrderSymbol()==Symbol() && OrderType()==orderType &&
         OrderOpenTime()>=latest)
      { latest=OrderOpenTime(); price=OrderOpenPrice(); }
   return(price);
}

bool GASPX_SendMarketOrder(const int direction,const double requestedLots,int &ticket,string &details)
{
   ticket=-1;
   if(InpSimulationMode || !InpEnableLiveTrading)
   { details="LIVE_DISABLED"; return(false); }
   if(!IsTradeAllowed()) { details="TRADE_NOT_ALLOWED"; return(false); }
   if(!GASPX_SpreadAllowed()) { details="SPREAD_BLOCK"; return(false); }

   RefreshRates();
   int type=(direction>0 ? OP_BUY : OP_SELL);
   double price=(direction>0 ? Ask : Bid);
   double lots=GASPX_NormalizeLots(requestedLots);
   ResetLastError();
   ticket=OrderSend(Symbol(),type,lots,price,InpSlippagePoints,0,0,
                    GASPX_NAME+" "+GASPX_BUILD,InpMagicNumber,0,
                    direction>0 ? clrDodgerBlue : clrTomato);
   if(ticket<0) { details="ERROR_"+IntegerToString(GetLastError()); return(false); }
   details="TICKET_"+IntegerToString(ticket);
   return(true);
}

#endif
