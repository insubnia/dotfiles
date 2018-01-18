# SIS MAKEFILE
TARGET	= $(notdir $(CURDIR))
PHONY	= 

CROSS	= # i686-w64-mingw32-
CC		= $(CROSS)gcc
CXX		= $(CROSS)g++
LD		= $(CXX)
#LD		= $(CROSS)ld
SIZE	= $(CROSS)size
OBJCOPY	= $(CROSS)objcopy		# Type "objcopy --help | tail", to find target architecture
OBJDUMP	= $(CROSS)objdump
RM		= rm -f

ELF		= $(TAR_DIR)$(TARGET).elf
BIN		= $(BLD_DIR)$(TARGET).bin
HEX		= $(BLD_DIR)$(TARGET).hex
MAP		= $(BLD_DIR)$(TARGET).map

MCU		=
OPT		= -O2 -g3

SRC_DIR		= src/
INC_DIR		= src/include/
BLD_DIR		= build/
LIB_DIR		= ./
TAR_DIR		= ./
INC_DIR		:= $(addprefix -I, $(INC_DIR))
LIB_DIR		:= $(addprefix -L, $(LIB_DIR))

CFLAGS		= -W -Wall -MMD $(OPT) \
			  -fdiagnostics-color -std=c99
CXXFLAGS	= -W -Wall -MMD $(OPT) \
			  -fdiagnostics-color -fpermissive
# LDFLAGS		= Wl, -Map=$(MAP)
LDFLAGS		+= -fdiagnostics-color

CSRCS	= $(wildcard $(SRC_DIR)*.c)
COBJS	= $(patsubst $(SRC_DIR)%.c, $(BLD_DIR)%.o, $(CSRCS))
CXXSRCS	= $(wildcard $(SRC_DIR)*.cpp)
CXXOBJS	= $(patsubst $(SRC_DIR)%.cpp, $(BLD_DIR)%.o, $(CXXSRCS))
OBJS	= $(COBJS) $(CXXOBJS)
DEPS	= $(OBJS:.o=*.d)

include $(wildcard *.mk)

PHONY += all
all: $(ELF) $(BIN) $(HEX)
	@echo Size of image
	@$(SIZE) $<
	@echo MAKE COMPLETE!!; echo

PHONY += clean
clean:
	@echo Removing files
	@$(RM) $(ELF) $(BIN) $(HEX) $(OBJS) $(DEPS) $(MAP)

PHONY += run
run:
	@echo Run $(notdir $(ELF)); echo
	@$(ELF)

PHONY += test
test:
	@echo $(PHONY)
	@echo $(CXXFLAGS)
	@echo $(LDFLAGS)

$(BIN): $(ELF)
	@echo Making Binary from $(<F)
	@$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@echo Making Intel hex from $(<F)
	@$(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJS)
	@mkdir -p $(TAR_DIR)
	@echo Linking $(@F)
	@$(LD) -o $@ $^ $(LDFLAGS) $(LIB_DIR)

$(COBJS): $(BLD_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(BLD_DIR)
	@echo Compiling $(<F)
	@$(CC) -o $@ -c $< $(CFLAGS) $(INC_DIR)

$(CXXOBJS): $(BLD_DIR)%.o: $(SRC_DIR)%.cpp
	@mkdir -p $(BLD_DIR)
	@echo Compiling $(<F)
	@$(CXX) -o $@ -c $< $(CXXFLAGS) $(INC_DIR)

.PHONY: $(PHONY)

