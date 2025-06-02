parameter
gen_gas(year_focus,month,day,hour,n)
gen_oil(year_focus,month,day,hour,n)
gen_coal(year_focus,month,day,hour,n)
gen_lig(year_focus,month,day,hour,n)
gen_nuc(year_focus,month,day,hour,n)
gen_hydro(year_focus,month,day,hour,n,i)

price(year_focus,month,day,hour,n)
generation_all(year_focus,month,day,hour,n,i)
generation_thermal(year_focus,month,day,hour,n,i)
generation_gas(year_focus,month,day,hour,n,i)
generation_coal(year_focus,month,day,hour,n,i)
generation_oil(year_focus,month,day,hour,n,i)
generation_biomass(year_focus,month,day,hour,n,i)

Pon_all(year_focus,month,day,hour,n,i)


storage_cluster_activity(year_focus,month,day,hour,n)
StLevel(year_focus,month,day,hour,n)
Reservoir_activity(year_focus,month,day,hour,n)
PSP_pump(year_focus,month,day,hour,n)
PSP_charge(year_focus,month,day,hour,n)
PSP_Gen(year_focus,month,day,hour,n)
X_demand(year_focus,month,day,hour,n)
shedding(year_focus,month,day,hour,n)

export(year_focus,month,day,hour,n,nn)
import(year_focus,month,day,hour,n,nn)

PrimaryReserve(year_focus,month,day,hour,i)
SecondaryReserve_pos(year_focus,month,day,hour,i)
SecondaryReserve_neg(year_focus,month,day,hour,i)

  generation_all_monthly(year_focus,month,n,i)
  generation_thermal_monthly(year_focus,month,n,i)
  generation_gas_monthly(year_focus,month,n)
  generation_coal_monthly(year_focus,month,n)
  generation_lignite_monthly(year_focus,month,n)
  generation_oil_monthly(year_focus,month,n)
  generation_biowaste_monthly(year_focus,month,n)

  export_monthly(year_focus,month,n,nn)
  import_monthly(year_focus,month,n,nn)
;

price(year_focus,month,day,hour,'DE')               = sum(daily_window, price_roll(year_focus,month,day,hour,'DE',daily_window)     );

*generation_all(year_focus,month,day,hour,n,i)      = sum(daily_window, generation_all_roll(year_focus,month,day,hour,n,i,daily_window) );
*generation_thermal(year_focus,month,day,hour,n,thermal)  = sum(daily_window, generation_all_roll(year_focus,month,day,hour,n,thermal,daily_window) );
*generation_gas(year_focus,month,day,hour,n,gas)    = sum(daily_window, generation_all_roll(year_focus,month,day,hour,n,gas,daily_window) );
*generation_coal(year_focus,month,day,hour,n,coal)  = sum(daily_window, generation_all_roll(year_focus,month,day,hour,n,coal,daily_window) );
*generation_oil(year_focus,month,day,hour,n,oil)    = sum(daily_window, generation_all_roll(year_focus,month,day,hour,n,oil,daily_window) );
*generation_biomass(year_focus,month,day,hour,n,biomass)    = sum(daily_window, generation_all_roll(year_focus,month,day,hour,n,biomass,daily_window) );

$ontext
generation_all_monthly(year_focus,month,n,i)       = sum((day,hour), generation_all(year_focus,month,day,hour,n,i)    );
generation_thermal_monthly(year_focus,month,n,thermal)   = sum((day,hour), generation_all(year_focus,month,day,hour,n,thermal) );
generation_gas_monthly(year_focus,month,n)         = sum((day,hour,gas), generation_all(year_focus,month,day,hour,n,gas)    );
generation_lignite_monthly(year_focus,month,n)   = sum((day,hour,lignite), generation_all(year_focus,month,day,hour,n,lignite)        );
generation_coal_monthly(year_focus,month,n)      = sum((day,hour,coal), generation_all(year_focus,month,day,hour,n,coal)        );
generation_oil_monthly(year_focus,month,n)       = sum((day,hour,oil), generation_all(year_focus,month,day,hour,n,oil)        );
generation_biowaste_monthly(year_focus,month,n)   = sum((day,hour,biomass), generation_all(year_focus,month,day,hour,n,biomass)        );
$offtext

*%Store%  StLevel(year_focus,month,day,hour,'DE')             = sum(daily_window, StLevel_roll(year_focus,month,day,hour,'DE',daily_window) );
*         storage_cluster_activity(year_focus,month,day,hour,n)    = sum(daily_window, storage_activity_roll(year_focus,month,day,hour,n,daily_window) );
*%Store%  PSP_Gen(year_focus,month,day,hour,n)           = sum(daily_window, PSP_gen_roll(year_focus,month,day,hour,n,daily_window) );
*         Reservoir_activity(year_focus,month,day,hour,n)  = sum(daily_window, Reservoir_activity_roll(year_focus,month,day,hour,n,daily_window) );
*         PSP_pump(year_focus,month,day,hour,n)            = sum(daily_window, PSP_pump_roll(year_focus,month,day,hour,n,daily_window) );
*%Store%  PSP_charge(year_focus,month,day,hour,n)        = sum(daily_window, PSP_charge_roll(year_focus,month,day,hour,n,daily_window) );

