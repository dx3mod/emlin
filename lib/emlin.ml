module Sysfs = Sysfs
module Gpio = Gpio

let with_gpio f = Gpio.with_exported (module Sysfs.Mock ()) f
