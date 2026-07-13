#ifndef __GASPX_SPREAD_FILTER_MQH__
#define __GASPX_SPREAD_FILTER_MQH__

bool GASPX_SpreadAllowed()
{
   return(GASPX_CurrentSpreadPoints()<=InpMaxSpreadPoints);
}

#endif