*%xDem%   X_demand(year_focus,month,day,hour,n)   = sum(daily_window, X_demand_roll(year_focus,month,day,hour,n,daily_window) );
*         shedding(year_focus,month,day,hour,n)   = sum(daily_window, Shed_roll(year_focus,month,day,hour,n,daily_window) ) ;

*%Startup% Pon_all(year_focus,month,day,hour,'DE',i)     = sum(daily_window, Pon_all_roll(year_focus,month,day,hour,i,daily_window) ) ;


*%Flow%   export(year_focus,month,day,hour,n,nn)         = sum(daily_window, export_roll(year_focus,month,day,hour,n,nn,daily_window) ) ;
*%Flow%   import(year_focus,month,day,hour,n,nn)         = sum(daily_window, import_roll(year_focus,month,day,hour,n,nn,daily_window) ) ;
*%Flow%   export_monthly(year_focus,month,n,nn)         = sum((day,hour), export(year_focus,month,day,hour,n,nn) );
*%Flow%   import_monthly(year_focus,month,n,nn)         = sum((day,hour), import(year_focus,month,day,hour,n,nn) );


*%ConPow% PrimaryReserve(year_focus,month,day,hour,i)       = sum(daily_window,  PrimaryReserve_roll(year_focus,month,day,hour,i,daily_window) )         ;
*%ConPow% SecondaryReserve_pos(year_focus,month,day,hour,i) = sum(daily_window,  SecondaryReserve_pos_roll(year_focus,month,day,hour,i,daily_window) )   ;
*%ConPow% SecondaryReserve_neg(year_focus,month,day,hour,i) = sum(daily_window,  SecondaryReserve_neg_roll(year_focus,month,day,hour,i,daily_window) )   ;



EXECUTE_UNLOAD '%output_dir%%result%.gdx'    price
*                 , Pon_all
*                 , generation_all
*                , PSP_pump
*                , export, import
*                , export_monthly, import_monthly
*                 , generation_gas_monthly ,generation_lignite_monthly, generation_coal_monthly, generation_oil_monthly , generation_biowaste_monthly
*              , generation_thermal, generation_gas, generation_coal, generation_oil
*               , PrimaryReserve, SecondaryReserve_pos, SecondaryReserve_neg
*              , storage_cluster_activity, Reservoir_activity
*               , PSP_charge
*               , PSP_Gen
*               , X_demand
*               , shedding
*                 , modelstats, solvestats
*               , StLevel

;
*$stop

$onecho >out.tmp

         par=price                         rng=price!A1:AJ9999    rdim=4 cdim=1
*         par=generation_all                   rng=Generation!A1      rdim=4 cdim=2
*         par=Pon_all                       rng=P_on!A1            rdim=4 cdim=2
*         par=generation_thermal_monthly    rng=G_monthly!A1       rdim=2 cdim=2
*         par=generation_gas                rng=G_Gas!A1           rdim=4 cdim=2
*         par=generation_coal               rng=G_Coal!A1          rdim=4 cdim=2
*         par=generation_oil                rng=G_Oil!A1           rdim=4 cdim=2
*         par=generation_biomass            rng=G_Bio!A1           rdim=4 cdim=2
*         par=storage_activity              rng=PSP!A1             rdim=4 cdim=1
*         par=Reservoir_activity            rng=Reservoir!A1:O9999 rdim=4 cdim=1
*         par=PSP_pump                      rng=Pump!A1            rdim=4 cdim=1
*         par=PSP_Gen                       rng=PSP!W1             rdim=4 cdim=1
*         par=PSP_charge                    rng=Pump!W1            rdim=4 cdim=2
*         par=StLevel                       rng=StLevel!A1         rdim=4 cdim=1
*%xDem%   par=X_demand                      rng=x_dem!A1           rdim=4 cdim=1
*%ConPow% par=PrimaryReserve                rng=CP_pr!A1           rdim=4 cdim=1
*%ConPow% par=SecondaryReserve_pos          rng=CP_sec_pos!A1           rdim=4 cdim=1
*%ConPow% par=SecondaryReserve_neg          rng=CP_sec_neg!A1           rdim=4 cdim=1

*         par=modelstats                    rng=stats!A2:B9900     rdim=1 cdim=0
*         par=solvestats                    rng=stats!D2:E9900     rdim=1 cdim=0

$offecho

execute "XLSTALK -c    %output_dir%%result%.xlsx" ;

EXECUTE 'gdxxrw %output_dir%%result%.gdx o=%output_dir%%result%.xlsx EpsOut=0 @out.tmp'
;
