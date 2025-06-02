parameter
price_roll(year_focus,month,day,hour,n,*)
generation_all_roll(year_focus,month,day,hour,n,i,*)
generation_all_roll_monthly(year_focus,month,n,i,*)

Pon_all_roll(year_focus,month,day,hour,i,*)

storage_activity_roll(year_focus,month,day,hour,n,*)
StLevel_roll(year_focus,month,day,hour,n,*)
Reservoir_activity_roll(year_focus,month,day,hour,n,*)
PSP_pump_roll(year_focus,month,day,hour,n,*)
PSP_gen_roll(year_focus,month,day,hour,n,*)
PSP_charge_roll(year_focus,month,day,hour,n,*)
X_demand_roll(year_focus,month,day,hour,n,*)
Shed_roll(year_focus,month,day,hour,n,*)

export_roll(year_focus,month,day,hour,n,nn,*)
import_roll(year_focus,month,day,hour,n,nn,*)

PrimaryReserve_roll(year_focus,month,day,hour,i,*)
SecondaryReserve_pos_roll(year_focus,month,day,hour,i,*)
SecondaryReserve_neg_roll(year_focus,month,day,hour,i,*)

modelstats(*)
solvestats(*)
;

loop(daily_window,
    x_down = 1+(ord(daily_window)-3)*24 ;
    x_up   =   ord(daily_window)*24 ;
    x_focus= 1+(ord(daily_window)-2)*24  ;
    x_focus_up= (ord(daily_window)-1)*24 ;
    x_2DA_down= x_focus_up+1  ;

solve ProKoMo using LP minimizing COSTS ;

         price_roll(year_focus,month,day,hour,'DE',daily_window)      =  sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), energy_balance.M('DE',t))*scaling_objective*(-1) ;

*         generation_all_roll(year_focus,month,day,hour,'DE',i,daily_window) = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), G.l(i,'DE',t)) ;
*         generation_all_roll_monthly(year_focus,month,n,i,daily_window) = sum( t$(map_YMT(year_focus,month,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), G.l(i,n,t)) ;

*%Startup%     Pon_all_roll(year_focus,month,day,hour,thermal,daily_window)       = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), P_on.l(thermal,'DE',t)) ;

*         storage_activity_roll(year_focus,month,day,hour,'DE',daily_window) = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), sum( StorageCluster, g.l(StorageCluster,'DE',t)) ) ;

*%Store%  StLevel_roll(year_focus,month,day,hour,'DE',daily_window) = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), storagelevel.l('PSP','DE',t) ) ;

*         Reservoir_activity_roll(year_focus,month,day,hour,n,daily_window) = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), sum( ReservoirCluster, G.l(ReservoirCluster,n,t)) )  ;
*         PSP_pump_roll(year_focus,month,day,hour,'DE',daily_window) = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), sum( StorageCluster, cap_PSP_cluster('DE',StorageCluster,t) * (1-share_PSP_daily) * 0.8 - pump.l (StorageCluster,'DE',t) ) ) ;
*%Store%  PSP_gen_roll(year_focus,month,day,hour,'DE',daily_window) = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up),  G.l('PSP','DE',t) )  ;
*%Store%  PSP_charge_roll(year_focus,month,day,hour,'DE',daily_window) = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up),  Charge.l('DE',t) )  ;
*%xDem%   X_demand_roll(year_focus,month,day,hour,n,daily_window)   = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up),  X_dem.l(n,t) )  ;
*             Shed_roll(year_focus,month,day,hour,n,daily_window)   = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up),  Shed.l(n,t) )  ;


*%Flow%   export_roll(year_focus,month,day,hour,'DE',nn,daily_window)   = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up),  flow.l('DE',nn,t) )  ;
*%Flow%   import_roll(year_focus,month,day,hour,'DE',nn,daily_window)   = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up),  flow.l(nn,'DE',t) )  ;

*%ConPow% PrimaryReserve_roll(year_focus,month,day,hour,i,daily_window)       = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up),  sum( bp$map_bpT(bp,t),  pcr.l(i,'DE',bp) ))  ;
*%ConPow% SecondaryReserve_pos_roll(year_focus,month,day,hour,i,daily_window)    = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), sum( bs$map_bsT(bs,t),  scr_pos.l(i,'DE',bs) ))  ;
*%ConPow% SecondaryReserve_neg_roll(year_focus,month,day,hour,i,daily_window)    = sum( t$(map_YMDHT(year_focus,month,day,hour,t)and ord(t)>=x_focus and ord(t)<= x_focus_up), sum( bs$map_bsT(bs,t),  scr_neg.l(i,'DE',bs) ))  ;


* modelstats(daily_window)          =  ProKoMo.modelstat    ;
* solvestats(daily_window)          =  ProKoMo.solvestat    ;

)
;
