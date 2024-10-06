module Sysfs = Sysfs
module Gpio = Gpio
module I2c = I2c

let with_gpio f = Gpio.with_exported (module Sysfs.Hardware) f

let with_i2c f =
  let module I = I2c.Make (I2c.Hardware) in
  f (module I : I2c.S);
  I.close_all ()
