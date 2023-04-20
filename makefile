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
ifeq ($(OS),Windows_NT)
	TOOLCHAIN_ROOT := G:/ProgramData/chocolatey/bin/
endif
# CROSS   := $(TOOLCHAIN_ROOT)arm-none-eabi-
# CROSS   := $(TOOLCHAIN_ROOT)i686-w64-mingw32-

CC       := $(CROSS)gcc
CXX      := $(CROSS)g++
LD       := $(CROSS)ld
SIZE     := $(CROSS)size
OBJCOPY  := $(CROSS)objcopy
OBJDUMP  := $(CROSS)objdump
RM       := rm -rf
MKDIR    := mkdir -p
ECHO     := echo
HEAD     := head
SYMLINK  := ln -sf
TAR      := tar -cf
COMPRESS := gzip -9f

ifeq ($(OS),Windows_NT)
	GIT_BIN_DIR := C:/Program Files/Git/usr/bin/
	RM     := $(GIT_BIN_DIR)$(RM)
	MKDIR  := $(GIT_BIN_DIR)$(MKDIR)
	ECHO   := $(GIT_BIN_DIR)$(ECHO) -e
	HEAD   := $(GIT_BIN_DIR)$(HEAD)
	CCACHE := $(if $(shell where ccache), ccache)
else
	CCACHE := $(if $(shell which ccache), ccache)
endif

CC_VERSION  := $(shell "$(CC)" --version | "$(HEAD)" -n 1)
CXX_VERSION := $(shell "$(CXX)" --version | "$(HEAD)" -n 1)

################################################################################
# flags
################################################################################
# CPU   := -mcpu=cortex-m0 -mthumb
OPTIM := -O2 -g3

CC_STD   := c99
CXX_STD  := $(if $(filter clang,$(CC_VERSION)),c++20,c++2a)

CFLAGS   =  $(CPU) $(OPTIM) \
		   -std=$(CC_STD) \
		   -W -Wall -MMD \
		   -Wno-sign-compare

CXXFLAGS = $(CPU) $(OPTIM) \
		   -std=$(CXX_STD) \
		   -W -Wall -MMD \
		   -Wno-sign-compare \
		   -fpermissive

LDFLAGS  = $(CPU) $(OPTIM)

# append compiler specific flags
ifneq (,$(findstring clang,$(CC_VERSION)))
	LDFLAGS += -Wl,-map,$(MAP) \
			   -Wl,-dead_strip
else ifneq (,$(findstring gcc,$(CC_VERSION)))
	LDFLAGS += -Wl,-Map=$(MAP) \
			   -Wl,--gc-sections
else
	LDFLAGS += $(warning undefined compiler: $(CC))
endif

################################################################################
# artifact
################################################################################
TARGET   := $(notdir $(CURDIR))
ARTIFACT := $(notdir $(CURDIR))
OUT_DIR  := build
TAR_DIR  := .

ifeq ($(UNAME), Darwin)
	DL_EXT = dylib
	SL_EXT = a
else ifeq ($(UNAME), Linux)
	DL_EXT = so
	SL_EXT = a
else ifeq ($(UNAME), Windows)
	DL_EXT = dll
	SL_EXT = lib
else
endif

ELF = $(TAR_DIR)/$(TARGET).elf
LST = $(TAR_DIR)/$(TARGET).lst
MAP = $(OUT_DIR)/$(TARGET).map
BIN = $(OUT_DIR)/$(TARGET).bin
HEX = $(OUT_DIR)/$(TARGET).hex
DL  = $(TAR_DIR)/$(TARGET).$(DL_EXT)

OUTPUT = $(ELF) $(MAP) $(BIN) $(HEX) $(DL)

################################################################################
# source & output
################################################################################
# LINKER_SCRIPT := $(TARGET).ld

SRC_ROOTS := \
			 .

INC_DIRS  := \

LIB_DIRS  := \

LIBS      := \


CSRCS   := $(patsubst ./%.c,%.c,$(foreach dir,$(SRC_ROOTS),$(call rwildcard,$(dir),*.c)))
CXXSRCS := $(patsubst ./%.cpp,%.cpp,$(foreach dir,$(SRC_ROOTS),$(call rwildcard,$(dir),*.cpp)))

COBJS   := $(CSRCS:%.c=$(OUT_DIR)/%.o)
CXXOBJS := $(CXXSRCS:%.cpp=$(OUT_DIR)/%.o)
OBJS    := $(COBJS) $(CXXOBJS)
DEPS    := $(OBJS:.o=.d)
-include $(DEPS)

CASMS   := $(CSRCS:%.c=$(OUT_DIR)/%.s)
CXXASMS := $(CXXSRCS:%.cpp=$(OUT_DIR)/%.s)
ASMS    := $(CASMS) $(CXXASMS)

OUTPUT  += $(OBJS) $(DEPS) $(ASMS)
OUTDIRS := $(filter-out ./,$(sort $(dir $(OUTPUT))))

################################################################################
# post-processing
################################################################################
include $(call rwildcard,.,*.mk)

LD := $(if $(strip $(CXXSRCS)),$(CXX),$(CC))

ifdef LINKER_SCRIPT
	LDFLAGS += -T$(LINKER_SCRIPT)
endif

INC_DIRS := $(addprefix -I, $(INC_DIRS))
LIB_DIRS := $(addprefix -L, $(LIB_DIRS))
LIBS     := $(addprefix -l, $(LIBS))

################################################################################
# verbose
################################################################################
ifeq ($(verbose),1)
V :=
else
V := @
endif

################################################################################
# rules
################################################################################
PHONY := all build clean run show cdb clang-format test

all: build

