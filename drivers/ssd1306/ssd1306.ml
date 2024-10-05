type t = { device : Emlin.I2c.Device.t }

module Make (I2c : Emlin.I2c.S) = struct
  let init device = { device }
  let output_string (_ : t) (_ : string) = ()
end
