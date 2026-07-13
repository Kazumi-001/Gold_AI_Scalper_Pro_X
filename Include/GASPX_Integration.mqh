#ifndef __GASPX_INTEGRATION_MQH__
#define __GASPX_INTEGRATION_MQH__

class GASPX_Integration
{
private:
   GASPX_SYSTEM_STATE m_state;
   GASPX_SYSTEM_STATE m_previousState;
   string m_details;

   void SetState(const GASPX_SYSTEM_STATE state,const string details)
   {
      m_state=state;
      m_details=details;
      if(m_state!=m_previousState)
      {
         g_logger.Integration(m_state,m_details);
         m_previousState=m_state;
      }
   }

public:
   GASPX_Integration(void)
   { m_state=GASPX_SYSTEM_STARTING; m_previousState=GASPX_SYSTEM_STARTING; m_details="INIT"; }

   bool Update(const GASPX_MarketSnapshot &market)
   {
      int bars=iBars(Symbol(),PERIOD_M1);
      if(bars<InpMinimumHistoryBars)
      { SetState(GASPX_SYSTEM_HISTORY_BLOCK,"bars="+IntegerToString(bars)); return(false); }

      if(Bid<=0.0 || Ask<=0.0 || Ask<Bid || Point<=0.0)
      { SetState(GASPX_SYSTEM_QUOTE_BLOCK,"INVALID_QUOTE"); return(false); }

      double tickSize=MarketInfo(Symbol(),MODE_TICKSIZE);
      double tickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
      double minLot=MarketInfo(Symbol(),MODE_MINLOT);
      double lotStep=MarketInfo(Symbol(),MODE_LOTSTEP);
      if(tickSize<=0.0 || tickValue<=0.0 || minLot<=0.0 || lotStep<=0.0)
      { SetState(GASPX_SYSTEM_BROKER_BLOCK,"INVALID_CONTRACT_SPEC"); return(false); }

      if(market.atrPoints<=0.0 || market.state==GASPX_MARKET_UNKNOWN)
      { SetState(GASPX_SYSTEM_MARKET_BLOCK,"MARKET_DATA_NOT_READY"); return(false); }

      SetState(GASPX_SYSTEM_READY,"PIPELINE_READY");
      return(true);
   }

   GASPX_SYSTEM_STATE State(void) { return(m_state); }
   string Details(void) { return(m_details); }
};

#endif
