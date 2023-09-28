#!/usr/bin/zsh

while getopts "i:o:" arg
do
  case "$arg" in
    i) input=$OPTARG ;;
    o) output=$OPTARG ;;
  esac
done

if [[ -z $input ]] || [ -z $output ]; then
  echo "Incorrect arguments"
  exit 1
fi

rm -rf "$output"

if [[ $DEPLOYMENT_POSTPROCESSING == "YES" ]]; then
  mkdir "$output"

  if [[ ${output##*.} == "xcassets" ]]; then
    cp "$input/Contents.json" "$output/Contents.json"
  fi
else
  cp -R "$input" "$output"
fi
