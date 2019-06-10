#!/bin/bash
# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/ for explanation of below
set -euo pipefail
test_type=$1
test_name=$2
test_prefix="test/test_${test_type}/test_${test_name}"
wdl_path=${test_prefix}.wdl
cromwell_version=36
# Check that wdl exists
if [ ! -f "${wdl_path}" ]; then
    echo "Test wdl ${wdl_path} not found!"
    exit 1
fi
# Validate the wdl with womtool, if not bypassing
echo "Validating ${wdl_path} with womtool-${cromwell_version}"
java -jar ~/womtool-${cromwell_version}.jar validate ${wdl_path}
echo "Validation successful, running cromwell"
# Run cromwell
metadata_file=~/test_${test_name}_metadata.json
java -jar -Dconfig.file=backends/backend.conf -Dbackend.default=Local ~/cromwell-${cromwell_version}.jar run ${wdl_path} -i ${test_prefix}.json -m $metadata_file -o workflow_opts/docker.json
echo "output md5sums:"
cat $metadata_file | jq '.outputs | values[]' | xargs -n 1 md5
