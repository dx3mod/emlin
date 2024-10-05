module Sysfs = Sysfs
module Gpio = Gpio

let with_gpio_mock f = Gpio.with_exported (module Sysfs.Mock ()) f
let with_gpio f = Gpio.with_exported (module Sysfs.Real) f
