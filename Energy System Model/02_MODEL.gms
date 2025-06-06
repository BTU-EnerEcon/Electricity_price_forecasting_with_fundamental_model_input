Variables
    costs           total generation costs (ojective variable)[bn �]
;

Positive Variables
    g(i,n,t)        generation of each technology cluster [MWh per h]
    p_on(i,n,t)     running (started) generation capacities [MW]
    su(i,n,t)       start-up activity of a generation technology [MW]
    sd              shutdown activity
    flow(n,nn,t)    electricity transfer from node n to nn [MWh per h]
    pump(i,n,t)      when PSP is not storage charging
    charge(n,t)
    storagelevel(i,n,t) State of Storage
    shed(n,t)         Load shedding
    curtailment(i,n,t) RES curtailment
    pcr(i,n,bp)         primary reserve provision
    scr_pos(i,n,bs)     secondary reserve provision - positive
    scr_neg(i,n,bs)     secondary reserve provision - negative
%xDem%    X_dem(n,t)

;

*##############################   Equations   ###############################

Equations
    ojective            objective function minimizes total system costs
    energy_balance      demand equals supply
    energy_balance2
    max_gen             generation is lower than running capacity
    min_gen
    max_cap             running capacity is lower than installed capacity

    startup_constraint  constraining start-up activities
    shutdown_constraint constraining shutdown activities
    p_on_tfirst         running capicity in the first hour of the rolling horizon
    p_on_tlast          running capicity in the last hour of the rolling horizon
    min_offtime         minimum offtime after shut down

    max_RES             maximum RES generation
    max_RES2

    CHP_constraint_lig      must production for CHP plants
    CHP_constraint_coal      must production for CHP plants
    CHP_constraint_gas      must production for CHP plants
    CHP_constraint_oil      must production for CHP plants

    lineflow_1      Flow is restricted by the time dependent NTC
    lineflow_2

    Store_max_cluster           maximum turbine capacity [MW]
    Pump_max_cluster           maximum turbine capacity [MW]
    Reservoir_power_max

    Store_Level         storage level mechanism
    Store_Level_max     maximum Storage Level (MWh)
    Store_max           maximum turbine capacity (MW)
    Store_tfirst        storage level in the first time period
    Store_tlast         storage level in the last time period

    PrimReserve          Primary Reserve
    SecReserve_pos       positive Secondary Reserve
    SecReserve_neg       negative Secondary Reserve

*    Gen_Bio
*    Gen_RoR
*    Gen_Reserv
;

ojective..      COSTS =E= sum(t$(ord(t)>=x_down and ord(t)<=x_up),
                         sum((Thermal,n)$CAP(thermal,n,t), g(Thermal,n,t) * vc_fl(Thermal,n,t))
%Startup%              + sum((Thermal,n)$CAP(thermal,n,t), SU(Thermal,n,t) * sc(Thermal,n,t))
%Startup%              + sum((Thermal,n)$CAP(thermal,n,t), (p_on(Thermal,n,t)-g(Thermal,n,t)) * (vc_ml(Thermal,n,t)-vc_fl(Thermal,n,t))*g_min(Thermal) / (1-g_min(Thermal)))
                       + sum((StorageCluster,n)$cap_PSP_cluster(n,StorageCluster,t), g(StorageCluster,n,t)* water_value_PSP_gen(n,StorageCluster,t) )
                       + sum((StorageCluster,n)$cap_PSP_cluster(n,StorageCluster,t), Pump(StorageCluster,n,t)*  water_value_PSP_pump(n,StorageCluster,t))
                       + sum((ReservoirCluster,n)$cap_Reservoir_cluster(n,ReservoirCluster,t), g(ReservoirCluster,n,t)*water_value_Reservoir(n,ReservoirCluster,t))
                       + sum((n), Shed(n,t)*voll)
                       + sum((ResT,n),Curtailment(ResT,n,t) * cost_curt)
%xDem%                 + sum((n), X_dem(n,t))*3500

                          ) /scaling_objective
;


energy_balance(n,t)$(ord(t)>=x_down and ord(t)<=x_focus_up)..     DEMAND(t,n) + CAP('PSP',n,t)*af_hydro('PSP',n,t)*(1-share_PSP_daily)* 0.8  =E= sum(i, g(i,n,t))
                                            + sum(StorageCluster, Pump(StorageCluster,n,t))
%Store%                                     - Charge(n,t)
%Flow%                                      + sum(nn$ntc(t,nn,n), flow(nn,n,t)) - sum(nn$ntc(t,n,nn), flow(n,nn,t))
                                            + Shed(n,t)
%xDem%                                      - X_dem(n,t)

