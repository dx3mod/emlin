module Pin = struct
  type 'mode t = { pin_num : int }
end

module Direction = struct
  type _ t = In : [ `In ] Pin.t t | Out : [ `Out ] Pin.t t
end

module type S = sig
  val pin : ?init:int -> int -> 'a Direction.t -> 'a
  val get_value : [> ] Pin.t -> int
  val set_value : [ `Out ] Pin.t -> int -> unit
  val toggle : [ `Out ] Pin.t -> unit
end

module Make (Sf : Sysfs.S) : S = struct
  let exported : [ `In | `Out ] Pin.t list ref = ref []

  let pin (type a) ?init num (dir : a Direction.t) : a =
    let pin = Pin.{ pin_num = num } in
    (* fix it  *)
    exported := pin :: !exported;
    match dir with
    | In ->
        Sf.set_direction num "in";
        pin
    | Out ->
        (match init with
        | Some x when x >= 1 -> Sf.set_direction num "high"
        | Some 0 -> Sf.set_direction num "low"
        | _ -> Sf.set_direction num "out");
        pin

  let get_value (pin : [> ] Pin.t) = Sf.get_value pin.pin_num [@@inline]
  let set_value (pin : [ `Out ] Pin.t) = Sf.set_value pin.pin_num [@@inline]

  let toggle (pin : _ Pin.t) =
    if get_value pin = 1 then set_value pin 0 else set_value pin 1
end

let with_exported (module Sf : Sysfs.S) f =
  let module G = Make (Sf) in
  f (module G : S)
