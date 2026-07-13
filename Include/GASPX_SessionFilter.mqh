#ifndef __GASPX_SESSION_FILTER_MQH__
#define __GASPX_SESSION_FILTER_MQH__

bool GASPX_SessionAllowed(const datetime when)
{
   int hour=TimeHour(when);
   if(InpSessionStartHour==0 && InpSessionEndHour==24) return(true);
   if(InpSessionStartHour<InpSessionEndHour)
      return(hour>=InpSessionStartHour && hour<InpSessionEndHour);
   return(hour>=InpSessionStartHour || hour<InpSessionEndHour);
}

#endif
