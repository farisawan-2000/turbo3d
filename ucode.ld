
OUTPUT_ARCH (mips)

#define BEGIN_SEG(name, addr) \
     _##name##SegmentStart = ADDR(.name); \
     _##name##SegmentRomStart = __romPos; \
     .name addr : AT(__romPos)

#define END_SEG(name) \
     _##name##SegmentEnd = ADDR(.name) + SIZEOF(.name); \
     _##name##SegmentRomEnd = __romPos + SIZEOF(.name); \
     __romPos += SIZEOF(.name);

#define BEGIN_UCODE_TEXT(name, addr) \
     name##TextStart = ADDR(.name); \
     name##TextRomStart = __romPos; \
     .name addr : AT(__romPos)

#define END_UCODE_TEXT(name) \
     name##TextEnd = ADDR(.name) + SIZEOF(.name); \
     name##TextRomEnd = __romPos + SIZEOF(.name); \
     __romPos += SIZEOF(.name);

#define BEGIN_UCODE_DATA(name, addr) \
     name##DataStart = ADDR(.name##_data); \
     name##DataRomStart = __romPos; \
     .name##_data addr : AT(__romPos)

#define END_UCODE_DATA(name) \
     name##DataEnd = ADDR(.name##_data) + SIZEOF(.name##_data); \
     name##DataRomEnd = __romPos + SIZEOF(.name##_data); \
     __romPos += SIZEOF(.name##_data);

#define BEGIN_NOLOAD(name) \
     _##name##SegNoloadStart = ADDR(.name.noload); \
     .name.noload (NOLOAD) :

#define END_NOLOAD(name) \
     _##name##SegNoloadEnd = ADDR(.name.noload) + SIZEOF(.name.noload);


SECTIONS
{
    __romPos = 0x0;

    /* header and boot */
    BEGIN_SEG(boot, 0x04001000) {
#ifdef TEXT
        *(.text);
#endif
#ifdef DATA
        *(.data);
#endif
    }
    END_SEG(boot)

    /DISCARD/ :
    {
        *(*);
    }
}


