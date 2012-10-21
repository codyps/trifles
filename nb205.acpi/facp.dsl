/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20110922-32 [Dec  6 2011]
 * Copyright (c) 2000 - 2011 Intel Corporation
 * 
 * Disassembly of facp.dat, Tue Dec  6 20:50:52 2011
 *
 * ACPI Data Table [FACP]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 0000   4]                    Signature : "FACP"    [Fixed ACPI Description Table]
[004h 0004   4]                 Table Length : 000000F4
[008h 0008   1]                     Revision : 03
[009h 0009   1]                     Checksum : 2D
[00Ah 0010   6]                       Oem ID : "INTEL "
[010h 0016   8]                 Oem Table ID : "CALISTGA"
[018h 0024   4]                 Oem Revision : 06040000
[01Ch 0028   4]              Asl Compiler ID : "ALAN"
[020h 0032   4]        Asl Compiler Revision : 00000001

[024h 0036   4]                 FACS Address : 7F6E2FC0
[028h 0040   4]                 DSDT Address : 7F6D645C
[02Ch 0044   1]                        Model : 00
[02Dh 0045   1]                   PM Profile : 00 [Unspecified]
[02Eh 0046   2]                SCI Interrupt : 0009
[030h 0048   4]             SMI Command Port : 000000B2
[034h 0052   1]            ACPI Enable Value : F0
[035h 0053   1]           ACPI Disable Value : F1
[036h 0054   1]               S4BIOS Command : 00
[037h 0055   1]              P-State Control : 80
[038h 0056   4]     PM1A Event Block Address : 00001000
[03Ch 0060   4]     PM1B Event Block Address : 00000000
[040h 0064   4]   PM1A Control Block Address : 00001004
[044h 0068   4]   PM1B Control Block Address : 00000000
[048h 0072   4]    PM2 Control Block Address : 00001020
[04Ch 0076   4]       PM Timer Block Address : 00001008
[050h 0080   4]           GPE0 Block Address : 00001028
[054h 0084   4]           GPE1 Block Address : 00000000
[058h 0088   1]       PM1 Event Block Length : 04
[059h 0089   1]     PM1 Control Block Length : 02
[05Ah 0090   1]     PM2 Control Block Length : 01
[05Bh 0091   1]        PM Timer Block Length : 04
[05Ch 0092   1]            GPE0 Block Length : 08
[05Dh 0093   1]            GPE1 Block Length : 00
[05Eh 0094   1]             GPE1 Base Offset : 00
[05Fh 0095   1]                 _CST Support : 85
[060h 0096   2]                   C2 Latency : 0001
[062h 0098   2]                   C3 Latency : 0023
[064h 0100   2]               CPU Cache Size : 0000
[066h 0102   2]           Cache Flush Stride : 0000
[068h 0104   1]            Duty Cycle Offset : 01
[069h 0105   1]             Duty Cycle Width : 03
[06Ah 0106   1]          RTC Day Alarm Index : 0D
[06Bh 0107   1]        RTC Month Alarm Index : 00
[06Ch 0108   1]            RTC Century Index : 32
[06Dh 0109   2]   Boot Flags (decoded below) : 0000
               Legacy Devices Supported (V2) : 0
            8042 Present on ports 60/64 (V2) : 0
                        VGA Not Present (V4) : 0
                      MSI Not Supported (V4) : 0
                PCIe ASPM Not Supported (V4) : 0
[06Fh 0111   1]                     Reserved : 00
[070h 0112   4]        Flags (decoded below) : 000002A5
      WBINVD instruction is operational (V1) : 1
              WBINVD flushes all caches (V1) : 0
                    All CPUs support C1 (V1) : 1
                  C2 works on MP system (V1) : 0
            Control Method Power Button (V1) : 0
            Control Method Sleep Button (V1) : 1
        RTC wake not in fixed reg space (V1) : 0
            RTC can wake system from S4 (V1) : 1
                        32-bit PM Timer (V1) : 0
                      Docking Supported (V1) : 1
               Reset Register Supported (V2) : 0
                            Sealed Case (V3) : 0
                    Headless - No Video (V3) : 0
        Use native instr after SLP_TYPx (V3) : 0
              PCIEXP_WAK Bits Supported (V4) : 0
                     Use Platform Timer (V4) : 0
               RTC_STS valid on S4 wake (V4) : 0
                Remote Power-on capable (V4) : 0
                 Use APIC Cluster Model (V4) : 0
     Use APIC Physical Destination Mode (V4) : 0

[074h 0116  12]               Reset Register : [Generic Address Structure]
[074h 0116   1]                     Space ID : 00 [SystemMemory]
[075h 0117   1]                    Bit Width : 00
[076h 0118   1]                   Bit Offset : 00
[077h 0119   1]         Encoded Access Width : 00 [Undefined/Legacy]
[078h 0120   8]                      Address : 0000000000000000

