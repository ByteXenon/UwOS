all: boot.iso

boot.iso: src/boot.asm
	nasm -o boot.iso src/boot.asm

# Limit the resources to avoid overloading the host VM
run: boot.iso
	qemu-system-x86_64 -smp 1 -m 1M -drive format=raw,file=boot.iso 

clean:
	rm -f boot.iso