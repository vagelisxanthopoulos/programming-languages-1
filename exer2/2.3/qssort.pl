/* read input file */
read_input(File, _, C) :-
    open(File, read, Stream),
    read_line(Stream, _),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

/*
* starting state and final state
* config(queue,stack)
*/
initial(config(C, [], -1), File):-
    read_input(File,_,C).
final(config(M, [], _)):-
    sort(0,@=<,M,M).

/*TESSEREIS KANONES GIA TA MOVES: 

1. Den kanoume Q an to teleuetaio poy vgalame apo tin stiva einai idio me to Head tis stivas. Diladi ama kanoume S, kanoume kai ta ypoloipa idia.
   Gia na to petyxoume, kratame sto config (sto tetarto orisma) to teleutaio stoixeio poy kaname S.

2. Den kanoume S an to prwto tis ouras einai idio me to Head tis stivas. Diladi kanoume Q ola ta idia mazi.
   Edw den xreiazetai na apothikeusoume kati, afou ta Head tis ouras kai tis stivas ta exoume etoima.

3. Se adeia stiva kanoume Q

4. Se adeia oura kanoume S

Oi prwtoi dyo kanones aposkopoun sto na kratame ta idia stoixeia mazi.
Diladi ta kanoume Q kai S pada ola mazi.
Etsi den apomakrynontai kai kerdizoume se xrono

*/

move(config([Qf|Q], [Sf|S], LastS), "Q", config(Q, [Qf | [Sf|S]], LastS)):- 
    Sf \= LastS.

move(config([Qf|Q], [], LastS), "Q" ,config(Q, [Qf], LastS)).

move(config([Qf|Q], [Sf|S], _), "S" ,config(Q1, S, Sf)):-
    Qf \= Sf,
    append([Qf|Q], [Sf], Q1).

move(config([], [Sf|S], _), "S", config([Sf], S, Sf)).

/* solve(+Conf, ?Moves) */
solve(Conf, []) :- 
    final(Conf).

solve(Conf, [Move|Moves]):-
    move(Conf, Move, Conf1),
    solve(Conf1, Moves).

qssort(File, String):-
    initial(InitConf, File),
    length(Ans, L),            /* tsekaroume an exoume artio mikos kinisewn */
    (L mod 2) =:= 0,
    solve(InitConf, Ans),
    conv(Ans, String),!.

conv(Ans, String):-
    atomics_to_string(Ans, String),
    not(length(Ans, 0)).

conv(Ans, "empty"):-
    length(Ans, 0).   
