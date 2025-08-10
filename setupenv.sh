SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null && pwd)
export OPUAS_TOOL_BUILD=$SCRIPT_DIR/build
export OPUAS_TOOL_DIR=$SCRIPT_DIR
export ANTLR_JAR_PATH=$OPUAS_TOOL_DIR/3rdparty/antlr4/antlr-4.13.2-complete.jar
