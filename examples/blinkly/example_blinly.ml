(* Мигание светодиодом *)

let () =
  Emlin_sysfs.(Gpio.with_exported (module Sysfs.Mock ()))
  @@ fun (module Gpio) ->
  let led_pin = Gpio.(pin 10 Out ~init:0) in

  while true do
    Gpio.toggle led_pin;
    Unix.sleep 1
  done
