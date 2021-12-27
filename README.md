### example call

```
#!/bin/sh
float2integer 4.035
4035
```

### our handcrafted testsuite

```
$ ./float2integer.sh

input: <empty> => -1
input: .0091234234 => 9
input: 0 => 0
input: 0.0 => 0
input: 0.1 => 100
input: 0.01 => 10
input: 0.001 => 1
input: 0.0001 => 0
input: 0.035267 => 35
input: 4.100820 => 4100
input: 35.0001234234 => 35000
input: 35.0091234234 => 35009
input: 35.1 => 35100
input: 35.12 => 35120
input: 35.02 => 35020
input: 0043.43 => 43430
input: 42 => 42000
```

### a handy (but correct) oneliner in 183 bytes madness

```
x(){ local o r f=${1%.*};r=${1#*.};case ${#r} in 0|3);;1)r=${r}00;;2)r=${r}0;;*)r=${r%${r#???}};esac;o=${f}$r;while case $o in 0[0-9]*):;;*)false;esac;do o=${o#?};done;echo ${o:--1};}
x 4.1
4100
```
