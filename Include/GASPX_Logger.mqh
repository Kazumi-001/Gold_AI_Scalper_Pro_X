#ifndef __GASPX_LOGGER_MQH__
#define __GASPX_LOGGER_MQH__

class GASPX_Logger
{
private:
   int m_handle;
   bool m_enabled;

public:
   GASPX_Logger(void) { m_handle=INVALID_HANDLE; m_enabled=false; }

   bool Open(const bool enabled)
   {
      m_enabled=enabled;
      if(!m_enabled) return(true);
      string folder="Gold_AI_Scalper_Pro_X";
      FolderCreate(folder);
      string buildTag=GASPX_BUILD;
      string dateTag=TimeToString(TimeCurrent(),TIME_DATE);
      StringReplace(buildTag,".","_");
      StringReplace(dateTag,".","");
      StringReplace(dateTag,"-","");
      string file=folder+"/GASPX_"+buildTag+"_"+Symbol()+"_"+dateTag+".csv";
      m_handle=FileOpen(file,FILE_CSV|FILE_READ|FILE_WRITE|FILE_SHARE_READ,';');
      if(m_handle==INVALID_HANDLE)
      {
         Print(GASPX_NAME,": logger open failed. Error=",GetLastError());
         return(false);
      }
      if(FileSize(m_handle)==0)
         FileWrite(m_handle,"time","event","symbol","bid","ask","spread_points",
                   "atr_points","market_score","danger_score","state","details");
      FileSeek(m_handle,0,SEEK_END);
      return(true);
   }

