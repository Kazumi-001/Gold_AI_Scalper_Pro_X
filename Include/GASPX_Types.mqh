#ifndef __GASPX_TYPES_MQH__
#define __GASPX_TYPES_MQH__

enum GASPX_MARKET_STATE
{
   GASPX_MARKET_UNKNOWN = 0,
   GASPX_MARKET_QUIET,
   GASPX_MARKET_TRADABLE,
   GASPX_MARKET_DANGEROUS
};

struct GASPX_MarketSnapshot
{
   datetime timestamp;
   double bid;
   double ask;
   double spreadPoints;
   double atrPoints;
   double marketScore;
   double dangerScore;
   GASPX_MARKET_STATE state;
};

string GASPX_MarketStateText(const GASPX_MARKET_STATE state)
{
   switch(state)
   {
      case GASPX_MARKET_QUIET:     return("QUIET");
      case GASPX_MARKET_TRADABLE:  return("TRADABLE");
      case GASPX_MARKET_DANGEROUS: return("DANGEROUS");
      default:                     return("UNKNOWN");
   }
}

double GASPX_ClampScore(const double value)
{
   if(value < 0.0) return(0.0);
   if(value > 100.0) return(100.0);
   return(value);
}

enum GASPX_SIGNAL_DIRECTION
{
   GASPX_SIGNAL_NONE = 0,
   GASPX_SIGNAL_BUY  = 1,
   GASPX_SIGNAL_SELL = -1
};

struct GASPX_SignalResult
{
   datetime barTime;
   GASPX_SIGNAL_DIRECTION direction;
   int buyScore;
   int sellScore;
   int confidence;
   double adx;
   double atrPoints;
   double marketScore;
   double dangerScore;
   bool spreadAllowed;
   bool sessionAllowed;
   bool marketAllowed;
   string reason;
};

string GASPX_SignalText(const GASPX_SIGNAL_DIRECTION direction)
{
   if(direction==GASPX_SIGNAL_BUY) return("BUY");
   if(direction==GASPX_SIGNAL_SELL) return("SELL");
   return("NONE");
}

struct GASPX_PositionSummary
{
   int direction;
   int count;
   double totalLots;
   double averagePrice;
   double floatingProfit;
   double latestPrice;
   bool simulated;
};

enum GASPX_SYSTEM_STATE
{
   GASPX_SYSTEM_STARTING = 0,
   GASPX_SYSTEM_READY,
   GASPX_SYSTEM_HISTORY_BLOCK,
   GASPX_SYSTEM_QUOTE_BLOCK,
   GASPX_SYSTEM_BROKER_BLOCK,
   GASPX_SYSTEM_MARKET_BLOCK
};

string GASPX_SystemStateText(const GASPX_SYSTEM_STATE state)
{
   switch(state)
   {
      case GASPX_SYSTEM_READY:         return("READY");
      case GASPX_SYSTEM_HISTORY_BLOCK: return("HISTORY_BLOCK");
      case GASPX_SYSTEM_QUOTE_BLOCK:   return("QUOTE_BLOCK");
      case GASPX_SYSTEM_BROKER_BLOCK:  return("BROKER_BLOCK");
      case GASPX_SYSTEM_MARKET_BLOCK:  return("MARKET_BLOCK");
      default:                         return("STARTING");
   }
}

#endif
