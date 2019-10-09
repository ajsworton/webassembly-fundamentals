# Requirements

## Web Assembly tools

### Arch / Manjaro
`sudo pacman -S wabt`
`sudo pacman -S python3` (optional)

### Other
Follow instructions at https://github.com/WebAssembly/wabt

## To build
From the root, compile the wat to wasm using the wat2wasm tool

`wat2wasm src/checkers.wat -o out/checkers.wasm`

you can inspect the binary using

`wasm-objdump -x out/checkers.wasm`
