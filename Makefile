# =========================================================
#  KuvixOS-V2 DDK Makefile (Linker Script Çözümü)
# =========================================================

CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -fPIC -nostdlib -ffreestanding -I./include -I../main/include
LDFLAGS = -shared -nostdlib

MOUSE_SRC = samples/ps2_mouse/main.cpp
MOUSE_OUT = samples/ps2_mouse/ps2_mouse.kdf

all: $(MOUSE_OUT)

$(MOUSE_OUT): $(MOUSE_SRC)
	# -T linker.ld ile bağlayıcıya mutlak kuralları dayatıyoruz
	$(CXX) -m32 -ffreestanding -O2 -nostdlib -fno-pie -fno-stack-protector \
		-I./include -I../main/include \
		-T linker.ld \
		-o $@ $<
	@echo "[DDK] Sürücü LINKER SCRIPT ile jilet gibi derlendi: $@"

clean:
	rm -f samples/ps2_mouse/*.kdf

.PHONY: all clean