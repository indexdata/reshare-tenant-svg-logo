#!/usr/bin/env bash

# Prepare the text of a long library name,
# and call the logo generator script.
#
# Typical invocation:
# reshare-tenant-svg-logo-fold.sh \
#   -t "My Beaut Library Name is Longer Than Short Names" \
#   -c palci -i "US-TEST-P" -p black

function show_usage {
  cat << EOU
Usage: ${0##*/} [-ht:c:i:p:w:d:]
Generate a ReShare tenant logo as SVG.

There are potentially 4 lines of centered text.
This script will fold a long name to occupy the necessary number of lines.

Required:
  -t   <text> The text of the library name (if spaces then enclosed in quotes).
              Must not be longer than 120 characters. Will be truncated.
  -c   <consortium> The consortium name (e.g. trove).
              Will be the stem of the output filename.
  -i   <code> The ISIL or NUC code. Will also be part of the output filename.

Optional:
  -h   Display this help, and exit.
  -p   <color> The text colour.
       Default is reshare-grey, else black, red, etc.
  -w   Width at which to fold the text words into lines.
       Default and maximum 40 characters.
  -d   <directory> The data directory to store the logo.
       Default is current directory.
EOU
}
max_length=120

# Defaults:
width=40
text_color="rgb(90,80,120,100%)"  # reshare-grey
data_dir="."

script_dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)
while getopts :ht:c:i:p:w:d: opt; do
  case $opt in
    h)
      show_usage
      exit 0
      ;;
    t)
      text=$OPTARG
      ;;
    c)
      consortium=$OPTARG
      ;;
    i)
      code=$OPTARG
      ;;
    p)
      color=$OPTARG
      ;;
    w)
      width=$OPTARG
      ;;
    d)
      data_dir=$OPTARG
      ;;
    :)
      echo "ERROR: Option -$OPTARG requires an argument." >&2
      show_usage >&2
      exit 1
      ;;
    \?)
      echo "ERROR: Invalid option: -$OPTARG" >&2
      show_usage >&2
      exit 1
      ;;
    *)
      show_usage >&2
      exit 1
      ;;
  esac
done
config_okay=true
if [ -z "${text}" ]; then
  echo "ERROR: Missing required option -t text." >&2
  config_okay=false
fi
if [ -z "${consortium}" ]; then
  echo "ERROR: Missing required option -c consortium." >&2
  config_okay=false
fi
if [ -z "${code}" ]; then
  echo "ERROR: Missing required option -i ISIL or NUC code." >&2
  config_okay=false
fi
if [ ! -d "${data_dir}" ]; then
  echo "ERROR: Specified data directory -d '${data_dir}' does not exist." >&2
  config_okay=false
fi
if [ -n "${text}" ]; then
  text=$(echo "${text}" | sed 's|&|and|g')
fi
if [ -n "${text}" ] && [ ${#text} -gt $max_length ]; then
  echo "WARNING: The option -t text length (${#text}) must not be greater than $max_length. Truncated." >&2
fi
if [ -n "${color}" ]; then
  text_color="${color}"
fi
if ! $config_okay; then
  show_usage >&2
  exit 2
fi

if [ "${consortium}" == "trove" ]; then
  logo_fn="${script_dir}/reshare-tenant-svg-logo-trove.svg"
else
  logo_fn="${script_dir}/reshare-tenant-svg-logo.svg"
fi
output_fn=$(echo "${data_dir}/${consortium}-${code,,}.svg" | sed "s/://g")

readarray -t lines < <(echo "${text}" | fold -s -w "$width" | sed 's/[[:space:]]$//g')
# declare -p lines >&2

if [ ${#lines[@]} -ge 4 ]; then
  # echo "4 lines: ${#text}"
  "${script_dir}/reshare-tenant-svg-logo.sh" -p "${text_color}" -b "${logo_fn}" \
    -1 "${lines[0]}" -2 "${lines[1]}" -3 "${lines[2]}" -4 "${lines[3]}" \
    -5 "${code}" > "${output_fn}"
elif [ ${#lines[@]} -eq 3 ]; then
  # echo "3 lines: ${#text}"
  "${script_dir}/reshare-tenant-svg-logo.sh" -p "${text_color}" -b "${logo_fn}" \
    -1 "${lines[0]}" -2 "${lines[1]}" -3 "${lines[2]}" \
    -4 "${code}" > "${output_fn}"
elif [ ${#lines[@]} -eq 2 ]; then
  # echo "2 lines: ${#text}"
  "${script_dir}/reshare-tenant-svg-logo.sh" -p "${text_color}" -b "${logo_fn}" \
    -1 "${lines[0]}" -2 "${lines[1]}" \
    -3 "${code}" > "${output_fn}"
else
  # echo "1 lines: ${#text}"
  "${script_dir}/reshare-tenant-svg-logo.sh" -p "${text_color}" -b "${logo_fn}" \
    -1 "${lines[0]}" \
    -2 "${code}" > "${output_fn}"
fi
