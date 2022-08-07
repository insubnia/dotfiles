#############################################################################
# Author: Insub Song
#############################################################################

# Recursive wildcard - https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

ifeq ($(OS),Windows_NT)
	RM = del /Q /F
	MKDIR := md
else
	RM = rm -f
	MKDIR := mkdir -p
endif

# CPU      := cortex-m0
# ARCH     := native
# CROSS    := i686-w64-mingw32-

TARGET   := $(notdir $(CURDIR))
ARTIFACT := $(notdir $(CURDIR))
# LDSCRIPT := $(TARGET).ld

CC		:= $(CROSS)gcc
LD		:= $(CROSS)ld
SIZE	:= $(CROSS)size
OBJCOPY := $(CROSS)objcopy
OBJDUMP := $(CROSS)objdump

ELF = $(TAR_DIR)/$(TARGET).elf
MAP = $(BLD_DIR)/$(TARGET).map
BIN = $(BLD_DIR)/$(TARGET).bin
HEX = $(BLD_DIR)/$(TARGET).hex
SO  = $(TAR_DIR)/$(TARGET).so

ifneq ($(OS),Windows_NT)
	SO := $(SO:%.so=%.dll)
endif

OUTPUT = $(ELF) $(BIN) $(HEX) $(MAP) $(SO)

OPT	= -O2 -g3

CFLAGS   = $(CPU) $(ARCH) -W -Wall -MMD \
		   $(OPT) \
		   -std=c99
CXXFLAGS = -march=$(ARCH) -W -Wall -MMD $(OPT) -fpermissive
LDFLAGS  = $(CPU) $(ARCH) \
		   $(LDSCRIPT) \
		   -Wl,-map,$(MAP)


SRCROOT := .
OBJROOT := debug
INCDIRS := include
LIBDIRS :=
LIBS	:=
BLD_DIR := build
TAR_DIR := .


include $(wildcard *.mk)

CSRCS   := $(call rwildcard,.,*.c)
CXXSRCS := $(call rwildcard,.,*.cpp)
COBJS   := $(CSRCS:$(SRCROOT)/%.c=$(OBJROOT)/%.o)
CXXOBJS := $(CXXSRCS:$(SRCROOT)/%.cpp=$(OBJROOT)/%.o)
OBJS    := $(COBJS) $(CXXOBJS)
DEPS    := $(OBJS:.o=.d)

-include $(DEPS)


OUTPUT += $(OBJS) $(DEPS)
TREE   = $(sort $(dir $(OUTPUT)))


CPU      := $(if $(CPU), -mcpu=$(CPU),)
ARCH     := $(if $(ARCH), -march=$(ARCH),)
LDSCRIPT := $(if $(LDSCRIPT), -T$(LDSCRIPT),)
INCDIRS  := $(addprefix -I, $(INCDIRS))
LIBDIRS  := $(addprefix -L, $(LIBDIRS))
LIBS     := $(addprefix -l, $(LIBS))


PHONY := all build clean run test

all: build

build: $(ELF) #$(BIN) $(HEX)
	@echo Size of image
	@$(SIZE) $<
	@echo MAKE COMPLETE!!; echo

clean:
	@echo Removing Files
	@$(RM) $(OUTPUT)

run:
	@echo Run $(notdir $(ELF)); echo
	@$(ELF)

test:
	@echo $(TREE)
	@echo $(CSRCS)

PHONY += so
so: $(SO)
	@echo COMPLETE!!

PHONY += dump
dump: $(ELF)
	@echo Information from $<
	@$(OBJDUMP) -S -D $<

PHONY += dev
dev:
	@echo Configuring Development Environment

PHONY += clang-format
clang-format:
	@echo Create .clang-format; echo
	@clang-format -style="{\
		BasedOnStyle                      : WebKit,\
		AlignAfterOpenBracket             : Align,\
		AlignEscapedNewlines              : DontAlign,\
		AlignOperands                     : true,\
		AlignTrailingComments             : true,\
		AllowShortCaseLabelsOnASingleLine : true,\
		BreakBeforeBinaryOperators        : None,\
		BreakBeforeTernaryOperators       : false,\
		Cpp11BracedListStyle              : false,\
		KeepEmptyLinesAtTheStartOfBlocks  : false,\
		MaxEmptyLinesToKeep               : 2,\
		PointerAlignment                  : Right,\
		SortIncludes                      : false,\
		SortUsingDeclarations             : false,\
	}" -dump-config > .clang-format

PHONY += cdb
cdb:
	@echo "Making compilation database (=compile_commands.json)"
	@compiledb make clean all


$(BIN): $(ELF)
	@echo Making Binary from $(<F)
	@$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@echo Making Intel hex from $(<F)
	@$(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJS)
	@$(MKDIR) $(TAR_DIR)
	@echo Linking $(@F)
	@$(CC) -o $@ $^ $(LIBDIRS) $(LIBS) $(LDFLAGS)

$(SO): $(OBJS)
	@$(MKDIR) $(TAR_DIR)
	@echo Making dynamic library
	@$(LD) -o $@ $^ $(LIBDIRS) $(LIBS) $(LDFLAGS) -shared

$(COBJS): $(OBJROOT)%.o: $(SRCROOT)%.c
	@$(MKDIR) $(TREE)
	@echo Compiling $(<F)
	@$(CC) -o $@ -c $< $(INCDIRS) $(CFLAGS)

$(CXXOBJS): $(OBJROOT)%.o: $(SRCROOT)%.cpp
	@$(MKDIR) $(TREE)
	@echo Compiling $(<F)
	@$(CXX) -o $@ -c $< $(INCDIRS) $(CXXFLAGS)

.PHONY: $(PHONY)
