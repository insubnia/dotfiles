# vim: filetype=make noexpandtab
################################################################################
# Author: Insub Song
################################################################################

################################################################################
# preset
################################################################################
# Recursive wildcard - https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

# OS detection - https://stackoverflow.com/questions/714100/os-detecting-makefile
ifeq ($(OS),Windows_NT)
	UNAME := Windows
else
	UNAME := $(shell uname)
endif

################################################################################
# toolchain
################################################################################
# CROSS   := arm-none-eabi-
# CROSS   := i686-w64-mingw32-

CC      := $(CROSS)gcc
CXX     := $(CROSS)g++
LD      := $(CROSS)ld
SIZE    := $(CROSS)size
OBJCOPY := $(CROSS)objcopy
OBJDUMP := $(CROSS)objdump
RM      := rm -f
MKDIR   := mkdir -p

ifeq ($(UNAME),Windows)
	GIT_BIN_DIR := "C:/Program Files/Git/usr/bin"
	RM    := $(GIT_BIN_DIR)/$(RM)
	MKDIR := $(GIT_BIN_DIR)/$(MKDIR)
endif

CC_VERSION  = $(shell $(CC) --version | head -n 1)
CXX_VERSION = $(shell $(CC) --version | head -n 1)

################################################################################
# flags
################################################################################
# CPU      := cortex-m0
# ARCH     := native

OPTIMIZE := -O2 -g3

CFLAGS   = $(CPU_OPT) $(ARCH_OPT) $(OPTIMIZE) \
		   -W -Wall -MMD \
		   -std=c99

CXXFLAGS = $(CPU_OPT) $(ARCH_OPT) $(OPTIMIZE) \
		   -W -Wall -MMD \
		   -fpermissive

LDFLAGS  = $(CPU_OPT) $(ARCH_OPT) \
		   $(LDFILE_OPT) \
		   $(MAP_OPT)

################################################################################
# artifact
################################################################################
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

################################################################################
# source & output
################################################################################
# LDFILE  := $(TARGET).ld

SRCROOT := .
OBJROOT := build
INCDIRS :=
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

################################################################################
# post-processing
################################################################################
include $(wildcard *.mk)

LDFILE_OPT = $(if $(LDFILE),-T$(LDFILE),)
CPU_OPT    = $(if $(CPU),-mcpu=$(CPU),)
ARCH_OPT   = $(if $(ARCH),-march=$(ARCH),)

ifneq (,$(findstring clang,$(CC_VERSION)))  # use ifneq to prevent double typing of finding word
	MAP_OPT := -Wl,-map,$(MAP)
else ifneq (,$(findstring arm-none-eabi-gcc,$(CC_VERSION)))
	MAP_OPT := -Wl,-Map=$(MAP)
else ifneq (,$(findstring gcc,$(CC_VERSION)))
	MAP_OPT := -Wl,-map=$(MAP)
else
	MAP_OPT :=\
	$(warning undefined compiler: $(CC))
endif

INCDIRS := $(addprefix -I, $(INCDIRS))
LIBDIRS := $(addprefix -L, $(LIBDIRS))
LIBS    := $(addprefix -l, $(LIBS))

################################################################################
# verbose
################################################################################
ifeq ($(verbose),1)
ECHO :=
else
ECHO := @
endif

################################################################################
# rules
################################################################################
PHONY := all build clean run show test

all: build

build: $(ELF) #$(BIN) $(HEX)
	@echo Size of image
	@$(SIZE) $<
	@echo "\nbuild complete\n"

clean:
	@echo cleaning
	$(ECHO) $(RM) $(OUTPUT)

run:
	@echo run $(notdir $(ELF)); echo
	@$(ELF)

show:
	@echo "\nCC_VERSION = $(CC_VERSION)"
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
	@echo $(TEST)
	@echo $(OUTDIRS)

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
	@echo linking $(@F)
	$(ECHO) $(CC) -o $@ $^ $(LIBDIRS) $(LIBS) $(LDFLAGS)

$(SO): $(OBJS)
	@$(MKDIR) $(TAR_DIR)
	@echo making dynamic library
	@$(LD) -o $@ $^ $(LIBDIRS) $(LIBS) $(LDFLAGS) -shared

$(COBJS): $(OBJROOT)%.o: $(SRCROOT)%.c
	@$(MKDIR) $(OUTDIRS)
	@echo compiling $(<F)
	$(ECHO) $(CC) -o $@ -c $< $(INCDIRS) $(CFLAGS)

$(CXXOBJS): $(OBJROOT)%.o: $(SRCROOT)%.cpp
	@$(MKDIR) $(OUTDIRS)
	@echo compiling $(<F)
	$(ECHO) $(CXX) -o $@ -c $< $(INCDIRS) $(CXXFLAGS)

.PHONY: $(PHONY)
