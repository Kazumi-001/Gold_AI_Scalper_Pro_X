#ifndef __GASPX_CONFIG_MQH__
#define __GASPX_CONFIG_MQH__

#define GASPX_NAME          "Gold AI Scalper Pro X"
#define GASPX_VERSION       "1.0"
#define GASPX_BUILD         "1.0.002"
#define GASPX_MAGIC_DEFAULT 777

input bool   InpSimulationMode = true;
input bool   InpEnableCsvLog   = true;
input int    InpMagicNumber    = GASPX_MAGIC_DEFAULT;
input int    InpMaxSpreadPoints = 30;
input int    InpAtrPeriod       = 14;
input int    InpSnapshotSeconds = 10;
input double InpAtrLowPoints    = 80.0;
input double InpAtrHighPoints   = 1200.0;

bool GASPX_ValidateInputs(string &reason)
{
   if(InpMagicNumber <= 0)       { reason="MagicNumber must be positive"; return(false); }
   if(InpMaxSpreadPoints <= 0)   { reason="MaxSpreadPoints must be positive"; return(false); }
   if(InpAtrPeriod < 2)          { reason="AtrPeriod must be at least 2"; return(false); }
   if(InpSnapshotSeconds < 1)    { reason="SnapshotSeconds must be positive"; return(false); }
   if(InpAtrLowPoints < 0.0 || InpAtrHighPoints <= InpAtrLowPoints)
   { reason="ATR thresholds are invalid"; return(false); }
   reason="";
   return(true);
}

#endif
