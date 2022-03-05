fun longest fileName =

let fun reverse xs =
    let
        fun rev (nil, z) = z
        | rev (y::ys, z) = rev (ys, y::z)
    in
         rev (xs, nil)
     end


fun parse file =
    let
	(* A function to read an integer from specified input. *)
        fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

	(* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
	val meres = readInt inStream
    val nosokomeia = readInt inStream
	val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	(meres, nosokomeia, reverse( readInts meres []))
    (*(meres, nosokomeia, reverse( readInts meres []))*)
    end


fun mergeSort nil = nil
    | mergeSort [e] = [e]
    | mergeSort theList =
    let
        fun halve nil = (nil, nil)
            | halve [a] = ([a], nil)
            | halve (a::b::cs) =
                let
                    val (x, y) = halve cs
                in
                    (a::x, b::y)
                end

        fun merge (nil, ys) = ys
            | merge (xs, nil) = xs
            | merge ((x1::x2::tlx)::xs, (y1::y2::tly)::ys) =
                if x1 < y1 then (x1::x2::tlx) :: merge(xs, (y1::y2::tly)::ys)
                else if x1 > y1 then (y1::y2::tly) :: merge((x1::x2::tlx)::xs, ys)
                    else if x2 < y2 then (x1::x2::tlx) :: merge(xs, (y1::y2::tly)::ys)
                         else (y1::y2::tly) :: merge((x1::x2::tlx)::xs, ys)
            | merge (h1::t1, h2::t2) = t1
        val (x, y) = halve theList
    in
            merge (mergeSort x, mergeSort y)
    end


fun starterList ([], nosokomeia) = []
   |starterList (h::t, nosokomeia) = 0 - h - nosokomeia  :: starterList(t, nosokomeia)

fun partialSumsHelp [] sum = []
    |partialSumsHelp (h::t) sum = (sum + h) :: partialSumsHelp t (sum + h)

fun partialSums l = partialSumsHelp l 0


fun indexCreatorHelp 0 counter l = []
    |indexCreatorHelp last counter l = 
        if (counter = last) then counter::l else counter::indexCreatorHelp last (counter+1) l


fun indexCreator last = indexCreatorHelp last 0 []

fun zip  nil l = nil
|   zip  l   nil  = nil
|   zip (a::la) (b::lb)  = ([a]@[b])::(zip la lb) ;



fun maxIndexArray l = 
    let
        val num = length l
        val arr = Array.array(num, 0)
        val revlist = reverse l
        fun fill max len counter [] = ()
           |fill max len counter ((h1::h2::t)::tl) = (
                if h2 > max then Array.update(arr, (len-counter-1) , h2) else Array.update(arr, (len-counter-1), max);
                if h2 > max then fill h2 len (counter+1) tl else fill max len (counter+1) tl
             )
           |fill max len counter (h::t) = ()
        val unit = fill 0 num 0 revlist
    in
        arr
    end

fun sortedtoarray l = 
    let
        val num = length l
        val temp = Array.array (2, 0)
        val arr = Array.array(num, temp)
        fun fill counter [] = ()
            |fill counter (h::t) = (
                let
                    val temp = Array.fromList h
                in
                    Array.update(arr, counter, temp);
                    fill (counter+1) t
                end 
                )
        val unit = fill 0 l
    in
        arr
    end

fun binaryHelp arr wanted st en max =
    if wanted > max then ~1 else
        if en > st then (
            let
                val mid = ((en - st) div 2) + st
                val temp = Array.sub(arr, mid)
                val midvalue = Array.sub(temp, 0)
             in
                if midvalue = wanted then mid  
                else if midvalue < wanted then binaryHelp arr wanted (mid+1) en max
                     else binaryHelp arr wanted st (mid-1) max
            end) else if st = en then (
                            let
                                val temp = Array.sub(arr, st)
                                val midvalue = Array.sub(temp, 0)
                            in
                                if midvalue >= wanted then st else st+1
                            end) else if st <> 0 andalso en <> 0 then st else 0


fun binarySearch arr wanted = 
    let
        val len = Array.length arr
        val temp = Array.sub(arr, (len-1))
        val max = Array.sub(temp, 0)
    in
        binaryHelp arr wanted 0 (len-1) max
    end

fun endgame (meres, nosokomeia, lista) = 
    let
        val psums = partialSums(starterList (lista, nosokomeia))
        val indexes = indexCreator (meres-1)
        val sums_indexes = zip psums indexes
        val sortedlist = mergeSort sums_indexes
        val llen = length psums
        
        val psumsArray = Array.fromList psums
        val maxindex = maxIndexArray sortedlist
        val sortedArray = sortedtoarray sortedlist
        
        fun maxLength 0 cnt max = 0
            |maxLength len 0 max = 
                let
                    val minSum = 0
                    val place = binarySearch sortedArray minSum
                in
                    if place > ~1 then (
                        let
                            val maxind = Array.sub(maxindex, place) + 1
                        in
                            if maxind > max then maxLength len 1 maxind else maxLength len 1 max
                        end) else maxLength len 1 max
                end
            |maxLength len cnt max =
                if (cnt < len) then (
                    let
                         val minSum = Array.sub(psumsArray, cnt-1)
                         val place = binarySearch sortedArray minSum
                    in
                        if place > ~1 then (
                           let
                                val maxind = Array.sub(maxindex, place) + 1 - cnt
                            in
                                if maxind > max then maxLength len (cnt + 1) maxind else maxLength len (cnt + 1) max
                            end) else maxLength len (cnt + 1) max
                    end) else max 
    in
        maxLength llen 0 0

    end

    val res = endgame (parse fileName)

in 
     print(Int.toString(res)^"\n")
end;

