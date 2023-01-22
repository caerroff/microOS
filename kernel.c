#include <stdio.h>
/**
 * MICRO OS KERNEL
 * A simple Kernel created for microOS x86
 * It should be able to get you to a CLI interface for now
 * It handles setting up the working environment
*/

/**
 * The main function, entering point of the kernel, called by the bootloader
*/

int main(void){
    printf("Welcome to the kernel\n");
    fprintf(stderr, "ERROR : Test\n");
    return 0;
}