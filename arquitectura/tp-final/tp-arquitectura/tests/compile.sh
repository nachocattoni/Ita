gcc ../*.c -o ../pilot-compiler
../pilot-compiler < $1 > arm.s
arm-linux-gnueabi-gcc -static arm.s
qemu-arm a.out