;
energy_balance2(n,t)$(ord(t)>=x_2DA_down and ord(t)<=x_up)..     DEMAND2DA(t,n) + CAP('PSP',n,t)*af_hydro('PSP',n,t)*(1-share_PSP_daily)* 0.8  =E= sum(i, g(i,n,t))
                                            + sum(StorageCluster, Pump(StorageCluster,n,t))
%Store%                                     - Charge(n,t)
%Flow%                                      + sum(nn$ntc(t,nn,n), flow(nn,n,t)) - sum(nn$ntc(t,n,nn), flow(n,nn,t))
                                            + Shed(n,t)
%xDem%                                      - X_dem(n,t)

;

max_gen(Thermal,n,bs,bp,t)$(ord(t)>=x_down and ord(t)<=x_up and map_bpt(bp,t)and map_bst(bs,t))..       g(Thermal,n,t)
%ConPow%                                         + pcr(Thermal,n,bp)+scr_pos(Thermal,n,bs)
                                                                 =L=
%Startup%                                       p_on(Thermal,n,t)
%exc_Startup%                                   CAP(Thermal,n,t) * AF_overall(Thermal,n,t) - outages(Thermal,n,t)
;

min_gen(Thermal,n,bs,bp,t)$(ord(t)>=x_down and ord(t)<=x_up  and map_bpt(bp,t)and map_bst(bs,t))..       g(Thermal,n,t) =G= p_on(Thermal,n,t)*g_min(Thermal)
%ConPow%                                                                                 + pcr(Thermal,n,bp)+scr_neg(Thermal,n,bs)
;

