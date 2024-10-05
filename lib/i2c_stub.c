// Port of https://github.com/armlabs/ssd1306_linux/blob/master/linux_i2c.c

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>

#include <caml/mlvalues.h>
#include <caml/fail.h>

CAMLprim value caml_i2c_init(value bus_num, value dev_addr)
{
    static char filename[32] = {0};

    sprintf(filename, "/dev/i2c-%d", Int_val(bus_num));

    const int device_fd = open(filename, O_RDWR);
    if (device_fd < 0)
        caml_failwith("open device");

    if (ioctl(device_fd, I2C_SLAVE, dev_addr) < 0)
    {
        close(device_fd);
        caml_failwith("set slave address");
    }

    return Val_int(device_fd);
}

CAMLprim value caml_i2c_close(value fd)
{
    close(Int_val(fd));
    return Val_unit;
}

CAMLprim value caml_i2c_write(value fd, value bytes, int len)
{
    const char* ptr = Bytes_val(bytes);

    const int result = write(fd, ptr, len);
    return Val_int(result);
}

CAMLprim value caml_i2c_read(value fd, value bytes, value len)
{
    char* ptr = Bytes_val(bytes);

    const int result = read(fd, ptr, len);
    return Val_int(result);
}
