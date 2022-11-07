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
RM       := rm -f
MKDIR    := mkdir -p
ECHO     := echo
HEAD     := head
SYMLINK  := ln -sf
TAR      := tar -cf
COMPRESS := gzip -9f

ifeq ($(UNAME),Windows)
	GIT_BIN_DIR := C:/Program Files/Git/usr/bin/
	RM    := $(GIT_BIN_DIR)$(RM)
	MKDIR := $(GIT_BIN_DIR)$(MKDIR)
	ECHO  := $(GIT_BIN_DIR)$(ECHO) -e
	HEAD  := $(GIT_BIN_DIR)$(HEAD)
endif

CC_VERSION  := $(shell "$(CC)" --version | "$(HEAD)" -n 1)
CXX_VERSION := $(shell "$(CXX)" --version | "$(HEAD)" -n 1)

################################################################################
# flags
################################################################################
# CPU      := cortex-m0
# ARCH     := native

OPTIMIZE := -O2 -g3
CC_STD   := c99
CXX_STD  := $(if $(filter clang,$(CC_VERSION)),c++20,c++2a)

CFLAGS   = \
		   $(CPU_OPT) $(ARCH_OPT) $(OPTIMIZE) \
		   -W -Wall -MMD \
		   -Wno-sign-compare \
		   -std=$(CC_STD)

CXXFLAGS = \
		   $(CPU_OPT) $(ARCH_OPT) $(OPTIMIZE) \
		   -W -Wall -MMD \
		   -Wno-sign-compare \
		   -fpermissive \
		   -std=$(CXX_STD)

LDFLAGS  = \
		   $(CPU_OPT) $(ARCH_OPT) \
		   $(LDFILE_OPT) \
		   $(MAP_OPT)

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
MAP = $(OUT_DIR)/$(TARGET).map
BIN = $(OUT_DIR)/$(TARGET).bin
HEX = $(OUT_DIR)/$(TARGET).hex
DL  = $(TAR_DIR)/$(TARGET).$(DL_EXT)

OUTPUT = $(ELF) $(MAP) $(BIN) $(HEX) $(DL)

################################################################################
# source & output
################################################################################
# LDFILE  := $(TARGET).ld

SRC_ROOTS := .\

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

OUTPUT  += $(OBJS) $(DEPS)
# OUTDIRS = $(sort $(dir $(OUTPUT)))

################################################################################
# post-processing
################################################################################
include $(call rwildcard,.,*.mk)

LD := $(if $(strip $(CXXSRCS)),$(CXX),$(CC))

LDFILE_OPT = $(if $(LDFILE),-T$(LDFILE),)
CPU_OPT    = $(if $(CPU),-mcpu=$(CPU),)
ARCH_OPT   = $(if $(ARCH),-arch $(ARCH),)

ifneq (,$(findstring clang,$(CC_VERSION)))  # use ifneq to prevent double typing of finding word
	MAP_OPT := -Wl,-map,$(MAP)
else ifneq (,$(findstring gcc,$(CC_VERSION)))
	MAP_OPT := -Wl,-Map=$(MAP)
else
	MAP_OPT :=\
	$(warning undefined compiler: $(CC))
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
PHONY := all build clean run show test

all: build

build: $(ELF) #$(BIN) $(HEX)
	@$(ECHO) "build complete\n"
	$V $(SIZE) $<
	@$(ECHO) "------------------------------------------------------------------\n"

clean:
	@$(ECHO) cleaning
	$V $(RM) $(OUTPUT)

run:
	@$(ECHO) "run $(notdir $(ELF))\n"
	@$(ELF)

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

test:
	@$(ECHO) $(TEST)
	@$(ECHO) "$(CC_VERSION)"

dl: $(DL)
	@$(ECHO) "complete\n"

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

PHONY += cdb
cdb:
	@echo generate compilation database as compile_commands.json
	@bear -- make clean all
# @compiledb make clean all


$(BIN): $(ELF)
	@$(ECHO) "converting format $(<F) to $(@F)"
	@$(MKDIR) $(@D)
	$V $(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@$(ECHO) "converting format $(<F) to $(@F)"
	@$(MKDIR) $(@D)
	$V $(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJS) $(LDFILE)
	@$(ECHO) "linking $(@F)"
	@$(MKDIR) $(@D)
	$V $(LD) -o $@ $(OBJS) $(LIB_DIRS) $(LIBS) $(LDFLAGS)

$(DL): $(OBJS)
	@$(ECHO) "making dynamic library"
	@$(MKDIR) $(@D)
	$V $(LD) -o $@ $(OBJS) $(LIB_DIRS) $(LIBS) $(LDFLAGS) -shared

$(COBJS): $(OUT_DIR)/%.o: %.c
	@$(ECHO) "compiling $(<F)"
	@$(MKDIR) $(@D)
	$V $(CC) -o $@ -c $< $(INC_DIRS) $(CFLAGS)

$(CXXOBJS): $(OUT_DIR)/%.o: %.cpp
	@$(ECHO) "compiling $(<F)"
	@$(MKDIR) $(@D)
	$V $(CXX) -o $@ -c $< $(INC_DIRS) $(CXXFLAGS)

.PHONY: $(PHONY)

