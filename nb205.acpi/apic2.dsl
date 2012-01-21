/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20111123-32 [Dec 12 2011]
 * Copyright (c) 2000 - 2011 Intel Corporation
 * 
 * Disassembly of apic2.dat, Tue Dec 27 22:42:32 2011
 *
 * ACPI Data Table [APIC]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "APIC"    [Multiple APIC Description Table]
[004h 0004   4]                 Table Length : 00000068
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : 13
[00Ah 0010   6]                       Oem ID : "PTLTD "
[010h 0016   8]                 Oem Table ID : "  APIC  "
[018h 0024   4]                 Oem Revision : 06040000
[01Ch 0028   4]              Asl Compiler ID : " LTP"
[020h 0032   4]        Asl Compiler Revision : 00000000

[024h 0036   4]           Local Apic Address : FEE00000
[028h 0040   4]        Flags (decoded below) : 00000001
                         PC-AT Compatibility : 1

[02Ch 0044   1]                Subtable Type : 00 [Processor Local APIC]
[02Dh 0045   1]                       Length : 08
[02Eh 0046   1]                 Processor ID : 00
[02Fh 0047   1]                Local Apic ID : 00
[030h 0048   4]        Flags (decoded below) : 00000001
                           Processor Enabled : 1

[034h 0052   1]                Subtable Type : 00 [Processor Local APIC]
[035h 0053   1]                       Length : 08
[036h 0054   1]                 Processor ID : 01
[037h 0055   1]                Local Apic ID : 01
[038h 0056   4]        Flags (decoded below) : 00000001
                           Processor Enabled : 1

[03Ch 0060   1]                Subtable Type : 01 [I/O APIC]
[03Dh 0061   1]                       Length : 0C
[03Eh 0062   1]                  I/O Apic ID : 02
[03Fh 0063   1]                     Reserved : 00
[040h 0064   4]                      Address : FEC00000
[044h 0068   4]                    Interrupt : 00000000

[048h 0072   1]                Subtable Type : 04 [Local APIC NMI]
[049h 0073   1]                       Length : 06
[04Ah 0074   1]                 Processor ID : 00
[04Bh 0075   2]        Flags (decoded below) : 0005
                                    Polarity : 1
                                Trigger Mode : 1
[04Dh 0077   1]         Interrupt Input LINT : 01

[04Eh 0078   1]                Subtable Type : 04 [Local APIC NMI]
[04Fh 0079   1]                       Length : 06
[050h 0080   1]                 Processor ID : 01
[051h 0081   2]        Flags (decoded below) : 0005
                                    Polarity : 1
                                Trigger Mode : 1
[053h 0083   1]         Interrupt Input LINT : 01

[054h 0084   1]                Subtable Type : 02 [Interrupt Source Override]
[055h 0085   1]                       Length : 0A
[056h 0086   1]                          Bus : 00
[057h 0087   1]                       Source : 00
[058h 0088   4]                    Interrupt : 00000002
[05Ch 0092   2]        Flags (decoded below) : 0005
                                    Polarity : 1
                                Trigger Mode : 1

[05Eh 0094   1]                Subtable Type : 02 [Interrupt Source Override]
[05Fh 0095   1]                       Length : 0A
[060h 0096   1]                          Bus : 00
[061h 0097   1]                       Source : 09
[062h 0098   4]                    Interrupt : 00000009
[066h 0102   2]        Flags (decoded below) : 000D
                                    Polarity : 1
                                Trigger Mode : 3

Raw Table Data: Length 104 (0x68)

  0000: 41 50 49 43 68 00 00 00 01 13 50 54 4C 54 44 20  APICh.....PTLTD 
  0010: 09 20 41 50 49 43 20 20 00 00 04 06 20 4C 54 50  . APIC  .... LTP
  0020: 00 00 00 00 00 00 E0 FE 01 00 00 00 00 08 00 00  ................
  0030: 01 00 00 00 00 08 01 01 01 00 00 00 01 0C 02 00  ................
  0040: 00 00 C0 FE 00 00 00 00 04 06 00 05 00 01 04 06  ................
  0050: 01 05 00 01 02 0A 00 00 02 00 00 00 05 00 02 0A  ................
  0060: 00 09 09 00 00 00 0D 00                          ........
