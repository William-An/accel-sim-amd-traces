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
	echo "Rsync will be used to copy the content of the trace folder into the local ./traces folder"
	exit
fi

if [[ ! -e "./traces" ]]; then
	mkdir traces
fi

rsync -avz $tracesDir/ ./traces
postProcessor=$(readlink -f ./bin/post-traces-processing)

# Loop through each benchmark trace folder
cd ./traces
traceDirs=*/
numTraceDirs=$((`echo $traceDirs | wc -w`))
curr=0
for traceDir in $traceDirs; do
	# if [[ "$traceDir" == "bin" ]]; then
	#	continue;
	# fi

	traceName=${traceDir%/}

	# Progress bar
	curr=$((curr + 1))
	already_done $curr
	remaining $curr $numTraceDirs
	percentage $curr $numTraceDirs
	echo -ne " Post-processing and zipping $traceName "

	# Postprocessing trace
	cd $traceDir
	$postProcessor ./kernelslist
	# remove raw traces
	echo "Removing raw traces for $traceName "
	rm *.trace
	rm kernelslist
	cd ..

	# Zipping folder
	zip "$traceName.zip" $traceName/*.traceg $traceName/*.g
	
	# Clear line
	clean_line
done
