fun parse file =
    let
	(* A function to read an integer from specified input. *)
      fun readInt input =
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

  (*N -> number of cities , K -> number of vehicles*)
      val N = readInt inStream
      val K = readInt inStream
	    val _ = TextIO.inputLine inStream

  (* A function to read N integers from the open file. *)
	   fun readInts 0 acc = rev acc
        | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	  (N,K,readInts K [])
    end

(*me vasi tin initial katastasi twn aftokinitwn ypologizoume to athroisma twn kinisewn gia na ftasoun ola se mia teliki katastasi (Sum) kathws kai to amaksi pou exei to megisto kostos metakinisis gia afti tin teliki katastasi (Max)*)
fun difference [] FinalState Cities Sum Max = (Sum,Max)
  | difference (h::t) FinalState Cities Sum Max =
    if FinalState >= h then difference t FinalState Cities (Sum+FinalState-h) (Int.max(Max,FinalState-h))
    else difference t FinalState Cities (Sum+Cities-h+FinalState) (Int.max(Max,Cities-h+FinalState))


fun aux (InitList,MinSum,MinIndex,FinalState,Cities) =
    if FinalState = Cities then (MinSum,MinIndex)
    else
    (
      let
        val diff = difference InitList FinalState Cities 0 0 (*ypologizoume me xrisi tis difference ta sum kai max gia kathe teliki katastasi (epanalipseis ises me ton arithmo twn polewn giati toses einai oi telikes katastaseis*)
        val sum = #1 diff
        val maximum = #2 diff
      in
        if (maximum > sum-maximum+1) then aux (InitList,MinSum,MinIndex,FinalState+1,Cities) (*an den einai valid afti i teliki katastasi min allakseis ta MinSum kai MinIndex kai proxwra sto epomeno FinalState*)
        else (*an einai valid diladi den kouname to idio amaksi 2 synexomenes fores koita an exei mikrotero sum h iso sum alla mikrotero arithmo polis*)
        (
          if (sum < MinSum orelse (sum = MinSum andalso FinalState < MinIndex)) then aux (InitList,sum,FinalState,FinalState+1,Cities) (*se afti tin periptwsi ananewse ta MinSum kai MinIndex*)
          else aux (InitList,MinSum,MinIndex,FinalState+1,Cities) (*alliws min ananewseis kati*)
        )
      end
    )




fun round inputFile =
    let
      val input = parse inputFile (*diavase tin eisodo*)
      val N = #1 input (*poleis*)
      val K = #2 input (*amaksia*)
      val InitList = #3 input (*thesis amaksiwn arxika*)
      val result = aux (InitList,1073741823,0,0,N)(*kalese tin aux kai arxikopoiise to Sum se megali timi(to 1073741823 einai to Int.maxint) etsi wste arxika i sygrisi sum < MinSum na ananewsei to MinSum an exoume valid final state*)
      val moves = #1 result (*plithos kinisewn pou apaiteitai*)
      val index = #2 result (*teliki poli*)
    in
      print(Int.toString(moves)^" "^Int.toString(index)^"\n")
    end
