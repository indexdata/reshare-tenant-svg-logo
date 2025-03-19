#!/usr/bin/env bash

# Generate a basic ReShare tenant logo as SVG.
#
# Typical invocation:
# reshare-tenant-svg-logo.sh -1 "My Beaut Library Name" \
#   -2 "US-TEST-P" > output.svg

function show_usage {
  cat << EOU
Usage: ${0##*/} [-hb:p:1:2:3:4:5:]
Generate a ReShare tenant logo as SVG.

There are lines of centered text.
Line 1 is mandatory for the tenant name.
Line 2 to line 5 are optional for a longer tenant name.
Typically use the final line for the ISIL code.
Each text piece must not be longer than 40 characters.
The lines must be sequential.

Required:
  -1   <text> The text for line 1 (if spaces then enclosed in quotes).

Optional:
  -h   Display this help, and exit.
  -b   <filename> The base SVG file with placeholders.
       Default: ./reshare-tenant-svg-logo.svg
  -p   <color> The text colour
       Default is reshare-grey, else black, red, etc.
  -2   <text> The text for line 2 (if spaces then enclosed in quotes).
  -3   <text> The text for line 3 (if spaces then enclosed in quotes).
  -4   <text> The text for line 4 (if spaces then enclosed in quotes).
  -5   <text> The text for line 5 (if spaces then enclosed in quotes).

EOU
}
max_width=40

# Defaults:
text_color="rgb(90,80,120,100%)"  # reshare-grey
text_2=""
text_3=""
text_4=""
text_5=""

script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)
base_svg_fn="${script_dir}/reshare-tenant-svg-logo.svg"
while getopts :hb:p:1:2:3:4:5: opt; do
  case $opt in
    h)
      show_usage
      exit 0
      ;;
    b)
      base_svg_fn=$OPTARG
      ;;
    p)
      color=$OPTARG
      ;;
    1)
      text_1=$OPTARG
      ;;
    2)
      text_2=$OPTARG
      ;;
    3)
      text_3=$OPTARG
      ;;
    4)
      text_4=$OPTARG
      ;;
    5)
      text_5=$OPTARG
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
if ! [ -e "${base_svg_fn}" ]; then
  echo "ERROR: Base SVG file '${base_svg_fn}' not found." >&2
  config_okay=false
fi
if [ -z "${text_1}" ]; then
  echo "ERROR: Missing required option -1 text (first line)." >&2
  config_okay=false
fi
if [ "${#text_1}" -gt ${max_width} ]; then
  echo "ERROR: The -1 text (first line) must be less than ${max_width} characters." >&2
  config_okay=false
fi
if [ "${#text_2}" -gt ${max_width} ]; then
  echo "ERROR: The -2 text (second line) must be less than ${max_width} characters." >&2
  config_okay=false
fi
if [ "${#text_3}" -gt ${max_width} ]; then
  echo "ERROR: The -3 text (third line) must be less than ${max_width} characters." >&2
  config_okay=false
fi
if [ "${#text_4}" -gt ${max_width} ]; then
  echo "ERROR: The -4 text (fourth line) must be less than ${max_width} characters." >&2
  config_okay=false
fi
if [ "${#text_5}" -gt ${max_width} ]; then
  echo "ERROR: The -5 text (fifth line) must be less than ${max_width} characters." >&2
  config_okay=false
fi
row_list="1"
for i in {2..5}; do
  var="text_${i}"
  if [ -z "${!var}" ]; then
    row_list="${row_list},"
  else
    row_list="${row_list},${i}"
  fi
done
trimmed_row_list=$(echo "${row_list}" | sed -E 's/,+$//')
if [[ "${trimmed_row_list}" =~ ,, ]]; then
  echo "ERROR: Text lines must be sequential: ${trimmed_row_list}" >&2
  config_okay=false
fi
if [ -n "${color}" ]; then
  text_color="${color}"
fi
if ! $config_okay; then
  show_usage >&2
  exit 2
fi

temp_1_pn=$(mktemp)
sed_cmd="s/placeholder_color/${text_color}/g;s/placeholder_1/${text_1}/"
svg_height_orig=330
svg_height_new="${svg_height_orig}"

for i in {2..5}; do
  var_text="text_${i}"
  var_placeholder="placeholder_${i}"
  if [ -z "${!var_text}" ]; then
    sed_cmd="${sed_cmd};/placeholder_${i}/d"
    svg_height_new=$((svg_height_new - 40))
  else
    sed_cmd="${sed_cmd};s/placeholder_${i}/${!var_text}/"
  fi
done

sed_cmd="${sed_cmd};s/ ${svg_height_orig}\"/ ${svg_height_new}\"/"
sed "${sed_cmd}" "${base_svg_fn}" > "${temp_1_pn}"

cat "${temp_1_pn}"
rm -f "${temp_1_pn}"
