# bfX

an 8-bit accumulator CISC microarch that uses brainf*ck as the core of the instruction set

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

## future additions 

| opcode   | instruction | description                      |
|----------|-------------|----------------------------------|
| xxxxyyyy |             | repeat the y instruction x times |


