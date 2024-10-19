let () =
  (* Capture the system SYSFS GPIO interface. *)
  Emlin.with_sysfs_gpio @@ fun (module Gpio) ->
  (* Export pin 74 as output pin.  *)
  let led_pin = Gpio.export 74 Out in

  (* Dead simple logic of blink LED. *)
  while true do
    Gpio.write led_pin High;
    Unix.sleep 1;
    Gpio.write led_pin Low;
    Unix.sleep 1
  done
