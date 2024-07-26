c2 = ./../c+=2/cp2

STARTDIR=start

SOURCE_assembly_i86=$(wildcard src/*.i86)
SOURCE_assembly_i86+=$(wildcard src/$(STARTDIR)/*.i86)
OBJECTS_assembly_i86=$(patsubst src/%.i86,build/%.o,$(SOURCE_assembly_i86))
DEPFILES_assembly_i86=$(patsubst src/%.i86,build/%.d,$(SOURCE_assembly_i86))
SOURCE_assembly_a86=$(wildcard src/*.a86)
SOURCE_assembly_a86+=$(wildcard src/$(STARTDIR)/*.a86)
OBJECTS_assembly_a86=$(patsubst src/%.a86,build/%.o,$(SOURCE_assembly_a86))
DEPFILES_assembly_a86=$(patsubst src/%.a86,build/%.d,$(SOURCE_assembly_a86))
SOURCE_c2_c2=$(wildcard src/*.c2)
SOURCE_c2_c2+=$(wildcard src/$(STARTDIR)/*.c2)
OBJECTS_c2_c2=$(patsubst src/%.c2,build/%.o,$(SOURCE_c2_c2))
DEPFILES_c2_c2=$(patsubst src/%.c2,build/%.d,$(SOURCE_c2_c2))
RESFILES_c2_c2=$(patsubst src/%.c2,build/%.c2resource,$(SOURCE_c2_c2))
SOURCE_c2_cp2=$(wildcard src/*.cp2)
SOURCE_c2_cp2+=$(wildcard src/$(STARTDIR)/*.cp2)
OBJECTS_c2_cp2=$(patsubst src/%.cp2,build/%.o,$(SOURCE_c2_cp2))
DEPFILES_c2_cp2=$(patsubst src/%.cp2,build/%.d,$(SOURCE_c2_cp2))
RESFILES_c2_cp2=$(patsubst src/%.cp2,build/%.c2resource,$(SOURCE_c2_cp2))

C2ARGS=
ASARGS=
c2syn=Intel

all: testprog

compilerDebug:
	make C2ARGS=--ddebug &> stdout.ans

build/%.o: src/%.i86
	@$(AS) $(ASARGS) --gstabs -MD -c -o $@ $<
	$(info  	$(AS)	$<)
build/%.o: src/%.a86
	@$(AS) $(ASARGS) --gstabs -MD -c -o $@ $<
	$(info  	$(AS)	$<)
build/%.o: src/%.c2 $(c2)
	@$(c2) $(C2ARGS) -MD -Bbuild -Ddocumentation --msyntax=$(c2syn) -Iinc --fno-libc -NOD -S -c -o $@ $<
	$(info  	$(c2)	$<)
build/%.o: src/%.cp2 $(c2)
	@$(c2) $(C2ARGS) -MD -Bbuild -Ddocumentation --msyntax=$(c2syn) -Iinc --fno-libc -NOD -S -c -o $@ $<
	$(info  	$(c2)	$<)
clean:
	@-rm -r build/*.o
	$(info  	DELETE	build/*.o)
	@-rm -r build/*.d
	$(info  	DELETE	build/*.d)
	@-rm -r build/*.i86
	$(info  	DELETE	build/*.i86)
	@-rm -r build/*.a86
	$(info  	DELETE	build/*.a86)

testprog:  $(OBJECTS_assembly_i86) $(OBJECTS_assembly_a86) $(OBJECTS_c2_cp2) $(OBJECTS_c2_c2)
	@$(c2) $(C2ARGS) -MD -Bbuild -Ddocumentation --msyntax=$(c2syn) -Iinc --fno-libc -NOD -S -c $(RESFILES_c2_cp2) $(RESFILES_c2_c2) -o build/c2resources.o
	$(info  	$(c2)	$(RESFILES_c2_cp2) $(RESFILES_c2_c2))
	@$(LD) $(OBJECTS_assembly_i86) $(OBJECTS_assembly_a86) $(OBJECTS_c2_cp2) $(OBJECTS_c2_c2) build/c2resources.o -x -lcpe2 -E -o test.exe
	$(info  	$(LD)	$@)

countLines:
	@find src inc -type f \( -iname \*.c2 -o -iname \*.cp2 -o -iname \*.i86 -o -iname \*.a86 \) -exec cat {} \; | wc -l

listCodeFiles:
	@find src inc -type f \( -iname \*.c2 -o -iname \*.cp2 -o -iname \*.i86 -o -iname \*.a86 \) -print

disas:
	objdump -M intel -M x86-64 -M amd64 --disassembler-color=extended --visualize-jumps=extended-color -d ./test.exe

-include $(DEPFILES_assembly_i86)
-include $(DEPFILES_assembly_a86)
-include $(DEPFILES_c2_c2)
-include $(DEPFILES_c2_cp2)
