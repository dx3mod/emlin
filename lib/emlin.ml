module Sysfs = Sysfs
module I2c = I2c

let dev_flag =
  Sys.getenv_opt "DEV" |> Option.fold ~none:false ~some:(( = ) "sim")

(** @deprecated *)
let with_sysfs_gpio ?(catch_break = true) f =
  let module Gpio = Sysfs.Gpio.Make (Sysfs.Gpio.Hardware) in
  Sys.catch_break catch_break;
  Fun.protect ~finally:Gpio.unexport (fun () -> f (module Gpio : Sysfs.Gpio.S))

let with_i2c f =
  let module I = I2c.Make (I2c.Hardware) in
  f (module I : I2c.S);
  I.close_all ()
