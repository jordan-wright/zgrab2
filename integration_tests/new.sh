#!/usr/bin/env bash

# Utility script for scaffolding stub test files for a new protocol

# Run from root of project
TEST_DIR=$(dirname "$0")
cd "$TEST_DIR/.."

if [ "$#" -ne 1 ]
then
  echo "Usage: ./integration_tests/new.sh <new_protocol_name>"
  exit 1
fi

module_name="$1"
module_path="integration_tests/$module_name"

mkdir -p $module_path

cat << EOF > $module_path/setup.sh
#!/usr/bin/env bash

echo "$module_name/setup: Tests setup for $module_name"
EOF
chmod +x $module_path/setup.sh

cat << EOF > $module_path/test.sh
#!/usr/bin/env bash

set -e
MODULE_DIR=\$(dirname \$0)
TEST_ROOT=\$MODULE_DIR/..
ZGRAB_ROOT=\$MODULE_DIR/../..
ZGRAB_OUTPUT=\$ZGRAB_ROOT/zgrab-output

mkdir -p \$ZGRAB_OUTPUT/$module_name

# OUTPUT_FILE=[TODO].json

echo "$module_name/test: Tests runner for $module_name"
# CONTAINER_NAME=[TODO] \$ZGRAB_ROOT/docker-runner/docker-run.sh $module_name > \$OUTPUT_FILE

EOF
chmod +x $module_path/test.sh

cat << EOF > $module_path/cleanup.sh
#!/usr/bin/env bash

set +e

echo "$module_name/cleanup: Tests cleanup for $module_name"
EOF
chmod +x $module_path/cleanup.sh

cat << EOF > schemas/$module_name.py
# zschema sub-schema for zgrab2's $module_name module
# Registers zgrab2-$module_name globally, and $module_name with the main zgrab2 schema.
from zschema.leaves import *
from zschema.compounds import *
import zschema.registry

import schemas.zcrypto as zcrypto
import schemas.zgrab2 as zgrab2

${module_name}_scan_response = SubRecord({
    "result": SubRecord({
        # TODO FIXME IMPLEMENT SCHEMA
    })
}, extends = zgrab2.base_scan_response)

zschema.registry.register_schema("zgrab2-${module_name}", ${module_name}_scan_response)

zgrab2.register_scan_response_type("${module_name}", ${module_name}_scan_response)
EOF

echo "import schemas.$module_name" >> schemas/__init__.py

echo "Test files scaffolded in $module_path"
