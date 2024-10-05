module Sysfs = Sysfs
module Gpio = Gpio
module I2c = I2c

let with_gpio_mock f = Gpio.with_exported (module Sysfs.Mock ()) f
let with_gpio f = Gpio.with_exported (module Sysfs.Real) f

let with_i2c f =
  let module I = I2c.Make (I2c.Unsafe) in
  f (module I : I2c.S);
  I.close_all ()
