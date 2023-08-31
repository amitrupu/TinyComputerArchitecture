// opcodes
`define nop 0
`define mova 1
`define movb 2
`define movam 3
`define movbm 4
`define movm 5
`define add 6
`define sub 7
`define mult 8
`define div 9
`define halt 10

// states
`define init 0
`define fetch_decode 1
`define move_data 2
`define move_from_mem 3
`define move_to_mem 4
`define stop 5
