#!/bin/sh
#
# convert a time in seconds (e.g. 3.234) to an integer for milliseconds (e.g. 3234)
# this works in every POSIX shell without external commands (e.g. bc/awk)

float2integer()
{
  local float="$1"                      # e.g. 0.035267
  local out front rest

  front="${float%.*}"                   # value before comma
  rest="${float#*.}"                    # value after comma

  case "$float" in
    '') ;;
   *.*) ;;
     *) rest=000 ;;			# input has no dot, but integer
  esac

  # make sure we have exact 3 digits, e.g. 518666 => 518 or 1 => 100
  case "${#rest}" in
    0) ;;
    1) rest="${rest}00" ;;
    2) rest="${rest}0" ;;
    3) ;;
    *) rest="${rest%"${rest#???}"}" ;;  # remove overlong tail, keep 3 chars
  esac

  out="${front}${rest}"                 # 3.234 => 3234

  has_leading_zeroes()
  {
    case "$1" in 0[0-9]*) true ;; *) false ;; esac
  }

  while has_leading_zeroes "$out"; do
    out=${out#?}  # remove first char
  done

  printf '%s\n' "${out:--1}"
}

# functionally the same as above, but in a handy (216 bytes) oneliner format:
x(){ local o r f=${1%.*};r=${1#*.};case $1 in ''|*.*);;*)r=000;esac;case ${#r} in 1)r=${r}00;;2)r=${r}0;;0|3);;*)r=${r%${r#???}};esac;o=${f}$r;while case $o in 0[0-9]*):;;*)false;esac;do o=${o#?};done;echo ${o:--1};}

# functionally the same as above, but does not accept plain integers as input (183 bytes):
y(){ local o r f=${1%.*};r=${1#*.};case ${#r} in 0|3);;1)r=${r}00;;2)r=${r}0;;*)r=${r%${r#???}};esac;o=${f}$r;while case $o in 0[0-9]*):;;*)false;esac;do o=${o#?};done;echo ${o:--1};}

# just for comparing:
use_bc()
{
  echo "( ${1:--0.001} * 1000 / 1 )" | bc
}

f()
{
  local float="$1"
  local f1 o1 o2 ref
  f1="$( float2integer "$1" )"
  o1="$( x "$1" )"
  o2="$( y "$1" )"
  ref="$( use_bc "$1" )"		# reference

  test "$ref" = "$f1" || echo "ERROR with posix-long for $float => $f1"
  test "$ref" = "$o1" || echo "ERROR with oneliner1 for $float => $o1"
  test "$ref" = "$o2" || echo "ERROR with oneliner2 for $float => $o2"

  printf '%s\n' "input: ${float:-<empty>} => $ref"
}

f ""
f .0091234234
f 0
f 0.0
f 0.1
f 0.01
f 0.001
f 0.0001
f 0.035267
f 4.100820
f 35.0001234234
f 35.0091234234
f 35.1
f 35.12
f 35.02
f 0043.43
f 42