build: $(ELF) $(LST) #$(BIN) $(HEX)
	@$(ECHO) "build complete\n"
	$V $(SIZE) $<
	@$(ECHO) "------------------------------------------------------------------\n"

clean:
	@$(ECHO) cleaning
	$V $(RM) $(OUTPUT)
	$V $(RM) $(addsuffix *,$(OUTDIRS))

run:
	@$(ECHO) "run $(notdir $(ELF))\n"
ifeq ($(UNAME),Linux)
	@sudo $(ELF)
else
	@$(ELF)
endif

show:
	@$(ECHO) "\nUNAME = $(UNAME)"
	@$(ECHO) "\nCOMPILER = $(CC_VERSION)"
ifneq ($(UNAME),Windows)
	@echo "\nSRC_ROOTS"
	@(for v in $(SRC_ROOTS); do $(ECHO) "\t$$v"; done)
	@echo "\nINC_DIRS"
	@(for v in $(INC_DIRS); do $(ECHO) "\t$$v"; done)
	@echo "\nLIB_DIRS"
	@(for v in $(LIB_DIRS); do $(ECHO) "\t$$v"; done)
	@echo "\nLIBS"
	@(for v in $(LIBS); do $(ECHO) "\t$$v"; done)
	@echo "\nCFLAGS"
	@(for v in $(CFLAGS); do $(ECHO) "\t$$v"; done)
	@echo "\nCXXFLAGS"
	@(for v in $(CXXFLAGS); do $(ECHO) "\t$$v"; done)
	@echo "\nLDFLAGS"
	@(for v in $(LDFLAGS); do $(ECHO) "\t$$v"; done)
	@echo "\nCSRCS"
	@(for v in $(CSRCS); do $(ECHO) "\t$$v"; done)
	@echo "\nCXXSRCS"
	@(for v in $(CXXSRCS); do $(ECHO) "\t$$v"; done)
	@echo
endif

cdb: clean
	@$(ECHO) "generating compilation database as compile_commands.json\n"
ifneq (,$(findstring $(UNAME),Darwin Windows))
	@compiledb make -j20 all
else
	@bear -- make -j20 all
endif

clang-format:
	@$(ECHO) "generating .clang-format"
	@clang-format -style="{\
		BasedOnStyle                      : WebKit,\
		AlignAfterOpenBracket             : Align,\
		AlignEscapedNewlines              : DontAlign,\
		AlignOperands                     : true,\
		AlignTrailingComments             : true,\
		AllowShortCaseLabelsOnASingleLine : true,\
		BitFieldColonSpacing              : Both,\
		BreakBeforeBinaryOperators        : None,\
		BreakBeforeTernaryOperators       : false,\
		Cpp11BracedListStyle              : false,\
		KeepEmptyLinesAtTheStartOfBlocks  : false,\
		MaxEmptyLinesToKeep               : 2,\
		PointerAlignment                  : Left,\
		ReferenceAlignment                : Left,\
		SortIncludes                      : false,\
		SortUsingDeclarations             : false,\
		SpaceBeforeRangeBasedForLoopColon : true,\
		SpacesBeforeTrailingComments      : 2,\
	}" -dump-config > .clang-format

test:
	@$(ECHO) $(CCACHE)
	@$(ECHO) $(OUTDIRS)
	@$(ECHO) "$(CC_VERSION)"
	@$(ECHO) $(TEST)


asm: $(ASMS)
	@$(ECHO) "complete\n"

dl: $(DL)
	@$(ECHO) "complete\n"

PHONY += dev
dev:
	@echo Configuring Development Environment

$(LST): $(ELF)
	@$(ECHO) "generating disassembly $(@F)"
	@$(MKDIR) $(@D)
	$V $(OBJDUMP) -h -S $< > $@

$(BIN): $(ELF)
	@$(ECHO) "converting format $(<F) to $(@F)"
	@$(MKDIR) $(@D)
	$V $(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@$(ECHO) "converting format $(<F) to $(@F)"
	@$(MKDIR) $(@D)
	$V $(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJS) $(LINKER_SCRIPT)
	@$(ECHO) "linking $(@F)"
	@$(MKDIR) $(@D)
	$V $(LD) -o $@ $(OBJS) $(LIB_DIRS) $(LIBS) $(LDFLAGS)

$(DL): $(OBJS) $(LINKER_SCRIPT)
	@$(ECHO) "making dynamic library"
	@$(MKDIR) $(@D)
	$V $(LD) -o $@ $(OBJS) $(LIB_DIRS) $(LIBS) $(LDFLAGS) -shared

$(COBJS): $(OUT_DIR)/%.o: %.c
	@$(ECHO) "compiling $(<F)"
	@$(MKDIR) $(@D)
	$V$(CCACHE) $(CC) -o $@ -c $< $(INC_DIRS) $(CFLAGS)

$(CXXOBJS): $(OUT_DIR)/%.o: %.cpp
	@$(ECHO) "compiling $(<F)"
	@$(MKDIR) $(@D)
	$V$(CCACHE) $(CXX) -o $@ -c $< $(INC_DIRS) $(CXXFLAGS)

$(CASMS): $(OUT_DIR)/%.s: %.c
	@$(ECHO) "generating assembly $(@F)"
	@$(MKDIR) $(@D)
	$V$(CC) -o $@ -S $< $(INC_DIRS) $(CFLAGS)

$(CXXASMS): $(OUT_DIR)/%.s: %.cpp
	@$(ECHO) "generating assembly $(@F)"
	@$(MKDIR) $(@D)
	$V$(CXX) -o $@ -S $< $(INC_DIRS) $(CXXFLAGS)

.PHONY: $(PHONY)
