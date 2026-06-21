.section .text.head, "ax"
.global _start
_start:
    # C++ tarafında tanımlayacağımız driver_header yapısını buraya referans veriyoruz
    .long 0x46444B4B          # magic: KDF_MAGIC ("KDKF")
    .long 0x00000001          # driver_version
    .ascii "ps2_mouse\0\0\0\0\0\0\0" # driver_name (16 byte'a tamamla)
    .long 32                  # init_offset (Header bittikten sonraki offset)
    .long 0                   # exit_offset
    .long 0                   # code_size