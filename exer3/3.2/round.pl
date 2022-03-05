/* o algorithmos einai idios me to arxeio java pou ypovlithike gia to idio provlima */
/* me tin moni diafora oti sortaroume tin eisodo opote anti gia N+K einai N+KlogK */

/* read input */
read_input(File, Cities, Cars, Carslocation) :-
    open(File, read, Stream),
    read_line(Stream, [Cities, Cars]),
    read_line(Stream, Carslocation).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).





/* kataskeuazoume lista Carspercity */
/* sortaroume carslocation, to diatrexoume kai opou exoume keno amaksiwn vazoume midenika alliws auksanoume kata 1*/
/* otan merikes poleis den exoun amaksi xrisimopoioume tin akolouthi voithiki synartisi */
/* gia na gemisoume midenika to endiameso */

zero_filler(Res, 0, Res).

zero_filler(List, Zeros, Res) :- 
    RestZeros is Zeros - 1,
    zero_filler([0 | List], RestZeros, Res).

cars_per_city_maker(Cities, [], Acc, Res, Prev):- /* sto telos prothetoume midenika an xreiazetai*/
    RestZeros is (Cities - Prev - 1),
    zero_filler(Acc, RestZeros, Res).

cars_per_city_maker(Cities, [Hin | Tin], [Hacc | Tacc], Res, Prev):- /* periptosi opou to amaksi einai stin idia poli me prin */
    Hin = Prev,
    NewH is Hacc + 1,
    cars_per_city_maker(Cities, Tin, [NewH | Tacc], Res, Hin).

cars_per_city_maker(Cities, [Hin | Tin], Acc, Res, Prev):-  /*periptosi opou to amaksi einai se epomeni poli apo prin */
    Hin \= Prev,
    (Prev = -1 ->
        Zeros is Hin
    ;   Zeros is (Hin - Prev - 1)
    ),
    zero_filler(Acc, Zeros, NewAcc),
    cars_per_city_maker(Cities, Tin, [1 | NewAcc], Res, Hin).


cars_per_city_maker(Cities, Carslocation, Carspercity) :-
    msort(Carslocation, Carslocsorted),
    cars_per_city_maker(Cities, Carslocsorted, [], RevCarspercity, -1),
    reverse(RevCarspercity, Carspercity),!.





/* kataskeuazoume lista me sums opws kseroume apo algorithmo */
/* arxika vriskoume to sum tis prwtis polis*/

firstsum([], Sum, _, Sum).

firstsum([H | T], Acc, Distance, Sum) :-
    NewAcc is (Acc + H * Distance),
    NewDistance is Distance - 1,
    firstsum(T, NewAcc, NewDistance, Sum).

firstsum(Cities, [_ | T], Sum) :-
    InitDistance is Cities - 1,          /* [H | T] einai to Carspercity */
    firstsum(T, 0, InitDistance, Sum),!. /* ksekiname apo to deutero */

firstsum(_, [], 0).

sums(_, _, [], Res, Res, _).

sums(Cars, Cities, [H | T], Acc, Res, PrevSum) :-
    Sub is (Cities - 1) * H,
    Add is Cars - H,
    CurrSum is PrevSum - Sub + Add,
    sums(Cars, Cities, T, [CurrSum | Acc] , Res, CurrSum).

sums(Cars, Cities, [_ | T], FirstSum, Sums) :-
    sums(Cars, Cities, T, [FirstSum], RevSums, FirstSum), /* ksekiname apo to deutero */
    reverse(RevSums, Sums),!.



/* kataskeuazoume lista me megistes apostaseis opws kseroume apo algorithmo */
/* arxika vriskoume tin prwti poli me amaksi */

firstcar(_, 1, CurrPos, Ans) :-
    Ans is (CurrPos - 1). /* kaname mia extra auksisi thesis */

firstcar([H | T], _, CurrPos, Ans) :-
    (H > 0 ->
        NewFound is 1
    ;   NewFound is 0
    ),
    NextPos is CurrPos + 1,
    firstcar(T, NewFound, NextPos, Ans).

firstcar(Carspercity, Pos) :-
    firstcar(Carspercity, 0, 0, Pos),!.

maxdists(_, [_], Res, Res, _, _). /*termatizoume otan exei meinei ena stoixeio stin lista Carspercity */

maxdists(Cities, [H | T], Acc, Res, Nearest, Pos) :-
    (H > 0 ->
        NewNearest is Pos
    ;   NewNearest is Nearest
    ),
    Temp is Pos - 1 - NewNearest,
    (Temp < 0 ->
        Max is Cities + Pos - 1 - NewNearest
    ;   Max is Pos - 1 - NewNearest
    ),
    NewPos is Pos - 1,
    maxdists(Cities, T, [Max | Acc], Res, NewNearest, NewPos).

maxdists(Cities, Carspercity, Firstcar, Ans) :-
    reverse(Carspercity, Rev),       /* diatrexoume anapoda tin carspercity */
    FirstMax is Cities - 1 - Firstcar,
    InitPos is Cities - 1,
    maxdists(Cities, Rev, [FirstMax], Ans, Firstcar, InitPos),!.




/* telikos elegxos */
final([], [], _, Total, City, Total, City).

final([Hmax | Tmax], [Hsum | Tsum], Pos, CurrTotal, _, Total, City) :- /* periptosi opou exoume ypopsifio proorismo */
    Temp is Hsum - Hmax + 1,
    Hmax =< Temp,
    Hsum < CurrTotal,
    NewCity is Pos,
    NewTotal is Hsum,
    NextCity is Pos + 1,
    final(Tmax, Tsum, NextCity, NewTotal, NewCity, Total, City).

final([_ | Tmax], [_ | Tsum], Pos, CurrTotal, CurrCity, Total, City) :-    /* periptosi opou den exoume ypopsifio proorismo */
    NextCity is Pos + 1,
    final(Tmax, Tsum, NextCity, CurrTotal, CurrCity, Total, City).

final(MaxDists, Sums, Total, City) :-
    max_list(Sums, MaxSum),
    Init is MaxSum + 1,
    final(MaxDists, Sums, 0, Init, 0, Total, City),!.     /* arxikopoioume to CurrTotal ws to megisto athroisma + 1 wste o prwtos ypopsifios proorismos na perasei ton elegxo Hsum < CurrTotal */



round(File, Total, City) :-
    read_input(File, Cities, Cars, Carslocation),
    cars_per_city_maker(Cities, Carslocation, Carspercity),
    firstsum(Cities, Carspercity, FirstSum),
    firstcar(Carspercity, FirstCar),
    sums(Cars, Cities, Carspercity, FirstSum, Sums),
    maxdists(Cities, Carspercity, FirstCar, MaxDists),
    final(MaxDists, Sums, Total, City),!.
