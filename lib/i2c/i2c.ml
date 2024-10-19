module type Interface = sig
  val init : int -> int -> int
  val close : int -> unit
  val write : int -> bytes -> int -> int
  val read : int -> bytes -> int -> int
end

exception Error of string

module Device = struct
  type t = { bus_num : int; addr : int; fd : int }

  let pp fmt t = Format.fprintf fmt "Device(i2c-%d, addr: %d)" t.bus_num t.addr
end

module type S = sig
  val init : bus_num:int -> addr:int -> Device.t
  val close : Device.t -> unit
  val close_all : unit -> unit
end

module Make (B : Interface) : S = struct
  let open_fds : int list ref = ref []

  let init ~bus_num ~addr =
    try
      let fd = B.init bus_num addr in
      open_fds := fd :: !open_fds;
      Device.{ bus_num; addr; fd }
    with Failure msg -> raise (Error msg)

  let close device = B.close device.Device.fd
  let close_all () = List.iter B.close !open_fds
end

module Hardware : Interface = struct
  external init : int -> int -> int = "caml_i2c_init"
  external close : int -> unit = "caml_i2c_close"
  external write : int -> bytes -> int -> int = "caml_i2c_write"
  external read : int -> bytes -> int -> int = "caml_i2c_read"
end
