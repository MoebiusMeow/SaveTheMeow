ASM = main.asm util.asm paint.asm testobj.asm button.asm
OBJ = main.obj util.obj paint.obj testobj.obj button.obj
RCM = rclist.rcm 
RCINC = rclist.inc
RC  = rclist.rc
RES = rclist.res
EXE = app.exe

EX_LIB = kernel32.lib gdi32.lib user32.lib msvcrt.lib

ML = $(MASM)\bin\ml.exe
LINK = $(MASM)\bin\link.exe
RC_E = $(MASM)\bin\rc.exe

LINK_FLAG = /subsystem:console /LIBPATH:$(IRVINE) /LIBPATH:$(MASM)\lib
ML_FLAG = /c /coff /I$(MASM)/include


$(EXE): $(OBJ) $(RES)
	$(LINK) $(LINK_FLAG) $(OBJ) $(RES) $(EX_LIB) /out:$(EXE)
	del $(OBJ)
	del $(RES)
	@echo [SUCCESS]

$(OBJ): $(ASM) $(RCINC)
	$(ML) $(ML_FLAG) $(ASM) 

$(RC) $(RCINC): $(RCM)
	rcmake.exe $(RCM)

$(RES): $(RC)
	$(RC_E) $(RC)
	del $(RC)


clean:
	del $(EXE)
	del $(RCINC)