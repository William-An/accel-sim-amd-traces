# Accel-Sim AMD traces

This is a repository hosting the AMD GCN3 traces from [a modified MGPUSim simulator](https://github.com/William-An/MGPUSim-Accel-Sim) in [Accel-Sim](https://github.com/accel-sim/accel-sim-framework/tree/release) format for trace consumption consumption, enabling trace-driven simulation for AMD GCN3 GPU.

## Usage

To use the trace processing and zipping scripts:

```bash
# The script will sync the traces from the traces folder into `./traces`
# then it will enter each folder inside it for post-processing and zipping
# Note the raw traces will be removed
./process_traces.sh "TRACES FOLDER"
```

## TODO

1. Add flags parser
	1. `-k`: keep original trace files
	2. `-t`: traces directory
	3. `-z`: zip the traces
