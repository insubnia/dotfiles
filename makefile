# Author: sis
# general makefile

TARGET	= $(notdir $(CURDIR))

ARCH	=
CROSS	= # i686-w64-mingw32-

CC		= $(CROSS)gcc
CXX		= $(CROSS)g++
LD		= $(CXX)
# LD		= $(CROSS)ld
SIZE	= $(CROSS)size
OBJCOPY	= $(CROSS)objcopy		# Type "objcopy --help | tail", to find target architecture
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

OPT	= -O2 -g3

CFLAGS	= -W -Wall -MMD $(OPT) -std=c99
CXXFLAGS= -W -Wall -MMD $(OPT) -fpermissive
# LDFLAGS	= -v

SRC_DIR	= src/
INC_DIR	= src/include/
BLD_DIR	= build/
TAR_DIR	= ./
LIB_DIR	= ./
LIBS	=

include $(wildcard *.mk)

CSRCS	= $(wildcard $(SRC_DIR)*.c)
COBJS	= $(patsubst $(SRC_DIR)%.c, $(BLD_DIR)%.o, $(CSRCS))
CXXSRCS	= $(wildcard $(SRC_DIR)*.cpp)
CXXOBJS	= $(patsubst $(SRC_DIR)%.cpp, $(BLD_DIR)%.o, $(CXXSRCS))
OBJS	= $(COBJS) $(CXXOBJS)
DEPS	= $(OBJS:.o=*.d)

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
	@$(RM) $(ELF) $(BIN) $(HEX) $(OBJS) $(DEPS) $(MAP) $(SO)

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

