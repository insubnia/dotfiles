# Author: sis
# general makefile

TARGET	= $(notdir $(CURDIR))

# Type "objcopy --help | tail, to show available architecture"
ARCH	= native
CROSS	= # i686-w64-mingw32-

CC		= $(CROSS)gcc
CXX		= $(CROSS)g++
LD		= $(CXX)
# LD		= $(CROSS)ld
SIZE	= $(CROSS)size
OBJCOPY	= $(CROSS)objcopy
OBJDUMP	= $(CROSS)objdump
RM		= rm -f

ELF	= $(TAR_DIR)$(TARGET).elf
BIN	= $(BLD_DIR)$(TARGET).bin
HEX	= $(BLD_DIR)$(TARGET).hex
MAP	= $(BLD_DIR)$(TARGET).map
ifeq ($(OS),Windows_NT)
	SO = $(TAR_DIR)$(TARGET).dll
else
	SO = $(TAR_DIR)$(TARGET).so
endif

OUTPUT = $(ELF) $(BIN) $(HEX) $(MAP) $(SO)

OPT	= -O2 -g3

CFLAGS   = -march=$(ARCH) -W -Wall -MMD $(OPT) -std=c99
CXXFLAGS = -march=$(ARCH) -W -Wall -MMD $(OPT) -fpermissive
# LDFLAGS  = -v

SRC_DIR	= ./
INC_DIR	= ./
BLD_DIR	= build/
TAR_DIR	= ./
LIB_DIR	= ./
LIBS	=

include $(wildcard *.mk)

CSRCS	= $(wildcard $(SRC_DIR)*.c)
CXXSRCS	= $(wildcard $(SRC_DIR)*.cpp)

COBJS	= $(patsubst $(SRC_DIR)%.c, $(BLD_DIR)%.o, $(CSRCS))
CXXOBJS	= $(patsubst $(SRC_DIR)%.cpp, $(BLD_DIR)%.o, $(CXXSRCS))
OBJS	= $(COBJS) $(CXXOBJS)
DEPS	= $(OBJS:.o=*.d)
OUTPUT	+= $(OBJS) $(DEPS)

-include $(DEPS)

INC_DIR	:= $(addprefix -I, $(INC_DIR))
LIB_DIR	:= $(addprefix -L, $(LIB_DIR))
LIBS	:= $(addprefix -l, $(LIBS))

PHONY += all
all: $(ELF) #$(BIN) $(HEX)
	@echo Size of image
	@$(SIZE) $<
	@echo MAKE COMPLETE!!; echo

PHONY += clean
clean:
	@echo Removing files
	@$(RM) $(OUTPUT)

PHONY += run
run:
	@echo Run $(notdir $(ELF)); echo
	@$(ELF)

PHONY += so
so: $(SO)
	@echo COMPLETE!!

PHONY += dump
dump: $(ELF)
	@echo Information from $<
	@$(OBJDUMP) -S -D $<

PHONY += dev
dev:
	@echo Config dev; echo
	@clang-format -style="{\
		BasedOnStyle                      : WebKit,\
		AlignAfterOpenBracket             : Align,\
		AlignTrailingComments             : true,\
		AllowShortCaseLabelsOnASingleLine : true,\
		Cpp11BracedListStyle              : true,\
		KeepEmptyLinesAtTheStartOfBlocks  : false,\
		MaxEmptyLinesToKeep               : 2,\
		PointerAlignment                  : Right,\
		SortIncludes                      : false,\
		SortUsingDeclarations             : false,\
	}" -dump-config > .clang-format

PHONY += test
test:
	@echo $(PHONY)


$(BIN): $(ELF)
	@echo Making Binary from $(<F)
	@$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@echo Making Intel hex from $(<F)
	@$(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJS)
	@mkdir -p $(TAR_DIR)
	@echo Linking $(@F)
	@$(LD) -o $@ $^ $(LIB_DIR) $(LIBS) $(LDFLAGS)

$(SO): $(OBJS)
	@mkdir -p $(TAR_DIR)
	@echo Making dynamic library
	@$(LD) -o $@ $^ $(LIB_DIR) $(LIBS) $(LDFLAGS) -shared

$(COBJS): $(BLD_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(BLD_DIR)
	@echo Compiling $(<F)
	@$(CC) -o $@ -c $< $(INC_DIR) $(CFLAGS)

$(CXXOBJS): $(BLD_DIR)%.o: $(SRC_DIR)%.cpp
	@mkdir -p $(BLD_DIR)
	@echo Compiling $(<F)
	@$(CXX) -o $@ -c $< $(INC_DIR) $(CXXFLAGS)

.PHONY: $(PHONY)
