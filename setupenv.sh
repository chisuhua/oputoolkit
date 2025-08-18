SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null && pwd)
export OPUTOOL_BUILD=$SCRIPT_DIR/build
export OPUTOOL_DIR=$SCRIPT_DIR
export OPUARCH_ROOT=$SCRIPT_DIR/opuarch
export ANTLR_JAR_PATH=$OPUTOOL_DIR/3rdparty/antlr4/antlr-4.13.2-complete.jar
export ANTLR_RUNTIME_DIR=$OPUTTOOL_BUILD/include/antlr4-runtime
