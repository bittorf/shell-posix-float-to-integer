#!/bin/sh
#
# convert a time in seconds (e.g. 3.234) to an integer for milliseconds (e.g. 3234)

float2integer()         # this works in every POSIX shell without external commands (e.g. bc/awk)
{
  local float="$1"      # e.g. 0.035267
  local out front rest

  printf '%s' "$float => "

  front="${float%.*}"                   # value before comma
  rest="${float#*.}"                    # value after comma

  # make sure we have exact 3 digits, e.g. 518666 => 518 or 1 => 100
  case "${#rest}" in
    0) ;;
    1) rest="${rest}00" ;;
    2) rest="${rest}0" ;;
    3) ;;
    *) rest="${rest%"${rest#???}"}" ;;  # remove overlong tail, keep 3 chars
  esac

  out="${front}${rest}"                 # 3.234 => 3234

  printf '%s' "$float => front: $front rest: $rest 1stOUT: $out => "

  has_leading_zeroes()
  {
    case "$1" in 0[0-9]*) true ;; *) false ;; esac
  }

  while has_leading_zeroes "$out"; do {
    out=${out#?}  # strip 1st char
  } done

  printf '%s\n' "${out:--1}"
}

float2integer ""
float2integer .0091234234
float2integer 0
float2integer 0.0
float2integer 0.1
float2integer 0.01
float2integer 0.001
float2integer 0.035267
float2integer 4.100820
float2integer 35.0001234234
float2integer 35.0091234234
float2integer 35.1
float2integer 35.12
float2integer 35.02
