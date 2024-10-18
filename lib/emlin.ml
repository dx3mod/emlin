module Sysfs = Sysfs
module I2c = I2c

let dev_flag =
  Sys.getenv_opt "DEV" |> Option.fold ~none:false ~some:(( = ) "sim")

let with_sysfs_gpio f =
  let module Gpio = Sysfs.Gpio.Make (Sysfs.Gpio.Hardware) in
  f (module Gpio : Sysfs.Gpio.S);
  Gpio.unexport ()

let with_i2c f =
  let module I = I2c.Make (I2c.Hardware) in
  f (module I : I2c.S);
  I.close_all ()
