# Emlin

An OCaml library that provides access to Linux hardware interfaces, including GPIO, I2C, and other peripherals, making it easier to develop embedded systems from userspace.

> [!WARNING]
> Now in active development!

**Base**
- [ ] Sysfs
    - [X] ~~GPIO~~ (deprecated)
    - [ ] Interrupts
- [ ] I2C 
- [ ] 1Wire

**Drivers**
- [ ] ssd1306

## Installation

Installation of latest development version.
```console
$ opam pin https://github.com/dx3mod/emlin.git
```

## Usage

See [`examples/`](./examples/).

### Blink 

Turn an LED on and off every second.

```ocaml
let () =
  Emlin.with_sysfs_gpio @@ fun (module Gpio) ->

  let led_pin = Gpio.export 74 Output in

  while true do
    Gpio.write led_pin High;
    Unix.sleep 1;
    Gpio.write led_pin Low;
    Unix.sleep 1
  done
```

## Contribution

See [HACKING.md](./HACKING.md%20) if you are interested in developing the project.