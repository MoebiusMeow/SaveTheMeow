.386
.model flat, stdcall
option casemap:none

include util.inc

.data
szOpenFile          byte    "r", 0
szFileGetLineFormat byte    "%s", 0
szdPrintFormat      byte    "%d", 0dh, 0ah, 0
szdPrint2Format     byte    "%d %d", 0dh, 0ah, 0
szdPrint3Format     byte    "%d %d %d", 0dh, 0ah, 0
szdPrintFloatFormat byte    "%f", 0dh, 0ah, 0
szdPrint2FloatFormat byte    "(%f %f)", 0dh, 0ah, 0
PI                  REAL4   3.1415926
real0               REAL4   0.0
real1               REAL4   1.0
real2               REAL4   2.0
real1n              REAL4   -1.0
real1of2            REAL4   0.5
real1of3            REAL4   0.33333
real2of3            REAL4   0.66666
real9of10           REAL4   0.9
real11              REAL4   11.0
real100             REAL4   100.0
MouseXi             DWORD   0
MouseYi             DWORD   0
MouseXf             REAL4   0.0
MouseYf             REAL4   0.0

.data?
fileBuffer          BYTE    1024 DUP(?)

.code
dPrint      proc  data:DWORD
    pushad
    invoke  printf, offset szdPrintFormat, data
    popad
    ret
dPrint      ENDP

dPrint2     proc  data0:DWORD, data1:DWORD
    pushad
    invoke  printf, offset szdPrint2Format, data0, data1
    popad
    ret
dPrint2     ENDP

dPrint3     proc  data0:DWORD, data1:DWORD, data2:DWORD
    pushad
    invoke  printf, offset szdPrint3Format, data0, data1, data2
    popad
    ret
dPrint3     ENDP

dword2real4    PROC intValue: DWORD
    local   @result:DWORD
    fild    DWORD ptr intValue
    fstp    DWORD ptr @result
    mov     eax, @result
    ret
dword2real4    ENDP

real42dword    PROC realValue: REAL4
    local   @result:DWORD
    fld     DWORD ptr realValue
    fistp   DWORD ptr @result
    mov     eax, @result
    ret
real42dword    ENDP


dPrintFloat proc  data:DWORD
    local   dbdata: QWORD
    pushad
    fld     DWORD ptr data
    fstp    QWORD ptr dbdata
    invoke  printf, offset szdPrintFloatFormat, dbdata
    popad
    ret
dPrintFloat endp

dPrint2Float proc  data0:DWORD, data1:DWORD
    local   dbdata0: QWORD, dbdata1:QWORD
    pushad
    fld     DWORD ptr data0
    fstp    QWORD ptr dbdata0
    fld     DWORD ptr data1
    fstp    QWORD ptr dbdata1
    invoke  printf, offset szdPrint2FloatFormat, dbdata0, dbdata1
    popad
    ret
dPrint2Float endp

UpdateMousePos proc x:DWORD, y:DWORD
    mov     eax, x
    mov     MouseXi, eax
    mov     eax, y
    mov     MouseYi, eax 
    invoke  dword2real4, MouseXi
    mov     MouseXf, eax
    invoke  dword2real4, MouseYi
    mov     MouseYf, eax
    ; invoke  dPrint2, MouseXi, MouseYi
    ; invoke  dPrint2Float, MouseXf, MouseYf
    ret
UpdateMousePos endp

OpenTextFile        PROC uses ebx edi esi szFileName:DWORD
    invoke  printf, szFileName
    invoke  fopen, szFileName, offset szOpenFile
    ret
OpenTextFile        ENDP

GetFileLine     PROC uses ebx edi esi pFile:DWORD
    invoke  fscanf, pFile, offset szFileGetLineFormat, offset fileBuffer
    mov     eax, offset fileBuffer
    ret
GetFileLine     ENDP

CloseFile      PROC uses ebx esi edi  pFile:DWORD
    invoke  fclose, pFile
    ret
CloseFile       ENDP
    
Random          PROC  uses ebx esi edi
    local   @integer
    invoke  rand
    and     eax, 0000ffffh
    
    invoke  dPrint, eax
    mov     @integer, eax
    fild    @integer
    mov     eax, 7fffh
    mov     @integer, eax
    fidiv   @integer
    fstp    @integer
    mov     eax, @integer
    ret
Random      ENDP

end
