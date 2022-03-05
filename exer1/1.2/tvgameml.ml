let rec reverse xs =
    let
        rec rev (x, z) = 
        match x with
            [] -> z
           |y::ys -> rev (ys, y::z)
    in 
        rev (xs, [])

let rec pow x y = 
    match y with
    0 -> 1
   |exp -> let temp1 = (y) / 2 in
           if (y mod 2) == 0 then ((pow x temp1)*(pow x temp1)) else (x*(pow x temp1)*(pow x temp1))          


let parse file =
    let input = open_in file in
    let firstline = input_line input in
    let len = String.length firstline in

    let rec spaceloc counter = 
        match counter with
        0->1
       |cnt -> 
                begin
                    let temp = String.get firstline (cnt - 1) in
                    if (temp == ' ') then (cnt - 1) else spaceloc (counter - 1)     
                end in

    let space = spaceloc len in

    let rec grammesstilesHelp counter leng index acc = 
        match counter with
        0 -> acc
       |cnt -> 
                begin
                    let temp2 = Char.code (String.get firstline index) - 48 in
                    let temp3 = leng - cnt  in
                    let temp4 = acc + temp2 * (pow 10 temp3) in
                    grammesstilesHelp (cnt - 1) leng (index - 1) temp4
                end in

    let grammes = grammesstilesHelp space space (space -1) 0 in

    let stiles = grammesstilesHelp (len - space - 1) (len - space -1) (len - 1) 0 in


    let elements = (grammes * stiles) in
    let acc = Array.make elements 'o' in
    let rec nextlistChar rem =
        match rem with
            0 -> 
                begin
                    close_in input;
                    acc
                end
           |r -> 
                begin
                    let curr = input_char input in
                    if curr == '\n' then nextlistChar r 
                    else 
                        begin 
                            let place = elements - r in
                            Array.set acc place curr;
                            nextlistChar (r - 1)
                        end
                end
    in
    let nextChar = nextlistChar elements in
        (grammes, stiles , nextChar)


let convertToInt (grammes, stiles, nextChar) = 
    let elements = grammes*stiles in
    let ret = Array.make elements 5 in
    let rec updater rem =
        match rem with
        0 -> ()
       |j->
            begin
                let place = elements - j in
                let curr = Array.get nextChar place in              

                if curr == 'U' then Array.set ret place (place - stiles) else (
                if curr == 'D' then Array.set ret place (place + stiles) else (
                if curr == 'R' then Array.set ret place (place + 1) else (
                if curr == 'L' then Array.set ret place (place - 1) else ())));

                let value = Array.get ret place in
                let temp1 = (value) / stiles in
                let temp2 = (place) / stiles in

                if value < 0 then Array.set ret place (-1) else (
                if value >= elements then Array.set ret place (-1) else (
                if ((curr =='R' || curr == 'L') && (temp1 != temp2)) then Array.set ret place (-1) else ()));
               
                updater (j - 1)
            end in
    updater elements;
    ret


let rec pathchecker place canfinish cannotfinish visited next currpath =
    Array.set visited place true;
    let nextplace = Array.get next place in
    let bool1 = Array.get visited nextplace in
    let bool2 = Array.get canfinish nextplace in
    let bool3 = Array.get cannotfinish nextplace in

    if bool2 then (true, place::currpath) else (
    if bool3 then (false, place::currpath) else (
    if bool1 then (false, place::currpath) else 
        begin
            let temp = place::currpath in
            pathchecker nextplace canfinish cannotfinish visited next temp
        end))


let badstarts next =

    let size = Array.length next in
    let visited = Array.make size false in
    let canfinish = Array.make size false in
    let cannotfinish = Array.make size false in

    let rec init counter = 
        match counter with
        0 -> ()
       |cnt -> 
                begin
                    let index = size - cnt in
                    let temp = Array.get next index in
                    if temp == (-1) then (
                    Array.set visited index true;
                    Array.set canfinish index true) else ();
                    init (cnt - 1)                     
                end 
    in

    init size;

    let rec updaterHelp arrayToUpdate currpath = 
        match currpath with
        [] -> ()
       |h::t -> 
                begin
                     Array.set arrayToUpdate h true;
                     updaterHelp arrayToUpdate t    
                end in

    let rec updater (ends, currpath) = 
        if ends then updaterHelp canfinish currpath else updaterHelp cannotfinish currpath in

    let rec killer counter =
        match counter with
        0 -> ()
       |cnt -> 
                begin
                    let place = size - cnt in
                    let bool1 = Array.get visited place in
                    if bool1 then killer (cnt - 1) else 
                        begin
                            let currpath = [] in
                            let toupla = pathchecker place canfinish cannotfinish visited next currpath in
                            updater toupla;
                            killer (cnt - 1);
                        end   
                end in
    killer size;
    
    let rec final counter result =
        match counter with
        0 -> result
       |cnt ->
            begin
                let bool1 = Array.get cannotfinish (counter - 1) in
                if bool1 then final (cnt - 1) (result + 1) else final (cnt - 1) result
            end in

    final size 0 





let test = 
    let file = Sys.argv.(1) in
    let input = parse file in
    let next = convertToInt input in
    let res = badstarts next in
    print_int res;
    print_newline ()

