:-ensure_loaded('RTXengine/RTXengine.pl').
:-ensure_loaded('RTXengine/RTXutil.pl').



:-dynamic inst/2.
:-dynamic finst/1.


m:-make.


inst(building,[id:1, name:'Edificio das couves', id_thingsboard:'idtb_1']).

inst(space,[id:1, name:'Bastidor computadores', 37,
       occupation_type:tecnologia, id_thingsboard:'idtb_2', building_id:1]).

inst(env_var,[id:1, name:temperatura, value:37, unit_type:celcius, space_id:1]).

inst(profile, [id:1, name:verao, state:activo, space_id:1]).

inst(device,  [id:1, name:ar_condicionado, type:actuador, id_thingsboard:'idtb_3', space_id:1]).

inst(dev_config,[id:1, state:active, operation_value:10, device_id:1, schedule_id:1]).

inst(activation_strategy,[id:1, name:agressiva, profile_id:1]).

inst(schedule,[id:1, start:'08.30', end:'10:45', profile_id:1]).

inst(strategy_occupation,[min:18, max:26, activation_strategy_id:1]).

inst(strategy_temporal,[monday:true, tuesday:true, wednesday:true, thursday:true, friday:true, saturday:false, sunday:false,
                   spring:true, summer:true, autumn:false, winter:false,
                   activation_strategy_id:1]).

inst(env_var_config,[id:1, min:15, max:25, env_var_id:1, schedule_id:1]).


/*factorize_instances */
fi:-
    findall( _ , (
                 inst(Name, AttributeValueList),
                 member(AttributeValue, AttributeValueList),
                 AttributeName : AttributeValue =  AttributeValue,
                 NewFunctor =.. [Name|[AttributeName, AttributeValue]],
                 assert(NewFunctor),
                 assert(finst(NewFunctor))
             ),_).



set_if_null(Functor):-
    catch(Functor,   _Catcher,    assert(Functor) ),!.
set_if_null(_).


/*destrioy facts*/
df:-
    forall(finst(X), retractall(X)),
    retractall(finst(_)).

/*
there_is(_,[]).
there_is(Relation, [A:V |Attributes]):-
    inst(Relation, AttributeValueList),
    member( A:V, AttributeValueList),
    there_is(Relation,Attributes).
    %finda( member( Attr:Value, Attributes), member(Attr:Value,AttributeValueList)).
*/

there_is_a(Relation, Attributes):-
    inst(Relation, AttributeValueList),
    forall( member( Attr:Value, Attributes), member(Attr:Value,AttributeValueList)).


% instance-based rule: handles any variable specified in profiles_schema
defrule r_above_max
   if   there_is_a(building,               [id : Building_id])
        and there_is_a(space,              [id : Space_id              , building_id : Building_id])
        and there_is_a(profile,            [id : Profile_id            , space_id    : Space_id   ])
        and there_is_a(activation_strategy,[id : Activation_strategy_id, profile_id  : Profile_id ])
        and there_is_a(strategy_occupation,[activation_strategy_id : Activation_strategy_id, max:MaxVal ])
        and there_is_a(env_var,            [id : Env_var_id, value:Env_var_vale])
        and Env_var_vale> MaxVal
   then [
       Term = evento(env_var, Env_var_id , 'above' , MaxVal),
       writeln(Term),
       assert_once(Term)
   ].

% instance-based rule: handles any variable specified in profiles_schema
defrule r_below_min
   if   there_is_a(building,               [id : Building_id])
        and there_is_a(space,              [id : Space_id              , building_id : Building_id])
        and there_is_a(profile,            [id : Profile_id            , space_id    : Space_id   ])
        and there_is_a(activation_strategy,[id : Activation_strategy_id, profile_id  : Profile_id ])
        and there_is_a(strategy_occupation,[activation_strategy_id : Activation_strategy_id, max:MaxVal ])
        and there_is_a(env_var,            [id : Env_var_id, value:Env_var_vale])
        and Env_var_vale < MaxVal
   then [
       Term = evento(env_var, Env_var_id , 'below' , MaxVal),
       writeln(Term),
       assert_once(Term)
   ].



%schema-based
defrule r_var_above_max
if there_is_a(building,[id : Building_id])
    and
    get_related( building(id:Building_id) ,  env_var([id:Id, name:_Name, value:Value]), _)     and
    get_related( building(id:Building_id) ,  strategy_occupation([min:_MinVal, max:MaxVal]),_) and
    (   Value >MaxVal )
    then     [
       Term = evento(env_var, Id , 'above' , MaxVal),
       writeln(Term),
       assert_once(Term)
    ].

