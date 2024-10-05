let () =
  (* Захват периферии. *)
  Emlin.with_gpio_mock @@ fun (module Gpio) ->
  Emlin.with_i2c @@ fun (module I2c) ->
  (* Подключения драйвера контроллера дисплея ssd1306. *)
  let module Ssd1306 = Ssd1306.Make (I2c) in
  (* Девайсы. *)
  let led_pin = Gpio.(pin 10 Out ~init:0) in
  let display = I2c.init ~bus_num:2 ~addr:0x30 |> Ssd1306.init in

  (* Вывод на дисплей строки *)
  Ssd1306.output_string display "Hello World";

  (* Мигание светодиодом *)
  while true do
    Gpio.toggle led_pin;
    Unix.sleep 1
  done
