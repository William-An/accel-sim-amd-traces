#!/usr/bin/env bash
# Postprocessing and zipping AMD GCN3 traces

already_done() { 
  local elapsed=${1}
  local done=0
  while [ "$done" -lt "$elapsed" ]; do
    printf "▇"; 
    done=$(($done + 1))
  done 
}
remaining() { 
  local elapsed=${1}
  local duration=${2}
  while [ "$elapsed" -lt "$duration" ]; do
    printf " "; 
    elapsed=$(($elapsed + 1))
  done 
}
percentage() { 
  local elapsed=${1}
  local duration=${2}
  printf "| %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); 
}
clean_line() { 
  printf "\r";
  printf "%-100s" " "
  printf "\r"; 
}

tracesDir=$1
if [[ -z $tracesDir ]]; then
	echo "Please enter a trace folder as an argument"
	exit
fi

cp -r $tracesDir/* .
postProcessor=./bin/post-traces-processing

rm ./traces.log 2> /dev/null
rm ./traces.err 2> /dev/null

# Loop through each benchmark trace folder
traceDirs=*/
numTraceDirs=$((`echo $traceDirs | wc -w` - 1))
curr=0
for traceDir in $traceDirs; do
	if [[ "$traceDir" == "bin" ]]; then
		continue;
	fi

	traceName=${traceDir%/}

	# Progress bar
	curr=$((curr + 1))
	already_done $curr
	remaining $curr $numTraceDirs
	percentage $curr $numTraceDirs
	echo -ne " Post-processing and zipping $traceName"

	# Postprocessing trace
	cd $traceDir
	../$postProcessor ./kernelslist 2>> ../traces.err >> ../traces.log 
	cd ..

	# Zipping folder
	zip "$traceName.zip" $traceName/*.traceg $traceName/*.g 2>> ./traces.err >> ./traces.log
	
	# Clear line
	clean_line
done