%schema-based
defrule r_var_below_min
if  there_is_a(building,[id : Building_id])
    and
    get_related( building(id:Building_id) ,  env_var([id:Id, name:_Name, value:Value]), _)     and
    get_related( building(id:Building_id) ,  strategy_occupation([min:MinVal, max:_MaxVal]),_) and
    (   Value < MinVal )
    then     [
       Term = evento(env_var, Id , 'below' , MinVal),
       writeln(Term),
       assert_once(Term)
    ].




defrule test_0
   if not(my_increment(_)) or (my_increment(Incr) and (Incr<10)) then
   [
       (  \+ ground(Incr),Incr=0;true),
       set_if_null( my_increment(0)),
       Incr2 is Incr +1,
       assert_once(my_increment(Incr2)),
       format('increment ~w~n',[Incr])
   ].



defrule rule_loop_start
  if not(my_increment(_)) then
  [
     assert(my_increment(0))
  ].

defrule rule_loop_finish
  if my_increment(Incr)  and (Incr<10) then
  [
     Incr2 is Incr +1,
     assert_once(my_increment(Incr2)),
     format('increment ~w~n',[Incr])
  ].




% canonical-based rule
defrule r_temperature_above_max
   if temperature(value, Value) and temperature(max_ref, MaxValue)
      and (Value > MaxValue)
   then [
       Term = event(temperature, 'above' , MaxValue),
       %writeln(Term),
       assert_single(Term)
   ].

/*
assert(temperature(value, 10)), assert(temperature(min_ref, 25)).
findall(   ev(X,Y,Z),  event(X,Y,Z), L), writeln(L).
*/
% canonical-based rule
defrule r_temperature_below_min
   if temperature(value, Value) and temperature(min_ref, MinValue)
      and (Value < MinValue)
   then [
       Term = event(temperature, 'below' , MinValue),
      % writeln(Term),
       assert_single(Term)
   ].


% canonical-based rule
defrule r_co2_above_maximum
   if co2(value, Value) and co2(max_ref, MaxValue)
      and (Value > MaxValue)
   then [
       Term = event(co2, 'above' , MaxValue),
      % writeln(Term),
       assert_single(Term)
   ].



%ref 005
defrule r_hvac_work_1 % winter: comfort range between 21 and 26ºC, ref 005
   if season(winter) and external_temperature(Temperature)
                     and hvac(power, Power) and (Power>1.7)  and (Temperature>21)
   then [
       assert_once(failure(hvac, excessive_power, comfort))
   ].


%ref 005
defrule r_hvac_work_2 % winter: comfort range between 21 and 26ºC, ref 005
   if season(winter) and external_temperature(Temperature)
                     and hvac(power, Power) and (Power>1.7)  and (Temperature<26)  /*> 1.7kw*/
   then [
       assert_once(failure(hvac, excessive_power, comfort))
   ].


defrule r_hvac_partido  % ref 005
   if hvac(state, on) and hvac(power, Power) and (Power>1.7)
   and delta(temperature30,temperature0,DeltaT) and  DeltaT<0.2 /* 0.2ºC*/
   then [
       assert_once(failure(hvac, badly_dimensioned, technical)),
       assert_once(failure(hvac, breakdown         , technical))
   ].


defrule r_hvac_anomaly %ref 005
   if daily_on_off(hvac,NOnOff) and (NOnOff>=5) and average_power(hvac, daily,Power) and (Power)>2
   then [
       assert_once(failure(hvac, badly_dimensioned, technical)),
       assert_once(failure(hvac, energy_leak       , technical))
   ].


defrule r_hvac_too_manyoperational_regime_changes
   if daily_on_off(hvac,NOnOff) and (NOnOff>50)  % more than 50 regime changes
   then [
       assert_once(failure(hvac, badly_dimensioned, technical, 'HVAC badly dimensioned')),
       assert_once(failure(hvac, energy_leak       , technical, 'HVAC '))
   ].


%rule e) from paper 005 not done
%rule f) from paper 005 not done
%

defrule r_space_empty
if state(lights, off) then
[
   assert_single(space_empty)
   ,writeln('lights are off, so space is empty')
].

% ref 005 g)
defrule r_hvac_working_nobody_inside
   if state(hvac,on, Time) and (Time>30) and space_empty /*30 minuts*/
   then [
       assert_single(failure([
                       device    : hvac,
                       type      : energy_energy_wast ,
                       effect    : operational,
                       decription: 'HVAC use without anyone in the building']
                          ))
       ,writeln(r_hvac_working_nobody_inside)

   ].


/*                                PUE calculation       */

%ref 006, exemplo completo na referencia
defrule pue1  /*Power Usage Effectiveness*/
if state(external,temperature, medium) and state(building, temperature, high) then
[
   assert_single( pue(very_high    , 0  )),
   assert_single( pue(high         , 0.7)),
   assert_single( pue(medium       , 0.1)),
   assert_single( pue(low          , 0.2)),
   assert_single( pue(very_low     , 0.0))
].



