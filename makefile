#############################################################################
# Author: Insub Song
#############################################################################

#############################################################################
# functions
#############################################################################
# Recursive wildcard - https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

#############################################################################
# toolchain
#############################################################################
# CROSS   := i686-w64-mingw32-

CC      := $(CROSS)gcc
LD      := $(CROSS)ld
SIZE    := $(CROSS)size
OBJCOPY := $(CROSS)objcopy
OBJDUMP := $(CROSS)objdump
RM      := rm -f
MKDIR   := mkdir -p

ifeq ($(OS),Windows_NT)
	RM    := del /Q /F
	MKDIR := md
	SO    := $(SO:%.so=%.dll)
endif

#############################################################################
# flags
#############################################################################
# CPU      := cortex-m0
# ARCH     := native

OPT	     := -O2 -g3

CFLAGS   = $(CPU) $(ARCH) -W -Wall -MMD \
		   $(OPT) \
		   -std=c99
CXXFLAGS = $(CPU) $(ARCH) -W -Wall -MMD \
		   $(OPT) -fpermissive
LDFLAGS  = $(CPU) $(ARCH) \
		   $(LDFILE) \
		   -Wl,-map,$(MAP)

#############################################################################
# artifact
#############################################################################
TARGET   := $(notdir $(CURDIR))
ARTIFACT := $(notdir $(CURDIR))
BLD_DIR  := build
TAR_DIR  := .

ELF = $(TAR_DIR)/$(TARGET).elf
MAP = $(BLD_DIR)/$(TARGET).map
BIN = $(BLD_DIR)/$(TARGET).bin
HEX = $(BLD_DIR)/$(TARGET).hex
SO  = $(TAR_DIR)/$(TARGET).so

OUTPUT = $(ELF) $(MAP) $(BIN) $(HEX) $(SO)

#############################################################################
# source & output
#############################################################################
# LDFILE  := $(TARGET).ld

SRCROOT := .
OBJROOT := debug
INCDIRS := include
LIBDIRS :=
LIBS    :=

CSRCS   := $(call rwildcard,.,*.c)
CXXSRCS := $(call rwildcard,.,*.cpp)
COBJS   := $(CSRCS:$(SRCROOT)/%.c=$(OBJROOT)/%.o)
CXXOBJS := $(CXXSRCS:$(SRCROOT)/%.cpp=$(OBJROOT)/%.o)
OBJS    := $(COBJS) $(CXXOBJS)
DEPS    := $(OBJS:.o=.d)

-include $(DEPS)

OUTPUT  += $(OBJS) $(DEPS)
OUTDIRS := $(sort $(dir $(OUTPUT)))

#############################################################################
# post-processing
#############################################################################
CPU     := $(if $(CPU), -mcpu=$(CPU),)
ARCH    := $(if $(ARCH), -march=$(ARCH),)
LDFILE  := $(if $(LDFILE), -T$(LDFILE),)
INCDIRS := $(addprefix -I, $(INCDIRS))
LIBDIRS := $(addprefix -L, $(LIBDIRS))
LIBS    := $(addprefix -l, $(LIBS))

include $(wildcard *.mk)

#############################################################################
# verbose
#############################################################################
ifeq ($(verbose),1)
ECHO :=
else
ECHO := @
endif

#############################################################################
# rules
#############################################################################
PHONY := all build clean run show test

all: build

build: $(ELF) #$(BIN) $(HEX)
	@echo Size of image
	@$(SIZE) $<
	@echo MAKE COMPLETE!!; echo

clean:
	@echo cleaning
	$(ECHO) $(RM) $(OUTPUT)

run:
	@echo Run $(notdir $(ELF)); echo
	@$(ELF)

show:
	@echo "\nSRCROOT = $(SRCROOT)"
	@echo "\nINCDIRS"
	@(for v in $(INCDIRS); do echo "\t$$v"; done)
	@echo "\nLIBDIRS"
	@(for v in $(LIBDIRS); do echo "\t$$v"; done)
	@echo "\nLIBS"
	@(for v in $(LIBS); do echo "\t$$v"; done)
	@echo "\nCFLAGS"
	@(for v in $(CFLAGS); do echo "\t$$v"; done)
	@echo "\nLDFLAGS"
	@(for v in $(LDFLAGS); do echo "\t$$v"; done)
	@echo "\nCSRCS"
	@(for v in $(CSRCS); do echo "\t$$v"; done)
	@echo

test:
	@echo $(OUTDIRS)
	@echo $(LDFILE)

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
	@echo create .clang-format
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
	$(ECHO) $(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@echo Making Intel hex from $(<F)
	$(ECHO) $(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJS) $(LDFILE)
	@$(MKDIR) $(TAR_DIR)
	@echo Linking $(@F)
	$(ECHO) $(CC) -o $@ $^ $(LIBDIRS) $(LIBS) $(LDFLAGS)

$(SO): $(OBJS)
	@$(MKDIR) $(TAR_DIR)
	@echo Making dynamic library
	@$(LD) -o $@ $^ $(LIBDIRS) $(LIBS) $(LDFLAGS) -shared

$(COBJS): $(OBJROOT)%.o: $(SRCROOT)%.c
	@$(MKDIR) $(OUTDIRS)
	@echo Compiling $(<F)
	$(ECHO) $(CC) -o $@ -c $< $(INCDIRS) $(CFLAGS)

$(CXXOBJS): $(OBJROOT)%.o: $(SRCROOT)%.cpp
	@$(MKDIR) $(OUTDIRS)
	@echo Compiling $(<F)
	$(ECHO) $(CXX) -o $@ -c $< $(INCDIRS) $(CXXFLAGS)

.PHONY: $(PHONY)
