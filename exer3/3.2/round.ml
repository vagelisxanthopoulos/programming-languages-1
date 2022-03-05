(** o algorithmos einai idios me to arxeio java pou ypovlithike gia to idio provlima*)
(**mas xreazetai argotera *)
let rec reverse xs =
    let
        rec rev (x, z) = 
        match x with
            [] -> z
           |y::ys -> rev (ys, y::z)
    in 
        rev (xs, [])


(**metatropi listas string se lista akeraiwn *)
let rec stringListToIntList input = 
	match input with
	[] -> []
	|h::t -> int_of_string h :: stringListToIntList t



(**i parse epistrefei poleis, autokinita, topothesies autokinitwn *)
let parse file = 
	let input = open_in file in
	let firstline = Str.split (Str.regexp " ") (input_line input) in
	let secondline = Str.split (Str.regexp " ") (input_line input) in
	let citiescars = stringListToIntList firstline in
	let carslocations = stringListToIntList secondline in
	let rec get_nth_list_element num list = 
		match list with
		[] -> -1
		|h::t -> if num == 1 then h else get_nth_list_element (num - 1) t
	in
	let cities = get_nth_list_element 1 citiescars in
	let cars = get_nth_list_element 2 citiescars in
	(cities, cars, carslocations)



(** i carspercity epistrefei array me arithmo amaksiwn ana poli, synoliki apostasi apo poli 0 kai prwti poli pou exei amaksi*)
let carspercity (cities, cars, carslocations) = 
	let ret = Array.make cities 0 in
	let rec filler carslocations firstcity_with_car totaldistancecity0 = 
		match carslocations with
		[] -> 
				begin
					let listret = Array.to_list ret in
					(listret, firstcity_with_car, totaldistancecity0, cities, cars)
				end
		|h::t ->
				begin
					let newvalue = (Array.get ret h) + 1 in 
					Array.set ret h newvalue;
					if ((h != 0) && (h < firstcity_with_car)) then filler t h (totaldistancecity0 + cities - h) else
					if ((h = 0) && (h < firstcity_with_car)) then filler t h totaldistancecity0 else
					if ((h != 0) && (h >= firstcity_with_car)) then filler t firstcity_with_car (totaldistancecity0 + cities - h) else
					filler t firstcity_with_car totaldistancecity0
				end in
	filler carslocations cities 0


(** i totaldistance vriskei tin synoliki apostasi gia kathe poli *)

let totaldistance (carspercity, firstcity_with_car, totaldistancecity0, cities, cars) = 
	let ret = Array.make cities 0 in
	Array.set ret 0 totaldistancecity0;
	let rec filler carspercity city = 
		match carspercity with
		[] -> ret
		|h::t -> 
				begin
					if (city == 0) then filler t (city + 1) else 
					begin
						let prevcity = city - 1 in
						let prevsum = Array.get ret prevcity in
						let subtract = h * (cities - 1) in
						let add = cars - h in
						let newsum = prevsum - subtract + add in
						Array.set ret city newsum ;
						filler t (city + 1) 
					end
				end in
	filler carspercity 0




(** i madxistance vriskei tis megistes apostaseis apo kathe poli *)
let maxdistance (carspercity, firstcity_with_car, totaldistancecity0, cities, cars) =
	let ret = Array.make cities 0 in
	Array.set ret (cities - 1) (cities - 1 - firstcity_with_car);
	let rev = reverse carspercity in
	let rec filler carsper city nearestcity = 
		match carsper with
		[] -> ret
		|[a] -> ret
		|h::t ->
				begin 
					if (h > 0) then
						begin 
							let newnearest = city + 1 in
							if (city - newnearest >= 0) then
								begin 
									Array.set ret city (city - newnearest);
									filler t (city - 1) newnearest
								end
							else 
								begin
									Array.set ret city (city - newnearest + cities);
									filler t (city - 1) newnearest
								end
						end
					else 
						begin
							let newnearest = nearestcity in
							if (city - newnearest >= 0) then
								begin 
									Array.set ret city (city - newnearest);
									filler t (city - 1) newnearest
								end
							else 
								begin
									Array.set ret city (city - newnearest + cities);
									filler t (city - 1) newnearest
								end	
						end
				end
	 in
	filler rev (cities - 2) firstcity_with_car



(** i finder kanei ton elegxo*)
let finder (maxdistance, totaldistance) = 
	let len = Array.length maxdistance in
	let ret = Array.make 2 0 in
	let rec checker counter meetcity totaldistancetomeet = 
		match counter with 
		0 -> meetcity
		|other -> 
				begin
					let city = len - counter in
					let sum = Array.get totaldistance city in
					let max = Array.get maxdistance city in
					if (max <= sum - max + 1) then
						begin
							if ((sum < totaldistancetomeet) || (totaldistancetomeet == 0)) then checker (counter - 1) city sum
							else checker (counter - 1) meetcity totaldistancetomeet
						end
					else checker (counter - 1) meetcity totaldistancetomeet
				end in
	let meetcity = checker len 0 0 in
	let totalsteps = Array.get totaldistance meetcity in
	Array.set ret 0 totalsteps;
	Array.set ret 1 meetcity;
	ret


let main = 
	let file = Sys.argv.(1) in
	let input = parse file in
	let carsperci = carspercity input in
	let maxdist = maxdistance carsperci in
	let totaldist = totaldistance carsperci in
	let result = finder(maxdist, totaldist) in
	let dist = Array.get result 0 in
	let city = Array.get result 1 in
	print_int dist;
	print_string " ";
	print_int city;
	print_newline ()
