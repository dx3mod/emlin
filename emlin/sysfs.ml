module type S = sig
  val export : int -> unit
  val unexport : int -> unit
  val set_direction : int -> string -> unit
  val set_value : int -> int -> unit
  val get_value : int -> int
end

module Hardware : S = struct
  (* TODO: implement caching *)

  let export num =
    Out_channel.with_open_text "/sys/class/gpio/export" (fun oc ->
        Printf.fprintf oc "%d\n" num)

  let unexport num =
    Out_channel.with_open_text "/sys/class/gpio/unexport" (fun oc ->
        Printf.fprintf oc "%d\n" num)

  let set_direction num dir =
    let path = Printf.sprintf "/sys/class/gpio/gpio%d/direction" num in
    Out_channel.with_open_text path (fun oc ->
        output_string oc dir;
        output_string oc "\n")

  let set_value num v =
    let path = Printf.sprintf "/sys/class/gpio/gpio%d/value" num in
    Out_channel.with_open_text path (fun oc -> Printf.fprintf oc "%d\n" v)

  let get_value num =
    let path = Printf.sprintf "/sys/class/gpio/gpio%d/value" num in
    In_channel.with_open_text path (fun ic ->
        match input_char ic with
        | '0' -> 0
        | '1' -> 1
        (* TODO: remove overhead *)
        | _ -> failwith "get_value some other value")
end

module Mock () : S = struct
  let exported : int list ref = ref []

  let export num =
    if List.exists (( = ) num) !exported then
      failwith @@ Printf.sprintf "pin %d already exported!" num
    else exported := num :: !exported;
    Printf.printf "export %d\n" num

  let unexport num =
    exported := List.filter (( <> ) num) !exported;
    Printf.printf "unexport %d\n" num

  let set_direction = Printf.printf "set_direction %d %s\n"
  let set_value = Printf.printf "set_value %d %d\n"

  let get_value num =
    Printf.printf "get_value %d\n" num;
    Random.int_in_range ~min:0 ~max:1
end
