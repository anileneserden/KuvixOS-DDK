OUTPUT_FORMAT("binary") /* Doğrudan saf binary üretsin */
ENTRY(driver_init)

SECTIONS
{
    . = 0x0; /* Başlangıç ofseti 0 */

    .text : {
        *(.text.head)    /* ÖNCE KDF_Header yapısını koy! */
        *(.text)         /* Sonra normal fonksiyonları (driver_init vb.) koy */
        *(.text.*)
    }

    .rodata : { *(.rodata*) }
    .data   : { *(.data*) }
    .bss    : { *(.bss*) }

    /DISCARD/ : {
        *(.comment)
        *(.eh_frame)
        *(.note*)
    }
}