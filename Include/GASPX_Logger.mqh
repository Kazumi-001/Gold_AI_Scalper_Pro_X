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

   void Close(void)
   {
      if(m_handle!=INVALID_HANDLE) FileClose(m_handle);
      m_handle=INVALID_HANDLE;
   }
};

#endif
