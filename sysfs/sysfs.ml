module type S = sig
  val export : int -> unit
  val unexport : int -> unit
  val set_direction : int -> string -> unit
  val set_value : int -> int -> unit
  val get_value : int -> int
end

module Mock () : S = struct
  let exported : int list ref = ref []

  let export num =
    if List.exists (( = ) num) !exported then
      failwith @@ Printf.sprintf "pin %d already exported!" num
    else exported := num :: !exported

  let unexport num = exported := List.filter (( <> ) num) !exported
  let set_direction _ _ = ()
  let set_value _ _ = ()
  let get_value _ = 1
end
