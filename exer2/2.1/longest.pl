/*
 * A predicate that reads the input from File and returns it in
 * the last three arguments: N, K and C.
 * Example:
 *
 * ?- read_input('c1.txt', N, K, C).
 * N = 10,
 * K = 3,
 * C = [1, 3, 1, 3, 1, 3, 3, 2, 2|...].
 */

/* akolouthitike autos o algorithmos (method 4):

https://www.geeksforgeeks.org/given-an-array-arr-find-the-maximum-j-i-such-that-arrj-arri/

*/

read_input(File, M, MO, C) :-
    open(File, read, Stream),
    read_line(Stream, [M, MO]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).




edithelp([], ACC, ACC, _).

edithelp([H | T], ACC, RES, MO) :-
	TEMP is (H * (-1) - MO),
	edithelp(T, [TEMP | ACC], RES, MO).

editor([H | T], MO, RES) :-
	edithelp([H | T], [], TEMP, MO),
	reverse(TEMP, RES).


prefixer([], Acc, Acc, _).

prefixer([H | T], Acc, Reversed, Last) :-
	Temp is Last + H,
	prefixer(T, [Temp | Acc], Reversed, Temp).

prefixer(List, Res) :-
	prefixer(List, [], Reversed, 0),
	reverse(Reversed, Res).




leftminpref([], Acc, Acc, _).

leftminpref([H | T], Acc, Rev, Last) :-
	Temp is min(Last, H),
	leftminpref(T, [Temp | Acc], Rev, Temp).

leftminpref([H | T], Res) :-
	leftminpref([H | T], [], Rev, H),
	reverse(Rev, Res).


rightmaxpref([], Acc, Acc, _).

rightmaxpref([H | T], Acc, Rev, Last) :-
	Temp is max(Last, H),
	rightmaxpref(T, [Temp | Acc], Rev, Temp).

rightmaxpref(List, Res) :-
	reverse(List, [H | T]),
	rightmaxpref([H | T], [], Res, H).



final([], _, _, Cntl, MaxAcc, Ret) :-
	(Cntl = 1 ->
		Ret is MaxAcc + 1
	; 	Ret is MaxAcc
	). 

final(_, [], _, Cntl, MaxAcc, Ret) :-
	(Cntl = 1 ->
		Ret is MaxAcc + 1
	; 	Ret is MaxAcc
	). 


final([Hr | Tr], [Hl | Tl], CntR, CntL, MaxAcc, Res) :-
	Sum is (Hr - Hl),
	Len is (CntR - CntL),
	Sum >= 0,
	NewMaxAcc is max(MaxAcc, Len),
	NewCntR is (CntR + 1),
	final(Tr, [Hl | Tl], NewCntR, CntL, NewMaxAcc, Res).


final([Hr | Tr], [Hl | Tl], CntR, CntL, MaxAcc, Res) :-
	Sum is (Hr - Hl),
	Sum < 0,
	NewCntL is (CntL + 1),
	final([Hr | Tr], Tl, CntR, NewCntL, MaxAcc, Res).


final(Rm, Lm, Res) :-
	final(Rm, Lm, 1, 1, 0, Res).



longest(File, An) :-
	read_input(File, _, MO, C),
	editor(C, MO, Ready),
	prefixer(Ready, Pref),
	leftminpref(Pref, Lm),
	rightmaxpref(Pref, Rm),
	final(Rm, Lm, An), !.



