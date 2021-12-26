### example call

```
#!/bin/sh
float2integer 4.035
4035
```

### our handcrafted testsuite

```
user@box:~/software/shell-posix-float2integer$ . float2integer.sh

 =>  => front:  rest:  1stOUT:  => -1
.0091234234 => .0091234234 => front:  rest: 009 1stOUT: 009 => 9
0 => 0 => front: 0 rest: 000 1stOUT: 0000 => 0
0.0 => 0.0 => front: 0 rest: 000 1stOUT: 0000 => 0
0.1 => 0.1 => front: 0 rest: 100 1stOUT: 0100 => 100
0.01 => 0.01 => front: 0 rest: 010 1stOUT: 0010 => 10
0.001 => 0.001 => front: 0 rest: 001 1stOUT: 0001 => 1
0.035267 => 0.035267 => front: 0 rest: 035 1stOUT: 0035 => 35
4.100820 => 4.100820 => front: 4 rest: 100 1stOUT: 4100 => 4100
35.0001234234 => 35.0001234234 => front: 35 rest: 000 1stOUT: 35000 => 35000
35.0091234234 => 35.0091234234 => front: 35 rest: 009 1stOUT: 35009 => 35009
35.1 => 35.1 => front: 35 rest: 100 1stOUT: 35100 => 35100
35.12 => 35.12 => front: 35 rest: 120 1stOUT: 35120 => 35120
35.02 => 35.02 => front: 35 rest: 020 1stOUT: 35020 => 35020
```

### a handy oneliner

see file `f2i`

```
x(){ local o f r;f=${1%.*};r=${1#*.};case ${#r} in 0|3);;1)r=${r}00;;2)r=${r}0;;*)r=${r%${r#???}};;esac;o=${f}$r;while case $o in 0[0-9]*):;;*)false;;esac;do o=${o#?};done;echo ${o:--1};}
x 4.1
4100
```
