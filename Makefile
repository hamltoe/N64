# Makefile for n64-mygame
TARGET = mygame
BUILD = build
SRC = src
INC = include

LIBDRAGON := extern/libdragon
TINY3D := extern/tiny3d

N64_INST ?= /usr/local
CC = mips64-elf-gcc

CFLAGS = -Wall -O2 -G0 -mabi=32 -march=vr4300 -mtune=vr4300
CFLAGS += -I$(LIBDRAGON)/include -I$(INC)
CFLAGS += -I$(TINY3D)/include -I$(TINY3D)/src

LDFLAGS = -L$(LIBDRAGON)/lib -ldragon -lm
LDFLAGS += $(TINY3D)/libtiny3d.a  # if you're building Tiny3D as a static lib

SRCS := $(shell find $(SRC) -name '*.c')
OBJS := $(SRCS:%.c=$(BUILD)/%.o)

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/$(TARGET).elf: $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(BUILD)/$(TARGET).n64: $(BUILD)/$(TARGET).elf
	n64tool -l 0x80010000 -o $@ -t "MY GAME" $<
	chksum64 $@

all: $(BUILD)/$(TARGET).n64

clean:
	rm -rf $(BUILD)