   void Event(const string eventName,const string details)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),eventName,
                Symbol(),DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",details);
      FileFlush(m_handle);
   }

   void Snapshot(const GASPX_MarketSnapshot &s)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      FileWrite(m_handle,TimeToString(s.timestamp,TIME_DATE|TIME_SECONDS),"SNAPSHOT",Symbol(),
                DoubleToString(s.bid,Digits),DoubleToString(s.ask,Digits),
                DoubleToString(s.spreadPoints,1),DoubleToString(s.atrPoints,1),
                DoubleToString(s.marketScore,1),DoubleToString(s.dangerScore,1),
                GASPX_MarketStateText(s.state),InpSimulationMode ? "SIMULATION" : "FRAMEWORK_ONLY");
      FileFlush(m_handle);
   }

   void Signal(const GASPX_SignalResult &s)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      string details="direction="+GASPX_SignalText(s.direction)+
                     ",buy="+IntegerToString(s.buyScore)+
                     ",sell="+IntegerToString(s.sellScore)+
                     ",confidence="+IntegerToString(s.confidence)+
                     ",adx="+DoubleToString(s.adx,1)+
                     ",atr="+DoubleToString(s.atrPoints,1)+
                     ",market_score="+DoubleToString(s.marketScore,1)+
                     ",danger_score="+DoubleToString(s.dangerScore,1)+
                     ",spread="+(s.spreadAllowed ? "1" : "0")+
                     ",session="+(s.sessionAllowed ? "1" : "0")+
                     ",market="+(s.marketAllowed ? "1" : "0")+
                     ",reason="+s.reason;
      FileWrite(m_handle,TimeToString(s.barTime,TIME_DATE|TIME_SECONDS),"SIGNAL",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","",
                "","",details);
      FileFlush(m_handle);
   }

   void Trade(const string action,const int direction,const double lots,
              const double price,const int level,const bool simulated,const string details)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      string side=(direction>0 ? "BUY" : "SELL");
      string payload="action="+action+",side="+side+
                     ",lots="+DoubleToString(lots,2)+
                     ",price="+DoubleToString(price,Digits)+
                     ",level="+IntegerToString(level)+
                     ",mode="+(simulated ? "SIMULATION" : "LIVE")+
                     ",details="+details;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"TRADE",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",payload);
      FileFlush(m_handle);
   }

   void Risk(const string action,const double value,const string details)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      string payload="action="+action+",value="+DoubleToString(value,2)+",details="+details;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"RISK",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",payload);
      FileFlush(m_handle);
   }

   void Performance(const string action,const double realized,const double grossRealized,
                    const double commission,const double slippage,const double cumulativeCosts,
                    const double basketProfit,
                    const double cumulative,const double grossProfit,const double grossLoss,
                    const double profitFactor,const double maxDrawdown,
                    const int wins,const int losses,const string details)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      string pf=(grossLoss>0.0 ? DoubleToString(profitFactor,3) : "INF");
      string payload="action="+action+
                     ",realized="+DoubleToString(realized,2)+
                     ",gross_realized="+DoubleToString(grossRealized,2)+
                     ",commission="+DoubleToString(commission,2)+
                     ",slippage="+DoubleToString(slippage,2)+
                     ",cumulative_costs="+DoubleToString(cumulativeCosts,2)+
                     ",basket_profit="+DoubleToString(basketProfit,2)+
                     ",cumulative="+DoubleToString(cumulative,2)+
                     ",gross_profit="+DoubleToString(grossProfit,2)+
                     ",gross_loss="+DoubleToString(grossLoss,2)+
                     ",profit_factor="+pf+
                     ",max_drawdown="+DoubleToString(maxDrawdown,2)+
                     ",wins="+IntegerToString(wins)+
                     ",losses="+IntegerToString(losses)+
                     ",details="+details;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"PERFORMANCE",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",payload);
      FileFlush(m_handle);
   }

   void Equity(const double cumulative,const double floatingProfit,const double equityProfit,
               const double peakEquityProfit,const double drawdown,const double maxDrawdown,
               const double maxDrawdownPercent,const double recoveryFactor)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      string recovery=(maxDrawdown>0.0 ? DoubleToString(recoveryFactor,3) : "INF");
      string payload="cumulative="+DoubleToString(cumulative,2)+
                     ",floating="+DoubleToString(floatingProfit,2)+
                     ",equity_profit="+DoubleToString(equityProfit,2)+
                     ",peak_equity_profit="+DoubleToString(peakEquityProfit,2)+
                     ",drawdown="+DoubleToString(drawdown,2)+
                     ",max_drawdown="+DoubleToString(maxDrawdown,2)+
                     ",max_drawdown_percent="+DoubleToString(maxDrawdownPercent,3)+
                     ",recovery_factor="+recovery;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"EQUITY",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",payload);
      FileFlush(m_handle);
   }

   void Position(const GASPX_PositionSummary &p,const string action)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      string side=p.direction>0 ? "BUY" : (p.direction<0 ? "SELL" : "FLAT");
      string payload="action="+action+",side="+side+
                     ",count="+IntegerToString(p.count)+
                     ",lots="+DoubleToString(p.totalLots,2)+
                     ",average="+DoubleToString(p.averagePrice,Digits)+
                     ",profit="+DoubleToString(p.floatingProfit,2)+
                     ",mode="+(p.simulated ? "SIMULATION" : "LIVE");
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"POSITION",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",payload);
      FileFlush(m_handle);
   }

   void Diagnostic(const int basketId,const int direction,const datetime entryTime,
                   const int durationSeconds,const int maxPositions,
                   const double entryAdx,const double entryAtr,const double entryMarketScore,
                   const double entryDangerScore,const int buyScore,const int sellScore,
                   const int confidence,const double netProfit,const string exitReason)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      string side=(direction>0 ? "BUY" : "SELL");
      string outcome=(netProfit>0.0 ? "WIN" : (netProfit<0.0 ? "LOSS" : "FLAT"));
      string payload="basket_id="+IntegerToString(basketId)+
                     ",side="+side+
                     ",entry_time="+TimeToString(entryTime,TIME_DATE|TIME_MINUTES)+
                     ",entry_hour="+IntegerToString(TimeHour(entryTime))+
                     ",duration_seconds="+IntegerToString(durationSeconds)+
                     ",max_positions="+IntegerToString(maxPositions)+
                     ",entry_adx="+DoubleToString(entryAdx,1)+
                     ",entry_atr="+DoubleToString(entryAtr,1)+
                     ",entry_market_score="+DoubleToString(entryMarketScore,1)+
                     ",entry_danger_score="+DoubleToString(entryDangerScore,1)+
                     ",buy_score="+IntegerToString(buyScore)+
                     ",sell_score="+IntegerToString(sellScore)+
                     ",confidence="+IntegerToString(confidence)+
                     ",net_profit="+DoubleToString(netProfit,2)+
                     ",outcome="+outcome+
                     ",exit_reason="+exitReason;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"DIAGNOSTIC",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",payload);
      FileFlush(m_handle);
   }

   void Integration(const GASPX_SYSTEM_STATE state,const string details)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"INTEGRATION",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",
                "state="+GASPX_SystemStateText(state)+",details="+details);
      FileFlush(m_handle);
   }

   void Verification(const string testName,const bool passed,const string details)
   {
      if(!m_enabled || m_handle==INVALID_HANDLE) return;
      FileWrite(m_handle,TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),"VERIFY",Symbol(),
                DoubleToString(Bid,Digits),DoubleToString(Ask,Digits),"","","","","",
                "test="+testName+",result="+(passed ? "PASS" : "FAIL")+",details="+details);
      FileFlush(m_handle);
   }

   void Close(void)
   {
      if(m_handle!=INVALID_HANDLE) FileClose(m_handle);
      m_handle=INVALID_HANDLE;
   }
};

#endif
