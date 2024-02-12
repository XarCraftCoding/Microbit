# Microbit 2.0

This repository contains the source code of Microbit 2.0.

## Building & Running

First, you will have to install **bochs** and **fasm**. Then run these commands:
```bash
cd src
fasm bootSect.asm
bochs
```
These commands should work in both Linux and Windows.