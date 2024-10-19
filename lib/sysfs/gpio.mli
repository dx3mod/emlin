(** Control GPIO via gpiofs.
    @deprecated

    {[
      let module Gpio = Sysfs.Gpio.Make (Sysfs.Gpio.Hardware) in
      (* ... *)
      let led_pin = Gpio.export 74 Out in
      (* ... *)
      Gpio.unexport ()
    ]}
  
    *)

(** {1 Primitives}  *)

module Pin : sig
  type 'mode t

  val pp : Format.formatter -> 'a t -> unit
end

module Direction : sig
  type _ t = In : [ `Input ] t | Out : [ `Output ] t
end

module Signal : sig
  type t = High | Low

  val of_bool : bool -> t
  val pp : Format.formatter -> t -> unit
end

(** {1 Interface layer}  *)

module type Interface = sig
  val export : int -> unit
  val set_direction : int -> string -> unit
  val read : int -> char
  val write : int -> char -> unit
  val unexport : int -> unit
end

module Hardware : Interface

(** {1 High-level interface}  *)

module type S = sig
  val export : int -> 'a Direction.t -> 'a Pin.t
  val unexport : unit -> unit
  val write : [ `Output ] Pin.t -> Signal.t -> unit
  val read : [ `Input ] Pin.t -> Signal.t
end

module Make : functor (_ : Interface) -> S
