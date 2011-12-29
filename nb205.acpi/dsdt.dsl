/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20110922-32 [Dec  6 2011]
 * Copyright (c) 2000 - 2011 Intel Corporation
 * 
 * Disassembly of dsdt.dat, Tue Dec  6 20:11:56 2011
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x0000B702 (46850)
 *     Revision         0x01 **** 32-bit table (V1), no 64-bit math support
 *     Checksum         0x46
 *     OEM ID           "TOSCPL"
 *     OEM Table ID     "CALISTGA"
 *     OEM Revision     0x06040000 (100925440)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20050624 (537200164)
 */

DefinitionBlock ("dsdt.aml", "DSDT", 1, "TOSCPL", "CALISTGA", 0x06040000)
{
    External (PDC1)
    External (PDC0)
    External (CFGD)
    External (\_PR_.CPU0._PPC)

    Name (Z000, One)
    Name (Z001, 0x02)
    Name (Z002, 0x04)
    Name (Z003, 0x08)
    Name (Z004, Zero)
    Name (Z005, 0x0F)
    Name (Z006, 0x0D)
    Name (Z007, 0x0B)
    Name (Z008, 0x09)
    Name (ECDY, Zero)
    OperationRegion (PRT0, SystemIO, 0x80, 0x04)
    Field (PRT0, DWordAcc, Lock, Preserve)
    {
        P80H,   32
    }

    OperationRegion (IO_T, SystemIO, 0x0800, 0x10)
    Field (IO_T, ByteAcc, NoLock, Preserve)
    {
                Offset (0x08), 
        TRP0,   8
    }

    OperationRegion (PMIO, SystemIO, 0x1000, 0x80)
    Field (PMIO, ByteAcc, NoLock, Preserve)
    {
                Offset (0x2A), 
            ,   10, 
        ACPW,   1, 
                Offset (0x30), 
            ,   4, 
        SLPE,   1, 
                Offset (0x34), 
            ,   4, 
        SLPS,   1, 
                Offset (0x42), 
            ,   1, 
        GPEC,   1
    }

    OperationRegion (GPIO, SystemIO, 0x1180, 0x3C)
    Field (GPIO, ByteAcc, NoLock, Preserve)
    {
        GU00,   8, 
        GU01,   8, 
        GU02,   8, 
        GU03,   8, 
        GIO0,   8, 
        GIO1,   8, 
        GIO2,   8, 
        GIO3,   8, 
                Offset (0x0C), 
            ,   6, 
        BTEN,   1, /* Bluetooth: used as _STA return for BT */
                Offset (0x0D), 
            ,   4, 
        GP12,   1, 
                Offset (0x0E), 
            ,   5, 
        BTRS,   1, /* Bluetooth: Written by _PTS to 0 */
                Offset (0x0F), 
        GL03,   8, 
                Offset (0x18), 
        GB00,   8, 
        GB01,   8, 
        GB02,   8, 
        GB03,   8, 
                Offset (0x2C), 
        GIV0,   8, 
            ,   5, 
        LPOL,   1, 
                Offset (0x2E), 
        GIV2,   8, 
        GIV3,   8, 
        GU04,   8, 
        GU05,   8, 
        GU06,   8, 
        GU07,   8, 
        GIO4,   8, 
        GIO5,   8, 
        GIO6,   8, 
        GIO7,   8, 
            ,   4, 
        BTPR,   1, /* BT Power Reset (?): Written by _PTS to 1 */
            ,   2, 
        GP39,   1, 
        GL05,   8, 
        GL06,   8, 
        GL07,   8
    }

    OperationRegion (GNVS, SystemMemory, 0x7F6E2CBC, 0x0200)
    Field (GNVS, AnyAcc, Lock, Preserve)
    {
        OSYS,   16, /* Linux = 0x03E8,  */
        SMIF,   8, 
        PRM0,   8,  /* Passed by BRTW to P8XH*/
        PRM1,   8, 
        SCIF,   8, 
        PRM2,   8, 
        PRM3,   8, 
        LCKF,   8, 
        PRM4,   8, 
        PRM5,   8, 
        P80D,   32,  /* _PTS stores Zero */
        LIDS,   8, 
        PWRS,   8, 
        DBGS,   8, 
        LINX,   8, /* Linux is One */
                Offset (0x14), 
        ACTT,   8, 
        PSVT,   8, 
        TC1V,   8, 
        TC2V,   8, 
        TSPV,   8, 
        CRTT,   8, 
        DTSE,   8, 
        DTS1,   8, 
        DTS2,   8, 
                Offset (0x1E), 
        BNUM,   8, 
        B0SC,   8, 
        B1SC,   8, 
        B2SC,   8, 
        B0SS,   8, 
        B1SS,   8, 
        B2SS,   8, 
                Offset (0x28), 
        APIC,   8, 
        MPEN,   8, 
        PPCS,   8, 
        PPCM,   8, 
        PCP0,   8, 
        PCP1,   8, 
                Offset (0x32), 
        NATP,   8, 
        CMAP,   8, 
        CMBP,   8, 
        LPTP,   8, 
        FDCP,   8, 
        CMCP,   8, 
        CIRP,   8, 
                Offset (0x3C), 
        IGDS,   8, 
        TLST,   8, 
        CADL,   8, 
        PADL,   8, 
        CSTE,   16, 
        NSTE,   16, 
        SSTE,   16, 
        NDID,   8, 
        DID1,   32, 
        DID2,   32, 
        DID3,   32, 
        DID4,   32, 
        DID5,   32, 
                Offset (0x67), 
        BLCS,   8, 
        BRTL,   8, 
        ALSE,   8, 
        ALAF,   8, 
        LLOW,   8, 
        LHIH,   8, 
                Offset (0x6E), 
        EMAE,   8, 
        EMAP,   16, 
        EMAL,   16, 
                Offset (0x74), 
        MEFE,   8, 
                Offset (0x78), 
        TPMP,   8, 
        TPME,   8, 
                Offset (0x82), 
        GTF0,   56, 
        GTF2,   56, 
        IDEM,   8, 
                Offset (0xC6), 
        MARK,   16, 
                Offset (0xE5), 
        STPH,   8, // if not = 0xAA, PHMR & PHMW don't run.
                Offset (0x100), 
        OEMN,   16, 
        BRAD,   8, 
        VVEN,   8, 
        BGU1,   8, 
        BST1,   8,  // GNVS? SystemMemory
        BFC1,   16, // Write BFC0 into this.
        WKLN,   8, 
        WAKF,   8, 
        HORZ,   16, 
        VERT,   16, 
        OES1,   8, 
        OES2,   8, 
        HDPT,   8, 
        TVFM,   8, 
        TOUD,   8, 
        CEV1,   32, 
        CEV2,   32, 
        CEV3,   32, 
        CEVD,   8, 
        CEVN,   8, 
        CCM1,   32, 
        CCM2,   32, 
        CCM3,   32, 
        CCM4,   32, 
        CCMD,   8, 
        CCMN,   8, 
        CME1,   32, 
        CME2,   32, 
        CME3,   32, 
        CME4,   32, 
        CMEN,   8, 
        PMID,   16, 
        PPID,   16, 
                Offset (0x14A), 
        ALMF,   8, 
        ALMM,   8, 
        ALMH,   8, 
        ALMD,   8, 
        ALMO,   8, 
        ALMY,   8, 
        LED1,   8, /* LED: ?? */
        LED2,   8, /* LED: ?? */
        CIRE,   8, 
        WWLN,   8, 
        BDN1,   8, 
        HAPE,   8, 
        TPID,   8, 
        CEEV,   16, 
                Offset (0x15E), 
        DTST,   8
    }

    OperationRegion (RCRB, SystemMemory, 0xFED1C000, 0x4000)
    Field (RCRB, DWordAcc, Lock, Preserve)
    {
                Offset (0x1000), 
                Offset (0x3000), 
                Offset (0x3404), 
        HPAS,   2, 
            ,   5, 
        HPAE,   1, 
                Offset (0x3418), 
            ,   1, 
        PATD,   1, 
        SATD,   1, 
        SMBD,   1, 
        HDAD,   1, 
        A97D,   1, 
                Offset (0x341A), 
        RP1D,   1, 
        RP2D,   1, 
        RP3D,   1, 
        RP4D,   1, 
        RP5D,   1, 
        RP6D,   1
    }

    Mutex (MUTX, 0x00)
    Name (_S0, Package (0x03)
    {
        Zero, 
        Zero, 
        Zero
    })
    Name (_S3, Package (0x03)
    {
        0x05, 
        0x05, 
        Zero
    })
    Name (_S4, Package (0x03)
    {
        0x06, 
        0x06, 
        Zero
    })
    Name (_S5, Package (0x03)
    {
        0x07, 
        0x07, 
        Zero
    })
    Scope (_PR)
    {
        Processor (CPU0, 0x00, 0x00001010, 0x06) {}
        Processor (CPU1, 0x01, 0x00001010, 0x06) {}
    }

    Name (DSEN, One)
    Name (ECON, Zero)
    Name (GPIC, Zero) /* OS Interrupt mode: 0 - PIC, 1 - APIC, 2 - SAPIC */
    Name (CTYP, Zero)
    Name (L01C, Zero) /* \_GPE._LO1 counter (counts how many time _L01 executes)  */
    Name (VFN0, Zero)

    /* P_____ interupt C____ */
    /* _PIC: specify OS interupt mode for ACPI */
    /* Arg0: 0 - PIC, 1 - APIC, 2 - SAPIC */
    Method (_PIC, 1, NotSerialized)
    {
        Store (Arg0, GPIC)
    }

    /* Prepare to Sleep */
    /* _PTS: Indicate the intended sleep state to ACPI */
    /* Arg0: One of 1, 2, 3, or 4 => S1, S2, S3, S4 */
    Method (_PTS, 1, NotSerialized)
    {
        Store (Zero, P80D) /* GNVS, ??? */
        P8XH (Zero, Arg0)
        If (\_SB.PCI0.LPCB.EC0.BTSW) /* ??? */
        {
            Store (Zero, \_SB.PCI0.LPCB.EC0.BTPW) /* EC, ??? */
            Store (Zero, BTRS) /* GPIO, ??? */
            Store (One, BTPR)  /* GPIO, ??? */
        }

        If (LEqual (Arg0, 0x03)) /* S3 */
        {
            Store (0x4C, \_SB.BCMD) /* SMI1, ???  */
            Store (Zero, \_SB.SMIC) /* SMI0, ??? */
        }

        If (LEqual (Arg0, 0x04)) /* S4 */
        {
            \_SB.PCI0.LPCB.PHSS (0x0E) /* ??? */
        }

        If (LEqual (Arg0, 0x05)) {} /* S5 (Not In Spec) */
    }

    /* Wake: ???   */
    /* Arg0: ???   */
    /* Return: ??? */
    Method (_WAK, 1, NotSerialized)
    {
        P8XH (Zero, 0xAB)
        If (LOr (LEqual (Arg0, 0x03), LEqual (Arg0, 0x04)))
        {
            If (And (CFGD, 0x01000000))
            {
                If (LAnd (And (CFGD, 0xF0), LEqual (OSYS, 0x07D1)))
                {
                    TRAP (0x3D)
                }
            }
        }

        If (LEqual (LINX, One))
        {
            If (\_SB.PCI0.LPCB.EC0.BTSW) /* BT ??? */
            {
                \_SB.PCI0.LPCB.EC0.BT.BTPO () /* BT ??? */
            }
        }

        If (LEqual (RP2D, Zero))
        {
            Notify (\_SB.PCI0.RP02, Zero)
        }

        If (LEqual (RP3D, Zero))
        {
            Notify (\_SB.PCI0.RP03, Zero)
        }

        If (LEqual (RP4D, Zero))
        {
            Notify (\_SB.PCI0.RP04, Zero)
        }

        If (LEqual (RP5D, Zero))
        {
            Notify (\_SB.PCI0.RP05, Zero)
        }

        If (LEqual (RP6D, Zero))
        {
            Notify (\_SB.PCI0.RP06, Zero)
        }

        If (LEqual (Arg0, 0x03))
        {
            TRAP (0x46)
        }

        If (LEqual (Arg0, 0x04))
        {
            \_SB.PCI0.LPCB.PHSS (0x0F)
            Store (WAKF, Local0)
            Store (Zero, WAKF)
            And (Local0, 0x05, Local0)
            If (LEqual (Local0, One))
            {
                P8XH (Zero, 0x41)
                Notify (\_SB.PWRB, 0x02)
            }
        }

        P8XH (One, 0xCD)
        Return (Package (0x02)
        {
            Zero, 
            Zero
        })
    }

    /* "General Purpose Events", Root level event handlers */
    Scope (_GPE)
    {
        /* Level event 0x01 */
        Method (_L01, 0, NotSerialized)
        {
            Add (L01C, One, L01C)
            P8XH (Zero, One)
            P8XH (One, L01C)
            Sleep (0x64)
            If (LAnd (LEqual (RP1D, Zero), \_SB.PCI0.RP01.HPCS))
            {
                If (\_SB.PCI0.RP01.PDC1)
                {
                    If (\_SB.PCI0.RP01.PDS1)
                    {
                        \_SB.VALZ.EXCN ()
                    }

                    Store (One, \_SB.PCI0.RP01.PDC1)
                    Store (One, \_SB.PCI0.RP01.HPCS)
                    Notify (\_SB.PCI0.RP01, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP01.HPCS)
                }
            }

            If (LAnd (LEqual (RP2D, Zero), \_SB.PCI0.RP02.HPCS))
            {
                If (\_SB.PCI0.RP02.PDC2)
                {
                    Store (One, \_SB.PCI0.RP02.PDC2)
                    Store (One, \_SB.PCI0.RP02.HPCS)
                    Notify (\_SB.PCI0.RP02, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP02.HPCS)
                }
            }

            If (LAnd (LEqual (RP3D, Zero), \_SB.PCI0.RP03.HPCS))
            {
                If (\_SB.PCI0.RP03.PDC3)
                {
                    Store (One, \_SB.PCI0.RP03.PDC3)
                    Store (One, \_SB.PCI0.RP03.HPCS)
                    Notify (\_SB.PCI0.RP03, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP03.HPCS)
                }
            }

            If (LAnd (LEqual (RP4D, Zero), \_SB.PCI0.RP04.HPCS))
            {
                If (\_SB.PCI0.RP04.PDC4)
                {
                    Store (One, \_SB.PCI0.RP04.PDC4)
                    Store (One, \_SB.PCI0.RP04.HPCS)
                    Notify (\_SB.PCI0.RP04, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP04.HPCS)
                }
            }

            If (LAnd (LEqual (RP5D, Zero), \_SB.PCI0.RP05.HPCS))
            {
                If (\_SB.PCI0.RP05.PDC5)
                {
                    Store (One, \_SB.PCI0.RP05.PDC5)
                    Store (One, \_SB.PCI0.RP05.HPCS)
                    Notify (\_SB.PCI0.RP05, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP05.HPCS)
                }
            }

            If (LAnd (LEqual (RP6D, Zero), \_SB.PCI0.RP06.HPCS))
            {
                If (\_SB.PCI0.RP06.PDC6)
                {
                    Store (One, \_SB.PCI0.RP06.PDC6)
                    Store (One, \_SB.PCI0.RP06.HPCS)
                    Notify (\_SB.PCI0.RP06, Zero)
                }
                Else
                {
                    Store (One, \_SB.PCI0.RP06.HPCS)
                }
            }
        }

        Method (_L02, 0, NotSerialized)
        {
            Store (Zero, GPEC)
        }

        Method (_L03, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB1, 0x02)
        }

        Method (_L04, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB2, 0x02)
        }

        Method (_L05, 0, NotSerialized)
        {
            If (HDAD) {}
            Else
            {
                Notify (\_SB.PCI0.HDEF, 0x02)
            }
        }

        Method (_L09, 0, NotSerialized)
        {
            If (\_SB.PCI0.RP01.PSP1)
            {
                Store (One, \_SB.PCI0.RP01.PSP1)
                Store (One, \_SB.PCI0.RP01.PMCS)
                Notify (\_SB.PCI0.RP01, 0x02)
            }

            If (\_SB.PCI0.RP02.PSP2)
            {
                Store (One, \_SB.PCI0.RP02.PSP2)
                Store (One, \_SB.PCI0.RP02.PMCS)
                Notify (\_SB.PCI0.RP02, 0x02)
            }

            If (\_SB.PCI0.RP03.PSP3)
            {
                Store (One, \_SB.PCI0.RP03.PSP3)
                Store (One, \_SB.PCI0.RP03.PMCS)
                Notify (\_SB.PCI0.RP03, 0x02)
            }

            If (\_SB.PCI0.RP04.PSP4)
            {
                Store (One, \_SB.PCI0.RP04.PSP4)
                Store (One, \_SB.PCI0.RP04.PMCS)
                Notify (\_SB.PCI0.RP04, 0x02)
            }

            If (\_SB.PCI0.RP05.PSP5)
            {
                Store (One, \_SB.PCI0.RP05.PSP5)
                Store (One, \_SB.PCI0.RP05.PMCS)
                Notify (\_SB.PCI0.RP05, 0x02)
            }

            If (\_SB.PCI0.RP06.PSP6)
            {
                Store (One, \_SB.PCI0.RP06.PSP6)
                Store (One, \_SB.PCI0.RP06.PMCS)
                Notify (\_SB.PCI0.RP06, 0x02)
            }
        }

        Method (_L0B, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.PCIB, 0x02)
        }

        Method (_L0C, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB3, 0x02)
        }

        Method (_L0D, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB7, 0x02)
        }

        Method (_L0E, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.USB4, 0x02)
        }

        Method (_L1D, 0, NotSerialized)
        {
            P8XH (Zero, 0xFA)
            Not (LPOL, LPOL)
            Notify (\_SB.LID0, 0x80)
        }
    }

    Method (BRTW, 1, Serialized)
    {
        Store (Arg0, Local1)
        If (LEqual (ALSE, 0x02))
        {
            Store (Divide (Multiply (ALAF, Arg0), 0x64, ), Local1)
            If (LGreater (Local1, 0x64))
            {
                Store (0x64, Local1)
            }
        }

        Store (Divide (Multiply (0xFF, Local1), 0x64, ), Local0)
        Store (Local0, PRM0)
        If (LEqual (TRAP (0x12), Zero))
        {
            P8XH (0x02, Local0)
            Store (Arg0, BRTL)
        }
    }

    Method (GETB, 3, Serialized)
    {
        Multiply (Arg0, 0x08, Local0)
        Multiply (Arg1, 0x08, Local1)
        CreateField (Arg2, Local0, Local1, TBF3)
        Return (TBF3)
    }

    Method (HKDS, 1, Serialized)
    {
        If (LEqual (Zero, DSEN))
        {
            If (LEqual (TRAP (Arg0), Zero))
            {
                If (LNotEqual (CADL, PADL))
                {
                    Store (CADL, PADL)
                    /* XXX: first condition appears to be true always */
                    /* || (> OSYS 0x07D0) (< OSYS 0x07D6)
                       (OSYS > 0x07D0) || (OSYS < 0x07D6)
                    */
                    If (LOr (LGreater (OSYS, 0x07D0), LLess (OSYS, 0x07D6)))
                    {
                        Notify (\_SB.PCI0, Zero)
                    }
                    Else
                    {
                        Notify (\_SB.PCI0.GFX0, Zero)
                    }
                    /* LONG sleep */
                    Sleep (0x02EE)
                }

                Notify (\_SB.PCI0.GFX0, 0x80)
            }
        }

        If (LEqual (One, DSEN))
        {
            If (LEqual (TRAP (Increment (Arg0)), Zero))
            {
                Notify (\_SB.PCI0.GFX0, 0x81)
            }
        }
    }

    Method (LSDS, 1, Serialized)
    {
        If (Arg0)
        {
            HKDS (0x0C)
        }
        Else
        {
            HKDS (0x0E)
        }

        If (LNotEqual (DSEN, One))
        {
            Sleep (0x32)
            While (LEqual (DSEN, 0x02))
            {
                Sleep (0x32)
            }
        }
    }

    /* Called From: */
    /*  _PTS: (Zero, Sleep state as one of {1,2,3,4})
        _WAK: first: (Zero, 0xAB), then[in some cases]: (Zero, 0x41)
	      last: (One, 0xCD) immediately prior to return
	_GPE:
	  _L01:
            P8XH (Zero, One)
            P8XH (One, L01C)
          _L1D:
	    P8XH (Zero, 0xFA)
	BRTW:
            P8XH (0x02, Local0) where Local0=PRM0
    */
    Method (P8XH, 2, Serialized)
    {
        If (LEqual (Arg0, Zero))
        {
            Store (Or (And (P80D, 0xFFFFFF00), Arg1), P80D)
        }

        If (LEqual (Arg0, One))
        {
            Store (Or (And (P80D, 0xFFFF00FF), ShiftLeft (Arg1, 0x08)
                ), P80D)
        }

        If (LEqual (Arg0, 0x02))
        {
            Store (Or (And (P80D, 0xFF00FFFF), ShiftLeft (Arg1, 0x10)
                ), P80D)
        }

        If (LEqual (Arg0, 0x03))
        {
            Store (Or (And (P80D, 0x00FFFFFF), ShiftLeft (Arg1, 0x18)
                ), P80D)
        }

        Store (P80D, P80H)
    }

    Method (PNOT, 0, Serialized)
    {
        If (MPEN)
        {
            If (And (PDC0, 0x08))
            {
                Notify (\_PR.CPU0, 0x80)
                If (And (PDC0, 0x10))
                {
                    Sleep (0x64)
                    Notify (\_PR.CPU0, 0x81)
                }
            }

            If (And (PDC1, 0x08))
            {
                Notify (\_PR.CPU1, 0x80)
                If (And (PDC1, 0x10))
                {
                    Sleep (0x64)
                    Notify (\_PR.CPU1, 0x81)
                }
            }
        }
        Else
        {
            Notify (\_PR.CPU0, 0x80)
            Sleep (0x64)
            Notify (\_PR.CPU0, 0x81)
        }
    }

    Method (TRAP, 1, Serialized)
    {
        Store (Arg0, SMIF)
        Store (Zero, TRP0)
        Return (SMIF)
    }

    Method (GETP, 1, Serialized)
    {
        If (LEqual (And (Arg0, 0x09), Zero))
        {
            Return (Ones)
        }

        If (LEqual (And (Arg0, 0x09), 0x08))
        {
            Return (0x0384)
        }

        ShiftRight (And (Arg0, 0x0300), 0x08, Local0)
        ShiftRight (And (Arg0, 0x3000), 0x0C, Local1)
        Return (Multiply (0x1E, Subtract (0x09, Add (Local0, Local1))
            ))
    }

    Method (GDMA, 5, Serialized)
    {
        If (Arg0)
        {
            If (LAnd (Arg1, Arg4))
            {
                Return (0x14)
            }

            If (LAnd (Arg2, Arg4))
            {
                Return (Multiply (Subtract (0x04, Arg3), 0x0F))
            }

            Return (Multiply (Subtract (0x04, Arg3), 0x1E))
        }

        Return (Ones)
    }

    Method (GETT, 1, Serialized)
    {
        Return (Multiply (0x1E, Subtract (0x09, Add (And (ShiftRight (Arg0, 0x02
            ), 0x03), And (Arg0, 0x03)))))
    }

    Method (GETF, 3, Serialized)
    {
        Name (TMPF, Zero)
        If (Arg0)
        {
            Or (TMPF, One, TMPF)
        }

        If (And (Arg2, 0x02))
        {
            Or (TMPF, 0x02, TMPF)
        }

        If (Arg1)
        {
            Or (TMPF, 0x04, TMPF)
        }

        If (And (Arg2, 0x20))
        {
            Or (TMPF, 0x08, TMPF)
        }

        If (And (Arg2, 0x4000))
        {
            Or (TMPF, 0x10, TMPF)
        }

        Return (TMPF)
    }

    Method (SETP, 3, Serialized)
    {
        If (LGreater (Arg0, 0xF0))
        {
            Return (0x08)
        }
        Else
        {
            If (And (Arg1, 0x02))
            {
                If (LAnd (LLessEqual (Arg0, 0x78), And (Arg2, 0x02)))
                {
                    Return (0x2301)
                }

                If (LAnd (LLessEqual (Arg0, 0xB4), And (Arg2, One)))
                {
                    Return (0x2101)
                }
            }

            Return (0x1001)
        }
    }

    Method (SDMA, 1, Serialized)
    {
        If (LLessEqual (Arg0, 0x14))
        {
            Return (One)
        }

        If (LLessEqual (Arg0, 0x1E))
        {
            Return (0x02)
        }

        If (LLessEqual (Arg0, 0x2D))
        {
            Return (One)
        }

        If (LLessEqual (Arg0, 0x3C))
        {
            Return (0x02)
        }

        If (LLessEqual (Arg0, 0x5A))
        {
            Return (One)
        }

        Return (Zero)
    }

    Method (SETT, 3, Serialized)
    {
        If (And (Arg1, 0x02))
        {
            If (LAnd (LLessEqual (Arg0, 0x78), And (Arg2, 0x02)))
            {
                Return (0x0B)
            }

            If (LAnd (LLessEqual (Arg0, 0xB4), And (Arg2, One)))
            {
                Return (0x09)
            }
        }

        Return (0x04)
    }

    Name (FWSO, "FWSO")
    Name (_PSC, Zero)
    Method (_PS0, 0, NotSerialized)
    {
        Store (_PSC, Local0)
        Store (Zero, _PSC)
    }

    Method (_PS3, 0, NotSerialized)
    {
        Store (0x03, _PSC)
    }

    Scope (_SB)
    {
        OperationRegion (SMI0, SystemIO, 0x0000FE00, 0x00000002)
        Field (SMI0, AnyAcc, NoLock, Preserve)
        {
            SMIC,   8  /* Written by _PTS to Zero */
        }

        OperationRegion (SMI1, SystemMemory, 0x7F6E2EBD, 0x00000090)
        Field (SMI1, AnyAcc, NoLock, Preserve)
        {
            BCMD,   8,  /* Written by _PTS to 0x4C */
            DID,    32, 
            INFO,   1024
        }

        Field (SMI1, AnyAcc, NoLock, Preserve)
        {
                    AccessAs (ByteAcc, 0x00), 
                    Offset (0x05), 
            INF,    8
        }

        Method (_INI, 0, NotSerialized)
        {
            If (DTSE)
            {
                TRAP (0x47)
            }

            Store (0x07D0, OSYS)
            If (CondRefOf (_OSI, Local0))
            {
                If (_OSI ("Linux"))
                {
                    Store (One, LINX)
                    Store (0x03E8, OSYS)
                }
                Else
                {
                    Store (Zero, LINX)
                }

                If (_OSI ("Windows 2001"))
                {
                    Store (0x07D1, OSYS)
                }

                If (_OSI ("Windows 2001 SP1"))
                {
                    Store (0x07D1, OSYS)
                }

                If (_OSI ("Windows 2001 SP2"))
                {
                    Store (0x07D2, OSYS)
                }

                If (_OSI ("Windows 2006"))
                {
                    Store (0x07D6, OSYS)
                }

                If (_OSI ("Windows 2009"))
                {
                    Store (0x07D9, OSYS)
                }
            }

            If (LAnd (MPEN, LEqual (OSYS, 0x07D1)))
            {
                TRAP (0x3D)
            }

            If (LGreaterEqual (OSYS, 0x07D0))
            {
                Store (One, PRM0)
                If (LGreaterEqual (OSYS, 0x07D1))
                {
                    Store (0x03, PRM0)
                }
            }
            Else
            {
                Store (Zero, PRM0)
            }
        }

        Device (LID0)
        {
            Name (_HID, EisaId ("PNP0C0D"))
            Method (_LID, 0, NotSerialized)
            {
                Return (LPOL)
            }
        }

        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C"))
        }

        Device (HAPS)
        {
            Name (_HID, "TOS620A")
            Name (ECPT, Zero)
            Name (ECRS, Zero)
            Method (_STA, 0, NotSerialized)
            {
                If (HAPE)
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (PTLV, 1, NotSerialized)
            {
                If (^^PCI0.LPCB.ECOK ())
                {
                    Store (Arg0, ^^PCI0.LPCB.EC0.HAPL)
                    Store (Arg0, ECPT)
                }
                Else
                {
                    Store (Arg0, ECPT)
                }
            }

            Method (RSSS, 0, NotSerialized)
            {
                If (^^PCI0.LPCB.ECOK ())
                {
                    Store (One, ^^PCI0.LPCB.EC0.HAPR)
                }
                Else
                {
                    Store (One, ECRS)
                }
            }
        }

        Device (PCI0)
        {
            Method (_S3D, 0, NotSerialized)
            {
                Return (0x02)
            }

            Method (_S4D, 0, NotSerialized)
            {
                Return (0x02)
            }

            Name (_HID, EisaId ("PNP0A08"))
            Name (_CID, EisaId ("PNP0A03"))
            Name (_ADR, Zero)
            Name (_BBN, Zero)
            OperationRegion (HBUS, PCI_Config, 0x40, 0xC0)
            Field (HBUS, DWordAcc, NoLock, Preserve)
            {
                        Offset (0x50), 
                    ,   4, 
                PM0H,   2, 
                        Offset (0x51), 
                PM1L,   2, 
                    ,   2, 
                PM1H,   2, 
                        Offset (0x52), 
                PM2L,   2, 
                    ,   2, 
                PM2H,   2, 
                        Offset (0x53), 
                PM3L,   2, 
                    ,   2, 
                PM3H,   2, 
                        Offset (0x54), 
                PM4L,   2, 
                    ,   2, 
                PM4H,   2, 
                        Offset (0x55), 
                PM5L,   2, 
                    ,   2, 
                PM5H,   2, 
                        Offset (0x56), 
                PM6L,   2, 
                    ,   2, 
                PM6H,   2, 
                        Offset (0x57), 
                    ,   7, 
                HENA,   1, 
                        Offset (0x5C), 
                    ,   3, 
                TLUD,   5
            }

            Name (BUF0, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x00FF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0100,             // Length
                    ,, )
                DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0x00000CF7,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000CF8,         // Length
                    ,, , TypeStatic)
                IO (Decode16,
                    0x0CF8,             // Range Minimum
                    0x0CF8,             // Range Maximum
                    0x01,               // Alignment
                    0x08,               // Length
                    )
                DWordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x00000000,         // Granularity
                    0x00000D00,         // Range Minimum
                    0x0000FFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x0000F300,         // Length
                    ,, , TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000A0000,         // Range Minimum
                    0x000BFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00020000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C0000,         // Range Minimum
                    0x000C3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y00, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C4000,         // Range Minimum
                    0x000C7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y01, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C8000,         // Range Minimum
                    0x000CBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y02, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000CC000,         // Range Minimum
                    0x000CFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y03, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D0000,         // Range Minimum
                    0x000D3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y04, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D4000,         // Range Minimum
                    0x000D7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y05, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000D8000,         // Range Minimum
                    0x000DBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y06, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000DC000,         // Range Minimum
                    0x000DFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y07, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E0000,         // Range Minimum
                    0x000E3FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y08, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E4000,         // Range Minimum
                    0x000E7FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y09, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000E8000,         // Range Minimum
                    0x000EBFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y0A, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000EC000,         // Range Minimum
                    0x000EFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00004000,         // Length
                    ,, _Y0B, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000F0000,         // Range Minimum
                    0x000FFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00010000,         // Length
                    ,, _Y0C, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0xFEBFFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000000,         // Length
                    ,, _Y0E, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0xFED40000,         // Range Minimum
                    0xFED44FFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000000,         // Length
                    ,, _Y0D, AddressRangeMemory, TypeStatic)
            })
            Method (_CRS, 0, Serialized)
            {
                If (PM1L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y00._LEN, C0LN)
                    Store (Zero, C0LN)
                }

                If (LEqual (PM1L, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y00._RW, C0RW)
                    Store (Zero, C0RW)
                }

                If (PM1H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y01._LEN, C4LN)
                    Store (Zero, C4LN)
                }

                If (LEqual (PM1H, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y01._RW, C4RW)
                    Store (Zero, C4RW)
                }

                If (PM2L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y02._LEN, C8LN)
                    Store (Zero, C8LN)
                }

                If (LEqual (PM2L, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y02._RW, C8RW)
                    Store (Zero, C8RW)
                }

                If (PM2H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y03._LEN, CCLN)
                    Store (Zero, CCLN)
                }

                If (LEqual (PM2H, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y03._RW, CCRW)
                    Store (Zero, CCRW)
                }

                If (PM3L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y04._LEN, D0LN)
                    Store (Zero, D0LN)
                }

                If (LEqual (PM3L, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y04._RW, D0RW)
                    Store (Zero, D0RW)
                }

                If (PM3H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y05._LEN, D4LN)
                    Store (Zero, D4LN)
                }

                If (LEqual (PM3H, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y05._RW, D4RW)
                    Store (Zero, D4RW)
                }

                If (PM4L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y06._LEN, D8LN)
                    Store (Zero, D8LN)
                }

                If (LEqual (PM4L, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y06._RW, D8RW)
                    Store (Zero, D8RW)
                }

                If (PM4H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y07._LEN, DCLN)
                    Store (Zero, DCLN)
                }

                If (LEqual (PM4H, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y07._RW, DCRW)
                    Store (Zero, DCRW)
                }

                If (PM5L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y08._LEN, E0LN)
                    Store (Zero, E0LN)
                }

                If (LEqual (PM5L, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y08._RW, E0RW)
                    Store (Zero, E0RW)
                }

                If (PM5H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y09._LEN, E4LN)
                    Store (Zero, E4LN)
                }

                If (LEqual (PM5H, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y09._RW, E4RW)
                    Store (Zero, E4RW)
                }

                If (PM6L)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0A._LEN, E8LN)
                    Store (Zero, E8LN)
                }

                If (LEqual (PM6L, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y0A._RW, E8RW)
                    Store (Zero, E8RW)
                }

                If (PM6H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0B._LEN, ECLN)
                    Store (Zero, ECLN)
                }

                If (LEqual (PM6H, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y0B._RW, ECRW)
                    Store (Zero, ECRW)
                }

                If (PM0H)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0C._LEN, F0LN)
                    Store (Zero, F0LN)
                }

                If (LEqual (PM0H, One))
                {
                    CreateBitField (BUF0, \_SB.PCI0._Y0C._RW, F0RW)
                    Store (Zero, F0RW)
                }

                If (TPMP)
                {
                    CreateDWordField (BUF0, \_SB.PCI0._Y0D._LEN, TPML)
                    Store (0x5000, TPML)
                }

                CreateDWordField (BUF0, \_SB.PCI0._Y0E._MIN, M1MN)
                CreateDWordField (BUF0, \_SB.PCI0._Y0E._MAX, M1MX)
                CreateDWordField (BUF0, \_SB.PCI0._Y0E._LEN, M1LN)
                ShiftLeft (TLUD, 0x1B, M1MN)
                Add (Subtract (M1MX, M1MN), One, M1LN)
                Return (BUF0)
            }

            Method (_PRT, 0, NotSerialized)
            {
                If (GPIC) /* If (OS Interrupt Mode != PIC) */
                {
                    Return (Package (0x11)
                    {
                        Package (0x04)
                        {
                            0x0001FFFF, 
                            Zero, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x0002FFFF, 
                            Zero, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x0007FFFF, 
                            Zero, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x001BFFFF, 
                            Zero, 
                            Zero, 
                            0x16
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            Zero, 
                            Zero, 
                            0x11
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            One, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x02, 
                            Zero, 
                            0x12
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x03, 
                            Zero, 
                            0x13
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            Zero, 
                            Zero, 
                            0x17
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            One, 
                            Zero, 
                            0x13
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            0x02, 
                            Zero, 
                            0x12
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            0x03, 
                            Zero, 
                            0x10
                        }, 

                        Package (0x04)
                        {
                            0x001EFFFF, 
                            Zero, 
                            Zero, 
                            0x16
                        }, 

                        Package (0x04)
                        {
                            0x001EFFFF, 
                            One, 
                            Zero, 
                            0x14
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            Zero, 
                            Zero, 
                            0x12
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            One, 
                            Zero, 
                            0x13
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            0x03, 
                            Zero, 
                            0x10
                        }
                    })
                }
                Else /* OS Interrupt mode == PIC */
                {
                    Return (Package (0x11)
                    {
                        Package (0x04)
                        {
                            0x0001FFFF, 
                            Zero, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x0002FFFF, 
                            Zero, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x0007FFFF, 
                            Zero, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001BFFFF, 
                            Zero, 
                            ^LPCB.LNKG, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            Zero, 
                            ^LPCB.LNKB, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            One, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x02, 
                            ^LPCB.LNKC, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001CFFFF, 
                            0x03, 
                            ^LPCB.LNKD, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            Zero, 
                            ^LPCB.LNKH, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            One, 
                            ^LPCB.LNKD, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            0x02, 
                            ^LPCB.LNKC, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001DFFFF, 
                            0x03, 
                            ^LPCB.LNKA, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001EFFFF, 
                            Zero, 
                            ^LPCB.LNKG, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001EFFFF, 
                            One, 
                            ^LPCB.LNKE, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            Zero, 
                            ^LPCB.LNKC, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            One, 
                            ^LPCB.LNKD, 
                            Zero
                        }, 

                        Package (0x04)
                        {
                            0x001FFFFF, 
                            0x03, 
                            ^LPCB.LNKA, 
                            Zero
                        }
                    })
                }
            }

            Device (PDRC)
            {
                Name (_HID, EisaId ("PNP0C02"))
                Name (_UID, One)
                Name (BUF0, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0xE0000000,         // Address Base
                        0x10000000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED14000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED18000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED19000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED1C000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED20000,         // Address Base
                        0x00020000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED40000,         // Address Base
                        0x00005000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED45000,         // Address Base
                        0x0004B000,         // Address Length
                        )
                })
                Name (BUF1, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0xE0000000,         // Address Base
                        0x10000000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED14000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED18000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED19000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED1C000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED20000,         // Address Base
                        0x00020000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED45000,         // Address Base
                        0x0004B000,         // Address Length
                        )
                })
                Method (_CRS, 0, Serialized)
                {
                    If (LNot (TPMP))
                    {
                        Return (BUF0)
                    }

                    Return (BUF1)
                }
            }

            Device (GFX0)
            {
                Name (_ADR, 0x00020000)
                Method (_DOS, 1, NotSerialized)
                {
                    Store (And (Arg0, 0x03), DSEN)
                }

                Method (_DOD, 0, NotSerialized)
                {
                    Return (Package (0x02)
                    {
                        0x00010100, 
                        0x00010400
                    })
                }

                Device (LCD)
                {
                    Method (_ADR, 0, NotSerialized)
                    {
                        Return (0x0400)
                    }

                    Method (_DCS, 0, NotSerialized)
                    {
                        ^^^LPCB.PHSS (0x0C)
                        If (And (CSTE, 0x0808))
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        If (And (NSTE, 0x0808))
                        {
                            Return (One)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        If (LEqual (And (Arg0, 0xC0000000), 0xC0000000))
                        {
                            Store (NSTE, CSTE)
                        }
                    }

                    Method (_BCL, 0, NotSerialized)
                    {
                        Store (0xC0, P80H)
                        Return (Package (0x0A)
                        {
                            0x46, 
                            0x28, 
                            Zero, 
                            0x0A, 
                            0x14, 
                            0x1E, 
                            0x28, 
                            0x32, 
                            0x3C, 
                            0x46
                        })
                    }

                    Method (_BCM, 1, NotSerialized)
                    {
                        Divide (Arg0, 0x0A, Local0, Local1)
                        Store (Local1, ^^^LPCB.EC0.BRTS)
                    }

                    Method (_BQC, 0, NotSerialized)
                    {
                        Multiply (^^^LPCB.EC0.BRTS, 0x0A, Local0)
                        Return (Local0)
                    }
                }

                Device (CRT1)
                {
                    Name (_ADR, 0x0100)
                    Method (_DCS, 0, NotSerialized)
                    {
                        ^^^LPCB.PHSS (0x0C)
                        If (And (CSTE, 0x0101))
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        If (And (NSTE, 0x0101))
                        {
                            Return (One)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        If (LEqual (And (Arg0, 0xC0000000), 0xC0000000))
                        {
                            Store (NSTE, CSTE)
                        }
                    }
                }

                Method (DSSW, 0, NotSerialized)
                {
                    ^^LPCB.PHSS (0x0C)
                    DSSM ()
                }

                Method (DSSM, 0, NotSerialized)
                {
                    If (LEqual (Zero, DSEN))
                    {
                        Store (CADL, PADL)
                        If (LGreaterEqual (OSYS, 0x07D1))
                        {
                            Notify (PCI0, Zero)
                        }
                        Else
                        {
                            Notify (GFX0, Zero)
                        }

                        Sleep (0x03E8) /* LONG */
                        Notify (GFX0, 0x80)
                    }

                    If (LEqual (One, DSEN))
                    {
                        ^^LPCB.PHSS (One)
                        Notify (GFX0, 0x81)
                    }
                }

                Method (STBL, 1, NotSerialized)
                {
                    If (LEqual (And (Arg0, 0x07), Zero))
                    {
                        Store (0x0800, NSTE)
                    }
                    Else
                    {
                        If (LEqual (Arg0, One))
                        {
                            Store (0x0800, NSTE)
                        }

                        If (LEqual (Arg0, 0x02))
                        {
                            Store (One, NSTE)
                        }

                        If (LEqual (Arg0, 0x03))
                        {
                            Store (0x0801, NSTE)
                        }

                        If (LEqual (Arg0, 0x04))
                        {
                            Store (0x02, NSTE)
                        }

                        If (LEqual (Arg0, 0x05))
                        {
                            Store (0x0802, NSTE)
                        }

                        If (LEqual (Arg0, 0x06))
                        {
                            Store (0x03, NSTE)
                        }

                        If (LEqual (Arg0, 0x07))
                        {
                            Store (0x0803, NSTE)
                        }
                    }

                    DSSM ()
                }
            }

            /* HIDEF (?) */
            Device (HDEF)
            {
                Name (_ADR, 0x001B0000)
                Name (_PRW, Package (0x02)
                {
                    0x05, 
                    0x04
                })
            }

            Device (RP01)
            {
                Name (_ADR, 0x001C0000)
                OperationRegion (P1CS, PCI_Config, 0x40, 0x0100)
                Field (P1CS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x1A), 
                    ABP1,   1, 
                        ,   2, 
                    PDC1,   1, 
                        ,   2, 
                    PDS1,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSP1,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPCS,   1, /* Written & read by _GPE._L01 */
                    PMCS,   1
                }

                Device (PXS1)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (GPIC)
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                Zero, 
                                0x10
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                Zero, 
                                0x11
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                Zero, 
                                0x12
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                Zero, 
                                0x13
                            }
                        })
                    }
                    Else
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                ^^LPCB.LNKA, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                ^^LPCB.LNKB, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                ^^LPCB.LNKC, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                ^^LPCB.LNKD, 
                                Zero
                            }
                        })
                    }
                }
            }

            Device (RP02)
            {
                Name (_ADR, 0x001C0001)
                OperationRegion (P2CS, PCI_Config, 0x40, 0x0100)
                Field (P2CS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x1A), 
                    ABP2,   1, 
                        ,   2, 
                    PDC2,   1, 
                        ,   2, 
                    PDS2,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSP2,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPCS,   1, 
                    PMCS,   1
                }

                Device (PXS2)
                {
                    Name (_ADR, Zero)
                    Method (_RMV, 0, NotSerialized)
                    {
                        Return (Zero)
                    }

                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                    Name (_EJD, "\\_SB.PCI0.USB7.HUB7.PRT7")
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (GPIC)
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                Zero, 
                                0x11
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                Zero, 
                                0x12
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                Zero, 
                                0x13
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                Zero, 
                                0x10
                            }
                        })
                    }
                    Else
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                ^^LPCB.LNKB, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                ^^LPCB.LNKC, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                ^^LPCB.LNKD, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                ^^LPCB.LNKA, 
                                Zero
                            }
                        })
                    }
                }
            }

            Device (RP03)
            {
                Name (_ADR, 0x001C0002)
                OperationRegion (P3CS, PCI_Config, 0x40, 0x0100)
                Field (P3CS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x1A), 
                    ABP3,   1, 
                        ,   2, 
                    PDC3,   1, 
                        ,   2, 
                    PDS3,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSP3,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPCS,   1, 
                    PMCS,   1
                }

                Device (PXS3)
                {
                    Name (_ADR, Zero)
                    Method (_RMV, 0, NotSerialized)
                    {
                        Return (Zero)
                    }

                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                    Method (_PSW, 1, NotSerialized)
                    {
                        If (Arg0)
                        {
                            Store (One, ^^^LPCB.EC0.PWAK)
                        }
                        Else
                        {
                            Store (Zero, ^^^LPCB.EC0.PWAK)
                        }
                    }

                    Name (_EJD, "\\_SB.PCI0.USB7.HUB7.PRT5")
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (GPIC)
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                Zero, 
                                0x12
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                Zero, 
                                0x13
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                Zero, 
                                0x10
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                Zero, 
                                0x11
                            }
                        })
                    }
                    Else
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                ^^LPCB.LNKC, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                ^^LPCB.LNKD, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                ^^LPCB.LNKA, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                ^^LPCB.LNKB, 
                                Zero
                            }
                        })
                    }
                }
            }

            Device (RP04)
            {
                Name (_ADR, 0x001C0003)
                OperationRegion (P4CS, PCI_Config, 0x40, 0x0100)
                Field (P4CS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x1A), 
                    ABP4,   1, 
                        ,   2, 
                    PDC4,   1, 
                        ,   2, 
                    PDS4,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSP4,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPCS,   1, 
                    PMCS,   1
                }

                Device (PXS4)
                {
                    Name (_ADR, Zero)
                    Method (_RMV, 0, NotSerialized)
                    {
                        Return (One)
                    }

                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                    Name (_EJD, "\\_SB.PCI0.USB7.HUB7.PRT3")
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (GPIC)
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                Zero, 
                                0x13
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                Zero, 
                                0x10
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                Zero, 
                                0x11
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                Zero, 
                                0x12
                            }
                        })
                    }
                    Else
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                ^^LPCB.LNKD, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                ^^LPCB.LNKA, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                ^^LPCB.LNKB, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                ^^LPCB.LNKC, 
                                Zero
                            }
                        })
                    }
                }
            }

            Device (RP05)
            {
                Name (_ADR, 0x001C0004)
                OperationRegion (P5CS, PCI_Config, 0x40, 0x0100)
                Field (P5CS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x1A), 
                    ABP5,   1, 
                        ,   2, 
                    PDC5,   1, 
                        ,   2, 
                    PDS5,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSP5,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPCS,   1, 
                    PMCS,   1
                }

                Device (PXS5)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (GPIC)
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                Zero, 
                                0x10
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                Zero, 
                                0x11
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                Zero, 
                                0x12
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                Zero, 
                                0x13
                            }
                        })
                    }
                    Else
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                ^^LPCB.LNKA, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                ^^LPCB.LNKB, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                ^^LPCB.LNKC, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                ^^LPCB.LNKD, 
                                Zero
                            }
                        })
                    }
                }
            }

            Device (RP06)
            {
                Name (_ADR, 0x001C0005)
                OperationRegion (P6CS, PCI_Config, 0x40, 0x0100)
                Field (P6CS, AnyAcc, NoLock, WriteAsZeros)
                {
                            Offset (0x1A), 
                    ABP6,   1, 
                        ,   2, 
                    PDC6,   1, 
                        ,   2, 
                    PDS6,   1, 
                            Offset (0x20), 
                            Offset (0x22), 
                    PSP6,   1, 
                            Offset (0x9C), 
                        ,   30, 
                    HPCS,   1, 
                    PMCS,   1
                }

                Device (PXS6)
                {
                    Name (_ADR, Zero)
                    Name (_PRW, Package (0x02)
                    {
                        0x09, 
                        0x04
                    })
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (GPIC)
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                Zero, 
                                0x11
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                Zero, 
                                0x12
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                Zero, 
                                0x13
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                Zero, 
                                0x10
                            }
                        })
                    }
                    Else
                    {
                        Return (Package (0x04)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                ^^LPCB.LNKB, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                ^^LPCB.LNKC, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                ^^LPCB.LNKD, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                ^^LPCB.LNKA, 
                                Zero
                            }
                        })
                    }
                }
            }

            Device (USB1)
            {
                Name (_ADR, 0x001D0000)
                OperationRegion (U1CS, PCI_Config, 0xC4, 0x04)
                Field (U1CS, DWordAcc, NoLock, Preserve)
                {
                    U1EN,   2
                }

                Name (_PRW, Package (0x02)
                {
                    0x03, 
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (One, U1EN)
                        Store (One, ^^LPCB.EC0.UWAK)
                    }
                    Else
                    {
                        Store (Zero, U1EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }
            }

            Device (USB2)
            {
                Name (_ADR, 0x001D0001)
                OperationRegion (U2CS, PCI_Config, 0xC4, 0x04)
                Field (U2CS, DWordAcc, NoLock, Preserve)
                {
                    U2EN,   2
                }

                Name (_PRW, Package (0x02)
                {
                    0x04, 
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U2EN)
                        Store (One, ^^LPCB.EC0.UWAK)
                    }
                    Else
                    {
                        Store (Zero, U2EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }
            }

            Device (USB3)
            {
                Name (_ADR, 0x001D0002)
                OperationRegion (U2CS, PCI_Config, 0xC4, 0x04)
                Field (U2CS, DWordAcc, NoLock, Preserve)
                {
                    U3EN,   2
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x03, U3EN)
                        Store (One, ^^LPCB.EC0.UWAK)
                    }
                    Else
                    {
                        Store (Zero, U3EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }
            }

            Device (USB4)
            {
                Name (_ADR, 0x001D0003)
                OperationRegion (U4CS, PCI_Config, 0xC4, 0x04)
                Field (U4CS, DWordAcc, NoLock, Preserve)
                {
                    U4EN,   2
                }

                Name (_PRW, Package (0x02)
                {
                    0x0E, 
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x02, U4EN)
                        Store (One, ^^LPCB.EC0.UWAK)
                    }
                    Else
                    {
                        Store (Zero, U4EN)
                    }
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Method (_S4D, 0, NotSerialized)
                {
                    Return (0x02)
                }
            }

            Device (USB7)
            {
                Name (_ADR, 0x001D0007)
                Name (_PRW, Package (0x02)
                {
                    0x0D, 
                    0x03
                })
                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (One, ^^LPCB.EC0.UWAK)
                    }
                }
            }

            Scope (USB1)
            {
                Device (RHUB)
                {
                    Name (_ADR, Zero)
                    Device (USBB)
                    {
                        Name (_ADR, 0x02)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }
                }
            }

            Scope (USB2)
            {
                Device (RHUB)
                {
                    Name (_ADR, Zero)
                    Device (USBB)
                    {
                        Name (_ADR, 0x02)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }
                }
            }

            Scope (USB3)
            {
                Device (RHUB)
                {
                    Name (_ADR, Zero)
                    Device (USBA)
                    {
                        Name (_ADR, One)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }

                    Device (USBB)
                    {
                        Name (_ADR, 0x02)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }
                }
            }

            Scope (USB4)
            {
                Device (RHUB)
                {
                    Name (_ADR, Zero)
                    Device (USBA)
                    {
                        Name (_ADR, One)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }
                }
            }

            Scope (USB7)
            {
                Device (RHUB)
                {
                    Name (_ADR, Zero)
                    Device (USBB)
                    {
                        Name (_ADR, 0x02)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }

                    Device (USBD)
                    {
                        Name (_ADR, 0x04)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }

                    Device (USBE)
                    {
                        Name (_ADR, 0x05)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }

                    Device (USBF)
                    {
                        Name (_ADR, 0x06)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }

                    Device (USBG)
                    {
                        Name (_ADR, 0x07)
                        Name (_UPC, Package (0x04)
                        {
                            0xFF, 
                            0xFF, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Buffer (0x10)
                        {
                            0x81, 0x00, 0x30, 0x00
                        })
                    }
                }
            }

            Device (PCIB)
            {
                Name (_ADR, 0x001E0000)
                Method (_PRT, 0, NotSerialized)
                {
                    If (GPIC)
                    {
                        Return (Package (0x15)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                Zero, 
                                0x15
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                Zero, 
                                0x16
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                Zero, 
                                0x17
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                Zero, 
                                0x14
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                Zero, 
                                Zero, 
                                0x16
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                One, 
                                Zero, 
                                0x15
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                0x02, 
                                Zero, 
                                0x14
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                0x03, 
                                Zero, 
                                0x17
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                Zero, 
                                Zero, 
                                0x12
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                One, 
                                Zero, 
                                0x13
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                0x02, 
                                Zero, 
                                0x11
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                0x03, 
                                Zero, 
                                0x10
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                Zero, 
                                Zero, 
                                0x13
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                One, 
                                Zero, 
                                0x12
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                0x02, 
                                Zero, 
                                0x15
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                0x03, 
                                Zero, 
                                0x16
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                Zero, 
                                Zero, 
                                0x11
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                One, 
                                Zero, 
                                0x14
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                0x02, 
                                Zero, 
                                0x16
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                0x03, 
                                Zero, 
                                0x15
                            }, 

                            Package (0x04)
                            {
                                0x0008FFFF, 
                                Zero, 
                                Zero, 
                                0x14
                            }
                        })
                    }
                    Else
                    {
                        Return (Package (0x15)
                        {
                            Package (0x04)
                            {
                                0xFFFF, 
                                Zero, 
                                ^^LPCB.LNKF, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                One, 
                                ^^LPCB.LNKG, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x02, 
                                ^^LPCB.LNKH, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0xFFFF, 
                                0x03, 
                                ^^LPCB.LNKE, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                Zero, 
                                ^^LPCB.LNKG, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                One, 
                                ^^LPCB.LNKF, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                0x02, 
                                ^^LPCB.LNKE, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0001FFFF, 
                                0x03, 
                                ^^LPCB.LNKH, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                Zero, 
                                ^^LPCB.LNKC, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                One, 
                                ^^LPCB.LNKD, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                0x02, 
                                ^^LPCB.LNKB, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0002FFFF, 
                                0x03, 
                                ^^LPCB.LNKA, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                Zero, 
                                ^^LPCB.LNKD, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                One, 
                                ^^LPCB.LNKC, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                0x02, 
                                ^^LPCB.LNKF, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0003FFFF, 
                                0x03, 
                                ^^LPCB.LNKG, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                Zero, 
                                ^^LPCB.LNKB, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                One, 
                                ^^LPCB.LNKE, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                0x02, 
                                ^^LPCB.LNKG, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0005FFFF, 
                                0x03, 
                                ^^LPCB.LNKF, 
                                Zero
                            }, 

                            Package (0x04)
                            {
                                0x0008FFFF, 
                                Zero, 
                                ^^LPCB.LNKE, 
                                Zero
                            }
                        })
                    }
                }
            }

            Device (AUD0)
            {
                Name (_ADR, 0x001E0002)
            }

            Device (MODM)
            {
                Name (_ADR, 0x001E0003)
                Name (_PRW, Package (0x02)
                {
                    0x05, 
                    0x04
                })
            }

            Device (LPCB)
            {
                Name (_ADR, 0x001F0000)
                OperationRegion (LPC0, PCI_Config, 0x40, 0xC0)
                Field (LPC0, AnyAcc, NoLock, Preserve)
                {
                            Offset (0x20), 
                    PARC,   8, 
                    PBRC,   8, 
                    PCRC,   8, 
                    PDRC,   8, 
                            Offset (0x28), 
                    PERC,   8, 
                    PFRC,   8, 
                    PGRC,   8, 
                    PHRC,   8, 
                            Offset (0x40), 
                    IOD0,   8, 
                    IOD1,   8, 
                    IOE0,   8, 
                    IOE1,   8
                }

                /* AC Adapter */
                Device (ACAD)
                {
                    Name (_HID, "ACPI0003")
                    Name (_PCL, Package (0x01)
                    {
                        _SB
                    })
                    Method (_PSR, 0, NotSerialized)
                    {
                        If (ECOK ())
                        {
                            Return (^^EC0.ADPT)
                        }
                        Else
                        {
                            Return (One)
                        }
                    }
                }

                Device (LNKA)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, One)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PARC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLA, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLA, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PARC, 0x0F), IRQ0)
                        Return (RTLA)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PARC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PARC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKB)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x02)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PBRC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLB, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLB, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PBRC, 0x0F), IRQ0)
                        Return (RTLB)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PBRC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PBRC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKC)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x03)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PCRC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLC, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLC, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PCRC, 0x0F), IRQ0)
                        Return (RTLC)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PCRC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PCRC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKD)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x04)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PDRC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLD, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLD, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PDRC, 0x0F), IRQ0)
                        Return (RTLD)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PDRC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PDRC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKE)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x05)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PERC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLE, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLE, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PERC, 0x0F), IRQ0)
                        Return (RTLE)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PERC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PERC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKF)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x06)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PFRC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLF, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLF, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PFRC, 0x0F), IRQ0)
                        Return (RTLF)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PFRC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PFRC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKG)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x07)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PGRC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,10,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLG, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLG, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PGRC, 0x0F), IRQ0)
                        Return (RTLG)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PGRC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PGRC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Device (LNKH)
                {
                    Name (_HID, EisaId ("PNP0C0F"))
                    Name (_UID, 0x08)
                    Method (_DIS, 0, Serialized)
                    {
                        Store (0x80, PHRC)
                    }

                    Name (_PRS, ResourceTemplate ()
                    {
                        IRQ (Level, ActiveLow, Shared, )
                            {1,3,4,5,6,7,11,12,14,15}
                    })
                    Method (_CRS, 0, Serialized)
                    {
                        Name (RTLH, ResourceTemplate ()
                        {
                            IRQ (Level, ActiveLow, Shared, )
                                {}
                        })
                        CreateWordField (RTLH, One, IRQ0)
                        Store (Zero, IRQ0)
                        ShiftLeft (One, And (PHRC, 0x0F), IRQ0)
                        Return (RTLH)
                    }

                    Method (_SRS, 1, Serialized)
                    {
                        CreateWordField (Arg0, One, IRQ0)
                        FindSetRightBit (IRQ0, Local0)
                        Decrement (Local0)
                        Store (Local0, PHRC)
                    }

                    Method (_STA, 0, Serialized)
                    {
                        If (And (PHRC, 0x80))
                        {
                            Return (0x09)
                        }
                        Else
                        {
                            Return (0x0B)
                        }
                    }
                }

                Method (ECOK, 0, NotSerialized)
                {
                    If (LEqual (^EC0.Z009, One))
                    {
                        Return (One)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                OperationRegion (LPEC, SystemIO, 0xFF2C, 0x04)
                Field (LPEC, ByteAcc, NoLock, Preserve)
                {
                    ECFA,   8, 
                    ECFB,   16, 
                    ECFD,   8
                }

                Mutex (PHMX, 0x00)

                /* PHeonix Memory Read??
                    Called by
                    EC0._REG:
                        Store (PHMR (0xA3F4), Local0)
                 */
                Method (PHMR, 1, NotSerialized)
                {
                    Acquire (PHMX, 0xFFFF)
                    If (LNotEqual (STPH, 0xAA))
                    {
                        Store (Arg0, ECFB)
                        Store (ECFD, Local0)
                        Store (0x23F4, ECFB)
                    }
                    Else
                    {
                        Store (Zero, Local0)
                    }

                    Release (PHMX)
                    Return (Local0)
                }

                /* PHeonix Memory Write??
                    Called by
                    EC0._REG :
                */
                Method (PHMW, 2, NotSerialized)
                {
                    Acquire (PHMX, 0xFFFF)
                    If (LNotEqual (STPH, 0xAA))
                    {
                        Store (Arg0, ECFB)
                        Store (Arg1, ECFD)
                        Store (0x23F4, ECFB)
                    }

                    Release (PHMX)
                    Return (Arg1)
                }

                /* Embedded controller */
                Device (EC0)
                {
                    Name (_HID, EisaId ("PNP0C09"))
                    Name (_GPE, 0x19)
                    Name (Z009, Zero) /* Checked to determine if "OK" */
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0062,             // Range Minimum
                            0x0062,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0066,             // Range Minimum
                            0x0066,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                    })
                    Method (_REG, 2, NotSerialized)
                    {
                        If (LEqual (Arg0, 0x03))
                        {
                            Store (Arg1, Z009)
                            Store (One, ECRD)
                            Store (PHMR (0xA3F4), Local0)
                            And (Local0, 0xF8, Local0)
                            If (LEqual (LINX, One))
                            {
                                Or (Local0, 0x02, Local0)
                                PHMW (0xA3F4, Local0)
                                If (BTSW)
                                {
                                    ^BT.BTPO ()
                                }
                            }
                            Else
                            {
                                If (LGreaterEqual (OSYS, 0x07D9))
                                {
                                    Or (Local0, 0x03, Local0)
                                    PHMW (0xA3F4, Local0)
                                }
                                Else
                                {
                                    If (LGreaterEqual (OSYS, 0x07D6))
                                    {
                                        Or (Local0, One, Local0)
                                        PHMW (0xA3F4, Local0)
                                        Store (One, OSTY)
                                    }
                                    Else
                                    {
                                        If (LLess (OSYS, 0x07D6))
                                        {
                                            If (LNotEqual (OSYS, Zero))
                                            {
                                                PHMW (0xA3F4, Local0)
                                                Store (Zero, OSTY)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Method (WTTA, 6, NotSerialized)
                    {
                        Return (^^^^VALZ.SPFC (Arg0, Arg1, Arg2, Arg3, Arg4, Arg5))
                    }

                    OperationRegion (ERAM, EmbeddedControl, Zero, 0xFF)
                    Field (ERAM, ByteAcc, Lock, Preserve)
                    {
                        /* Bluetooth? */
                        BTDT,   1, 
                        BTPW,   1, 
                        BTDS,   1, 
                        BTPS,   1, 
                        BTSW,   1, /* If One, BT.BTPO is called */
                        BTWK,   1, 
                        WMXD,   1, 
                        WMXS,   1, 
                        FNSF,   2, 

                        /* 3G modem? */
                        ID3G,   1, 
                        UWBI,   1, 
                            ,   1, 
                        PW3G,   1, 
                        UWBP,   1, 
                        /* */
                                Offset (0x02), 
                        ECRD,   1, 
                                Offset (0x04), 
                            ,   1, 
                        NTMP,   1, 
                        NTHT,   1, 
                                Offset (0x05), 
                        HKEV,   1, 
                        HKHS,   1, 
                            ,   1, 
                        LEDO,   1, /* LED: ?? */
                        CIRF,   1, 
                        KBST,   1, 
                                Offset (0x06), 
                        FANP,   8, 
                        CLME,   1, 
                                Offset (0x08), 
                        IRX0,   1, 
                        IRX1,   1, 
                        CECS,   1, 
                        HDCS,   1, 
                        HDPO,   1, 
                            ,   2, 
                        BSCC,   1, 
                        CECE,   16, 
                        WFAT,   8, 
                                Offset (0x0D), 
                        CNFR,   3, 
                                Offset (0x0E), 
                        SNDS,   8, 
                        REVS,   8, 
                                Offset (0x20), 
                        CMID,   8, 
                        PANB,   8, 
                        PAE1,   32, 
                        PAE2,   32, 
                        PAE3,   32, 
                        PAE4,   32, 
                                Offset (0x60), 
                        SMPR,   8, 
                        SMST,   8, 
                        SMAD,   8, 
                        SMCM,   8, 
                        SMD0,   256, 
                        BCNT,   8, 
                        SMAA,   24, 
                                Offset (0x90), 
                                Offset (0x91), 
                                Offset (0x92), 
                            ,   2, 
                        OSTY,   2, 
                                Offset (0x93), 
                                Offset (0x94), 
                        ENIB,   16, 
                        ENDD,   8, 
                        SCAC,   1, 
                        SCDC,   1, 
                        SCAD,   1, 
                        UWAK,   1, 
                        SLCP,   1, 
                                Offset (0x98), 
                        SCBL,   8, 
                                Offset (0x9A), 
                        BAL0,   1, 
                        BAL1,   1, 
                        BAL2,   1, 
                        BAL3,   1, 
                        BBC0,   1, 
                        BBC1,   1, 
                        BBC2,   1, 
                        BBC3,   1, 
                                Offset (0x9C), 
                        PHDD,   1, 
                        IFDD,   1, 
                        IODD,   1, 
                        SHDD,   1, 
                        S120,   1, 
                        EFDD,   1, 
                        CRTD,   1, 
                        SPWR,   1, 
                        SBTN,   1, 
                        VIDO,   1, 
                        VOLD,   1, 
                        VOLU,   1, 
                        MUTE,   1, 
                        HKMD,   1, 
                                Offset (0x9E), 
                        S4ST,   1, 
                        SKEY,   1, 
                        BKEY,   1, 
                        TOUP,   1, 
                        FNBN,   1, 
                            ,   1, 
                        DIGM,   1, 
                                Offset (0x9F), 
                            ,   1, 
                        LIDF,   1, 
                                Offset (0xA0), 
                        DKSP,   1, 
                        DKIN,   1, 
                        DKID,   1, 
                        DKOK,   1, 
                                Offset (0xA1), 
                        DKPW,   1, 
                                Offset (0xA2), 
                        BTNS,   8, 
                        S1LD,   1, 
                        S3LD,   1, 
                        VGAQ,   1, 
                        PCMQ,   1, 
                        PCMR,   1, 
                        ADPT,   1, 
                        SLLS,   1, 
                        SYS7,   1, 
                        PWAK,   1, 
                        MWAK,   1, 
                        LWAK,   1, 
                            ,   1, 
                        WLED,   1, /* LED: wireless? */
                                Offset (0xA5), 
                                Offset (0xAA), 
                        TCNL,   8, 
                        TMPI,   8, 
                        TMSD,   8, 
                        FASN,   4, 
                        FASU,   4, 
                        PCVL,   4, 
                            ,   2, 
                        SWTO,   1, 
                        HWTO,   1, 
                        MODE,   1, 
                        FANS,   2, 
                        INIT,   1, 
                        FAN1,   1, 
                        FAN2,   1, 
                        FANT,   1, 
                        SKNM,   1, 
                        CTMP,   8, 
                        LIDE,   1, 
                        PMEE,   1, 
                        PWBE,   1, 
                        RNGE,   1, 
                        BTWE,   1, 
                        DCKE,   1, 
                                Offset (0xB2), 
                        SKTA,   8, 
                        SKTB,   8, 
                        SKTC,   8, 
                        TDCB,   8, 
                        TOHK,   16, 
                                Offset (0xB9), 
                        BRTS,   8, 
                        CNTS,   8, 
                        WLAT,   1, 
                        BTAT,   1, 
                        WLEX,   1, 
                        BTEX,   1, 
                        KLSW,   1, 
                        WLOK,   1, 
                                Offset (0xBC), 
                        PTID,   8, 
                        CPUT,   8, 
                        HAPL,   2, 
                        HAPR,   1, 
                                Offset (0xBF), 
                        GHID,   8, 
                            ,   4, 
                        BMF0,   3,  // Bat. ??
                        BTY0,   1,  // Bat. Type (--)
                        BST0,   8,  // Bat. Status (r-)
                        BRC0,   16, // Bat. Remaining Capacity (r-)
                        BSN0,   16, // Bat. Serial Number   (--)
                        BPV0,   16, // Bat. Present Voltage (r-)
                        BDV0,   16, // Bat. Design Voltage  (r-)
                        BDC0,   16, // Bat. Design Capacity (r-)
                        BFC0,   16, // Bat. Full Capacity?
                        GAU0,   8,  // Bat. ????
                        CYC0,   8, 
                        BPC0,   16, 
                        BAC0,   16, // Bat. ??
                        BAT0,   8,  // Bat. ??
                        BTW0,   16, // ??
                                Offset (0xDE), 
                        BSSB,   16, 
                            ,   4, 
                        BMF1,   3, 
                        BTY1,   1, 
                        BST1,   8, // Bat. Status (rw, written from BST0)
                                Offset (0xE3), 
                        BCV1,   16, 
                        BCV2,   16, 
                        BCV3,   16, 
                        BCV4,   16, 
                                Offset (0xF0), 
                                Offset (0xF4), 
                        MFDE,   16, 
                                Offset (0xF8), 
                        BDN0,   8
                    }

                    Method (_Q13, 0, NotSerialized)
                    {
                        Store (^^^^HAPS.ECPT, HAPL)
                        If (^^^^HAPS.ECRS)
                        {
                            Store (^^^^HAPS.ECRS, HAPR)
                        }
                    }

                    Method (_Q19, 0, NotSerialized)
                    {
                        Store ("=====QUERY_19=====", Debug)
                        Notify (BT, 0x80)
                    }

                    Method (_Q1A, 0, NotSerialized)
                    {
                        Store ("=====QUERY_1A=====", Debug)
                        Notify (BT, 0x90)
                    }

                    Method (_Q1C, 0, NotSerialized)
                    {
                        Store ("=====QUERY_1C=====", Debug)
                        If (VIDO)
                        {
                            If (IGDS)
                            {
                                ^^^GFX0.DSSW ()
                            }
                            Else
                            {
                            }

                            Store (Zero, VIDO)
                        }
                    }

                    Method (_Q1D, 0, NotSerialized)
                    {
                        Store ("=====QUERY_1D=====", Debug)
                        PCLK ()
                    }

                    Method (_Q1E, 0, NotSerialized)
                    {
                        Store ("=====QUERY_1E=====", Debug)
                        PCLK ()
                    }

                    Method (_Q22, 0, NotSerialized)
                    {
                        Store ("=====QUERY_22=====", Debug)
                        Sleep (0x03E8)
                        Notify (BAT1, 0x80)
                    }

                    Method (_Q23, 0, NotSerialized)
                    {
                        Store ("=====QUERY_23=====", Debug)
                        Sleep (0x03E8)
                        Notify (BAT1, 0x80)
                    }

                    Method (_Q25, 0, NotSerialized)
                    {
                        Store ("=====QUERY_25=====", Debug)
                        Sleep (0x03E8)
                        Notify (BAT1, 0x81)
                        Sleep (0x03E8)
                        Notify (BAT1, 0x80)
                    }

                    Method (_Q34, 0, NotSerialized)
                    {
                        Store ("=====QUERY_34=====", Debug)
                        If (BKEY)
                        {
                            PHSS (0x71)
                            Store (Zero, BKEY)
                        }
                    }

                    Method (_Q37, 0, NotSerialized)
                    {
                        Store ("=====QUERY_37=====", Debug)
                        PHSS (0x0D)
                        Notify (ACAD, 0x80)
                        Sleep (0x03E8)
                        Notify (BAT1, 0x80)
                    }

                    Method (_Q38, 0, NotSerialized)
                    {
                        Store ("=====QUERY_38=====", Debug)
                        PHSS (0x0D)
                        Notify (ACAD, 0x80)
                        Sleep (0x03E8)
                        Notify (BAT1, 0x80)
                    }

                    Mutex (CECQ, 0x00)
                    Method (_Q50, 0, NotSerialized)
                    {
                        Store (CECE, Local0)
                        Store (Zero, CECE)
                        Acquire (CECQ, 0xFFFF)
                        If (LEqual (Local0, 0x1500))
                        {
                            Store (CMID, CCMD)
                            Store (PANB, CCMN)
                            Store (PAE1, CCM1)
                            Store (PAE2, CCM2)
                            Store (PAE3, CCM3)
                            Store (PAE4, CCM4)
                        }
                        Else
                        {
                            If (LEqual (Local0, 0x1501))
                            {
                                Store (PANB, CMEN)
                                Store (PAE1, CME1)
                                Store (PAE2, CME2)
                                Store (PAE3, CME3)
                                Store (PAE4, CME4)
                            }
                            Else
                            {
                                If (LEqual (Local0, 0x1502))
                                {
                                    Store (CMID, CEVD)
                                    Store (PANB, CEVN)
                                    Store (PAE1, CEV1)
                                    Store (PAE2, CEV2)
                                    Store (PAE3, CEV3)
                                }
                            }
                        }

                        Store (Local0, CEEV)
                        Store (One, ^^^^VALZ.CECF)
                        Notify (VALZ, 0x80)
                        Release (CECQ)
                    }

                    Method (_Q64, 0, NotSerialized)
                    {
                        Store (0x80, P80H)
                        Notify (HAPS, 0x80)
                    }

                    Method (_Q65, 0, NotSerialized)
                    {
                        Store (0x81, P80H)
                        Notify (HAPS, 0x81)
                    }

                    Method (_Q66, 0, NotSerialized)
                    {
                        Store (0x66, P80H)
                        PHSS (0x90)
                        Store (DTST, TDCB)
                    }

                    Method (_Q11, 0, NotSerialized)
                    {
                        Store (0x87, P80H)
                        If (IGDS)
                        {
                            Notify (^^^GFX0.LCD, 0x87)
                        }
                        Else
                        {
                        }

                        Notify (VALZ, 0x80)
                    }

                    Method (_Q12, 0, NotSerialized)
                    {
                        Store (0x86, P80H)
                        If (IGDS)
                        {
                            Notify (^^^GFX0.LCD, 0x86)
                        }
                        Else
                        {
                        }

                        Notify (VALZ, 0x80)
                    }

                    Method (_Q43, 0, NotSerialized)
                    {
                        Notify (VALZ, 0x80)
                    }

                    Device (BT)
                    {
                        Name (_HID, "TOS6205")
                        Method (_STA, 0, NotSerialized)
                        {
                            If (BTEN)
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (0x0F)
                            }
                        }

                        Method (DUSB, 0, NotSerialized)
                        {
                            Store (Zero, BTDT)
                        }

                        Method (AUSB, 0, NotSerialized)
                        {
                            Store (One, BTDT)
                        }

                        /* BlueTooth Power On (?)
                         * Called if LINX is One by _WAK */
                        Method (BTPO, 0, NotSerialized)
                        {
                            Store (One, BTPW)
                            Store (Zero, BTPR)
                            Sleep (0xC8)
                            Store (One, BTRS)
                        }

                        /* BlueTooth Power ofF (?)
                         */
                        Method (BTPF, 0, NotSerialized)
                        {
                            Store (Zero, BTPW)
                            Store (Zero, BTRS)
                            Store (One, BTPR)
                        }

                        Method (BTST, 0, NotSerialized)
                        {
                            Store (BTSW, Local3)
                            If (Local3)
                            {
                                ShiftLeft (BTDT, 0x06, Local0)
                                ShiftLeft (BTPW, 0x07, Local1)
                            }
                            Else
                            {
                                Store (Zero, BTDT)
                                Store (Zero, BTPW)
                                Store (Zero, BTRS)
                                Store (One, BTPR)
                                Store (Zero, Local0)
                                Store (Zero, Local1)
                            }

                            Or (Local0, Local1, Local2)
                            Or (Local2, Local3, Local2)
                            Return (Local2)
                        }
                    }

                    OperationRegion (CCLK, SystemIO, 0x1010, 0x04)
                    Field (CCLK, DWordAcc, NoLock, Preserve)
                    {
                            ,   1, 
                        DUTY,   3, /* Read by THRO */
                        THEN,   1, /* Read by THRO, CLCK, PCLK */
                                Offset (0x01), 
                        FTT,    1, /* CLCK, PCLK */
                            ,   8, 
                        TSTS,   1
                    }

                    OperationRegion (ECRM, EmbeddedControl, Zero, 0xFF)
                    Field (ECRM, ByteAcc, Lock, Preserve)
                    {
                                Offset (0x94), 
                        ERIB,   16, /* Written by FANG Arg0 and FANW Arg0 */
                        ERBD,   8,  /* Read and returned by FANG,
                                       Written by FANW Arg1. */
                                Offset (0xAC), 
                        SDTM,   8, 
                        FSSN,   4, 
                        FANU,   4, 
                        PTVL,   3, 
                            ,   4, 
                        TTHR,   1, /* Read by THRO */
                                Offset (0xBC), 
                        PJID,   8, 
                                Offset (0xBE), 
                                Offset (0xF9), 
                        RFRD,   16
                    }

                    Mutex (FAMX, 0x00)

                    /* Fan:  ??
                       Arg0: ??
                       Return: ??

                       Not called by internal.
                    */
                    Method (FANG, 1, NotSerialized)
                    {
                        Acquire (FAMX, 0xFFFF)
                        Store (Arg0, ERIB)
                        Store (ERBD, Local0)
                        Release (FAMX)
                        Return (Local0)
                    }

                    /* Fan: ??
                       Arg0: ??
                       Arg1: ??
                       Return: ??

                       Not called by internal.
                    */
                    Method (FANW, 2, NotSerialized)
                    {
                        Acquire (FAMX, 0xFFFF)
                        Store (Arg0, ERIB)
                        Store (Arg1, ERBD)
                        Release (FAMX)
                        Return (Arg1)
                    }

                    /* Not called by internal. */
                    Method (TUVR, 1, NotSerialized)
                    {
                        Return (0x03)
                    }

                    /* Not called by internal. */
                    Method (THRO, 1, NotSerialized)
                    {
                        If (LEqual (Arg0, Zero))
                        {
                            Return (THEN) /* CCLK reg. */
                        }
                        Else
                        {
                            If (LEqual (Arg0, One))
                            {
                                Return (DUTY) /* CCLK reg. */
                            }
                            Else
                            {
                                If (LEqual (Arg0, 0x02))
                                {
                                    Return (TTHR) /* EC */
                                }
                                Else
                                {
                                    /* Some type of failure
                                    indication */
                                    Return (0xFF)
                                }
                            }
                        }
                    }

                    /* CLCK:  */
                    /* Arg0: New DUTY value */
                    Method (CLCK, 1, NotSerialized)
                    {
                        If (LEqual (Arg0, Zero))
                        {
                            Store (Zero, THEN) /* CCLK */
                            Store (Zero, FTT)  /* CCLK */
                        }
                        Else
                        {
                            Store (Arg0, DUTY) /* CCLK */
                            Store (One, THEN)  /* CCLK */
                        }

                        Return (THEN) /* CCLK */
                    }

                    Method (PCLK, 0, NotSerialized)
                    {
                        Store (PTVL, Local0)
                        If (LEqual (Local0, Zero))
                        {
                            Store (Zero, THEN) /* CCLK */
                            Store (Zero, FTT)  /* CCLK */
                        }
                        Else
                        {
                            Decrement (Local0)
                            Store (Not (Local0), Local1)
                            And (Local1, 0x07, Local1)
                            Store (Local1, DUTY)
                            Store (One, THEN)
                        }
                    }

                    Method (EKVR, 0, NotSerialized)
                    {
                        Return (One)
                    }

                    Name (CSTT, Package (0x08)
                    {
                        Zero, 
                        One, 
                        0x02, 
                        0x03, 
                        0x04, 
                        0x05, 
                        0x06, 
                        0x07
                    })
                    Name (CADT, Package (0x08)
                    {
                        Zero, 
                        0x10, 
                        0x20, 
                        0x30, 
                        0x40, 
                        0x50, 
                        0x60, 
                        0x70
                    })
                    Method (DOSS, 0, NotSerialized)
                    {
                        PHSS (0x0C)
                        Name (DSPY, Zero)
                        If (And (CSTE, 0x08))
                        {
                            Or (DSPY, One, DSPY)
                        }

                        If (And (CSTE, One))
                        {
                            Or (DSPY, 0x02, DSPY)
                        }

                        If (And (CSTE, 0x02))
                        {
                            If (LNot (IGDS))
                            {
                                Or (DSPY, 0x04, DSPY)
                            }
                        }

                        If (And (CSTE, 0x80))
                        {
                            Or (DSPY, 0x08, DSPY)
                        }

                        If (And (CSTE, 0x04))
                        {
                            Or (DSPY, 0x0100, DSPY)
                        }

                        If (And (CADL, 0x08))
                        {
                            Or (DSPY, 0x10, DSPY)
                        }

                        If (And (CADL, One))
                        {
                            Or (DSPY, 0x20, DSPY)
                        }

                        If (And (CADL, 0x02))
                        {
                            If (LNot (IGDS))
                            {
                                Or (DSPY, 0x40, DSPY)
                            }
                        }

                        If (And (CADL, 0x04))
                        {
                            Or (DSPY, 0x1000, DSPY)
                        }

                        Return (DSPY)
                    }

                    Method (DOSW, 1, NotSerialized)
                    {
                        If (IGDS)
                        {
                            And (Arg0, 0x0100, Local0)
                            If (Local0)
                            {
                                Or (Arg0, 0x08, Arg0)
                            }

                            And (Arg0, 0x0F, Arg0)
                            ^^^GFX0.STBL (Arg0)
                        }
                        Else
                        {
                        }

                        Return (One)
                    }

                    Method (ANTW, 1, NotSerialized)
                    {
                        Store (ShiftRight (And (Arg0, One), Zero, Local0), WLAT)
                        Store (ShiftRight (And (Arg0, 0x02), One, Local1), BTAT)
                        Store (ShiftRight (And (Arg0, 0x04), 0x02, Local2), PW3G)
                        Store (ShiftRight (And (Arg0, 0x08), 0x03, Local2), WMXS)
                        Return (One)
                    }

                    Method (ANTR, 0, NotSerialized)
                    {
                        Store (Zero, Local1)
                        Or (ShiftLeft (WLAT, Zero, Local0), Local1, Local1)
                        Or (ShiftLeft (BTAT, One, Local0), Local1, Local1)
                        Or (ShiftLeft (WLEX, 0x02, Local0), Local1, Local1)
                        Or (ShiftLeft (BTEX, 0x03, Local0), Local1, Local1)
                        Or (ShiftLeft (KLSW, 0x04, Local0), Local1, Local1)
                        Or (ShiftLeft (ID3G, 0x05, Local0), Local1, Local1)
                        Or (ShiftLeft (PW3G, 0x06, Local0), Local1, Local1)
                        Or (ShiftLeft (WMXD, 0x07, Local0), Local1, Local1)
                        Or (ShiftLeft (WMXS, 0x08, Local0), Local1, Local1)
                        Return (Local1)
                    }

                    Method (TPAF, 2, NotSerialized)
                    {
                        Store (Arg0, PPCA)
                        Store (Arg1, PPCD)
                        OPPC ()
                        Notify (\_PR.CPU0, 0x80)
                        Notify (\_PR.CPU1, 0x80)
                        Return (Arg0)
                    }

                    Scope (\_SB)
                    {
                        Name (PPCA, Zero)
                        Name (PPCD, Zero)
                        Method (OPPC, 0, NotSerialized)
                        {
                            If (LEqual (^PCI0.LPCB.ACAD._PSR (), Zero))
                            {
                                Store (PPCD, \_PR.CPU0._PPC)
                            }
                            Else
                            {
                                Store (PPCA, \_PR.CPU0._PPC)
                            }
                        }
                    }

                    Method (NTFY, 0, NotSerialized)
                    {
                        Store (One, ^^^^VALZ.TECF)
                        Notify (VALZ, 0x80)
                        Return (0xAA)
                    }

                    /* System Bus */
                    Scope (\_SB)
                    {

                        /* TOSHIBA device */
                        Device (VALZ)
                        {
                            Name (_HID, EisaId ("TOS1900"))
                            Name (_DDN, "VALZeneral")
                            Name (TECF, Zero)
                            Name (CECF, Zero)
                            Name (INFF, Zero)
                            Method (_STA, 0, NotSerialized)
                            {
                                Return (0x0B)
                            }

                            Method (ENAB, 0, NotSerialized)
                            {
                            }

                            Method (INFO, 0, NotSerialized)
                            {
                                If (TECF)
                                {
                                    Store (Zero, TECF)
                                    Store (^^PCI0.LPCB.EC0.TOHK, Local0)
                                    Store (Zero, ^^PCI0.LPCB.EC0.TOHK)
                                }
                                Else
                                {
                                    If (CECF)
                                    {
                                        Store (Zero, CECF)
                                        Store (CEEV, Local0)
                                        Store (Zero, CEEV)
                                    }
                                    Else
                                    {
                                        Store (Zero, Local0)
                                    }
                                }

                                Return (Local0)
                            }

                            /* ?? */
                            Method (SPFC, 6, NotSerialized)
                            {
                                Name (TSFR, Package (0x06) {})
                                Store (Zero, Index (TSFR, Zero))
                                Store (Zero, Index (TSFR, One))
                                Store (Zero, Index (TSFR, 0x02))
                                Store (Zero, Index (TSFR, 0x03))
                                Store (Zero, Index (TSFR, 0x04))
                                Store (Zero, Index (TSFR, 0x05))
                                CreateDWordField (Arg0, Zero, TOI0)
                                CreateDWordField (Arg1, Zero, TOI1)
                                CreateDWordField (Arg2, Zero, TOI2)
                                CreateDWordField (Arg3, Zero, TOI3)
                                CreateDWordField (Arg4, Zero, TOI4)
                                CreateDWordField (Arg5, Zero, TOI5)
                                Name (BUSY, Zero)
                                Name (COMT, Zero)
                                Name (ACET, Zero)
                                If (LLess (OSYS, 0x07D6))
                                {
                                    If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x2A)))
                                    {
                                        Store (Zero, Index (TSFR, Zero))
                                        Store (ShiftLeft (^^PCI0.LPCB.PHMR (0xB9F4), 0x0D, Local0), Index (TSFR, 0x02))
                                        Store (ShiftLeft (^^PCI0.LPCB.PHMR (0x93F8), 0x0D, Local1), Index (TSFR, 0x03))
                                        Return (TSFR)
                                    }
                                    Else
                                    {
                                        If (LAnd (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA7)), 
                                            LEqual (TOI2, Zero)), LEqual (TOI3, Zero)))
                                        {
                                            Store (Zero, BUSY)
                                            Store (0x80, COMT)
                                            If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                            {
                                                Store (Zero, Index (TSFR, Zero))
                                            }
                                            Else
                                            {
                                                If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                {
                                                    Store (^^PCI0.LPCB.PHMR (0xC5F6), Local1)
                                                    And (Local1, One, ACET)
                                                    Store (Zero, Index (TSFR, Zero))
                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xB3F4), 0x18, Local1)
                                                    Store (Zero, ^^PCI0.LPCB.INF)
                                                    ^^PCI0.LPCB.PHSS (0x7A)
                                                    Store (^^PCI0.LPCB.INF, Local2)
                                                    ShiftLeft (Local2, 0x10, Local2)
                                                    Or (Local1, Local2, Local2)
                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xB0F4), 0x08, Local3)
                                                    If (LEqual (ACET, One))
                                                    {
                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0xE7F8), Local4)
                                                    }
                                                    Else
                                                    {
                                                        Or (Local3, 0xFF, Local4)
                                                    }

                                                    Or (Local2, Local4, Index (TSFR, 0x02))
                                                    And (0xFF, ^^PCI0.LPCB.PHMR (0xE9F8), Local5)
                                                    ShiftLeft (Local5, 0x10, Local5)
                                                    If (LEqual (ACET, One))
                                                    {
                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xEAF8), 0x08, Local6)
                                                        Or (Local6, ^^PCI0.LPCB.PHMR (0xEBF8), Local6)
                                                    }
                                                    Else
                                                    {
                                                        Store (0xFFFF, Local6)
                                                    }

                                                    Or (Local5, Local6, Index (TSFR, 0x03))
                                                }
                                                Else
                                                {
                                                    If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                        BUSY, 0x40)))
                                                    {
                                                        Store (0x8D20, Index (TSFR, Zero))
                                                    }
                                                    Else
                                                    {
                                                        If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                            LNotEqual (COMT, 0x80)))
                                                        {
                                                            Store (0x8D50, Index (TSFR, Zero))
                                                        }
                                                        Else
                                                        {
                                                            Store (0x8300, Index (TSFR, Zero))
                                                        }
                                                    }
                                                }
                                            }

                                            Return (TSFR)
                                        }
                                        Else
                                        {
                                            If (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x42)))
                                            {
                                                If (LOr (LEqual (TOI2, One), LEqual (TOI2, 0x10)))
                                                {
                                                    ^^PCI0.LPCB.PHMW (0x94F8, TOI2)
                                                    Store (Zero, Index (TSFR, Zero))
                                                }
                                                Else
                                                {
                                                    Store (0x8300, Index (TSFR, Zero))
                                                }

                                                Return (TSFR)
                                            }
                                            Else
                                            {
                                                If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x9F)))
                                                {
                                                    If (LEqual (TOI2, Zero))
                                                    {
                                                        Store (^^PCI0.LPCB.PHMR (0xD7F8), Local0)
                                                        ShiftLeft (Local0, 0x08, Local0)
                                                        Store (^^PCI0.LPCB.PHMR (0xD8F8), Local1)
                                                        Or (Local0, Local1, Local2)
                                                        If (LEqual (Local2, 0xFFFF))
                                                        {
                                                            Store (Zero, Index (TSFR, 0x03))
                                                        }
                                                        Else
                                                        {
                                                            Store (Local2, Index (TSFR, 0x03))
                                                        }

                                                        Store (Zero, Index (TSFR, Zero))
                                                    }
                                                    Else
                                                    {
                                                        If (LEqual (TOI2, 0xFFFF))
                                                        {
                                                            Store (Zero, Index (TSFR, Zero))
                                                            Store (0x0200, Index (TSFR, 0x03))
                                                        }
                                                        Else
                                                        {
                                                            Store (0x8300, Index (TSFR, Zero))
                                                        }
                                                    }

                                                    Return (TSFR)
                                                }
                                                Else
                                                {
                                                    If (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x9F)))
                                                    {
                                                        If (LEqual (TOI2, Zero))
                                                        {
                                                            ShiftRight (TOI3, 0x08, Local0)
                                                            And (TOI3, 0xFF, Local1)
                                                            ^^PCI0.LPCB.PHMW (0xD7F8, Local0)
                                                            ^^PCI0.LPCB.PHMW (0xD8F8, Local1)
                                                            ^^PCI0.LPCB.PHMW (0xD9F8, One)
                                                            Store (Zero, Index (TSFR, Zero))
                                                        }
                                                        Else
                                                        {
                                                            Store (0x8300, Index (TSFR, Zero))
                                                        }

                                                        Return (TSFR)
                                                    }
                                                    Else
                                                    {
                                                        If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA1)))
                                                        {
                                                            Store (Zero, BUSY)
                                                            Store (0x80, COMT)
                                                            If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                            {
                                                                Store (Zero, Index (TSFR, Zero))
                                                            }
                                                            Else
                                                            {
                                                                If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                {
                                                                    If (LEqual (TOI2, One))
                                                                    {
                                                                        Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                                        And (Local1, One, Local1)
                                                                        If (LEqual (Local1, One))
                                                                        {
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xC7F4), 0x08, Local2)
                                                                            Or (Local2, ^^PCI0.LPCB.PHMR (0xC6F4), Local2)
                                                                            Divide (Local2, 0x64, Local3, Index (TSFR, 0x02))
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            Store (0xFF, Index (TSFR, 0x02))
                                                                        }
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                        Store (0xFF, Index (TSFR, 0x02))
                                                                    }
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                        BUSY, 0x40)))
                                                                    {
                                                                        Store (0x8D20, Index (TSFR, Zero))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                            LNotEqual (COMT, 0x80)))
                                                                        {
                                                                            Store (0x8D50, Index (TSFR, Zero))
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                        }
                                                                    }
                                                                }
                                                            }

                                                            Return (TSFR)
                                                        }
                                                        Else
                                                        {
                                                            If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA2)))
                                                            {
                                                                Store (Zero, BUSY)
                                                                Store (0x80, COMT)
                                                                If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                {
                                                                    If (LOr (LEqual (TOI3, Zero), LEqual (TOI3, One)))
                                                                    {
                                                                        Store (Zero, Index (TSFR, Zero))
                                                                    }
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LAnd (LEqual (TOI3, Zero), LEqual (TOI5, One)), LEqual (
                                                                        COMT, 0x80)))
                                                                    {
                                                                        ShiftRight (^^PCI0.LPCB.PHMR (0xADF4), 0x04, Local1)
                                                                        If (LLess (TOI2, Local1))
                                                                        {
                                                                            If (LEqual (TOI2, Zero))
                                                                            {
                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xECF8), 0x08, Local1)
                                                                                Or (Local1, ^^PCI0.LPCB.PHMR (0xEDF8), Index (TSFR, 0x02))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (TOI2, One))
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xEEF8), 0x08, Local1)
                                                                                    Or (Local1, ^^PCI0.LPCB.PHMR (0xEFF8), Index (TSFR, 0x02))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                }
                                                                            }
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                        }
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LAnd (LAnd (LEqual (TOI3, One), LEqual (TOI5, One)), LEqual (
                                                                            COMT, 0x80)))
                                                                        {
                                                                            ShiftRight (^^PCI0.LPCB.PHMR (0xADF4), 0x04, Local1)
                                                                            If (LLess (TOI2, Local1))
                                                                            {
                                                                                If (LEqual (TOI2, Zero))
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xECF8), 0x08, Local1)
                                                                                    Or (Local1, ^^PCI0.LPCB.PHMR (0xEDF8), Index (TSFR, 0x02))
                                                                                    Multiply (^^PCI0.LPCB.PHMR (0x95F8), 0x64, Index (TSFR, 0x03))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (TOI2, One))
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xEEF8), 0x08, Local1)
                                                                                        Or (Local1, ^^PCI0.LPCB.PHMR (0xEFF8), Index (TSFR, 0x02))
                                                                                        Multiply (^^PCI0.LPCB.PHMR (0x96F8), 0x64, Index (TSFR, 0x03))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                    }
                                                                                }
                                                                            }
                                                                            Else
                                                                            {
                                                                                Store (0x8300, Index (TSFR, Zero))
                                                                            }
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                BUSY, 0x40)))
                                                                            {
                                                                                Store (0x8D20, Index (TSFR, Zero))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                    LNotEqual (COMT, 0x80)))
                                                                                {
                                                                                    Store (0x8D50, Index (TSFR, Zero))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }

                                                                Return (TSFR)
                                                            }
                                                            Else
                                                            {
                                                                If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA6)), LEqual (
                                                                    TOI2, Zero)))
                                                                {
                                                                    If (HAPE)
                                                                    {
                                                                        Store (Zero, BUSY)
                                                                        Store (0x80, COMT)
                                                                        If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                        {
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                            {
                                                                                If (LEqual (TOI3, One))
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE3F8), 0x18, Local1)
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE2F8), 0x10, Local2)
                                                                                    Or (Local1, Local2, Local2)
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE1F8), 0x08, Local3)
                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0xE0F8), Local4)
                                                                                    Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE5F8), 0x08, Local5)
                                                                                    Or (Local5, ^^PCI0.LPCB.PHMR (0xE4F8), Index (TSFR, 0x04))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (TOI3, Zero))
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x59F5), 0x18, Local1)
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x58F5), 0x10, Local2)
                                                                                        Or (Local1, Local2, Local2)
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x57F5), 0x08, Local3)
                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0x56F5), Local4)
                                                                                        Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x5BF5), 0x08, Local5)
                                                                                        Or (Local5, ^^PCI0.LPCB.PHMR (0x5AF5), Index (TSFR, 0x04))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (TOI3, 0x0200))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x18, Local1)
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x68F5), 0x10, Local2)
                                                                                            Or (Local1, Local2, Local2)
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                            Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local4)
                                                                                            Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local5)
                                                                                            Or (Local5, ^^PCI0.LPCB.PHMR (0x6AF5), Local6)
                                                                                            Add (Local6, ^^PCI0.LPCB.PHMR (0x5EF5), Index (TSFR, 0x04))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LEqual (TOI3, 0x0201))
                                                                                            {
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x08, Local1)
                                                                                                Or (Local1, ^^PCI0.LPCB.PHMR (0x68F5), Local1)
                                                                                                Add (Local1, ^^PCI0.LPCB.PHMR (0x5DF5), Local2)
                                                                                                ShiftLeft (Local2, 0x10, Local2)
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                                Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local3)
                                                                                                Add (Local3, ^^PCI0.LPCB.PHMR (0x5CF5), Local4)
                                                                                                Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local2)
                                                                                                Or (Local2, ^^PCI0.LPCB.PHMR (0x6AF5), Index (TSFR, 0x04))
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                Store (0x8300, Index (TSFR, Zero))
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                    BUSY, 0x40)))
                                                                                {
                                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                        LNotEqual (COMT, 0x80)))
                                                                                    {
                                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (0x8000, Index (TSFR, Zero))
                                                                    }

                                                                    Return (TSFR)
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA8)), LEqual (
                                                                        TOI4, 0x98)))
                                                                    {
                                                                        Store (Zero, BUSY)
                                                                        Store (0x80, COMT)
                                                                        If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                        {
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                            {
                                                                                If (LEqual (TOI2, One))
                                                                                {
                                                                                    Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                                                    And (Local1, One, Local1)
                                                                                    If (LEqual (Local1, One))
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Store (^^PCI0.LPCB.PHMR (0xD7F4), Index (TSFR, 0x03))
                                                                                        Store (^^PCI0.LPCB.PHMR (0xD1F4), Local2)
                                                                                        And (Local2, 0x80, Local2)
                                                                                        If (LLess (Local2, 0x80))
                                                                                        {
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xD1F4), 0x08, Local1)
                                                                                            Or (Local1, ^^PCI0.LPCB.PHMR (0xD0F4), Index (TSFR, 0x02))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xD1F4), 0x08, Local1)
                                                                                            Or (Local1, ^^PCI0.LPCB.PHMR (0xD0F4), Local1)
                                                                                            Subtract (0xFFFF, Local1, Index (TSFR, 0x02))
                                                                                        }
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Store (0xFFFF, Index (TSFR, 0x02))
                                                                                        Store (0xFF, Index (TSFR, 0x03))
                                                                                    }
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                    Store (0xFF, Index (TSFR, 0x03))
                                                                                }
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                    BUSY, 0x40)))
                                                                                {
                                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                        LNotEqual (COMT, 0x80)))
                                                                                    {
                                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                    }
                                                                                }
                                                                            }
                                                                        }

                                                                        Return (TSFR)
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA8)), LEqual (
                                                                            TOI4, 0x9A)))
                                                                        {
                                                                            Store (Zero, BUSY)
                                                                            Store (0x80, COMT)
                                                                            If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                            {
                                                                                Store (Zero, Index (TSFR, Zero))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                                {
                                                                                    ShiftRight (^^PCI0.LPCB.PHMR (0xADF4), 0x04, Local1)
                                                                                    If (LLess (TOI2, Local1))
                                                                                    {
                                                                                        If (LEqual (TOI2, Zero))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Store (^^PCI0.LPCB.PHMR (0x99F8), Index (TSFR, 0x02))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LEqual (TOI2, One))
                                                                                            {
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                Store (^^PCI0.LPCB.PHMR (0x9AF8), Index (TSFR, 0x02))
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                Store (0x8300, Index (TSFR, Zero))
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                    }
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                        BUSY, 0x40)))
                                                                                    {
                                                                                        Store (0x8D20, Index (TSFR, Zero))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                            LNotEqual (COMT, 0x80)))
                                                                                        {
                                                                                            Store (0x8D50, Index (TSFR, Zero))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }

                                                                            Return (TSFR)
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA8)), LEqual (
                                                                                TOI4, 0x9B)))
                                                                            {
                                                                                Store (Zero, BUSY)
                                                                                Store (0x80, COMT)
                                                                                If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LAnd (LEqual (TOI2, Zero), LEqual (TOI5, One)), LEqual (
                                                                                        COMT, 0x80)))
                                                                                    {
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x9BF8), 0x18, Local1)
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x9CF8), 0x10, Local2)
                                                                                        Or (Local1, Local2, Local2)
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x9DF8), 0x08, Local3)
                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0x9EF8), Local3)
                                                                                        Or (Local2, Local3, Index (TSFR, 0x03))
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x9FF8), 0x18, Local4)
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xA0F8), 0x10, Local5)
                                                                                        Or (Local4, Local5, Local5)
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xA1F8), 0x08, Local6)
                                                                                        Or (Local6, ^^PCI0.LPCB.PHMR (0xA2F8), Local6)
                                                                                        Or (Local5, Local6, Index (TSFR, 0x02))
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Or (^^PCI0.LPCB.PHMR (0xDFF8), 0x02, Local1)
                                                                                        ^^PCI0.LPCB.PHMW (0xDFF8, Local1)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LAnd (LAnd (LEqual (TOI2, One), LEqual (TOI5, One)), LEqual (
                                                                                            COMT, 0x80)))
                                                                                        {
                                                                                            And (0xFF, ^^PCI0.LPCB.PHMR (0xA3F8), Local1)
                                                                                            Store (Local1, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Or (^^PCI0.LPCB.PHMR (0xDFF8), 0x04, Local1)
                                                                                            ^^PCI0.LPCB.PHMW (0xDFF8, Local1)
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LAnd (LAnd (LEqual (TOI2, 0x02), LEqual (TOI5, One)), LEqual (
                                                                                                COMT, 0x80)))
                                                                                            {
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xABF8), 0x18, Local1)
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xAAF8), 0x10, Local2)
                                                                                                Or (Local1, Local2, Local2)
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xA9F8), 0x08, Local3)
                                                                                                Or (Local3, ^^PCI0.LPCB.PHMR (0xA8F8), Local3)
                                                                                                Or (Local2, Local3, Index (TSFR, 0x03))
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xA7F8), 0x18, Local4)
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xA6F8), 0x10, Local5)
                                                                                                Or (Local4, Local5, Local5)
                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xA5F8), 0x08, Local6)
                                                                                                Or (Local6, ^^PCI0.LPCB.PHMR (0xA4F8), Local6)
                                                                                                Or (Local5, Local6, Index (TSFR, 0x02))
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                Or (^^PCI0.LPCB.PHMR (0xDFF8), 0x08, Local1)
                                                                                                ^^PCI0.LPCB.PHMW (0xDFF8, Local1)
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                                    BUSY, 0x40)))
                                                                                                {
                                                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                                        LNotEqual (COMT, 0x80)))
                                                                                                    {
                                                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }

                                                                                Return (TSFR)
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA8)), LEqual (
                                                                                    TOI4, 0xA0)))
                                                                                {
                                                                                    If (LEqual (TOI3, Zero))
                                                                                    {
                                                                                        Store (Zero, BUSY)
                                                                                        Store (0x80, COMT)
                                                                                        If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                                            {
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                Store (^^PCI0.LPCB.PHMR (0xDBF8), Local1)
                                                                                                Store (0x0B, Local2)
                                                                                                And (Local1, Local2, Index (TSFR, 0x02))
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                                    BUSY, 0x40)))
                                                                                                {
                                                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                                        LNotEqual (COMT, 0x80)))
                                                                                                    {
                                                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                    }

                                                                                    Return (TSFR)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0xA0)))
                                                                                    {
                                                                                        And (TOI2, 0xF4, Local0)
                                                                                        If (LAnd (LEqual (TOI3, Zero), LEqual (Local0, Zero)))
                                                                                        {
                                                                                            ^^PCI0.LPCB.PHMW (0xDBF8, TOI2)
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                                        }

                                                                                        Return (TSFR)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA8)), LEqual (
                                                                                            TOI4, 0x9D)))
                                                                                        {
                                                                                            If (LEqual (TOI3, Zero))
                                                                                            {
                                                                                                If (LEqual (TOI5, Zero))
                                                                                                {
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LEqual (TOI5, One))
                                                                                                    {
                                                                                                        Store (^^PCI0.LPCB.PHMR (0xDFF8), Local0)
                                                                                                        And (Local0, One, Local0)
                                                                                                        Store (Local0, Index (TSFR, 0x02))
                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                Store (0x8300, Index (TSFR, Zero))
                                                                                            }

                                                                                            Return (TSFR)
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x9D)))
                                                                                            {
                                                                                                If (LEqual (TOI3, Zero))
                                                                                                {
                                                                                                    If (LOr (LEqual (TOI2, Zero), LEqual (TOI2, One)))
                                                                                                    {
                                                                                                        ^^PCI0.LPCB.PHMW (0xDFF8, TOI2)
                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                                    }
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                                }

                                                                                                Return (TSFR)
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xA8)), LEqual (
                                                                                                    TOI4, 0xA9)))
                                                                                                {
                                                                                                    Store (Zero, BUSY)
                                                                                                    Store (0x80, COMT)
                                                                                                    If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                                                    {
                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                                                        {
                                                                                                            If (LEqual (TOI2, One))
                                                                                                            {
                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                                                                                And (Local1, One, Local1)
                                                                                                                If (LEqual (Local1, One))
                                                                                                                {
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x60F5), 0x18, Local1)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x61F5), 0x10, Local2)
                                                                                                                    Or (Local1, Local2, Local2)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xDFF4), 0x08, Local3)
                                                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0xDEF4), Local4)
                                                                                                                    Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE6F4), 0x18, Local1)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE5F4), 0x10, Local2)
                                                                                                                    Or (Local1, Local2, Local2)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE4F4), 0x08, Local3)
                                                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0xE3F4), Local4)
                                                                                                                    Or (Local2, Local4, Index (TSFR, 0x03))
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x62F5), 0x18, Local1)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x63F5), 0x10, Local2)
                                                                                                                    Or (Local1, Local2, Local2)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x64F5), 0x08, Local3)
                                                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0x65F5), Local4)
                                                                                                                    Or (Local2, Local4, Index (TSFR, 0x04))
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xEAF4), 0x18, Local1)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE9F4), 0x10, Local2)
                                                                                                                    Or (Local1, Local2, Local2)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xE8F4), 0x08, Local3)
                                                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0xE7F4), Local4)
                                                                                                                    Or (Local2, Local4, Index (TSFR, 0x05))
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x03))
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x04))
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x05))
                                                                                                                }
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LEqual (TOI2, 0x8001))
                                                                                                                {
                                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                                    Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                                                                                    And (Local1, One, Local1)
                                                                                                                    If (LEqual (Local1, One))
                                                                                                                    {
                                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x6CF5), 0x08, Local1)
                                                                                                                        Or (Local1, ^^PCI0.LPCB.PHMR (0x6DF5), Local1)
                                                                                                                        Store (Local1, Index (TSFR, 0x02))
                                                                                                                    }
                                                                                                                    Else
                                                                                                                    {
                                                                                                                        Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                    }
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x03))
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x04))
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x05))
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                                                BUSY, 0x40)))
                                                                                                            {
                                                                                                                Store (0x8D20, Index (TSFR, Zero))
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                                                    LNotEqual (COMT, 0x80)))
                                                                                                                {
                                                                                                                    Store (0x8D50, Index (TSFR, Zero))
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }

                                                                                                    Return (TSFR)
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xAA)))
                                                                                                    {
                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                        Store (^^PCI0.LPCB.PHMR (0xD2F8), Index (TSFR, 0x02))
                                                                                                        Store (^^PCI0.LPCB.PHMR (0xD3F8), Index (TSFR, 0x03))
                                                                                                        Return (TSFR)
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x56)), LEqual (
                                        TOI3, One)))
                                    {
                                        Or (ShiftLeft (^^PCI0.LPCB.EC0.WLAT, 0x09, Local0), ^^PCI0.LPCB.EC0.KLSW, Local2)
                                        Or (ShiftLeft (^^PCI0.LPCB.EC0.PW3G, 0x0D, Local0), Local2, Local2)
                                        Or (ShiftLeft (^^PCI0.LPCB.EC0.UWBP, 0x0B, Local0), Local2, Local2)
                                        Store (Local2, Index (TSFR, 0x02))
                                        Store (0x8000, Index (TSFR, Zero))
                                    }
                                    Else
                                    {
                                        If (LAnd (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x56)), LEqual (
                                            TOI3, 0x0200)))
                                        {
                                            If (LEqual (TOI2, Zero))
                                            {
                                                Store (Zero, ^^PCI0.LPCB.EC0.WLAT)
                                            }
                                            Else
                                            {
                                                Store (One, ^^PCI0.LPCB.EC0.WLAT)
                                            }

                                            Store (Zero, Index (TSFR, Zero))
                                        }
                                        Else
                                        {
                                            If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x56)), LEqual (
                                                TOI3, 0x03)))
                                            {
                                                If (^^PCI0.LPCB.EC0.ID3G)
                                                {
                                                    Store (Zero, Index (TSFR, Zero))
                                                    Store (0x2000, Index (TSFR, 0x02))
                                                }
                                                Else
                                                {
                                                    Store (0x8300, Index (TSFR, Zero))
                                                }
                                            }
                                            Else
                                            {
                                                If (LAnd (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x56)), LEqual (
                                                    TOI3, 0x2000)))
                                                {
                                                    If (LEqual (TOI2, Zero))
                                                    {
                                                        Store (Zero, ^^PCI0.LPCB.EC0.PW3G)
                                                    }
                                                    Else
                                                    {
                                                        Store (One, ^^PCI0.LPCB.EC0.PW3G)
                                                    }

                                                    Store (Zero, Index (TSFR, Zero))
                                                }
                                                Else
                                                {
                                                    If (LAnd (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x56)), LEqual (
                                                        TOI3, 0x0800)))
                                                    {
                                                        If (LEqual (TOI2, Zero))
                                                        {
                                                            Store (Zero, ^^PCI0.LPCB.EC0.UWBP)
                                                        }
                                                        Else
                                                        {
                                                            Store (One, ^^PCI0.LPCB.EC0.UWBP)
                                                        }

                                                        Store (Zero, Index (TSFR, Zero))
                                                    }
                                                    Else
                                                    {
                                                        If (LAnd (LEqual (TOI0, 0xF300), LEqual (TOI1, 0x050E)))
                                                        {
                                                            If (^^PCI0.LPCB.EC0.TOUP)
                                                            {
                                                                Store (Zero, Index (TSFR, 0x02))
                                                            }
                                                            Else
                                                            {
                                                                Store (One, Index (TSFR, 0x02))
                                                            }

                                                            Store (Zero, Index (TSFR, Zero))
                                                        }
                                                        Else
                                                        {
                                                            If (LAnd (LEqual (TOI0, 0xF400), LEqual (TOI1, 0x050E)))
                                                            {
                                                                If (TOUD)
                                                                {
                                                                    If (LEqual (TOI2, Zero))
                                                                    {
                                                                        Store (One, ^^PCI0.LPCB.EC0.TOUP)
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (Zero, ^^PCI0.LPCB.EC0.TOUP)
                                                                    }
                                                                }

                                                                Store (Zero, Index (TSFR, Zero))
                                                            }
                                                            Else
                                                            {
                                                                If (LAnd (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x5A)), LEqual (
                                                                    TOI3, One)))
                                                                {
                                                                    Store (TOI2, ^^PCI0.LPCB.EC0.FNSF)
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x7F)))
                                                                    {
                                                                        Store (^^PCI0.LPCB.EC0.CLME, Index (TSFR, 0x02))
                                                                        Store (One, Index (TSFR, 0x03))
                                                                        Store (Zero, Index (TSFR, Zero))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x7F)))
                                                                        {
                                                                            Store (TOI2, ^^PCI0.LPCB.EC0.CLME)
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x62)))
                                                                            {
                                                                                If (LEqual (OES1, 0x55))
                                                                                {
                                                                                    If (LEqual (OES2, 0x30))
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, 0x03))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (OES2, 0x31))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, 0x03))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0x21, Index (TSFR, 0x03))
                                                                                        }
                                                                                    }
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x21, Index (TSFR, 0x03))
                                                                                }

                                                                                Store (Zero, Index (TSFR, Zero))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x11)))
                                                                                {
                                                                                    If (LEqual (HORZ, 0x0280))
                                                                                    {
                                                                                        If (LEqual (VERT, 0x01E0))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, 0x02))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                        }
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (HORZ, 0x0320))
                                                                                        {
                                                                                            If (LEqual (VERT, 0x0258))
                                                                                            {
                                                                                                Store (0x0100, Index (TSFR, 0x02))
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LEqual (VERT, 0x01E0))
                                                                                                {
                                                                                                    Store (0x0400, Index (TSFR, 0x02))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LEqual (HORZ, 0x0400))
                                                                                            {
                                                                                                If (LEqual (VERT, 0x0300))
                                                                                                {
                                                                                                    Store (0x0200, Index (TSFR, 0x02))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LEqual (VERT, 0x0258))
                                                                                                    {
                                                                                                        Store (0x0300, Index (TSFR, 0x02))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LEqual (VERT, 0x0240))
                                                                                                        {
                                                                                                            Store (0x1200, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LEqual (HORZ, 0x0500))
                                                                                                {
                                                                                                    If (LEqual (VERT, 0x0400))
                                                                                                    {
                                                                                                        Store (0x0500, Index (TSFR, 0x02))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LEqual (VERT, 0x0258))
                                                                                                        {
                                                                                                            Store (0x0800, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LEqual (VERT, 0x0320))
                                                                                                            {
                                                                                                                Store (0x0900, Index (TSFR, 0x02))
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LEqual (VERT, 0x0300))
                                                                                                                {
                                                                                                                    Store (0x0D00, Index (TSFR, 0x02))
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LEqual (HORZ, 0x0578))
                                                                                                    {
                                                                                                        If (LEqual (VERT, 0x041A))
                                                                                                        {
                                                                                                            Store (0x0600, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LEqual (HORZ, 0x0640))
                                                                                                        {
                                                                                                            If (LEqual (VERT, 0x04B0))
                                                                                                            {
                                                                                                                Store (0x0700, Index (TSFR, 0x02))
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LEqual (VERT, 0x0384))
                                                                                                                {
                                                                                                                    Store (0x1100, Index (TSFR, 0x02))
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LEqual (HORZ, 0x05A0))
                                                                                                            {
                                                                                                                If (LEqual (VERT, 0x0384))
                                                                                                                {
                                                                                                                    Store (0x0A00, Index (TSFR, 0x02))
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                }
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LEqual (HORZ, 0x0690))
                                                                                                                {
                                                                                                                    If (LEqual (VERT, 0x041A))
                                                                                                                    {
                                                                                                                        Store (0x0B00, Index (TSFR, 0x02))
                                                                                                                    }
                                                                                                                    Else
                                                                                                                    {
                                                                                                                        If (LEqual (VERT, 0x03B1))
                                                                                                                        {
                                                                                                                            Store (0x0F00, Index (TSFR, 0x02))
                                                                                                                        }
                                                                                                                        Else
                                                                                                                        {
                                                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    If (LEqual (HORZ, 0x0780))
                                                                                                                    {
                                                                                                                        If (LEqual (VERT, 0x04B0))
                                                                                                                        {
                                                                                                                            Store (0x0C00, Index (TSFR, 0x02))
                                                                                                                        }
                                                                                                                        Else
                                                                                                                        {
                                                                                                                            If (LEqual (VERT, 0x0438))
                                                                                                                            {
                                                                                                                                Store (0x0E00, Index (TSFR, 0x02))
                                                                                                                            }
                                                                                                                            Else
                                                                                                                            {
                                                                                                                                Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                    Else
                                                                                                                    {
                                                                                                                        If (LEqual (HORZ, 0x0556))
                                                                                                                        {
                                                                                                                            If (LEqual (VERT, 0x0300))
                                                                                                                            {
                                                                                                                                Store (0x1000, Index (TSFR, 0x02))
                                                                                                                            }
                                                                                                                            Else
                                                                                                                            {
                                                                                                                                Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                            }
                                                                                                                        }
                                                                                                                        Else
                                                                                                                        {
                                                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }

                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0xC000)), LEqual (
                                                                                        TOI2, Zero)))
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0xC000)), LEqual (
                                                                                            TOI2, 0x03)))
                                                                                        {
                                                                                            Store (Zero, Local0)
                                                                                            Store (Zero, Local1)
                                                                                            Or (Local0, Local1, Local2)
                                                                                            Store (Local2, Index (TSFR, 0x03))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x1E)))
                                                                                            {
                                                                                                And (TOI2, 0x02, Local0)
                                                                                                If (LEqual (Local0, 0x02))
                                                                                                {
                                                                                                    Store (Zero, ^^PCI0.LPCB.EC0.HKEV)
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (One, ^^PCI0.LPCB.EC0.HKEV)
                                                                                                }

                                                                                                And (TOI2, 0x08, Local1)
                                                                                                If (LEqual (Local1, 0x08))
                                                                                                {
                                                                                                    Store (Zero, ^^PCI0.LPCB.EC0.HKHS)
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (One, ^^PCI0.LPCB.EC0.HKHS)
                                                                                                }

                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x1E)))
                                                                                                {
                                                                                                    Store (^^PCI0.LPCB.EC0.HKEV, Local0)
                                                                                                    Store (^^PCI0.LPCB.EC0.HKHS, Local1)
                                                                                                    If (LAnd (LEqual (Local0, One), LEqual (Local1, One)))
                                                                                                    {
                                                                                                        Store (One, Index (TSFR, 0x02))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LAnd (LEqual (Local0, One), LEqual (Local1, Zero)))
                                                                                                        {
                                                                                                            Store (0x09, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LAnd (LEqual (Local0, Zero), LEqual (Local1, One)))
                                                                                                            {
                                                                                                                Store (0x03, Index (TSFR, 0x02))
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                Store (0x0B, Index (TSFR, 0x02))
                                                                                                            }
                                                                                                        }
                                                                                                    }

                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x47)))
                                                                                                    {
                                                                                                        Store (Zero, Index (TSFR, 0x02))
                                                                                                        If (LEqual (^^PCI0.LPCB.EC0.HDPO, One))
                                                                                                        {
                                                                                                            Store (0x0131, Index (TSFR, 0x02))
                                                                                                            Store (Zero, Index (TSFR, 0x03))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (^^PCI0.LPCB.EC0.WFAT)
                                                                                                            {
                                                                                                                Store (0x20, Index (TSFR, 0x02))
                                                                                                                Store (^^PCI0.LPCB.EC0.WFAT, Index (TSFR, 0x03))
                                                                                                            }
                                                                                                        }

                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LAnd (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x47)), LEqual (
                                                                                                            TOI2, 0x5A00)))
                                                                                                        {
                                                                                                            Store (Zero, ^^PCI0.LPCB.EC0.WFAT)
                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x61)))
                                                                                                            {
                                                                                                                Store (^^PCI0.LPCB.EC0.CIRF, Index (TSFR, 0x02))
                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x61)))
                                                                                                                {
                                                                                                                    Store (TOI2, ^^PCI0.LPCB.EC0.CIRF)
                                                                                                                    Store (TOI2, ^^PCI0.LPCB.INF)
                                                                                                                    ^^PCI0.LPCB.PHSS (0x78)
                                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    If (LAnd (LEqual (TOI0, 0xF300), LEqual (TOI1, 0x010E)))
                                                                                                                    {
                                                                                                                        Or (ALMF, 0x02, ALMF)
                                                                                                                        ^^PCI0.LPCB.PHSS (0x8E)
                                                                                                                        Or (ShiftLeft (ALMY, 0x0A, Local0), ShiftLeft (ALMO, 0x06, Local1), Local2)
                                                                                                                        Or (ShiftLeft (ALMD, One, Local0), Local2, Local3)
                                                                                                                        Store (0x8005, Index (TSFR, One))
                                                                                                                        Store (Local3, Index (TSFR, 0x02))
                                                                                                                        Store (0x03FE, Index (TSFR, 0x03))
                                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                                    }
                                                                                                                    Else
                                                                                                                    {
                                                                                                                        If (LAnd (LEqual (TOI0, 0xF300), LEqual (TOI1, 0x010F)))
                                                                                                                        {
                                                                                                                            Or (ALMF, One, ALMF)
                                                                                                                            ^^PCI0.LPCB.PHSS (0x8E)
                                                                                                                            Or (ShiftLeft (ALMH, 0x07, Local0), ShiftLeft (ALMM, One, Local1), Local2)
                                                                                                                            If (LEqual (Local2, Zero))
                                                                                                                            {
                                                                                                                                Store (One, Local2)
                                                                                                                            }

                                                                                                                            Store (0x8004, Index (TSFR, One))
                                                                                                                            Store (Local2, Index (TSFR, 0x02))
                                                                                                                            Store (0x0FFF, Index (TSFR, 0x03))
                                                                                                                            Store (One, Index (TSFR, 0x04))
                                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                                        }
                                                                                                                        Else
                                                                                                                        {
                                                                                                                            If (LAnd (LEqual (TOI0, 0xF400), LEqual (TOI1, 0x010E)))
                                                                                                                            {
                                                                                                                                If (LEqual (TOI2, Zero))
                                                                                                                                {
                                                                                                                                    Store (Zero, ALMF)
                                                                                                                                }
                                                                                                                                Else
                                                                                                                                {
                                                                                                                                    ShiftRight (TOI2, One, Local0)
                                                                                                                                    And (Local0, 0x1F, ALMD)
                                                                                                                                    ShiftRight (TOI2, 0x06, Local0)
                                                                                                                                    And (Local0, 0x0F, ALMO)
                                                                                                                                    ShiftRight (TOI2, 0x0A, Local0)
                                                                                                                                    And (Local0, 0x3F, ALMY)
                                                                                                                                    Store (0x88, ALMF)
                                                                                                                                    ^^PCI0.LPCB.PHSS (0x8E)
                                                                                                                                }

                                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                            }
                                                                                                                            Else
                                                                                                                            {
                                                                                                                                If (LAnd (LEqual (TOI0, 0xF400), LEqual (TOI1, 0x010F)))
                                                                                                                                {
                                                                                                                                    If (LEqual (TOI2, Zero))
                                                                                                                                    {
                                                                                                                                        Store (Zero, ALMF)
                                                                                                                                    }
                                                                                                                                    Else
                                                                                                                                    {
                                                                                                                                        ShiftRight (TOI2, One, Local0)
                                                                                                                                        And (Local0, 0x3F, ALMM)
                                                                                                                                        ShiftRight (TOI2, 0x07, Local0)
                                                                                                                                        And (Local0, 0x1F, ALMH)
                                                                                                                                        Store (0x84, ALMF)
                                                                                                                                        ^^PCI0.LPCB.PHSS (0x8E)
                                                                                                                                    }

                                                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                                                }
                                                                                                                                Else
                                                                                                                                {
                                                                                                                                    If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x75)))
                                                                                                                                    {
                                                                                                                                        Store (PMID, Index (TSFR, 0x04))
                                                                                                                                        Store (PPID, Index (TSFR, 0x05))
                                                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                                                    }
                                                                                                                                    Else
                                                                                                                                    {
                                                                                                                                        If (LAnd (LEqual (TOI0, 0xF300), LEqual (TOI1, 0x014E)))
                                                                                                                                        {
                                                                                                                                            Store (0x8000, Index (TSFR, Zero))
                                                                                                                                        }
                                                                                                                                        Else
                                                                                                                                        {
                                                                                                                                            If (LAnd (LEqual (TOI0, 0xF400), LEqual (TOI1, 0x014E)))
                                                                                                                                            {
                                                                                                                                                Store (0x8000, Index (TSFR, Zero))
                                                                                                                                            }
                                                                                                                                            Else
                                                                                                                                            {
                                                                                                                                                If (LAnd (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x6D)), LEqual (
                                                                                                                                                    TOI2, Zero)))
                                                                                                                                                {
                                                                                                                                                    If (HAPE)
                                                                                                                                                    {
                                                                                                                                                        If (LEqual (TOI3, One))
                                                                                                                                                        {
                                                                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xE3F8), 0x18, Local1)
                                                                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xE2F8), 0x10, Local2)
                                                                                                                                                            Or (Local1, Local2, Local2)
                                                                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xE1F8), 0x08, Local3)
                                                                                                                                                            Or (Local3, ^^PCI0.LPCB.PHMR (0xE0F8), Local4)
                                                                                                                                                            Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xE5F8), 0x08, Local5)
                                                                                                                                                            Or (Local5, ^^PCI0.LPCB.PHMR (0xE4F8), Index (TSFR, 0x04))
                                                                                                                                                        }
                                                                                                                                                        Else
                                                                                                                                                        {
                                                                                                                                                            If (LEqual (TOI3, Zero))
                                                                                                                                                            {
                                                                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x59F5), 0x18, Local1)
                                                                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x58F5), 0x10, Local2)
                                                                                                                                                                Or (Local1, Local2, Local2)
                                                                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x57F5), 0x08, Local3)
                                                                                                                                                                Or (Local3, ^^PCI0.LPCB.PHMR (0x56F5), Local4)
                                                                                                                                                                Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x5BF5), 0x08, Local5)
                                                                                                                                                                Or (Local5, ^^PCI0.LPCB.PHMR (0x5AF5), Index (TSFR, 0x04))
                                                                                                                                                            }
                                                                                                                                                            Else
                                                                                                                                                            {
                                                                                                                                                                If (LEqual (TOI3, 0x0200))
                                                                                                                                                                {
                                                                                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x18, Local1)
                                                                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x68F5), 0x10, Local2)
                                                                                                                                                                    Or (Local1, Local2, Local2)
                                                                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local4)
                                                                                                                                                                    Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local5)
                                                                                                                                                                    Or (Local5, ^^PCI0.LPCB.PHMR (0x6AF5), Local6)
                                                                                                                                                                    Add (Local6, ^^PCI0.LPCB.PHMR (0x5EF5), Index (TSFR, 0x04))
                                                                                                                                                                }
                                                                                                                                                                Else
                                                                                                                                                                {
                                                                                                                                                                    If (LEqual (TOI3, 0x0201))
                                                                                                                                                                    {
                                                                                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x08, Local1)
                                                                                                                                                                        Or (Local1, ^^PCI0.LPCB.PHMR (0x68F5), Local1)
                                                                                                                                                                        Add (Local1, ^^PCI0.LPCB.PHMR (0x5DF5), Local2)
                                                                                                                                                                        ShiftLeft (Local2, 0x10, Local2)
                                                                                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local3)
                                                                                                                                                                        Add (Local3, ^^PCI0.LPCB.PHMR (0x5CF5), Local4)
                                                                                                                                                                        Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local2)
                                                                                                                                                                        Or (Local2, ^^PCI0.LPCB.PHMR (0x6AF5), Index (TSFR, 0x04))
                                                                                                                                                                    }
                                                                                                                                                                    Else
                                                                                                                                                                    {
                                                                                                                                                                        Store (0x8000, Index (TSFR, Zero))
                                                                                                                                                                    }
                                                                                                                                                                }
                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                    }
                                                                                                                                                    Else
                                                                                                                                                    {
                                                                                                                                                        Store (0x8000, Index (TSFR, Zero))
                                                                                                                                                    }

                                                                                                                                                    Return (TSFR)
                                                                                                                                                }
                                                                                                                                                Else
                                                                                                                                                {
                                                                                                                                                    If (LAnd (LAnd (LEqual (TOI0, 0xFF00), LEqual (TOI1, 0x6D)), LEqual (
                                                                                                                                                        TOI2, Zero)))
                                                                                                                                                    {
                                                                                                                                                        If (HAPS)
                                                                                                                                                        {
                                                                                                                                                            If (LOr (LEqual (TOI3, 0x0100), LEqual (TOI3, 0x0102)))
                                                                                                                                                            {
                                                                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                                                            }
                                                                                                                                                            Else
                                                                                                                                                            {
                                                                                                                                                                Store (0x8000, Index (TSFR, Zero))
                                                                                                                                                            }
                                                                                                                                                        }
                                                                                                                                                        Else
                                                                                                                                                        {
                                                                                                                                                            Store (0x8000, Index (TSFR, Zero))
                                                                                                                                                        }

                                                                                                                                                        Return (TSFR)
                                                                                                                                                    }
                                                                                                                                                    Else
                                                                                                                                                    {
                                                                                                                                                        Store (0x8000, Index (TSFR, Zero))
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    If (LAnd (LEqual (TOI0, 0xFE00), LEqual (TOI1, 0x96)))
                                    {
                                        Store (Zero, Index (TSFR, Zero))
                                        Store (0xFF00, Index (TSFR, 0x02))
                                        If (IGDS)
                                        {
                                            Store (0x0301, Index (TSFR, 0x03))
                                        }
                                        Else
                                        {
                                            Store (0x0302, Index (TSFR, 0x03))
                                        }

                                        Return (TSFR)
                                    }

                                    If (LEqual (TOI0, 0xF100))
                                    {
                                        If (LEqual (INFF, Zero))
                                        {
                                            Store (One, INFF)
                                            Store (0x44, Index (TSFR, Zero))
                                        }
                                        Else
                                        {
                                            Store (0x8100, Index (TSFR, Zero))
                                        }

                                        Return (TSFR)
                                    }
                                    Else
                                    {
                                        If (LEqual (TOI0, 0xF200))
                                        {
                                            If (LEqual (INFF, One))
                                            {
                                                Store (Zero, INFF)
                                                Store (0x44, Index (TSFR, Zero))
                                            }
                                            Else
                                            {
                                                Store (0x8200, Index (TSFR, Zero))
                                            }

                                            Return (TSFR)
                                        }
                                        Else
                                        {
                                            If (LAnd (LEqual (TOI0, 0xF300), LEqual (TOI1, 0x0150)))
                                            {
                                                If (LEqual (INFF, One))
                                                {
                                                    Store (Zero, Index (TSFR, Zero))
                                                    If (LEqual (TOI5, Zero))
                                                    {
                                                        Store (0x800C, Index (TSFR, One))
                                                        ^^PCI0.LPCB.PHSS (0x7D)
                                                        Or (ShiftLeft (One, 0x17, Local0), ^^PCI0.LPCB.INF, Local1)
                                                        Store (Local1, Index (TSFR, 0x02))
                                                        Or (ShiftLeft (One, One, Local0), One, Local1)
                                                        Or (ShiftLeft (One, 0x02, Local2), Local1, Local3)
                                                        Or (ShiftLeft (One, 0x03, Local4), Local3, Local5)
                                                        Or (ShiftLeft (One, 0x04, Local6), Local5, Local7)
                                                        ShiftLeft (One, 0x17, Local0)
                                                        Or (Local0, Local7, Index (TSFR, 0x03))
                                                        Or (Local0, Zero, Index (TSFR, 0x04))
                                                    }
                                                    Else
                                                    {
                                                        If (LEqual (TOI5, 0x0100))
                                                        {
                                                            Store (0x8001, Index (TSFR, One))
                                                            Store (One, Index (TSFR, 0x02))
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (TOI5, 0x0101))
                                                            {
                                                                Store (0x800C, Index (TSFR, One))
                                                                Or (ShiftLeft (One, One, Local0), One, Local1)
                                                                Or (ShiftLeft (One, 0x02, Local2), Local1, Local3)
                                                                Or (ShiftLeft (One, 0x03, Local4), Local3, Local5)
                                                                Or (ShiftLeft (One, 0x04, Local6), Local5, Local7)
                                                                ShiftLeft (One, 0x17, Local0)
                                                                Or (Local0, Local7, Index (TSFR, 0x02))
                                                            }
                                                            Else
                                                            {
                                                                If (LEqual (TOI5, 0x0200))
                                                                {
                                                                    Store (0x800D, Index (TSFR, One))
                                                                    Or (ShiftLeft (^^PCI0.LPCB.EC0.SCDC, One, Local0), ^^PCI0.LPCB.EC0.SCAC, Local1)
                                                                    Or (ShiftLeft (^^PCI0.LPCB.EC0.SCAD, 0x02, Local2), Local1, Local3)
                                                                    Or (ShiftLeft (^^PCI0.LPCB.EC0.SCBL, 0x10, Local4), Local3, Index (TSFR, 0x02))
                                                                    Store (0x00640005, Index (TSFR, 0x03))
                                                                    Store (0x000A0004, Index (TSFR, 0x04))
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                Else
                                                {
                                                    Store (0x8200, Index (TSFR, Zero))
                                                }

                                                Return (TSFR)
                                            }
                                            Else
                                            {
                                                If (LAnd (LEqual (TOI0, 0xF400), LEqual (TOI1, 0x0150)))
                                                {
                                                    If (LEqual (INFF, One))
                                                    {
                                                        Store (Zero, Index (TSFR, Zero))
                                                        If (LEqual (TOI5, Zero))
                                                        {
                                                            If (LEqual (And (TOI2, 0x00800000), 0x00800000))
                                                            {
                                                                If (LEqual (TOI2, 0x00800000))
                                                                {
                                                                    Store (Zero, ^^PCI0.LPCB.INF)
                                                                    ^^PCI0.LPCB.PHSS (0x7C)
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LAnd (LEqual (And (TOI2, One), One), 
                                                                        LGreaterEqual (And (TOI2, 0x1F), 0x03)), LLessEqual (And (TOI2, 0x1F
                                                                        ), 0x1F)))
                                                                    {
                                                                        Store (TOI2, ^^PCI0.LPCB.INF)
                                                                        ^^PCI0.LPCB.PHSS (0x7C)
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                    }
                                                                }
                                                            }
                                                            Else
                                                            {
                                                                Store (0x8300, Index (TSFR, Zero))
                                                            }
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (TOI5, 0x0200))
                                                            {
                                                                If (LAnd (LLessEqual (And (TOI2, 0x00FF0000), 0x00640000), 
                                                                    LLessEqual (And (TOI2, 0x0F), 0x07)))
                                                                {
                                                                    Store (TOI2, Local0)
                                                                    And (Local0, One, ^^PCI0.LPCB.EC0.SCAC)
                                                                    ShiftRight (TOI2, One, Local0)
                                                                    And (Local0, One, ^^PCI0.LPCB.EC0.SCDC)
                                                                    ShiftRight (TOI2, 0x02, Local0)
                                                                    And (Local0, One, ^^PCI0.LPCB.EC0.SCAD)
                                                                    ShiftRight (TOI2, 0x10, Local0)
                                                                    And (Local0, 0x7F, ^^PCI0.LPCB.EC0.SCBL)
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                }
                                                            }
                                                            Else
                                                            {
                                                                Store (0x8300, Index (TSFR, Zero))
                                                            }
                                                        }
                                                    }
                                                    Else
                                                    {
                                                        Store (0x8200, Index (TSFR, Zero))
                                                    }

                                                    Return (TSFR)
                                                }
                                            }
                                        }
                                    }

                                    Return (TSFR)
                                }

                                Name (_T_0, Zero)
                                Store (ToInteger (TOI0), _T_0)
                                If (LEqual (_T_0, 0xFE00))
                                {
                                    Name (_T_1, Zero)
                                    Store (ToInteger (TOI1), _T_1)
                                    If (LEqual (_T_1, 0x2A))
                                    {
                                        Store (Zero, Index (TSFR, Zero))
                                        Store (ShiftLeft (^^PCI0.LPCB.PHMR (0xB9F4), 0x0D, Local0), Index (TSFR, 0x02))
                                        Store (ShiftLeft (^^PCI0.LPCB.PHMR (0x93F8), 0x0D, Local1), Index (TSFR, 0x03))
                                        Return (TSFR)
                                    }
                                    Else
                                    {
                                        If (LEqual (_T_1, 0x9F))
                                        {
                                            If (LEqual (TOI2, Zero))
                                            {
                                                Store (^^PCI0.LPCB.PHMR (0xD7F8), Local0)
                                                ShiftLeft (Local0, 0x08, Local0)
                                                Store (^^PCI0.LPCB.PHMR (0xD8F8), Local1)
                                                Or (Local0, Local1, Local2)
                                                If (LEqual (Local2, 0xFFFF))
                                                {
                                                    Store (Zero, Index (TSFR, 0x03))
                                                }
                                                Else
                                                {
                                                    Store (Local2, Index (TSFR, 0x03))
                                                }

                                                Store (Zero, Index (TSFR, Zero))
                                            }
                                            Else
                                            {
                                                If (LEqual (TOI2, 0xFFFF))
                                                {
                                                    Store (Zero, Index (TSFR, Zero))
                                                    Store (0x0200, Index (TSFR, 0x03))
                                                }
                                                Else
                                                {
                                                    Store (0x8300, Index (TSFR, Zero))
                                                }
                                            }

                                            Return (TSFR)
                                        }
                                        Else
                                        {
                                            If (LEqual (_T_1, 0xA1))
                                            {
                                                Store (Zero, BUSY)
                                                Store (0x80, COMT)
                                                If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                {
                                                    Store (Zero, Index (TSFR, Zero))
                                                }
                                                Else
                                                {
                                                    If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                    {
                                                        If (LEqual (TOI2, One))
                                                        {
                                                            Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                            And (Local1, One, Local1)
                                                            If (LEqual (Local1, One))
                                                            {
                                                                Store (Zero, Index (TSFR, Zero))
                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0xC7F4), 0x08, Local2)
                                                                Or (Local2, ^^PCI0.LPCB.PHMR (0xC6F4), Local2)
                                                                Divide (Local2, 0x64, Local3, Index (TSFR, 0x02))
                                                            }
                                                            Else
                                                            {
                                                                Store (Zero, Index (TSFR, Zero))
                                                                Store (0xFF, Index (TSFR, 0x02))
                                                            }
                                                        }
                                                        Else
                                                        {
                                                            Store (0x8300, Index (TSFR, Zero))
                                                            Store (0xFF, Index (TSFR, 0x02))
                                                        }
                                                    }
                                                    Else
                                                    {
                                                        If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                            BUSY, 0x40)))
                                                        {
                                                            Store (0x8D20, Index (TSFR, Zero))
                                                        }
                                                        Else
                                                        {
                                                            If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                LNotEqual (COMT, 0x80)))
                                                            {
                                                                Store (0x8D50, Index (TSFR, Zero))
                                                            }
                                                            Else
                                                            {
                                                                Store (0x8300, Index (TSFR, Zero))
                                                            }
                                                        }
                                                    }
                                                }

                                                Return (TSFR)
                                            }
                                            Else
                                            {
                                                If (LEqual (_T_1, 0xA2))
                                                {
                                                    Store (Zero, BUSY)
                                                    Store (0x80, COMT)
                                                    If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                    {
                                                        If (LOr (LEqual (TOI3, Zero), LEqual (TOI3, One)))
                                                        {
                                                            Store (Zero, Index (TSFR, Zero))
                                                        }
                                                    }
                                                    Else
                                                    {
                                                        If (LAnd (LAnd (LEqual (TOI3, Zero), LEqual (TOI5, One)), LEqual (
                                                            COMT, 0x80)))
                                                        {
                                                            ShiftRight (^^PCI0.LPCB.PHMR (0xADF4), 0x04, Local1)
                                                            If (LLess (TOI2, Local1))
                                                            {
                                                                If (LEqual (TOI2, Zero))
                                                                {
                                                                    Store (Zero, Index (TSFR, Zero))
                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xECF8), 0x08, Local1)
                                                                    Or (Local1, ^^PCI0.LPCB.PHMR (0xEDF8), Index (TSFR, 0x02))
                                                                }
                                                                Else
                                                                {
                                                                    If (LEqual (TOI2, One))
                                                                    {
                                                                        Store (Zero, Index (TSFR, Zero))
                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xEEF8), 0x08, Local1)
                                                                        Or (Local1, ^^PCI0.LPCB.PHMR (0xEFF8), Index (TSFR, 0x02))
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                    }
                                                                }
                                                            }
                                                            Else
                                                            {
                                                                Store (0x8300, Index (TSFR, Zero))
                                                            }
                                                        }
                                                        Else
                                                        {
                                                            If (LAnd (LAnd (LEqual (TOI3, One), LEqual (TOI5, One)), LEqual (
                                                                COMT, 0x80)))
                                                            {
                                                                ShiftRight (^^PCI0.LPCB.PHMR (0xADF4), 0x04, Local1)
                                                                If (LLess (TOI2, Local1))
                                                                {
                                                                    If (LEqual (TOI2, Zero))
                                                                    {
                                                                        Store (Zero, Index (TSFR, Zero))
                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xECF8), 0x08, Local1)
                                                                        Or (Local1, ^^PCI0.LPCB.PHMR (0xEDF8), Index (TSFR, 0x02))
                                                                        Multiply (^^PCI0.LPCB.PHMR (0x95F8), 0x64, Index (TSFR, 0x03))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (TOI2, One))
                                                                        {
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xEEF8), 0x08, Local1)
                                                                            Or (Local1, ^^PCI0.LPCB.PHMR (0xEFF8), Index (TSFR, 0x02))
                                                                            Multiply (^^PCI0.LPCB.PHMR (0x96F8), 0x64, Index (TSFR, 0x03))
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                        }
                                                                    }
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                }
                                                            }
                                                            Else
                                                            {
                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                    BUSY, 0x40)))
                                                                {
                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                        LNotEqual (COMT, 0x80)))
                                                                    {
                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }

                                                    Return (TSFR)
                                                }
                                                Else
                                                {
                                                    If (LEqual (_T_1, 0xA6))
                                                    {
                                                        If (HAPE)
                                                        {
                                                            Store (Zero, BUSY)
                                                            Store (0x80, COMT)
                                                            If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                            {
                                                                Store (Zero, Index (TSFR, Zero))
                                                            }
                                                            Else
                                                            {
                                                                If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                {
                                                                    If (LEqual (TOI3, One))
                                                                    {
                                                                        Store (Zero, Index (TSFR, Zero))
                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE3F8), 0x18, Local1)
                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE2F8), 0x10, Local2)
                                                                        Or (Local1, Local2, Local2)
                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE1F8), 0x08, Local3)
                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0xE0F8), Local4)
                                                                        Or (Local2, Local4, Index (TSFR, 0x02))
                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE5F8), 0x08, Local5)
                                                                        Or (Local5, ^^PCI0.LPCB.PHMR (0xE4F8), Index (TSFR, 0x04))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (TOI3, Zero))
                                                                        {
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x59F5), 0x18, Local1)
                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x58F5), 0x10, Local2)
                                                                            Or (Local1, Local2, Local2)
                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x57F5), 0x08, Local3)
                                                                            Or (Local3, ^^PCI0.LPCB.PHMR (0x56F5), Local4)
                                                                            Or (Local2, Local4, Index (TSFR, 0x02))
                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x5BF5), 0x08, Local5)
                                                                            Or (Local5, ^^PCI0.LPCB.PHMR (0x5AF5), Index (TSFR, 0x04))
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (TOI3, 0x0200))
                                                                            {
                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x18, Local1)
                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x68F5), 0x10, Local2)
                                                                                Or (Local1, Local2, Local2)
                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local4)
                                                                                Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local5)
                                                                                Or (Local5, ^^PCI0.LPCB.PHMR (0x6AF5), Local6)
                                                                                Add (Local6, ^^PCI0.LPCB.PHMR (0x5EF5), Index (TSFR, 0x04))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (TOI3, 0x0201))
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x08, Local1)
                                                                                    Or (Local1, ^^PCI0.LPCB.PHMR (0x68F5), Local1)
                                                                                    Add (Local1, ^^PCI0.LPCB.PHMR (0x5DF5), Local2)
                                                                                    ShiftLeft (Local2, 0x10, Local2)
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local3)
                                                                                    Add (Local3, ^^PCI0.LPCB.PHMR (0x5CF5), Local4)
                                                                                    Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local2)
                                                                                    Or (Local2, ^^PCI0.LPCB.PHMR (0x6AF5), Index (TSFR, 0x04))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                        BUSY, 0x40)))
                                                                    {
                                                                        Store (0x8D20, Index (TSFR, Zero))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                            LNotEqual (COMT, 0x80)))
                                                                        {
                                                                            Store (0x8D50, Index (TSFR, Zero))
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        Else
                                                        {
                                                            Store (0x8000, Index (TSFR, Zero))
                                                        }

                                                        Return (TSFR)
                                                    }
                                                    Else
                                                    {
                                                        If (LEqual (_T_1, 0xA7))
                                                        {
                                                            Store (Zero, BUSY)
                                                            Store (0x80, COMT)
                                                            If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                            {
                                                                Store (Zero, Index (TSFR, Zero))
                                                            }
                                                            Else
                                                            {
                                                                If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                {
                                                                    Store (^^PCI0.LPCB.PHMR (0xC5F6), Local1)
                                                                    And (Local1, One, ACET)
                                                                    Store (Zero, Index (TSFR, Zero))
                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xB3F4), 0x18, Local1)
                                                                    Store (Zero, ^^PCI0.LPCB.INF)
                                                                    ^^PCI0.LPCB.PHSS (0x7A)
                                                                    Store (^^PCI0.LPCB.INF, Local2)
                                                                    ShiftLeft (Local2, 0x10, Local2)
                                                                    Or (Local1, Local2, Local2)
                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xB0F4), 0x08, Local3)
                                                                    If (LEqual (ACET, One))
                                                                    {
                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0xE7F8), Local4)
                                                                    }
                                                                    Else
                                                                    {
                                                                        Or (Local3, 0xFF, Local4)
                                                                    }

                                                                    Or (Local2, Local4, Index (TSFR, 0x02))
                                                                    And (0xFF, ^^PCI0.LPCB.PHMR (0xE9F8), Local5)
                                                                    ShiftLeft (Local5, 0x10, Local5)
                                                                    If (LEqual (ACET, One))
                                                                    {
                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xEAF8), 0x08, Local6)
                                                                        Or (Local6, ^^PCI0.LPCB.PHMR (0xEBF8), Local6)
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (0xFFFF, Local6)
                                                                    }

                                                                    Or (Local5, Local6, Index (TSFR, 0x03))
                                                                }
                                                                Else
                                                                {
                                                                    If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                        BUSY, 0x40)))
                                                                    {
                                                                        Store (0x8D20, Index (TSFR, Zero))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                            LNotEqual (COMT, 0x80)))
                                                                        {
                                                                            Store (0x8D50, Index (TSFR, Zero))
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                        }
                                                                    }
                                                                }
                                                            }

                                                            Return (TSFR)
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (_T_1, 0xA8))
                                                            {
                                                                Name (_T_2, Zero)
                                                                Store (ToInteger (TOI4), _T_2)
                                                                If (LEqual (_T_2, 0x98))
                                                                {
                                                                    Store (Zero, BUSY)
                                                                    Store (0x80, COMT)
                                                                    If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                    {
                                                                        Store (Zero, Index (TSFR, Zero))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                        {
                                                                            If (LEqual (TOI2, One))
                                                                            {
                                                                                Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                                                And (Local1, One, Local1)
                                                                                If (LEqual (Local1, One))
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Store (^^PCI0.LPCB.PHMR (0xD7F4), Index (TSFR, 0x03))
                                                                                    Store (^^PCI0.LPCB.PHMR (0xD1F4), Local2)
                                                                                    And (Local2, 0x80, Local2)
                                                                                    If (LLess (Local2, 0x80))
                                                                                    {
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xD1F4), 0x08, Local1)
                                                                                        Or (Local1, ^^PCI0.LPCB.PHMR (0xD0F4), Index (TSFR, 0x02))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xD1F4), 0x08, Local1)
                                                                                        Or (Local1, ^^PCI0.LPCB.PHMR (0xD0F4), Local1)
                                                                                        Subtract (0xFFFF, Local1, Index (TSFR, 0x02))
                                                                                    }
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                    Store (0xFF, Index (TSFR, 0x03))
                                                                                }
                                                                            }
                                                                            Else
                                                                            {
                                                                                Store (0x8300, Index (TSFR, Zero))
                                                                                Store (0xFFFF, Index (TSFR, 0x02))
                                                                                Store (0xFF, Index (TSFR, 0x03))
                                                                            }
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                BUSY, 0x40)))
                                                                            {
                                                                                Store (0x8D20, Index (TSFR, Zero))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                    LNotEqual (COMT, 0x80)))
                                                                                {
                                                                                    Store (0x8D50, Index (TSFR, Zero))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                }
                                                                            }
                                                                        }
                                                                    }

                                                                    Return (TSFR)
                                                                }
                                                                Else
                                                                {
                                                                    If (LEqual (_T_2, 0x9A))
                                                                    {
                                                                        Store (Zero, BUSY)
                                                                        Store (0x80, COMT)
                                                                        If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                        {
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                            {
                                                                                ShiftRight (^^PCI0.LPCB.PHMR (0xADF4), 0x04, Local1)
                                                                                If (LLess (TOI2, Local1))
                                                                                {
                                                                                    If (LEqual (TOI2, Zero))
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Store (^^PCI0.LPCB.PHMR (0x99F8), Index (TSFR, 0x02))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (TOI2, One))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Store (^^PCI0.LPCB.PHMR (0x9AF8), Index (TSFR, 0x02))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                                        }
                                                                                    }
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                }
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                    BUSY, 0x40)))
                                                                                {
                                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                        LNotEqual (COMT, 0x80)))
                                                                                    {
                                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                    }
                                                                                }
                                                                            }
                                                                        }

                                                                        Return (TSFR)
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (_T_2, 0x9B))
                                                                        {
                                                                            Store (Zero, BUSY)
                                                                            Store (0x80, COMT)
                                                                            If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                            {
                                                                                Store (Zero, Index (TSFR, Zero))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LAnd (LEqual (TOI2, Zero), LEqual (TOI5, One)), LEqual (
                                                                                    COMT, 0x80)))
                                                                                {
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x9BF8), 0x18, Local1)
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x9CF8), 0x10, Local2)
                                                                                    Or (Local1, Local2, Local2)
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x9DF8), 0x08, Local3)
                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0x9EF8), Local3)
                                                                                    Or (Local2, Local3, Index (TSFR, 0x03))
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x9FF8), 0x18, Local4)
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xA0F8), 0x10, Local5)
                                                                                    Or (Local4, Local5, Local5)
                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xA1F8), 0x08, Local6)
                                                                                    Or (Local6, ^^PCI0.LPCB.PHMR (0xA2F8), Local6)
                                                                                    Or (Local5, Local6, Index (TSFR, 0x02))
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Or (^^PCI0.LPCB.PHMR (0xDFF8), 0x02, Local1)
                                                                                    ^^PCI0.LPCB.PHMW (0xDFF8, Local1)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LAnd (LEqual (TOI2, One), LEqual (TOI5, One)), LEqual (
                                                                                        COMT, 0x80)))
                                                                                    {
                                                                                        And (0xFF, ^^PCI0.LPCB.PHMR (0xA3F8), Local1)
                                                                                        Store (Local1, Index (TSFR, 0x02))
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Or (^^PCI0.LPCB.PHMR (0xDFF8), 0x04, Local1)
                                                                                        ^^PCI0.LPCB.PHMW (0xDFF8, Local1)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LAnd (LAnd (LEqual (TOI2, 0x02), LEqual (TOI5, One)), LEqual (
                                                                                            COMT, 0x80)))
                                                                                        {
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xABF8), 0x18, Local1)
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xAAF8), 0x10, Local2)
                                                                                            Or (Local1, Local2, Local2)
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xA9F8), 0x08, Local3)
                                                                                            Or (Local3, ^^PCI0.LPCB.PHMR (0xA8F8), Local3)
                                                                                            Or (Local2, Local3, Index (TSFR, 0x03))
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xA7F8), 0x18, Local4)
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xA6F8), 0x10, Local5)
                                                                                            Or (Local4, Local5, Local5)
                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0xA5F8), 0x08, Local6)
                                                                                            Or (Local6, ^^PCI0.LPCB.PHMR (0xA4F8), Local6)
                                                                                            Or (Local5, Local6, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Or (^^PCI0.LPCB.PHMR (0xDFF8), 0x08, Local1)
                                                                                            ^^PCI0.LPCB.PHMW (0xDFF8, Local1)
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                                BUSY, 0x40)))
                                                                                            {
                                                                                                Store (0x8D20, Index (TSFR, Zero))
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                                    LNotEqual (COMT, 0x80)))
                                                                                                {
                                                                                                    Store (0x8D50, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }

                                                                            Return (TSFR)
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (_T_2, 0x9D))
                                                                            {
                                                                                If (LEqual (TOI3, Zero))
                                                                                {
                                                                                    If (LEqual (TOI5, Zero))
                                                                                    {
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (TOI5, One))
                                                                                        {
                                                                                            Store (^^PCI0.LPCB.PHMR (0xDFF8), Local0)
                                                                                            And (Local0, One, Local0)
                                                                                            Store (Local0, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                                        }
                                                                                    }
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                }

                                                                                Return (TSFR)
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (_T_2, 0xA0))
                                                                                {
                                                                                    If (LEqual (TOI3, Zero))
                                                                                    {
                                                                                        Store (Zero, BUSY)
                                                                                        Store (0x80, COMT)
                                                                                        If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                                            {
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                Store (^^PCI0.LPCB.PHMR (0xDBF8), Local1)
                                                                                                Store (0x0B, Local2)
                                                                                                And (Local1, Local2, Index (TSFR, 0x02))
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                                    BUSY, 0x40)))
                                                                                                {
                                                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                                        LNotEqual (COMT, 0x80)))
                                                                                                    {
                                                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                    }

                                                                                    Return (TSFR)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (_T_2, 0xA9))
                                                                                    {
                                                                                        Store (Zero, BUSY)
                                                                                        Store (0x80, COMT)
                                                                                        If (LAnd (LEqual (TOI5, Zero), LNotEqual (BUSY, 0x40)))
                                                                                        {
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LAnd (LEqual (TOI5, One), LEqual (COMT, 0x80)))
                                                                                            {
                                                                                                If (LEqual (TOI2, One))
                                                                                                {
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                    Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                                                                    And (Local1, One, Local1)
                                                                                                    If (LEqual (Local1, One))
                                                                                                    {
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x60F5), 0x18, Local1)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x61F5), 0x10, Local2)
                                                                                                        Or (Local1, Local2, Local2)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xDFF4), 0x08, Local3)
                                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0xDEF4), Local4)
                                                                                                        Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE6F4), 0x18, Local1)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE5F4), 0x10, Local2)
                                                                                                        Or (Local1, Local2, Local2)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE4F4), 0x08, Local3)
                                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0xE3F4), Local4)
                                                                                                        Or (Local2, Local4, Index (TSFR, 0x03))
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x62F5), 0x18, Local1)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x63F5), 0x10, Local2)
                                                                                                        Or (Local1, Local2, Local2)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0x64F5), 0x08, Local3)
                                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0x65F5), Local4)
                                                                                                        Or (Local2, Local4, Index (TSFR, 0x04))
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xEAF4), 0x18, Local1)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE9F4), 0x10, Local2)
                                                                                                        Or (Local1, Local2, Local2)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE8F4), 0x08, Local3)
                                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0xE7F4), Local4)
                                                                                                        Or (Local2, Local4, Index (TSFR, 0x05))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                        Store (0xFFFF, Index (TSFR, 0x03))
                                                                                                        Store (0xFFFF, Index (TSFR, 0x04))
                                                                                                        Store (0xFFFF, Index (TSFR, 0x05))
                                                                                                    }
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LEqual (TOI2, 0x8001))
                                                                                                    {
                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                        Store (^^PCI0.LPCB.PHMR (0x9AF4), Local1)
                                                                                                        And (Local1, One, Local1)
                                                                                                        If (LEqual (Local1, One))
                                                                                                        {
                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x6CF5), 0x08, Local1)
                                                                                                            Or (Local1, ^^PCI0.LPCB.PHMR (0x6DF5), Local1)
                                                                                                            Store (Local1, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                        }
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                                        Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                        Store (0xFFFF, Index (TSFR, 0x03))
                                                                                                        Store (0xFFFF, Index (TSFR, 0x04))
                                                                                                        Store (0xFFFF, Index (TSFR, 0x05))
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LAnd (LOr (LEqual (TOI5, Zero), LEqual (TOI5, One)), LEqual (
                                                                                                    BUSY, 0x40)))
                                                                                                {
                                                                                                    Store (0x8D20, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LAnd (LAnd (LEqual (TOI5, One), LNotEqual (BUSY, 0x40)), 
                                                                                                        LNotEqual (COMT, 0x80)))
                                                                                                    {
                                                                                                        Store (0x8D50, Index (TSFR, Zero))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Store (0x8300, Index (TSFR, Zero))
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }

                                                                                        Return (TSFR)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8000, Index (TSFR, Zero))
                                                                                        Return (TSFR)
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            Else
                                                            {
                                                                If (LEqual (_T_1, 0xAA))
                                                                {
                                                                    Store (Zero, Index (TSFR, Zero))
                                                                    Store (^^PCI0.LPCB.PHMR (0xD2F8), Index (TSFR, 0x02))
                                                                    Store (^^PCI0.LPCB.PHMR (0xD3F8), Index (TSFR, 0x03))
                                                                    Return (TSFR)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                Else
                                {
                                    If (LEqual (_T_0, 0xFF00))
                                    {
                                        Name (_T_3, Zero)
                                        Store (ToInteger (TOI1), _T_3)
                                        If (LEqual (_T_3, 0x42))
                                        {
                                            If (LOr (LEqual (TOI2, One), LEqual (TOI2, 0x10)))
                                            {
                                                ^^PCI0.LPCB.PHMW (0x94F8, TOI2)
                                                Store (Zero, Index (TSFR, Zero))
                                            }
                                            Else
                                            {
                                                Store (0x8300, Index (TSFR, Zero))
                                            }

                                            Return (TSFR)
                                        }
                                        Else
                                        {
                                            If (LEqual (_T_3, 0x9D))
                                            {
                                                If (LEqual (TOI3, Zero))
                                                {
                                                    If (LOr (LEqual (TOI2, Zero), LEqual (TOI2, One)))
                                                    {
                                                        ^^PCI0.LPCB.PHMW (0xDFF8, TOI2)
                                                        Store (Zero, Index (TSFR, Zero))
                                                    }
                                                    Else
                                                    {
                                                        Store (0x8300, Index (TSFR, Zero))
                                                    }
                                                }
                                                Else
                                                {
                                                    Store (0x8300, Index (TSFR, Zero))
                                                }

                                                Return (TSFR)
                                            }
                                            Else
                                            {
                                                If (LEqual (_T_3, 0x9F))
                                                {
                                                    If (LEqual (TOI2, Zero))
                                                    {
                                                        ShiftRight (TOI3, 0x08, Local0)
                                                        And (TOI3, 0xFF, Local1)
                                                        ^^PCI0.LPCB.PHMW (0xD7F8, Local0)
                                                        ^^PCI0.LPCB.PHMW (0xD8F8, Local1)
                                                        ^^PCI0.LPCB.PHMW (0xD9F8, One)
                                                        Store (Zero, Index (TSFR, Zero))
                                                    }
                                                    Else
                                                    {
                                                        Store (0x8300, Index (TSFR, Zero))
                                                    }

                                                    Return (TSFR)
                                                }
                                                Else
                                                {
                                                    If (LEqual (_T_3, 0xA0))
                                                    {
                                                        And (TOI2, 0xF4, Local0)
                                                        If (LAnd (LEqual (TOI3, Zero), LEqual (Local0, Zero)))
                                                        {
                                                            ^^PCI0.LPCB.PHMW (0xDBF8, TOI2)
                                                            Store (Zero, Index (TSFR, Zero))
                                                        }
                                                        Else
                                                        {
                                                            Store (0x8300, Index (TSFR, Zero))
                                                        }

                                                        Return (TSFR)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                Name (_T_4, Zero)
                                Store (ToInteger (TOI0), _T_4)
                                If (LEqual (_T_4, 0xF100))
                                {
                                    If (LEqual (INFF, Zero))
                                    {
                                        Store (One, INFF)
                                        Store (0x44, Index (TSFR, Zero))
                                    }
                                    Else
                                    {
                                        Store (0x8100, Index (TSFR, Zero))
                                    }

                                    Return (TSFR)
                                }
                                Else
                                {
                                    If (LEqual (_T_4, 0xF200))
                                    {
                                        If (LEqual (INFF, One))
                                        {
                                            Store (Zero, INFF)
                                            Store (0x44, Index (TSFR, Zero))
                                        }
                                        Else
                                        {
                                            Store (0x8200, Index (TSFR, Zero))
                                        }

                                        Return (TSFR)
                                    }
                                    Else
                                    {
                                        If (LEqual (_T_4, 0xF300))
                                        {
                                            Name (_T_5, Zero)
                                            Store (ToInteger (TOI1), _T_5)
                                            If (LEqual (_T_5, 0x050E))
                                            {
                                                Store (^^PCI0.LPCB.PHMR (0x9EF4), Local0)
                                                And (Local0, 0x08, Local0)
                                                If (Local0)
                                                {
                                                    Store (Zero, Index (TSFR, 0x02))
                                                }
                                                Else
                                                {
                                                    Store (One, Index (TSFR, 0x02))
                                                }

                                                Store (Zero, Index (TSFR, Zero))
                                                Return (TSFR)
                                            }
                                            Else
                                            {
                                                If (LEqual (_T_5, 0x010E))
                                                {
                                                    Or (ALMF, 0x02, ALMF)
                                                    ^^PCI0.LPCB.PHSS (0x8E)
                                                    Or (ShiftLeft (ALMY, 0x0A, Local0), ShiftLeft (ALMO, 0x06, Local1), Local2)
                                                    Or (ShiftLeft (ALMD, One, Local0), Local2, Local3)
                                                    Store (0x8005, Index (TSFR, One))
                                                    Store (Local3, Index (TSFR, 0x02))
                                                    Store (0x03FE, Index (TSFR, 0x03))
                                                    Store (Zero, Index (TSFR, Zero))
                                                    Return (TSFR)
                                                }
                                                Else
                                                {
                                                    If (LEqual (_T_5, 0x010F))
                                                    {
                                                        Or (ALMF, One, ALMF)
                                                        ^^PCI0.LPCB.PHSS (0x8E)
                                                        Or (ShiftLeft (ALMH, 0x07, Local0), ShiftLeft (ALMM, One, Local1), Local2)
                                                        If (LEqual (Local2, Zero))
                                                        {
                                                            Store (One, Local2)
                                                        }

                                                        Store (0x8004, Index (TSFR, One))
                                                        Store (Local2, Index (TSFR, 0x02))
                                                        Store (0x0FFF, Index (TSFR, 0x03))
                                                        Store (One, Index (TSFR, 0x04))
                                                        Store (Zero, Index (TSFR, Zero))
                                                        Return (TSFR)
                                                    }
                                                    Else
                                                    {
                                                        If (LEqual (_T_5, 0x0150))
                                                        {
                                                            If (LEqual (INFF, One))
                                                            {
                                                                Store (Zero, Index (TSFR, Zero))
                                                                If (LEqual (TOI5, Zero))
                                                                {
                                                                    Store (0x800C, Index (TSFR, One))
                                                                    ^^PCI0.LPCB.PHSS (0x7D)
                                                                    Or (ShiftLeft (One, 0x17, Local0), ^^PCI0.LPCB.INF, Local1)
                                                                    Store (Local1, Index (TSFR, 0x02))
                                                                    Or (ShiftLeft (One, One, Local0), One, Local1)
                                                                    Or (ShiftLeft (One, 0x02, Local2), Local1, Local3)
                                                                    Or (ShiftLeft (One, 0x03, Local4), Local3, Local5)
                                                                    Or (ShiftLeft (One, 0x04, Local6), Local5, Local7)
                                                                    ShiftLeft (One, 0x17, Local0)
                                                                    Or (Local0, Local7, Index (TSFR, 0x03))
                                                                    Or (Local0, Zero, Index (TSFR, 0x04))
                                                                }
                                                                Else
                                                                {
                                                                    If (LEqual (TOI5, 0x0100))
                                                                    {
                                                                        Store (0x8001, Index (TSFR, One))
                                                                        Store (One, Index (TSFR, 0x02))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (TOI5, 0x0101))
                                                                        {
                                                                            Store (0x800C, Index (TSFR, One))
                                                                            Or (ShiftLeft (One, One, Local0), One, Local1)
                                                                            Or (ShiftLeft (One, 0x02, Local2), Local1, Local3)
                                                                            Or (ShiftLeft (One, 0x03, Local4), Local3, Local5)
                                                                            Or (ShiftLeft (One, 0x04, Local6), Local5, Local7)
                                                                            ShiftLeft (One, 0x17, Local0)
                                                                            Or (Local0, Local7, Index (TSFR, 0x02))
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (TOI5, 0x0200))
                                                                            {
                                                                                Store (0x800D, Index (TSFR, One))
                                                                                Or (ShiftLeft (^^PCI0.LPCB.EC0.SCDC, One, Local0), ^^PCI0.LPCB.EC0.SCAC, Local1)
                                                                                Or (ShiftLeft (^^PCI0.LPCB.EC0.SCAD, 0x02, Local2), Local1, Local3)
                                                                                Or (ShiftLeft (^^PCI0.LPCB.EC0.SCBL, 0x10, Local4), Local3, Index (TSFR, 0x02))
                                                                                Store (0x00640005, Index (TSFR, 0x03))
                                                                                Store (0x000A0004, Index (TSFR, 0x04))
                                                                            }
                                                                            Else
                                                                            {
                                                                                Store (0x8300, Index (TSFR, Zero))
                                                                            }
                                                                        }
                                                                    }
                                                                }

                                                                Return (TSFR)
                                                            }
                                                            Else
                                                            {
                                                                Store (0x8200, Index (TSFR, Zero))
                                                                Return (TSFR)
                                                            }
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (_T_5, 0x014E))
                                                            {
                                                                Store (0x8000, Index (TSFR, Zero))
                                                                Return (TSFR)
                                                            }
                                                            Else
                                                            {
                                                                Store (0x8000, Index (TSFR, Zero))
                                                                Return (TSFR)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        Else
                                        {
                                            If (LEqual (_T_4, 0xF400))
                                            {
                                                Name (_T_6, Zero)
                                                Store (ToInteger (TOI1), _T_6)
                                                If (LEqual (_T_6, 0x050E))
                                                {
                                                    If (TOUD)
                                                    {
                                                        If (LEqual (TOI2, Zero))
                                                        {
                                                            Store (^^PCI0.LPCB.PHMR (0x9EF4), Local0)
                                                            Or (Local0, 0x08, Local0)
                                                            ^^PCI0.LPCB.PHMW (0x9EF4, Local0)
                                                        }
                                                        Else
                                                        {
                                                            Store (^^PCI0.LPCB.PHMR (0x9EF4), Local0)
                                                            And (Local0, 0xFFFFFFF7, Local0)
                                                            ^^PCI0.LPCB.PHMW (0x9EF4, Local0)
                                                        }
                                                    }

                                                    Store (Zero, Index (TSFR, Zero))
                                                    Return (TSFR)
                                                }
                                                Else
                                                {
                                                    If (LEqual (_T_6, 0x010E))
                                                    {
                                                        If (LEqual (TOI2, Zero))
                                                        {
                                                            Store (Zero, ALMF)
                                                        }
                                                        Else
                                                        {
                                                            ShiftRight (TOI2, One, Local0)
                                                            And (Local0, 0x1F, ALMD)
                                                            ShiftRight (TOI2, 0x06, Local0)
                                                            And (Local0, 0x0F, ALMO)
                                                            ShiftRight (TOI2, 0x0A, Local0)
                                                            And (Local0, 0x3F, ALMY)
                                                            Store (0x88, ALMF)
                                                            ^^PCI0.LPCB.PHSS (0x8E)
                                                        }

                                                        Store (Zero, Index (TSFR, Zero))
                                                        Return (TSFR)
                                                    }
                                                    Else
                                                    {
                                                        If (LEqual (_T_6, 0x010F))
                                                        {
                                                            If (LEqual (TOI2, Zero))
                                                            {
                                                                Store (Zero, ALMF)
                                                            }
                                                            Else
                                                            {
                                                                ShiftRight (TOI2, One, Local0)
                                                                And (Local0, 0x3F, ALMM)
                                                                ShiftRight (TOI2, 0x07, Local0)
                                                                And (Local0, 0x1F, ALMH)
                                                                Store (0x84, ALMF)
                                                                ^^PCI0.LPCB.PHSS (0x8E)
                                                            }

                                                            Store (Zero, Index (TSFR, Zero))
                                                            Return (TSFR)
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (_T_6, 0x0150))
                                                            {
                                                                If (LEqual (INFF, One))
                                                                {
                                                                    Store (Zero, Index (TSFR, Zero))
                                                                    If (LEqual (TOI5, Zero))
                                                                    {
                                                                        If (LEqual (And (TOI2, 0x00800000), 0x00800000))
                                                                        {
                                                                            If (LEqual (TOI2, 0x00800000))
                                                                            {
                                                                                Store (Zero, ^^PCI0.LPCB.INF)
                                                                                ^^PCI0.LPCB.PHSS (0x7C)
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LAnd (LEqual (And (TOI2, One), One), 
                                                                                    LGreaterEqual (And (TOI2, 0x1F), 0x03)), LLessEqual (And (TOI2, 0x1F
                                                                                    ), 0x1F)))
                                                                                {
                                                                                    Store (TOI2, ^^PCI0.LPCB.INF)
                                                                                    ^^PCI0.LPCB.PHSS (0x7C)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                                }
                                                                            }
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                        }
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (TOI5, 0x0200))
                                                                        {
                                                                            If (LAnd (LLessEqual (And (TOI2, 0x00FF0000), 0x00640000), 
                                                                                LLessEqual (And (TOI2, 0x0F), 0x07)))
                                                                            {
                                                                                Store (TOI2, Local0)
                                                                                And (Local0, One, ^^PCI0.LPCB.EC0.SCAC)
                                                                                ShiftRight (TOI2, One, Local0)
                                                                                And (Local0, One, ^^PCI0.LPCB.EC0.SCDC)
                                                                                ShiftRight (TOI2, 0x02, Local0)
                                                                                And (Local0, One, ^^PCI0.LPCB.EC0.SCAD)
                                                                                ShiftRight (TOI2, 0x10, Local0)
                                                                                And (Local0, 0x7F, ^^PCI0.LPCB.EC0.SCBL)
                                                                            }
                                                                            Else
                                                                            {
                                                                                Store (0x8300, Index (TSFR, Zero))
                                                                            }
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8300, Index (TSFR, Zero))
                                                                        }
                                                                    }
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x8200, Index (TSFR, Zero))
                                                                }

                                                                Return (TSFR)
                                                            }
                                                            Else
                                                            {
                                                                If (LEqual (_T_6, 0x014E))
                                                                {
                                                                    Store (0x8000, Index (TSFR, Zero))
                                                                    Return (TSFR)
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x8000, Index (TSFR, Zero))
                                                                    Return (TSFR)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            Else
                                            {
                                                If (LEqual (_T_4, 0xFE00))
                                                {
                                                    Name (_T_7, Zero)
                                                    Store (ToInteger (TOI1), _T_7)
                                                    If (LEqual (_T_7, 0x56))
                                                    {
                                                        Name (_T_8, Zero)
                                                        Store (ToInteger (TOI3), _T_8)
                                                        If (LEqual (_T_8, One))
                                                        {
                                                            Store (^^PCI0.LPCB.PHMR (0xBBF4), Local0)
                                                            And (Local0, One, Local0)
                                                            Store (^^PCI0.LPCB.PHMR (0xBBF4), Local1)
                                                            And (Local1, 0x10, Local1)
                                                            Or (ShiftLeft (Local0, 0x09, Local0), ShiftRight (Local1, 0x04, Local1), Local2)
                                                            Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                            And (Local0, 0x20, Local0)
                                                            Or (ShiftLeft (Local0, 0x08, Local0), Local2, Local2)
                                                            Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                            And (Local0, 0x40, Local0)
                                                            Or (ShiftLeft (Local0, 0x05, Local0), Local2, Local2)
                                                            Store (Local2, Index (TSFR, 0x02))
                                                            Store (Zero, Index (TSFR, Zero))
                                                            Return (TSFR)
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (_T_8, 0x03))
                                                            {
                                                                Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                                And (Local0, 0x04, Local0)
                                                                If (Local0)
                                                                {
                                                                    Store (Zero, Index (TSFR, Zero))
                                                                    Store (0x2000, Index (TSFR, 0x02))
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x8300, Index (TSFR, Zero))
                                                                }

                                                                Return (TSFR)
                                                            }
                                                            Else
                                                            {
                                                                Store (0x8000, Index (TSFR, Zero))
                                                                Return (TSFR)
                                                            }
                                                        }
                                                    }
                                                    Else
                                                    {
                                                        If (LEqual (_T_7, 0x7F))
                                                        {
                                                            Store (^^PCI0.LPCB.PHMR (0x07F4), Local0)
                                                            And (Local0, One, Local0)
                                                            Store (Local0, Index (TSFR, 0x02))
                                                            Store (One, Index (TSFR, 0x03))
                                                            Store (Zero, Index (TSFR, Zero))
                                                            Return (TSFR)
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (_T_7, 0x62))
                                                            {
                                                                If (LEqual (OES1, 0x55))
                                                                {
                                                                    If (LEqual (OES2, 0x30))
                                                                    {
                                                                        Store (Zero, Index (TSFR, 0x03))
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (OES2, 0x31))
                                                                        {
                                                                            Store (Zero, Index (TSFR, 0x03))
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x21, Index (TSFR, 0x03))
                                                                        }
                                                                    }
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x21, Index (TSFR, 0x03))
                                                                }

                                                                Store (Zero, Index (TSFR, Zero))
                                                                Return (TSFR)
                                                            }
                                                            Else
                                                            {
                                                                If (LEqual (_T_7, 0x11))
                                                                {
                                                                    Name (_T_9, Zero)
                                                                    Store (ToInteger (HORZ), _T_9)
                                                                    If (LEqual (_T_9, 0x0280))
                                                                    {
                                                                        Name (_T_A, Zero)
                                                                        Store (ToInteger (VERT), _T_A)
                                                                        If (LEqual (_T_A, 0x01E0))
                                                                        {
                                                                            Store (Zero, Index (TSFR, 0x02))
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            Return (TSFR)
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            Return (TSFR)
                                                                        }
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (_T_9, 0x0320))
                                                                        {
                                                                            Name (_T_B, Zero)
                                                                            Store (ToInteger (VERT), _T_B)
                                                                            If (LEqual (_T_B, 0x0258))
                                                                            {
                                                                                Store (0x0100, Index (TSFR, 0x02))
                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                Return (TSFR)
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (_T_B, 0x01E0))
                                                                                {
                                                                                    Store (0x0400, Index (TSFR, 0x02))
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                            }
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (_T_9, 0x0400))
                                                                            {
                                                                                Name (_T_C, Zero)
                                                                                Store (ToInteger (VERT), _T_C)
                                                                                If (LEqual (_T_C, 0x0300))
                                                                                {
                                                                                    Store (0x0200, Index (TSFR, 0x02))
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (_T_C, 0x0258))
                                                                                    {
                                                                                        Store (0x0300, Index (TSFR, 0x02))
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Return (TSFR)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (_T_C, 0x0240))
                                                                                        {
                                                                                            Store (0x1200, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Return (TSFR)
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Return (TSFR)
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (_T_9, 0x0500))
                                                                                {
                                                                                    Name (_T_D, Zero)
                                                                                    Store (ToInteger (VERT), _T_D)
                                                                                    If (LEqual (_T_D, 0x0400))
                                                                                    {
                                                                                        Store (0x0500, Index (TSFR, 0x02))
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Return (TSFR)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (_T_D, 0x0258))
                                                                                        {
                                                                                            Store (0x0800, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Return (TSFR)
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LEqual (_T_D, 0x0320))
                                                                                            {
                                                                                                Store (0x0900, Index (TSFR, 0x02))
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                Return (TSFR)
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LEqual (_T_D, 0x0300))
                                                                                                {
                                                                                                    Store (0x0D00, Index (TSFR, 0x02))
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                    Return (TSFR)
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                    Return (TSFR)
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (_T_9, 0x0578))
                                                                                    {
                                                                                        Name (_T_E, Zero)
                                                                                        Store (ToInteger (VERT), _T_E)
                                                                                        If (LEqual (_T_E, 0x041A))
                                                                                        {
                                                                                            Store (0x0600, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Return (TSFR)
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                            Return (TSFR)
                                                                                        }
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (_T_9, 0x0640))
                                                                                        {
                                                                                            Name (_T_F, Zero)
                                                                                            Store (ToInteger (VERT), _T_F)
                                                                                            If (LEqual (_T_F, 0x04B0))
                                                                                            {
                                                                                                Store (0x0700, Index (TSFR, 0x02))
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                Return (TSFR)
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LEqual (_T_F, 0x0384))
                                                                                                {
                                                                                                    Store (0x1100, Index (TSFR, 0x02))
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                    Return (TSFR)
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                    Return (TSFR)
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LEqual (_T_9, 0x05A0))
                                                                                            {
                                                                                                Name (_T_G, Zero)
                                                                                                Store (ToInteger (VERT), _T_G)
                                                                                                If (LEqual (_T_G, 0x0384))
                                                                                                {
                                                                                                    Store (0x0A00, Index (TSFR, 0x02))
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                    Return (TSFR)
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                    Return (TSFR)
                                                                                                }
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If (LEqual (_T_9, 0x0690))
                                                                                                {
                                                                                                    Name (_T_H, Zero)
                                                                                                    Store (ToInteger (VERT), _T_H)
                                                                                                    If (LEqual (_T_H, 0x041A))
                                                                                                    {
                                                                                                        Store (0x0B00, Index (TSFR, 0x02))
                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                        Return (TSFR)
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LEqual (_T_H, 0x03BA))
                                                                                                        {
                                                                                                            Store (0x0F00, Index (TSFR, 0x02))
                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                            Return (TSFR)
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                            Return (TSFR)
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If (LEqual (_T_9, 0x0780))
                                                                                                    {
                                                                                                        Name (_T_I, Zero)
                                                                                                        Store (ToInteger (VERT), _T_I)
                                                                                                        If (LEqual (_T_I, 0x04B0))
                                                                                                        {
                                                                                                            Store (0x0C00, Index (TSFR, 0x02))
                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                            Return (TSFR)
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LEqual (_T_I, 0x0438))
                                                                                                            {
                                                                                                                Store (0x0E00, Index (TSFR, 0x02))
                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                Return (TSFR)
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                Return (TSFR)
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LEqual (_T_9, 0x0556))
                                                                                                        {
                                                                                                            Name (_T_J, Zero)
                                                                                                            Store (ToInteger (VERT), _T_J)
                                                                                                            If (LEqual (_T_J, 0x0300))
                                                                                                            {
                                                                                                                Store (0x1000, Index (TSFR, 0x02))
                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                Return (TSFR)
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                Return (TSFR)
                                                                                                            }
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            Store (0xFFFF, Index (TSFR, 0x02))
                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                            Return (TSFR)
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                Else
                                                                {
                                                                    If (LEqual (_T_7, 0xC000))
                                                                    {
                                                                        Name (_T_K, Zero)
                                                                        Store (ToInteger (TOI2), _T_K)
                                                                        If (LEqual (_T_K, 0x03))
                                                                        {
                                                                            Store (Zero, Local0)
                                                                            Store (Zero, Local1)
                                                                            Or (Local0, Local1, Local2)
                                                                            Store (Local2, Index (TSFR, 0x03))
                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            Return (TSFR)
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8000, Index (TSFR, Zero))
                                                                            Return (TSFR)
                                                                        }
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (_T_7, 0x1E))
                                                                        {
                                                                            And (^^PCI0.LPCB.PHMR (0x05F4), 0xFFFFFF01, Local0)
                                                                            ShiftRight (^^PCI0.LPCB.PHMR (0x05F4), One, Local1)
                                                                            And (Local1, 0xFFFFFF01, Local1)
                                                                            If (LAnd (LEqual (Local0, One), LEqual (Local1, One)))
                                                                            {
                                                                                Store (One, Index (TSFR, 0x02))
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LAnd (LEqual (Local0, One), LEqual (Local1, Zero)))
                                                                                {
                                                                                    Store (0x09, Index (TSFR, 0x02))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LAnd (LEqual (Local0, Zero), LEqual (Local1, One)))
                                                                                    {
                                                                                        Store (0x03, Index (TSFR, 0x02))
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x0B, Index (TSFR, 0x02))
                                                                                    }
                                                                                }
                                                                            }

                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            Return (TSFR)
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (_T_7, 0x47))
                                                                            {
                                                                                Store (Zero, Index (TSFR, 0x02))
                                                                                ShiftRight (^^PCI0.LPCB.PHMR (0x08F4), 0x04, Local0)
                                                                                And (Local0, 0xFFFFFF01, Local1)
                                                                                If (LEqual (Local1, One))
                                                                                {
                                                                                    Store (0x0131, Index (TSFR, 0x02))
                                                                                    Store (Zero, Index (TSFR, 0x03))
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (^^PCI0.LPCB.PHMR (0x0BF4))
                                                                                    {
                                                                                        Store (0x20, Index (TSFR, 0x02))
                                                                                        Store (^^PCI0.LPCB.PHMR (0x0BF4), Index (TSFR, 0x03))
                                                                                    }
                                                                                }

                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                Return (TSFR)
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (_T_7, 0x61))
                                                                                {
                                                                                    ShiftRight (^^PCI0.LPCB.PHMR (0x05F4), 0x04, Local0)
                                                                                    And (Local0, 0xFFFFFF01, Index (TSFR, 0x02))
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (_T_7, 0x75))
                                                                                    {
                                                                                        Store (PMID, Index (TSFR, 0x04))
                                                                                        Store (PPID, Index (TSFR, 0x05))
                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                        Return (TSFR)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If (LEqual (_T_7, 0x6D))
                                                                                        {
                                                                                            If (HAPE)
                                                                                            {
                                                                                                If (LEqual (TOI2, Zero))
                                                                                                {
                                                                                                    If (LEqual (TOI3, One))
                                                                                                    {
                                                                                                        Store (Zero, Index (TSFR, Zero))
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE3F8), 0x18, Local1)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE2F8), 0x10, Local2)
                                                                                                        Or (Local1, Local2, Local2)
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE1F8), 0x08, Local3)
                                                                                                        Or (Local3, ^^PCI0.LPCB.PHMR (0xE0F8), Local4)
                                                                                                        Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                        ShiftLeft (^^PCI0.LPCB.PHMR (0xE5F8), 0x08, Local5)
                                                                                                        Or (Local5, ^^PCI0.LPCB.PHMR (0xE4F8), Index (TSFR, 0x04))
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        If (LEqual (TOI3, Zero))
                                                                                                        {
                                                                                                            Store (Zero, Index (TSFR, Zero))
                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x59F5), 0x18, Local1)
                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x58F5), 0x10, Local2)
                                                                                                            Or (Local1, Local2, Local2)
                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x57F5), 0x08, Local3)
                                                                                                            Or (Local3, ^^PCI0.LPCB.PHMR (0x56F5), Local4)
                                                                                                            Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                            ShiftLeft (^^PCI0.LPCB.PHMR (0x5BF5), 0x08, Local5)
                                                                                                            Or (Local5, ^^PCI0.LPCB.PHMR (0x5AF5), Index (TSFR, 0x04))
                                                                                                        }
                                                                                                        Else
                                                                                                        {
                                                                                                            If (LEqual (TOI3, 0x0200))
                                                                                                            {
                                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x18, Local1)
                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x68F5), 0x10, Local2)
                                                                                                                Or (Local1, Local2, Local2)
                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                                                Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local4)
                                                                                                                Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                                ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local5)
                                                                                                                Or (Local5, ^^PCI0.LPCB.PHMR (0x6AF5), Local6)
                                                                                                                Add (Local6, ^^PCI0.LPCB.PHMR (0x5EF5), Index (TSFR, 0x04))
                                                                                                            }
                                                                                                            Else
                                                                                                            {
                                                                                                                If (LEqual (TOI3, 0x0201))
                                                                                                                {
                                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x69F5), 0x08, Local1)
                                                                                                                    Or (Local1, ^^PCI0.LPCB.PHMR (0x68F5), Local1)
                                                                                                                    Add (Local1, ^^PCI0.LPCB.PHMR (0x5DF5), Local2)
                                                                                                                    ShiftLeft (Local2, 0x10, Local2)
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x67F5), 0x08, Local3)
                                                                                                                    Or (Local3, ^^PCI0.LPCB.PHMR (0x66F5), Local3)
                                                                                                                    Add (Local3, ^^PCI0.LPCB.PHMR (0x5CF5), Local4)
                                                                                                                    Or (Local2, Local4, Index (TSFR, 0x02))
                                                                                                                    ShiftLeft (^^PCI0.LPCB.PHMR (0x6BF5), 0x08, Local2)
                                                                                                                    Or (Local2, ^^PCI0.LPCB.PHMR (0x6AF5), Index (TSFR, 0x04))
                                                                                                                }
                                                                                                                Else
                                                                                                                {
                                                                                                                    Store (0x8000, Index (TSFR, Zero))
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0x8000, Index (TSFR, Zero))
                                                                                                }
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                Store (0x8000, Index (TSFR, Zero))
                                                                                            }

                                                                                            Return (TSFR)
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If (LEqual (_T_7, 0x96))
                                                                                            {
                                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                                Store (0xFF00, Index (TSFR, 0x02))
                                                                                                If (IGDS)
                                                                                                {
                                                                                                    Store (0x0301, Index (TSFR, 0x03))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0x0302, Index (TSFR, 0x03))
                                                                                                }
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                Store (0x8000, Index (TSFR, Zero))
                                                                                                Return (TSFR)
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                Else
                                                {
                                                    If (LEqual (_T_4, 0xFF00))
                                                    {
                                                        Name (_T_L, Zero)
                                                        Store (ToInteger (And (TOI1, 0x00FFFFFF)), _T_L)
                                                        If (LEqual (_T_L, 0x56))
                                                        {
                                                            Name (_T_M, Zero)
                                                            Store (ToInteger (TOI3), _T_M)
                                                            If (LEqual (_T_M, 0x0200))
                                                            {
                                                                If (LEqual (TOI2, Zero))
                                                                {
                                                                    Store (^^PCI0.LPCB.PHMR (0xBBF4), Local0)
                                                                    And (Local0, 0xFFFFFFFE, Local0)
                                                                    ^^PCI0.LPCB.PHMW (0xBBF4, Local0)
                                                                }
                                                                Else
                                                                {
                                                                    Store (^^PCI0.LPCB.PHMR (0xBBF4), Local0)
                                                                    Or (Local0, One, Local0)
                                                                    ^^PCI0.LPCB.PHMW (0xBBF4, Local0)
                                                                }

                                                                Store (Zero, Index (TSFR, Zero))
                                                                Return (TSFR)
                                                            }
                                                            Else
                                                            {
                                                                If (LEqual (_T_M, 0x2000))
                                                                {
                                                                    If (LEqual (TOI2, Zero))
                                                                    {
                                                                        Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                                        And (Local0, 0xFFFFFFDF, Local1)
                                                                        ^^PCI0.LPCB.PHMW (0x01F4, Local1)
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                                        Or (Local0, 0x20, Local1)
                                                                        ^^PCI0.LPCB.PHMW (0x01F4, Local1)
                                                                    }

                                                                    Store (Zero, Index (TSFR, Zero))
                                                                    Return (TSFR)
                                                                }
                                                                Else
                                                                {
                                                                    If (LEqual (_T_M, 0x0800))
                                                                    {
                                                                        If (LEqual (TOI2, Zero))
                                                                        {
                                                                            Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                                            And (Local0, 0xFFFFFFBF, Local1)
                                                                            ^^PCI0.LPCB.PHMW (0x01F4, Local1)
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                                            Or (Local0, 0x40, Local1)
                                                                            ^^PCI0.LPCB.PHMW (0x01F4, Local1)
                                                                        }

                                                                        Store (Zero, Index (TSFR, Zero))
                                                                        Return (TSFR)
                                                                    }
                                                                    Else
                                                                    {
                                                                        Store (0x8000, Index (TSFR, Zero))
                                                                        Return (TSFR)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        Else
                                                        {
                                                            If (LEqual (_T_L, 0x5A))
                                                            {
                                                                Name (_T_N, Zero)
                                                                Store (ToInteger (TOI3), _T_N)
                                                                If (LEqual (_T_N, One))
                                                                {
                                                                    Store (^^PCI0.LPCB.PHMR (0x01F4), Local0)
                                                                    Name (_T_O, Zero)
                                                                    Store (ToInteger (TOI2), _T_O)
                                                                    If (LEqual (_T_O, Zero))
                                                                    {
                                                                        And (Local0, 0xFFFFFFFC, Local0)
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (_T_O, One))
                                                                        {
                                                                            And (Local0, 0xFFFFFFFC, Local0)
                                                                            Or (Local0, One, Local0)
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (_T_O, 0x02))
                                                                            {
                                                                                And (Local0, 0xFFFFFFFC, Local0)
                                                                                Or (Local0, 0x02, Local0)
                                                                            }
                                                                        }
                                                                    }

                                                                    ^^PCI0.LPCB.PHMW (0x01F4, Local0)
                                                                    Return (TSFR)
                                                                }
                                                                Else
                                                                {
                                                                    Store (0x8000, Index (TSFR, Zero))
                                                                    Return (TSFR)
                                                                }
                                                            }
                                                            Else
                                                            {
                                                                If (LEqual (_T_L, 0x7F))
                                                                {
                                                                    Store (^^PCI0.LPCB.PHMR (0x07F4), Local0)
                                                                    Name (_T_P, Zero)
                                                                    Store (ToInteger (TOI2), _T_P)
                                                                    If (LEqual (_T_P, Zero))
                                                                    {
                                                                        And (Local0, 0xFFFFFFFE, Local0)
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (_T_P, One))
                                                                        {
                                                                            Or (Local0, One, Local0)
                                                                        }
                                                                    }

                                                                    ^^PCI0.LPCB.PHMW (0x07F4, Local0)
                                                                    Return (TSFR)
                                                                }
                                                                Else
                                                                {
                                                                    If (LEqual (_T_L, 0xC000))
                                                                    {
                                                                        Name (_T_Q, Zero)
                                                                        Store (ToInteger (TOI2), _T_Q)
                                                                        If (LEqual (_T_Q, Zero))
                                                                        {
                                                                            Name (_T_R, Zero)
                                                                            Store (ToInteger (TOI3), _T_R)
                                                                            If (LEqual (_T_R, Zero))
                                                                            {
                                                                                Store (Zero, Index (TSFR, Zero))
                                                                                Return (TSFR)
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (_T_R, One))
                                                                                {
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                            }
                                                                        }
                                                                        Else
                                                                        {
                                                                            Store (0x8000, Index (TSFR, Zero))
                                                                            Return (TSFR)
                                                                        }
                                                                    }
                                                                    Else
                                                                    {
                                                                        If (LEqual (_T_L, 0x1E))
                                                                        {
                                                                            And (TOI2, 0x02, Local0)
                                                                            If (LEqual (Local0, 0x02))
                                                                            {
                                                                                And (^^PCI0.LPCB.PHMR (0x05F4), 0xFE, Local0)
                                                                                ^^PCI0.LPCB.PHMW (0x05F4, Local0)
                                                                            }
                                                                            Else
                                                                            {
                                                                                Or (^^PCI0.LPCB.PHMR (0x05F4), One, Local0)
                                                                                ^^PCI0.LPCB.PHMW (0x05F4, Local0)
                                                                            }

                                                                            And (TOI2, 0x08, Local1)
                                                                            If (LEqual (Local1, 0x08))
                                                                            {
                                                                                And (^^PCI0.LPCB.PHMR (0x05F4), 0xFD, Local0)
                                                                                ^^PCI0.LPCB.PHMW (0x05F4, Local0)
                                                                            }
                                                                            Else
                                                                            {
                                                                                Or (^^PCI0.LPCB.PHMR (0x05F4), 0x02, Local0)
                                                                                ^^PCI0.LPCB.PHMW (0x05F4, Local0)
                                                                            }

                                                                            Store (Zero, Index (TSFR, Zero))
                                                                            Return (TSFR)
                                                                        }
                                                                        Else
                                                                        {
                                                                            If (LEqual (_T_L, 0x47))
                                                                            {
                                                                                Name (_T_S, Zero)
                                                                                Store (ToInteger (TOI2), _T_S)
                                                                                If (LEqual (_T_S, 0x5A00))
                                                                                {
                                                                                    ^^PCI0.LPCB.PHMW (0x0BF4, Zero)
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    Store (0x8000, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                            }
                                                                            Else
                                                                            {
                                                                                If (LEqual (_T_L, 0x61))
                                                                                {
                                                                                    And (^^PCI0.LPCB.PHMR (0x05F4), 0xEF, Local0)
                                                                                    ShiftLeft (TOI2, 0x04, Local1)
                                                                                    Or (Local0, Local1, Local2)
                                                                                    ^^PCI0.LPCB.PHMW (0x05F4, Local2)
                                                                                    Store (TOI2, ^^PCI0.LPCB.INF)
                                                                                    ^^PCI0.LPCB.PHSS (0x78)
                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                    Return (TSFR)
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If (LEqual (_T_L, 0x6D))
                                                                                    {
                                                                                        If (HAPE)
                                                                                        {
                                                                                            If (LEqual (TOI2, Zero))
                                                                                            {
                                                                                                If (LOr (LEqual (TOI3, 0x0100), LEqual (TOI3, 0x0102)))
                                                                                                {
                                                                                                    Store (Zero, Index (TSFR, Zero))
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Store (0x8000, Index (TSFR, Zero))
                                                                                                }
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                Store (0x8000, Index (TSFR, Zero))
                                                                                            }
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            Store (0x8000, Index (TSFR, Zero))
                                                                                        }

                                                                                        Return (TSFR)
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        Store (0x8000, Index (TSFR, Zero))
                                                                                        Return (TSFR)
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                Return (TSFR)
                            }

                            Method (EXCN, 0, NotSerialized)
                            {
                                Store (^^PCI0.LPCB.PHMR (0x9BF8), Local1)
                                Add (Local1, One, Local1)
                                ^^PCI0.LPCB.PHMW (0x9BF8, Local1)
                            }

                            Name (CMMS, Buffer (0x1C) {})
                            Name (PHMA, Package (0x06)
                            {
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                            Name (PHMB, Package (0x06)
                            {
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                            Method (HMB1, 0, NotSerialized)
                            {
                                If (LEqual (^^PCI0.LPCB.EC0.BAL0, One))
                                {
                                    CreateByteField (CMMS, Zero, CPN1)
                                    CreateByteField (CMMS, One, CPN2)
                                    CreateByteField (CMMS, 0x02, CPN3)
                                    CreateByteField (CMMS, 0x03, CPN4)
                                    CreateByteField (CMMS, 0x04, CPN5)
                                    CreateByteField (CMMS, 0x05, CPN6)
                                    CreateByteField (CMMS, 0x06, CPN7)
                                    CreateByteField (CMMS, 0x07, CPN8)
                                    CreateByteField (CMMS, 0x08, CPN9)
                                    CreateByteField (CMMS, 0x09, CPNA)
                                    CreateByteField (CMMS, 0x0A, CPNB)
                                    CreateByteField (CMMS, 0x0B, CPNC)
                                    CreateByteField (CMMS, 0x0C, MN01)
                                    CreateByteField (CMMS, 0x0D, MN02)
                                    CreateByteField (CMMS, 0x0E, MN03)
                                    CreateByteField (CMMS, 0x0F, MN04)
                                    CreateByteField (CMMS, 0x10, MN05)
                                    CreateByteField (CMMS, 0x11, MN06)
                                    CreateByteField (CMMS, 0x12, MN07)
                                    CreateByteField (CMMS, 0x13, MN08)
                                    CreateByteField (CMMS, 0x14, MN09)
                                    CreateByteField (CMMS, 0x15, MN0A)
                                    CreateByteField (CMMS, 0x16, MN0B)
                                    CreateByteField (CMMS, 0x17, MN0C)
                                    CreateWordField (CMMS, 0x18, MFDA)
                                    CreateWordField (CMMS, 0x1A, SRNM)
                                    Store (^^PCI0.LPCB.PHMR (0xACF8), CPN1)
                                    Store (^^PCI0.LPCB.PHMR (0xADF8), CPN2)
                                    Store (^^PCI0.LPCB.PHMR (0xAEF8), CPN3)
                                    Store (^^PCI0.LPCB.PHMR (0xAFF8), CPN4)
                                    Store (^^PCI0.LPCB.PHMR (0xB0F8), CPN5)
                                    Store (^^PCI0.LPCB.PHMR (0xB1F8), CPN6)
                                    Store (^^PCI0.LPCB.PHMR (0xB2F8), CPN7)
                                    Store (^^PCI0.LPCB.PHMR (0xB3F8), CPN8)
                                    Store (^^PCI0.LPCB.PHMR (0xB4F8), CPN9)
                                    Store (^^PCI0.LPCB.PHMR (0xB5F8), CPNA)
                                    Store (^^PCI0.LPCB.PHMR (0xB6F8), CPNB)
                                    Store (^^PCI0.LPCB.PHMR (0xB7F8), CPNC)
                                    Store (^^PCI0.LPCB.PHMR (0xB8F8), MN01)
                                    Store (^^PCI0.LPCB.PHMR (0xB9F8), MN02)
                                    Store (^^PCI0.LPCB.PHMR (0xBAF8), MN03)
                                    Store (^^PCI0.LPCB.PHMR (0xBBF8), MN04)
                                    Store (^^PCI0.LPCB.PHMR (0xBCF8), MN05)
                                    Store (^^PCI0.LPCB.PHMR (0xBDF8), MN06)
                                    Store (^^PCI0.LPCB.PHMR (0xBEF8), MN07)
                                    Store (^^PCI0.LPCB.PHMR (0xBFF8), MN08)
                                    Store (^^PCI0.LPCB.PHMR (0xC0F8), MN09)
                                    Store (^^PCI0.LPCB.PHMR (0xC1F8), MN0A)
                                    Store (^^PCI0.LPCB.PHMR (0xC2F8), MN0B)
                                    Store (^^PCI0.LPCB.PHMR (0xC3F8), MN0C)
                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xF5F4), 0x08, Local1)
                                    Or (Local1, ^^PCI0.LPCB.PHMR (0xF4F4), Local1)
                                    Store (Local1, MFDA)
                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xC5F4), 0x08, Local2)
                                    Or (Local2, ^^PCI0.LPCB.PHMR (0xC4F4), Local2)
                                    Store (Local2, SRNM)
                                    Store (CMMS, Index (PHMA, Zero))
                                    ShiftLeft (^^PCI0.LPCB.PHMR (0xC5F8), 0x08, Local0)
                                    Store (^^PCI0.LPCB.PHMR (0xC4F8), Local1)
                                    Or (Local0, Local1, Local1)
                                    ToBCD (Local1, Index (PHMA, One))
                                    Return (PHMA)
                                }
                                Else
                                {
                                    Return (PHMB)
                                }
                            }

                            Method (HMB2, 0, NotSerialized)
                            {
                                Return (PHMB)
                            }
                        }
                    }

                    Mutex (ECMX, 0x00)
                    Method (ECIR, 1, NotSerialized)
                    {
                        Acquire (ECMX, 0xFFFF)
                        Store (Arg0, ENIB)
                        Store (ENDD, Local0)
                        Release (ECMX)
                        Return (Local0)
                    }

                    Method (ECIW, 2, NotSerialized)
                    {
                        Acquire (ECMX, 0xFFFF)
                        Store (Arg0, ENIB)
                        Store (Arg1, ENDD)
                        Release (ECMX)
                        Return (Arg1)
                    }
                }

                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x01,               // Alignment
                            0x11,               // Length
                            )
                        IO (Decode16,
                            0x0093,             // Range Minimum
                            0x0093,             // Range Maximum
                            0x01,               // Alignment
                            0x0D,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x01,               // Alignment
                            0x20,               // Length
                            )
                        DMA (Compatibility, NotBusMaster, Transfer8_16, )
                            {4}
                    })
                }

                Device (HPET)
                {
                    Name (_HID, EisaId ("PNP0103"))
                    Name (_CID, EisaId ("PNP0C01"))
                    Name (BUF0, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadOnly,
                            0xFED00000,         // Address Base
                            0x00000400,         // Address Length
                            _Y0F)
                    })
                    Method (_STA, 0, NotSerialized)
                    {
                        If (LGreaterEqual (OSYS, 0x07D1))
                        {
                            If (HPAE)
                            {
                                Return (0x0F)
                            }
                        }
                        Else
                        {
                            If (HPAE)
                            {
                                Return (0x0B)
                            }
                        }

                        Return (Zero)
                    }

                    Method (_CRS, 0, Serialized)
                    {
                        If (HPAE)
                        {
                            CreateDWordField (BUF0, \_SB.PCI0.LPCB.HPET._Y0F._BAS, HPT0)
                            If (LEqual (HPAS, One))
                            {
                                Store (0xFED01000, HPT0)
                            }

                            If (LEqual (HPAS, 0x02))
                            {
                                Store (0xFED02000, HPT0)
                            }

                            If (LEqual (HPAS, 0x03))
                            {
                                Store (0xFED03000, HPT0)
                            }
                        }

                        Return (BUF0)
                    }
                }

                Device (IPIC)
                {
                    Name (_HID, EisaId ("PNP0000"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0020,             // Range Minimum
                            0x0020,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0024,             // Range Minimum
                            0x0024,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0028,             // Range Minimum
                            0x0028,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x002C,             // Range Minimum
                            0x002C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0030,             // Range Minimum
                            0x0030,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0034,             // Range Minimum
                            0x0034,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0038,             // Range Minimum
                            0x0038,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x003C,             // Range Minimum
                            0x003C,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A0,             // Range Minimum
                            0x00A0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A4,             // Range Minimum
                            0x00A4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A8,             // Range Minimum
                            0x00A8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00AC,             // Range Minimum
                            0x00AC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B0,             // Range Minimum
                            0x00B0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B4,             // Range Minimum
                            0x00B4,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00B8,             // Range Minimum
                            0x00B8,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00BC,             // Range Minimum
                            0x00BC,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IRQNoFlags ()
                            {2}
                    })
                }

                Device (MATH)
                {
                    Name (_HID, EisaId ("PNP0C04"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x00F0,             // Range Minimum
                            0x00F0,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {13}
                    })
                }

                Device (LDRC)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x02)
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0061,             // Range Minimum
                            0x0061,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0063,             // Range Minimum
                            0x0063,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0065,             // Range Minimum
                            0x0065,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0067,             // Range Minimum
                            0x0067,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0068,             // Range Minimum
                            0x0068,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x006C,             // Range Minimum
                            0x006C,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0092,             // Range Minimum
                            0x0092,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x00B2,             // Range Minimum
                            0x00B2,             // Range Maximum
                            0x01,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0800,             // Range Minimum
                            0x0800,             // Range Maximum
                            0x01,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x1000,             // Range Minimum
                            0x1000,             // Range Maximum
                            0x01,               // Alignment
                            0x80,               // Length
                            )
                        IO (Decode16,
                            0x1180,             // Range Minimum
                            0x1180,             // Range Maximum
                            0x01,               // Alignment
                            0x40,               // Length
                            )
                        IO (Decode16,
                            0xFE00,             // Range Minimum
                            0xFE00,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0xFF2C,             // Range Minimum
                            0xFF2C,             // Range Maximum
                            0x01,               // Alignment
                            0x54,               // Length
                            )
                    })
                }

                Device (RTC)
                {
                    Name (_HID, EisaId ("PNP0B00"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x01,               // Alignment
                            0x08,               // Length
                            )
                        IRQNoFlags ()
                            {8}
                    })
                }

                Device (TIMR)
                {
                    Name (_HID, EisaId ("PNP0100"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0040,             // Range Minimum
                            0x0040,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x0050,             // Range Minimum
                            0x0050,             // Range Maximum
                            0x10,               // Alignment
                            0x04,               // Length
                            )
                        IRQNoFlags ()
                            {0}
                    })
                }

                OperationRegion (SMI0, SystemIO, 0x0000FE00, 0x00000002)
                Field (SMI0, AnyAcc, NoLock, Preserve)
                {
                    SMIC,   8
                }

                OperationRegion (SMI1, SystemMemory, 0x7F6E2EBD, 0x00000090)
                Field (SMI1, AnyAcc, NoLock, Preserve)
                {
                    BCMD,   8, 
                    DID,    32, 
                    INFO,   1024
                }

                Field (SMI1, AnyAcc, NoLock, Preserve)
                {
                            AccessAs (ByteAcc, 0x00), 
                            Offset (0x05), 
                    INF,    8, 
                    INF1,   32
                }

                Mutex (PSMX, 0x00)
                Method (PHSS, 1, NotSerialized)
                {
                    Acquire (PSMX, 0xFFFF)
                    Store (0x80, BCMD)
                    Store (Arg0, DID)
                    Store (Zero, SMIC)
                    Release (PSMX)
                }

                Device (BAT1)
                {
                    Name (_HID, EisaId ("PNP0C0A"))
                    Name (_UID, One)
                    Name (_PCL, Package (0x01)
                    {
                        _SB
                    })
                    Name (BMDL, Zero)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (ECOK ())
                        {
                            If (^^EC0.BAL0)
                            {
                                Sleep (0x14)
                                Return (0x1F)
                            }
                            Else
                            {
                                Sleep (0x14)
                                Return (0x0F)
                            }
                        }
                        Else
                        {
                            Sleep (0x14)
                            Return (0x1F)
                        }
                    }

                    Method (_BIF, 0, NotSerialized)
                    {
                        Name (STAT, Package (0x0D)
                        {
                            One,    // Power Unit (0 = mW, 1 = mA)
                            0x0FA0, // Design Capacity
                            0x0FA0, // Last Full Charge Capacity
                            One,    // Bat. Tech. (0 = non-recharge, 1 = recharge)
                            0x39D0, // Design Voltage
                            0x01A4, // Design Capacity of Warning
                            0x9C,   // Design Capacity of Low
                            0x0108, // Capacity Granularity 1
                            0x0EC4, // Capacity Granularity 2
                            "PA3533U ", // Model Number
                            "41167",    // Serial Number
                            "Li-Ion",   // Battery Type
                            "TOSHIBA"   // OEM info
                        })
                        Name (CMMA, Buffer (0x0C) {})
                        CreateByteField (CMMA, Zero, APN1)
                        CreateByteField (CMMA, One, APN2)
                        CreateByteField (CMMA, 0x02, APN3)
                        CreateByteField (CMMA, 0x03, APN4)
                        CreateByteField (CMMA, 0x04, APN5)
                        CreateByteField (CMMA, 0x05, APN6)
                        CreateByteField (CMMA, 0x06, APN7)
                        CreateByteField (CMMA, 0x07, APN8)
                        CreateByteField (CMMA, 0x08, APN9)
                        CreateByteField (CMMA, 0x09, Z00A)
                        CreateByteField (CMMA, 0x0A, Z00B)
                        CreateByteField (CMMA, 0x0B, Z00C)
                        Store (PHMR (0xACF8), APN1)
                        Store (PHMR (0xADF8), APN2)
                        Store (PHMR (0xAEF8), APN3)
                        Store (PHMR (0xAFF8), APN4)
                        Store (PHMR (0xB0F8), APN5)
                        Store (PHMR (0xB1F8), APN6)
                        Store (PHMR (0xB2F8), APN7)
                        Store (PHMR (0xB3F8), APN8)
                        Store (PHMR (0xB4F8), APN9)
                        Store (PHMR (0xB5F8), Z00A)
                        Store (PHMR (0xB6F8), Z00B)
                        Store (PHMR (0xB7F8), Z00C)
                        Store (CMMA, Index (STAT, 0x09))
                        If (ECOK ())
                        {
                            Store (^^EC0.BDN0, Local0)
                            Store (Local0, BMDL)
                            Store (^^EC0.BFC0, BFC1)
                            Sleep (0x14)
                            Store (^^EC0.BDC0, Index (STAT, One))
                            Sleep (0x14)
                            Store (^^EC0.BDV0, Index (STAT, 0x04))
                            Sleep (0x14)
                        }
                        Else
                        {
                            Store ("Li-Ion", Index (STAT, 0x0B))
                            Store (BFC1, Index (STAT, One))
                        }

                        If (BFC1)
                        {
                            Divide (BFC1, 0x64, Local0, Local1)
                            Multiply (Local1, 0x0A, Local1)
                            Store (Local1, Index (STAT, 0x05))
                            Divide (BFC1, 0x64, Local0, Local1)
                            Multiply (Local1, 0x03, Local1)
                            Store (Local1, Index (STAT, 0x06))
                            Store (BFC1, Index (STAT, 0x02))
                        }

                        Return (STAT)
                    }

                    Method (_BST, 0, NotSerialized)
                    {
                        Name (PBST, Package (0x04)
                        {
                            Zero, // Bat. State (bit0 = discharging, bit1 =
                                  //    charging, bit 2 = critical energy state).
                            Ones, // Present rate (0xFFFFFFFF = unknown)
                            Ones, // Remaining Capacity (0xFFFFFFFF = unknown)
                            0x39D0// Present Voltage (must report for
                                  //    rechargable).
                        })
                        Store (0x39D0, Local3)
                        If (ECOK ())
                        {
                            Sleep (0x14)
                            Store (^^EC0.BST0, BST1)
                            Sleep (0x14)
                            Store (^^EC0.BRC0, Local2)
                            Sleep (0x14)
                            Store (^^EC0.BPV0, Local3)
                            Sleep (0x14)
                        }

                        Store (BST1, Index (PBST, Zero))
                        Store (Zero, Index (PBST, One))   // Jerks. (No battry rate for you).
                        Store (Local2, Index (PBST, 0x02)) // Capacity
                        Store (Local3, Index (PBST, 0x03)) // Voltage
                        If (ECOK ())
                        {
                            If (LNotEqual (^^EC0.BDN0, BMDL))
                            {
                                Notify (BAT1, 0x81)
                            }
                        }

                        Return (PBST)
                    }
                }

                Device (PS2K)
                {
                    Name (_HID, EisaId ("PNP0303"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {1}
                    })
                }

                Device (PS2M)
                {
                    Method (_HID, 0, NotSerialized)
                    {
                        If (LEqual (TPID, One))
                        {
                            Return (0x14072E4F)
                        }
                        Else
                        {
                            If (LEqual (TPID, 0x02))
                            {
                                Return (0x1103A906)
                            }
                            Else
                            {
                                Return (0x14072E4F)
                            }
                        }
                    }

                    Name (_CID, Package (0x03)
                    {
                        EisaId ("SYN0700"), 
                        EisaId ("SYN0002"), 
                        EisaId ("PNP0F13")
                    })
                    Name (_CRS, ResourceTemplate ()
                    {
                        IRQ (Edge, ActiveHigh, Exclusive, )
                            {12}
                    })
                }
            }

            Device (PATA)
            {
                Name (_ADR, 0x001F0001)
                OperationRegion (PACS, PCI_Config, 0x40, 0xC0)
                Field (PACS, DWordAcc, NoLock, Preserve)
                {
                    PRIT,   16, 
                            Offset (0x04), 
                    PSIT,   4, 
                            Offset (0x08), 
                    SYNC,   4, 
                            Offset (0x0A), 
                    SDT0,   2, 
                        ,   2, 
                    SDT1,   2, 
                            Offset (0x14), 
                    ICR0,   4, 
                    ICR1,   4, 
                    ICR2,   4, 
                    ICR3,   4, 
                    ICR4,   4, 
                    ICR5,   4
                }

                Device (PRID)
                {
                    Name (_ADR, Zero)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Name (PBUF, Buffer (0x14)
                        {
                            /* 0000 */    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
                            /* 0008 */    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
                            /* 0010 */    0x00, 0x00, 0x00, 0x00
                        })
                        CreateDWordField (PBUF, Zero, PIO0)
                        CreateDWordField (PBUF, 0x04, DMA0)
                        CreateDWordField (PBUF, 0x08, PIO1)
                        CreateDWordField (PBUF, 0x0C, DMA1)
                        CreateDWordField (PBUF, 0x10, FLAG)
                        Store (GETP (PRIT), PIO0)
                        Store (GDMA (And (SYNC, One), And (ICR3, One), 
                            And (ICR0, One), SDT0, And (ICR1, One)), DMA0)
                        If (LEqual (DMA0, Ones))
                        {
                            Store (PIO0, DMA0)
                        }

                        If (And (PRIT, 0x4000))
                        {
                            If (LEqual (And (PRIT, 0x90), 0x80))
                            {
                                Store (0x0384, PIO1)
                            }
                            Else
                            {
                                Store (GETT (PSIT), PIO1)
                            }
                        }
                        Else
                        {
                            Store (Ones, PIO1)
                        }

                        Store (GDMA (And (SYNC, 0x02), And (ICR3, 0x02), 
                            And (ICR0, 0x02), SDT1, And (ICR1, 0x02)), DMA1)
                        If (LEqual (DMA1, Ones))
                        {
                            Store (PIO1, DMA1)
                        }

                        Store (GETF (And (SYNC, One), And (SYNC, 0x02), 
                            PRIT), FLAG)
                        If (And (LEqual (PIO0, Ones), LEqual (DMA0, Ones)))
                        {
                            Store (0x78, PIO0)
                            Store (0x14, DMA0)
                            Store (0x03, FLAG)
                        }

                        Return (PBUF)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        CreateDWordField (Arg0, Zero, PIO0)
                        CreateDWordField (Arg0, 0x04, DMA0)
                        CreateDWordField (Arg0, 0x08, PIO1)
                        CreateDWordField (Arg0, 0x0C, DMA1)
                        CreateDWordField (Arg0, 0x10, FLAG)
                        If (LEqual (SizeOf (Arg1), 0x0200))
                        {
                            And (PRIT, 0xC0F0, PRIT)
                            And (SYNC, 0x02, SYNC)
                            Store (Zero, SDT0)
                            And (ICR0, 0x02, ICR0)
                            And (ICR1, 0x02, ICR1)
                            And (ICR3, 0x02, ICR3)
                            And (ICR5, 0x02, ICR5)
                            CreateWordField (Arg1, 0x62, W490)
                            CreateWordField (Arg1, 0x6A, W530)
                            CreateWordField (Arg1, 0x7E, W630)
                            CreateWordField (Arg1, 0x80, W640)
                            CreateWordField (Arg1, 0xB0, W880)
                            CreateWordField (Arg1, 0xBA, W930)
                            Or (PRIT, 0x8004, PRIT)
                            If (LAnd (And (FLAG, 0x02), And (W490, 0x0800)))
                            {
                                Or (PRIT, 0x02, PRIT)
                            }

                            Or (PRIT, SETP (PIO0, W530, W640), PRIT)
                            If (And (FLAG, One))
                            {
                                Or (SYNC, One, SYNC)
                                Store (SDMA (DMA0), SDT0)
                                If (LLess (DMA0, 0x1E))
                                {
                                    Or (ICR3, One, ICR3)
                                }

                                If (LLess (DMA0, 0x3C))
                                {
                                    Or (ICR0, One, ICR0)
                                }

                                If (And (W930, 0x2000))
                                {
                                    Or (ICR1, One, ICR1)
                                }
                            }
                        }

                        If (LEqual (SizeOf (Arg2), 0x0200))
                        {
                            And (PRIT, 0xBF0F, PRIT)
                            Store (Zero, PSIT)
                            And (SYNC, One, SYNC)
                            Store (Zero, SDT1)
                            And (ICR0, One, ICR0)
                            And (ICR1, One, ICR1)
                            And (ICR3, One, ICR3)
                            And (ICR5, One, ICR5)
                            CreateWordField (Arg2, 0x62, W491)
                            CreateWordField (Arg2, 0x6A, W531)
                            CreateWordField (Arg2, 0x7E, W631)
                            CreateWordField (Arg2, 0x80, W641)
                            CreateWordField (Arg2, 0xB0, W881)
                            CreateWordField (Arg2, 0xBA, W931)
                            Or (PRIT, 0x8040, PRIT)
                            If (LAnd (And (FLAG, 0x08), And (W491, 0x0800)))
                            {
                                Or (PRIT, 0x20, PRIT)
                            }

                            If (And (FLAG, 0x10))
                            {
                                Or (PRIT, 0x4000, PRIT)
                                If (LGreater (PIO1, 0xF0))
                                {
                                    Or (PRIT, 0x80, PRIT)
                                }
                                Else
                                {
                                    Or (PRIT, 0x10, PRIT)
                                    Store (SETT (PIO1, W531, W641), PSIT)
                                }
                            }

                            If (And (FLAG, 0x04))
                            {
                                Or (SYNC, 0x02, SYNC)
                                Store (SDMA (DMA1), SDT1)
                                If (LLess (DMA1, 0x1E))
                                {
                                    Or (ICR3, 0x02, ICR3)
                                }

                                If (LLess (DMA1, 0x3C))
                                {
                                    Or (ICR0, 0x02, ICR0)
                                }

                                If (And (W931, 0x2000))
                                {
                                    Or (ICR1, 0x02, ICR1)
                                }
                            }
                        }
                    }

                    Device (P_D0)
                    {
                        Name (_ADR, Zero)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Name (PIB0, Buffer (0x0E)
                            {
                                /* 0000 */    0x03, 0x00, 0x00, 0x00, 0x00, 0xA0, 0xEF, 0x03, 
                                /* 0008 */    0x00, 0x00, 0x00, 0x00, 0xA0, 0xEF
                            })
                            CreateByteField (PIB0, One, PMD0)
                            CreateByteField (PIB0, 0x08, DMD0)
                            If (And (PRIT, 0x02))
                            {
                                If (LEqual (And (PRIT, 0x09), 0x08))
                                {
                                    Store (0x08, PMD0)
                                }
                                Else
                                {
                                    Store (0x0A, PMD0)
                                    ShiftRight (And (PRIT, 0x0300), 0x08, Local0)
                                    ShiftRight (And (PRIT, 0x3000), 0x0C, Local1)
                                    Add (Local0, Local1, Local2)
                                    If (LEqual (0x03, Local2))
                                    {
                                        Store (0x0B, PMD0)
                                    }

                                    If (LEqual (0x05, Local2))
                                    {
                                        Store (0x0C, PMD0)
                                    }
                                }
                            }
                            Else
                            {
                                Store (One, PMD0)
                            }

                            If (And (SYNC, One))
                            {
                                Store (Or (SDT0, 0x40), DMD0)
                                If (And (ICR1, One))
                                {
                                    If (And (ICR0, One))
                                    {
                                        Add (DMD0, 0x02, DMD0)
                                    }

                                    If (And (ICR3, One))
                                    {
                                        Store (0x45, DMD0)
                                    }
                                }
                            }
                            Else
                            {
                                Or (Subtract (And (PMD0, 0x07), 0x02), 0x20, DMD0)
                            }

                            Return (PIB0)
                        }
                    }

                    Device (P_D1)
                    {
                        Name (_ADR, One)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Name (PIB1, Buffer (0x0E)
                            {
                                /* 0000 */    0x03, 0x00, 0x00, 0x00, 0x00, 0xB0, 0xEF, 0x03, 
                                /* 0008 */    0x00, 0x00, 0x00, 0x00, 0xB0, 0xEF
                            })
                            CreateByteField (PIB1, One, PMD1)
                            CreateByteField (PIB1, 0x08, DMD1)
                            If (And (PRIT, 0x20))
                            {
                                If (LEqual (And (PRIT, 0x90), 0x80))
                                {
                                    Store (0x08, PMD1)
                                }
                                Else
                                {
                                    Add (And (PSIT, 0x03), ShiftRight (And (PSIT, 0x0C), 
                                        0x02), Local0)
                                    If (LEqual (0x05, Local0))
                                    {
                                        Store (0x0C, PMD1)
                                    }
                                    Else
                                    {
                                        If (LEqual (0x03, Local0))
                                        {
                                            Store (0x0B, PMD1)
                                        }
                                        Else
                                        {
                                            Store (0x0A, PMD1)
                                        }
                                    }
                                }
                            }
                            Else
                            {
                                Store (One, PMD1)
                            }

                            If (And (SYNC, 0x02))
                            {
                                Store (Or (SDT1, 0x40), DMD1)
                                If (And (ICR1, 0x02))
                                {
                                    If (And (ICR0, 0x02))
                                    {
                                        Add (DMD1, 0x02, DMD1)
                                    }

                                    If (And (ICR3, 0x02))
                                    {
                                        Store (0x45, DMD1)
                                    }
                                }
                            }
                            Else
                            {
                                Or (Subtract (And (PMD1, 0x07), 0x02), 0x20, DMD1)
                            }

                            Return (PIB1)
                        }
                    }
                }
            }

            Device (SATA)
            {
                Name (_ADR, 0x001F0002)
                OperationRegion (SACS, PCI_Config, 0x40, 0xC0)
                Field (SACS, DWordAcc, NoLock, Preserve)
                {
                    PRIT,   16, 
                    SECT,   16, 
                    PSIT,   4, 
                    SSIT,   4, 
                            Offset (0x08), 
                    SYNC,   4, 
                            Offset (0x0A), 
                    SDT0,   2, 
                        ,   2, 
                    SDT1,   2, 
                            Offset (0x0B), 
                    SDT2,   2, 
                        ,   2, 
                    SDT3,   2, 
                            Offset (0x14), 
                    ICR0,   4, 
                    ICR1,   4, 
                    ICR2,   4, 
                    ICR3,   4, 
                    ICR4,   4, 
                    ICR5,   4, 
                            Offset (0x50), 
                    MAPV,   2
                }
            }

            Device (SBUS)
            {
                Name (_ADR, 0x001F0003)
                OperationRegion (SMBP, PCI_Config, 0x40, 0xC0)
                Field (SMBP, DWordAcc, NoLock, Preserve)
                {
                        ,   2, 
                    I2CE,   1
                }

                OperationRegion (SMBI, SystemIO, 0x18E0, 0x10)
                Field (SMBI, ByteAcc, NoLock, Preserve)
                {
                    HSTS,   8, 
                            Offset (0x02), 
                    HCON,   8, 
                    HCOM,   8, 
                    TXSA,   8, 
                    DAT0,   8, 
                    DAT1,   8, 
                    HBDR,   8, 
                    PECR,   8, 
                    RXSA,   8, 
                    SDAT,   16
                }

                Method (SSXB, 2, Serialized)
                {
                    If (STRT ())
                    {
                        Return (Zero)
                    }

                    Store (Zero, I2CE)
                    Store (0xBF, HSTS)
                    Store (Arg0, TXSA)
                    Store (Arg1, HCOM)
                    Store (0x48, HCON)
                    If (COMP ())
                    {
                        Or (HSTS, 0xFF, HSTS)
                        Return (One)
                    }

                    Return (Zero)
                }

                Method (SRXB, 1, Serialized)
                {
                    If (STRT ())
                    {
                        Return (0xFFFF)
                    }

                    Store (Zero, I2CE)
                    Store (0xBF, HSTS)
                    Store (Or (Arg0, One), TXSA)
                    Store (0x44, HCON)
                    If (COMP ())
                    {
                        Or (HSTS, 0xFF, HSTS)
                        Return (DAT0)
                    }

                    Return (0xFFFF)
                }

                Method (SWRB, 3, Serialized)
                {
                    If (STRT ())
                    {
                        Return (Zero)
                    }

                    Store (Zero, I2CE)
                    Store (0xBF, HSTS)
                    Store (Arg0, TXSA)
                    Store (Arg1, HCOM)
                    Store (Arg2, DAT0)
                    Store (0x48, HCON)
                    If (COMP ())
                    {
                        Or (HSTS, 0xFF, HSTS)
                        Return (One)
                    }

                    Return (Zero)
                }

                Method (SRDB, 2, Serialized)
                {
                    If (STRT ())
                    {
                        Return (0xFFFF)
                    }

                    Store (Zero, I2CE)
                    Store (0xBF, HSTS)
                    Store (Or (Arg0, One), TXSA)
                    Store (Arg1, HCOM)
                    Store (0x48, HCON)
                    If (COMP ())
                    {
                        Or (HSTS, 0xFF, HSTS)
                        Return (DAT0)
                    }

                    Return (0xFFFF)
                }

                Method (SBLW, 4, Serialized)
                {
                    If (STRT ())
                    {
                        Return (Zero)
                    }

                    Store (Arg3, I2CE)
                    Store (0xBF, HSTS)
                    Store (Arg0, TXSA)
                    Store (Arg1, HCOM)
                    Store (SizeOf (Arg2), DAT0)
                    Store (Zero, Local1)
                    Store (DerefOf (Index (Arg2, Zero)), HBDR)
                    Store (0x54, HCON)
                    While (LGreater (SizeOf (Arg2), Local1))
                    {
                        Store (0x0FA0, Local0)
                        While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                        {
                            Decrement (Local0)
                            Stall (0x32)
                        }

                        If (LNot (Local0))
                        {
                            KILL ()
                            Return (Zero)
                        }

                        Store (0x80, HSTS)
                        Increment (Local1)
                        If (LGreater (SizeOf (Arg2), Local1))
                        {
                            Store (DerefOf (Index (Arg2, Local1)), HBDR)
                        }
                    }

                    If (COMP ())
                    {
                        Or (HSTS, 0xFF, HSTS)
                        Return (One)
                    }

                    Return (Zero)
                }

                Method (SBLR, 3, Serialized)
                {
                    Name (TBUF, Buffer (0x0100) {})
                    If (STRT ())
                    {
                        Return (Zero)
                    }

                    Store (Arg2, I2CE)
                    Store (0xBF, HSTS)
                    Store (Or (Arg0, One), TXSA)
                    Store (Arg1, HCOM)
                    Store (0x54, HCON)
                    Store (0x0FA0, Local0)
                    While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                    {
                        Decrement (Local0)
                        Stall (0x32)
                    }

                    If (LNot (Local0))
                    {
                        KILL ()
                        Return (Zero)
                    }

                    Store (DAT0, Index (TBUF, Zero))
                    Store (0x80, HSTS)
                    Store (One, Local1)
                    While (LLess (Local1, DerefOf (Index (TBUF, Zero))))
                    {
                        Store (0x0FA0, Local0)
                        While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                        {
                            Decrement (Local0)
                            Stall (0x32)
                        }

                        If (LNot (Local0))
                        {
                            KILL ()
                            Return (Zero)
                        }

                        Store (HBDR, Index (TBUF, Local1))
                        Store (0x80, HSTS)
                        Increment (Local1)
                    }

                    If (COMP ())
                    {
                        Or (HSTS, 0xFF, HSTS)
                        Return (TBUF)
                    }

                    Return (Zero)
                }

                Method (STRT, 0, Serialized)
                {
                    Store (0xC8, Local0)
                    While (Local0)
                    {
                        If (And (HSTS, 0x40))
                        {
                            Decrement (Local0)
                            Sleep (One)
                            If (LEqual (Local0, Zero))
                            {
                                Return (One)
                            }
                        }
                        Else
                        {
                            Store (Zero, Local0)
                        }
                    }

                    Store (0x0FA0, Local0)
                    While (Local0)
                    {
                        If (And (HSTS, One))
                        {
                            Decrement (Local0)
                            Stall (0x32)
                            If (LEqual (Local0, Zero))
                            {
                                KILL ()
                            }
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }

                    Return (One)
                }

                Method (COMP, 0, Serialized)
                {
                    Store (0x0FA0, Local0)
                    While (Local0)
                    {
                        If (And (HSTS, 0x02))
                        {
                            Return (One)
                        }
                        Else
                        {
                            Decrement (Local0)
                            Stall (0x32)
                            If (LEqual (Local0, Zero))
                            {
                                KILL ()
                            }
                        }
                    }

                    Return (Zero)
                }

                Method (KILL, 0, Serialized)
                {
                    Or (HCON, 0x02, HCON)
                    Or (HSTS, 0xFF, HSTS)
                }
            }
        }
    }
}

