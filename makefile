# omni makefile

TARGET	= $(notdir $(CURDIR))

# Type "objcopy --help | tail, to show available architecture"
ARCH	= native
CROSS	= # i686-w64-mingw32-

CC		= $(CROSS)gcc
CXX		= $(CROSS)g++
# LD		= $(CROSS)ld
LD		= $(CXX)
SIZE	= $(CROSS)size
OBJCOPY	= $(CROSS)objcopy
OBJDUMP	= $(CROSS)objdump

ifeq ($(OS),Windows_NT)
	RM = del /Q /F
	MKDIR := md
else
	RM = rm -f
	MKDIR := mkdir -p
endif

ELF	= $(TAR_DIR)/$(TARGET).elf
BIN	= $(BLD_DIR)/$(TARGET).bin
HEX	= $(BLD_DIR)/$(TARGET).hex
MAP	= $(BLD_DIR)/$(TARGET).map
ifeq ($(OS),Windows_NT)
	SO = $(TAR_DIR)/$(TARGET).dll
else
	SO = $(TAR_DIR)/$(TARGET).so
endif

OUTPUT = $(ELF) $(BIN) $(HEX) $(MAP) $(SO)

OPT	= -O2 -g3

CFLAGS   = -march=$(ARCH) -W -Wall -MMD $(OPT) -std=c99
CXXFLAGS = -march=$(ARCH) -W -Wall -MMD $(OPT) -fpermissive
# LDFLAGS  = -v
LDFLAGS  = -Wl,-map,$(MAP)

SRCROOT = .
OBJROOT = debug

INCDIRS = include
LIBDIRS = .
BLD_DIR = build
TAR_DIR = .

ifeq ($(OS),Windows_NT)
	LIBS =
else
	LIBS = ncurses
endif


include $(wildcard *.mk)

ifeq ($(OS),Windows_NT)
	SUBDIRS := $(dir $(wildcard $(SRCROOT)/*/.)) $(SRCROOT)/
	CSRCS   := $(wildcard $(addsuffix *.c, $(SUBDIRS)))
	CXXSRCS := $(wildcard $(addsuffix *.cpp, $(SUBDIRS)))
else
	CSRCS   := $(shell find $(SRCROOT) -name "*.c" -not -path "./.*")
	CXXSRCS := $(shell find $(SRCROOT) -name "*.cpp" -not -path "./.*")
endif
COBJS   := $(CSRCS:$(SRCROOT)/%.c=$(OBJROOT)/%.o)
CXXOBJS := $(CXXSRCS:$(SRCROOT)/%.cpp=$(OBJROOT)/%.o)
OBJS    := $(COBJS) $(CXXOBJS)
DEPS    := $(OBJS:.o=.d)

OUTPUT += $(OBJS) $(DEPS)

TREE := $(sort $(dir $(OUTPUT)))

ifeq ($(OS),Windows_NT)
	OUTPUT := $(subst /,\,$(OUTPUT))
	TREE := $(subst /,\\,$(TREE))
endif

-include $(DEPS)

INCDIRS	:= $(addprefix -I, $(INCDIRS))
LIBDIRS	:= $(addprefix -L, $(LIBDIRS))
LIBS	:= $(addprefix -l, $(LIBS))

PHONY += all
all: $(ELF) #$(BIN) $(HEX)
	@echo Size of image
	@$(SIZE) $<
	@echo MAKE COMPLETE!!; echo

PHONY += clean
clean:
	@echo Removing Files
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

PHONY += test
test:
	@echo $(TREE)
	@echo $(CSRCS)


$(BIN): $(ELF)
	@echo Making Binary from $(<F)
	@$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@echo Making Intel hex from $(<F)
	@$(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJS)
	@$(MKDIR) $(TAR_DIR)
	@echo Linking $(@F)
	@$(LD) -o $@ $^ $(LIBDIRS) $(LIBS) $(LDFLAGS)

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
