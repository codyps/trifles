SECTIONS
{
    .test_align : ALIGN(8)
    {
        __start_test_align = .;
        BYTE(5);
        . = ALIGN(8);
        __stop_test_align = .;
    }
}
INSERT AFTER .rodata;