max_CAP(Thermal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..         p_on(Thermal,n,t) =L= CAP(Thermal,n,t) * AF_overall(Thermal,n,t) - Outages(Thermal,n,t)
;

startup_constraint(Thermal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..  p_on(Thermal,n,t)- p_on(Thermal,n,t-1) =L= su(Thermal,n,t)
;

shutdown_constraint(Thermal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..  p_on(Thermal,n,t-1)- p_on(Thermal,n,t) =L= sd(Thermal,n,t)
;

min_offtime(Thermal,n,t,tt)$( ord(t)>=x_down and ord(t)<=x_up and ord(tt)>=x_down and ord(tt)<=x_up and ord(t) <= ord(tt) and ord(tt) <= (ord(t)+downtime(Thermal)) )..
                                    p_on(Thermal,n,t-1) - p_on(Thermal,n,t) =l= CAP(Thermal,n,t)* AF_overall(Thermal,n,tt) - outages(Thermal,n,tt) - p_on(Thermal,n,tt)
;


max_RES(ResT,n,t)$(ord(t)>=x_down and ord(t)<=x_focus_up)..         g(ResT,n,t) =E= sqrt(sqr(res_gen(t,n,ResT)))-Curtailment(ResT,n,t)
;

max_RES2(ResT,n,t)$(ord(t)>=x_2DA_down and ord(t)<=x_up)..         g(ResT,n,t) =E= sqrt(sqr(res_gen(t-24,n,ResT)))-Curtailment(ResT,n,t)
;

CHP_constraint_lig(lignite,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..    g(lignite,n,t) =G= CHP_gen_lig_cluster(lignite,n,t)
;
CHP_constraint_coal(coal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..      g(coal,n,t) =G= CHP_gen_coal_cluster(coal,n,t)
;
CHP_constraint_gas(gas,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..        g(gas,n,t) =G= CHP_gen_gas_cluster(gas,n,t)
;
CHP_constraint_oil(oil,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..        g(oil,n,t) =G= CHP_gen_oil_cluster(oil,n,t)
;

lineflow_1(n,nn,t)$(ord(t)>=x_down and ord(t)<=x_focus_up)..      flow(n,nn,t)  =L=  ntc(t,n,nn)
;
lineflow_2(n,nn,t)$(ord(t)>=x_2DA_down and ord(t)<=x_up)..      flow(n,nn,t)  =L=  ntc(t-24,n,nn)
;
*daily storages
Store_Level(n,t)$(ord(t)>=x_down and ord(t)<=x_up)..     storagelevel('PSP',n,t) =E= storagelevel('PSP',n,t-1)-g('PSP',n,t)+Charge(n,t)*eta_fl('PSP',n)
;

Store_Level_max(n,t)$(ord(t)>=x_down and ord(t)<=x_up)..      storagelevel('PSP',n,t) =L= CAP('PSP',n,t) * share_PSP_daily * store_cpf
;

Store_max(n,t)$(ord(t)>=x_down and ord(t)<=x_up)..        g('PSP',n,t)
%Store%                                                   + charge(n,t)*1.1                                 #assuming that the pump capacity is generally lower than the turbine capacity
                                                       =L= CAP('PSP',n,t) * Share_PSP_daily * AF_hydro('PSP',n,t) 
;
Store_tfirst(n,t,'PSP')$(ord(t)=x_down)..    storagelevel('PSP',n,t) =E= CAP('PSP',n,t)* Share_PSP_daily * AF_hydro('PSP',n,t)*Store_cpf * 0.3
;
Store_tlast(n,t,'PSP')$(ord(t)=x_up)..     storagelevel('PSP',n,t) =E= CAP('PSP',n,t) * Share_PSP_daily * AF_hydro('PSP',n,t)*Store_cpf * 0.3
;

*seasonal storages
Store_max_cluster(StorageCluster,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..
                                        g(StorageCluster,n,t) =L= cap_PSP_cluster(n,StorageCluster,t) * (1-share_PSP_daily) * 0.8
;
Pump_max_cluster(StorageCluster,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..
                                        Pump(StorageCluster,n,t) =L= cap_PSP_cluster(n,StorageCluster,t) * (1-share_PSP_daily) * 0.8
;

Reservoir_power_max(ReservoirCluster,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..
                                        g(ReservoirCluster,n,t) =L= cap_Reservoir_cluster(n,ReservoirCluster,t)
;

PrimReserve(bp,t)$(ord(t)>=x_down and ord(t)<=x_up and map_bpt(bp,t))..         sum(Thermal, pcr(Thermal,'DE',bp)) =E= PR('DE')
;
SecReserve_pos(bs,t)$(ord(t)>=x_down and ord(t)<=x_up and map_bst(bs,t))..     sum(Thermal, scr_pos(Thermal,'DE',bs)) =E= SR_pos('DE')
;
SecReserve_neg(bs,t)$(ord(t)>=x_down and ord(t)<=x_up and map_bst(bs,t))..     sum(Thermal, scr_neg(Thermal,'DE',bs)) =E= SR_neg('DE')
;

*Gen_Bio(Biomass,n,t)$(ord(t)>=x_down and ord(t)<=x_up )..    g(Biomass,n,t) =e= CAP(Biomass,n,t) * af_overall(Biomass,n,t)
*;
*Gen_RoR(n,t)$(ord(t)>=x_down and ord(t)<=x_up )..    g('RoR',n,t) =e= CAP('RoR',n,t) * af_overall('RoR',n,t)
*;
*Gen_Reserv(n,t)$(ord(t)>=x_down and ord(t)<=x_up ).. g('Reservoir',n,t) =e= CAP('Reservoir',n,t) * af_overall('Reservoir',n,t)
*;
G.fx('Reservoir',n,t) = 0      ;
g.fx(Biomass,n,t)     = CAP(Biomass,n,t) * af_overall(Biomass,n,t) ;
G.fx('RoR',n,t)       = CAP('RoR',n,t) * af_hydro('RoR',n,t)      ;




model ProKoMo
    /
            ojective
            energy_balance
            energy_balance2
            max_gen
%Startup%   min_gen
%Startup%   max_cap
%Startup%   startup_constraint
%Startup%   shutdown_constraint
*%Startup%   min_offtime

            max_RES
            max_RES2

%CHP%       CHP_constraint_lig
%CHP%       CHP_constraint_coal
%CHP%       CHP_constraint_gas
%CHP%       CHP_constraint_oil
%Flow%      lineflow_1
%Flow%      lineflow_2

            Store_max_cluster
            Pump_max_cluster
            Reservoir_power_max

%store%     Store_Level
%store%     Store_Level_max
%store%     Store_max
%store%     Store_tfirst
%store%     Store_tlast

%ConPow%    PrimReserve
%ConPow%    SecReserve_pos
%ConPow%    SecReserve_neg

*    Gen_Bio
*    Gen_RoR
*    Gen_Reserv

    /  ;

ProKoMo.reslim = 1000000000;
ProKoMo.iterlim = 1000000000;
ProKoMo.holdfixed = 1;

option LP = CPLEX   ;

option threads = 4;
option BRatio = 1 ;

*    ProKoMo.optfile = 1;
*    ProKoMo.dictfile=0;
*    ProKoMo.SCALEOPT = 1;
*    OBJECTIVE_GLOBAL.scale = 1e006;

option
    limrow = 0,         # equations listed per block
    limcol = 0,         # variables listed per block
    solprint = off,     # solver's solution output printed
    sysout = off;       # solver's system output printed

* Turn off the listing of the input file
$offlisting

* Turn off the listing and cross-reference of the symbols used
$offsymxref offsymlist

;


