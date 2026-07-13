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

#endif
