module Pin = struct
  type 'mode t = { num : int }

  let pp fmt t = Format.fprintf fmt "Pin(%d)" t.num
end

module Direction = struct
  type _ t = In : [ `Input ] t | Out : [ `Output ] t
end

module Signal = struct
  type t = High | Low

  let[@inline] of_bool = function true -> High | false -> Low

  let pp fmt = function
    | High -> Format.fprintf fmt "High"
    | Low -> Format.fprintf fmt "Low"
end

module type Interface = sig
  val export : int -> unit
  val set_direction : int -> string -> unit
  val read : int -> char
  val write : int -> char -> unit
  val unexport : int -> unit
end

module type S = sig
  val export : int -> 'a Direction.t -> 'a Pin.t
  val unexport : unit -> unit
  val write : [ `Output ] Pin.t -> Signal.t -> unit
  val read : [ `Input ] Pin.t -> Signal.t
end

module Make (I : Interface) : S = struct
  let exported_pins = Dynarray.create ()

  let export (type a) pin_num (mode : a Direction.t) : a Pin.t =
    I.export pin_num;
    Dynarray.add_last exported_pins pin_num;

    match mode with
    | In ->
        I.set_direction pin_num "in";
        Pin.{ num = pin_num }
    | Out ->
        I.set_direction pin_num "out";
        Pin.{ num = pin_num }

  let write pin (value : Signal.t) =
    I.write pin.Pin.num (match value with High -> '1' | Low -> '0')

  let read pin : Signal.t =
    match I.read pin.Pin.num with '1' -> High | _ -> Low

  let unexport () = Dynarray.iter I.unexport exported_pins
end

module Hardware : Interface = struct
  let base_class_dir = "/sys/class/gpio/"
  let export_file = base_class_dir ^ "/export"
  let unexport_file = base_class_dir ^ "/unexport"

  let export pin_num =
    Out_channel.with_open_text export_file (fun oc ->
        Printf.fprintf oc "%d" pin_num)

  let unexport pin_num =
    Out_channel.with_open_text unexport_file (fun oc ->
        Printf.fprintf oc "%d" pin_num)

  let with_write_to_device_file name pin_num f =
    Out_channel.with_open_text
      (Printf.sprintf ("/sys/class/gpio/gpio%d/" ^^ name) pin_num)
      f

  let with_read_from_device_file name pin_num f =
    In_channel.with_open_text
      (Printf.sprintf ("/sys/class/gpio/gpio%d/" ^^ name) pin_num)
      f

  let read pin_num =
    with_read_from_device_file "value" pin_num (fun ic -> input_char ic)

  let write pin_num value =
    with_write_to_device_file "value" pin_num (fun oc -> output_char oc value)

  let set_direction pin_num mode =
    with_write_to_device_file "direction" pin_num (fun oc ->
        output_string oc mode)
end
