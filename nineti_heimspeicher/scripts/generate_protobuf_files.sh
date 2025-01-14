#!/bin/bash

PROTO_INPUT_DIR="$(realpath $1)"

# cd to script's directory
cd "$(dirname "$0")"

# Generate the gRPC code using the protoc command
protoc -I "$PROTO_INPUT_DIR"  $PROTO_INPUT_DIR/* --dart_out=../lib/src/model/protobuf