[080h 0128   1]         Value to cause reset : 00
[081h 0129   3]                     Reserved : 000000
[084h 0132   8]                 FACS Address : 000000007F6E2FC0
[08Ch 0140   8]                 DSDT Address : 000000007F6D645C
[094h 0148  12]             PM1A Event Block : [Generic Address Structure]
[094h 0148   1]                     Space ID : 01 [SystemIO]
[095h 0149   1]                    Bit Width : 20
[096h 0150   1]                   Bit Offset : 00
[097h 0151   1]         Encoded Access Width : 00 [Undefined/Legacy]
[098h 0152   8]                      Address : 0000000000001000

[0A0h 0160  12]             PM1B Event Block : [Generic Address Structure]
[0A0h 0160   1]                     Space ID : 00 [SystemMemory]
[0A1h 0161   1]                    Bit Width : 00
[0A2h 0162   1]                   Bit Offset : 00
[0A3h 0163   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0A4h 0164   8]                      Address : 0000000000000000

[0ACh 0172  12]           PM1A Control Block : [Generic Address Structure]
[0ACh 0172   1]                     Space ID : 01 [SystemIO]
[0ADh 0173   1]                    Bit Width : 10
[0AEh 0174   1]                   Bit Offset : 00
[0AFh 0175   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0B0h 0176   8]                      Address : 0000000000001004

[0B8h 0184  12]           PM1B Control Block : [Generic Address Structure]
[0B8h 0184   1]                     Space ID : 00 [SystemMemory]
[0B9h 0185   1]                    Bit Width : 00
[0BAh 0186   1]                   Bit Offset : 00
[0BBh 0187   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0BCh 0188   8]                      Address : 0000000000000000

[0C4h 0196  12]            PM2 Control Block : [Generic Address Structure]
[0C4h 0196   1]                     Space ID : 01 [SystemIO]
[0C5h 0197   1]                    Bit Width : 08
[0C6h 0198   1]                   Bit Offset : 00
[0C7h 0199   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0C8h 0200   8]                      Address : 0000000000001020

[0D0h 0208  12]               PM Timer Block : [Generic Address Structure]
[0D0h 0208   1]                     Space ID : 01 [SystemIO]
[0D1h 0209   1]                    Bit Width : 20
[0D2h 0210   1]                   Bit Offset : 00
[0D3h 0211   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0D4h 0212   8]                      Address : 0000000000001008

[0DCh 0220  12]                   GPE0 Block : [Generic Address Structure]
[0DCh 0220   1]                     Space ID : 01 [SystemIO]
[0DDh 0221   1]                    Bit Width : 40
[0DEh 0222   1]                   Bit Offset : 00
[0DFh 0223   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0E0h 0224   8]                      Address : 0000000000001028

[0E8h 0232  12]                   GPE1 Block : [Generic Address Structure]
[0E8h 0232   1]                     Space ID : 00 [SystemMemory]
[0E9h 0233   1]                    Bit Width : 00
[0EAh 0234   1]                   Bit Offset : 00
[0EBh 0235   1]         Encoded Access Width : 00 [Undefined/Legacy]
[0ECh 0236   8]                      Address : 0000000000000000


Raw Table Data: Length 244 (0xF4)

  0000: 46 41 43 50 F4 00 00 00 03 2D 49 4E 54 45 4C 20  FACP.....-INTEL 
  0010: 43 41 4C 49 53 54 47 41 00 00 04 06 41 4C 41 4E  CALISTGA....ALAN
  0020: 01 00 00 00 C0 2F 6E 7F 5C 64 6D 7F 00 00 09 00  ...../n.\dm.....
  0030: B2 00 00 00 F0 F1 00 80 00 10 00 00 00 00 00 00  ................
  0040: 04 10 00 00 00 00 00 00 20 10 00 00 08 10 00 00  ........ .......
  0050: 28 10 00 00 00 00 00 00 04 02 01 04 08 00 00 85  (...............
  0060: 01 00 23 00 00 00 00 00 01 03 0D 00 32 00 00 00  ..#.........2...
  0070: A5 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0080: 00 00 00 00 C0 2F 6E 7F 00 00 00 00 5C 64 6D 7F  ...../n.....\dm.
  0090: 00 00 00 00 01 20 00 00 00 10 00 00 00 00 00 00  ..... ..........
  00A0: 00 00 00 00 00 00 00 00 00 00 00 00 01 10 00 00  ................
  00B0: 04 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00C0: 00 00 00 00 01 08 00 00 20 10 00 00 00 00 00 00  ........ .......
  00D0: 01 20 00 00 08 10 00 00 00 00 00 00 01 40 00 00  . ...........@..
  00E0: 28 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00  (...............
  00F0: 00 00 00 00                                      ....
