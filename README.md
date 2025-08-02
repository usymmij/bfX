# bfX

an 8-bit CISC microarch that uses brainf*ck as the core of the instruction set

## ISA

| opcode   | instruction | description                    |
|----------|-------------|--------------------------------|
| xxxx0000 | >           | increment data pointer         |
| xxxx0001 | <           | decrement data pointer         |
| xxxx0010 | +           | increment byte at data pointer |
| xxxx0011 | -           | decrement byte at data pointer |
| xxxx0100 | .           | output byte to bus             |
| xxxx0101 | ,           | input byte to bus              |
| xxxx1000 | {           | loop forward until }           |
| xxxx1001 | }           | loop backward until {          |
| 11111111 |             | end of code (HALT)             |
> the `{` and `}` instructions force the ISA to become CISC since it must loop 

## Memory

512B memory, which is shared by both instructions and data

The PC starts at address 0, and the BF data pointer is initialized to byte 256
> The code can modify itself by subtracting the data pointer far enough

## checklist

| status | opcode   | instruction | description                      |
|--------|----------|-------------|----------------------------------|
| x      | xxxx0000 | >           | increment data pointer           |
| x      | xxxx0001 | <           | decrement data pointer           |
| x      | xxxx0010 | +           | increment byte at data pointer   |
| x      | xxxx0011 | -           | decrement byte at data pointer   |
| x      | xxxx0100 | .           | output byte to bus               |
| x      | xxxx0101 | ,           | input byte to bus                |
| x      | xxxx1000 | {           | loop forward until }             |
| x      | xxxx1001 | }           | loop backward until {            |
|        | 11111111 |             | end of code (HALT)               |
|        | xxxxyyyy |             | repeat the y instruction x times |


