# os-from-scratch

## Description

This project is implementation of Operating System for x86 from scratch.

## Compilation

Required dependencies: nasm, CMake, (ninja)

```
$ git clone https://github.com/drop-stones/os-from-scrach.git
$ cd os-from-scratch
$ mkdir build
$ cd build
$ cmake -G Ninja .
$ ninja
```

## Usage

### Run OS

Required dependencies: qemu-system-x86_64
```
$ ninja qemu
```

## Features

- [x] Bootloader
- [x] Switch to 32-bit protected mode
- [ ] Linker
- [ ] C Runtime