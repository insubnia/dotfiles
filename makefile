# SIS MAKEFILE
CROSS	= 
CC		= $(CROSS)gcc
CXX		= $(CROSS)g++
LD		= $(CXX)
#LD		= $(CROSS)ld

SIZE	= $(CROSS)size
OBJCOPY	= $(CROSS)objcopy
OBJDUMP	= $(CROSS)objdump
RM		= rm -f 

MCU		= 
OPT		= -O2

SRC_DIR		= src/
INC_DIR		= src/include/
BLD_DIR		= build/
LIB_DIR		= ./
TAR_DIR		= ./
INC_DIR		:= $(addprefix -I, $(INC_DIR))
LIB_DIR		:= $(addprefix -L, $(LIB_DIR))

TAR_NAME	= $(notdir $(CURDIR))
TAR_EXT		= #bin exe
ELF			= $(TAR_DIR)$(TAR_NAME).elf
MAP			= $(BLD_DIR)$(TAR_NAME).map

CFLAGS		= -W -Wall -MMD $(OPT) \
			  -fdiagnostics-color -std=c99
CXXFLAGS	= -W -Wall -MMD $(OPT) \
			  -fdiagnostics-color -fpermissive
#LDFLAGS		= Wl, -Map=$(MAP)
LDFLAGS		+= -fdiagnostics-color

TARS	= $(addprefix $(TAR_DIR)$(TAR_NAME)., $(TAR_EXT))
CSRCS	= $(wildcard $(SRC_DIR)*.c)
COBJS	= $(patsubst $(SRC_DIR)%.c, $(BLD_DIR)%.o, $(CSRCS)) 
CXXSRCS	= $(wildcard $(SRC_DIR)*.cpp)
CXXOBJS	= $(patsubst $(SRC_DIR)%.cpp, $(BLD_DIR)%.o, $(CXXSRCS)) 
OBJS	= $(COBJS) $(CXXOBJS)
DEPS	= $(OBJS:.o=*.d)

include $(wildcard *.mk)

.PHONY: all clean test

test:
	@echo $(CXXFLAGS)
	@echo $(LDFLAGS)

all: $(ELF) #$(TARS)
	@echo MAKE COMPLETE!!

$(TARS): $(ELF)
	@echo Making target
	@$(OBJCOPY) -O binary $< $@

$(ELF): $(OBJS)
	@mkdir -p $(TAR_DIR)
	@echo Linking $(@F)
	@$(LD) -o $@ $^ $(LDFLAGS) $(LIB_DIR)
	@echo Size of $(@F)
	@$(SIZE) $@

$(COBJS): $(BLD_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(BLD_DIR)
	@echo Compiling $(<F)
	@$(CC) -o $@ -c $< $(CFLAGS) $(INC_DIR)

$(CXXOBJS): $(BLD_DIR)%.o: $(SRC_DIR)%.cpp
	@mkdir -p $(BLD_DIR)
	@echo Compiling $(<F)
	@$(CXX) -o $@ -c $< $(CXXFLAGS) $(INC_DIR)

clean:
	@echo Removing files
	@$(RM) $(ELF) $(OBJS) $(DEPS) $(TARS) $(MAP)

