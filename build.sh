#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null && pwd)
if [ ! -n "$OPUTOOL_BUILD" ]
then 
    source setupenv.sh
fi
BUILD_DIR=$OPUTOOL_BUILD


# dependency record
FORCE=false
TARGET_DIR=".build_targets"  # 存放目标标记文件的目录

mkdir -p "$TARGET_DIR"

#THREADS=$(nproc)

BUILD_OPT=(dbg rel dbgrel clean)
#TGT_LIST=(all yamlcpp antlr4 ptxasm opuas)
TGT_LIST=(all yamlcpp antlr4 opuisa ptxasm ptxas opuas)
OPT=(n)

[ -z "${BUILD_TYPE}" ] && BUILD_TYPE=rel

TGT="all"

function Usage {
    echo "Usage: run_build.sh with one below argument"
    echo "       the argument ${BUILD_OPT[@]}: build option, dbgrel is the default"
    echo "       the argument ${TGT_LIST[@]}: the target will be built, all is default"
    echo "       the argument n: will print the run command but not executed"
    exit
}

BUILD_ARG=
NORUN=n

function is_in_list() {
  local target="$1"
  shift
  local list=("$@")

  for item in "${list[@]}"; do
    if [[ "$item" == "$target" ]]; then
      return 0
    fi
  done

  return 1
}

if [ -z "$1" ]; then
  echo "build all target"
else
  if is_in_list "$1" "${TGT_LIST[@]}"; then
    TGT=$1
    echo "will running target $TGT $BUILD_ARG"
    shift
  fi
fi

for arg in "$@"; do
  if [ "$arg" == "-n" ]; then
    NORUN=y
  elif [ "$arg" == "-force" ]; then
    FORCE=true
  elif echo "${BUILD_OPT[@]}" | grep -wq "$arg"; then
    BUILD_TYPE=$arg
  elif echo "${OPT[@]}" | grep -wq "$arg"; then
    BUILD_ARG+="$arg "
  else
    Usage
  fi
done

function run_cmd {
    echo $1;
    if [ "$NORUN" != "y" ]; then
        eval $1 || { echo "Failed to run $1"; exit 1;}
    fi
}

build() {
    local target=$1
    local target_src=$2
    local target_file="$TARGET_DIR/$target"
    local func="cd $target_src && ./build.sh $BUILD_TYPE && cd -"
    echo "$func"

    if [[ "$FORCE" == true ]]; then
        echo "[FORCE] Running $target..."
        run_cmd "$func"
        mark_done "$target"
        return $?
    fi

    if [[ -f "$target_file" ]]; then
        echo "[SKIP] $target already done."
    else
        echo "[BUILD] Running $target..."
        run_cmd "$func"
        mark_done "$target" || exit 1
    fi
}

mark_done() {
    local target=$1
    touch "$SCRIPT_DIR/$TARGET_DIR/$target"
}


##### yaml-cpp
#YAMLCPP_SRC=${SCRIPT_DIR}/3rdparty/yaml-cpp
#YAMLCPP_BUILD=${BUILD_DIR}/yamlcpp

#function build_yamlcpp {
#   run_cmd "cd $YAMLCPP_SRC"
#   run_cmd "./build.sh"
#}

#function clean_yamlcpp {
#   run_cmd "cd $YAMLCPP_SRC"
#   run_cmd "./build.sh clean"
#}


##### antlr4
#ANTLR4_SRC=${SCRIPT_DIR}/3rdparty/antlr4

#function build_antlr4 {
#    run_cmd "cd $ANTLR4_SRC"
#    run_cmd "./build.sh"
#}

#function clean_antlr4 {
#    run_cmd "cd $ANTLR4_SRC"
#    run_cmd "./build.sh clean"
#}


##### ptxasm
#PTXASM_SRC=${SCRIPT_DIR}/ptxasm
#PTXASM_BUILD=${BUILD_DIR}/ptxasm

#function build_ptxasm {
#    run_cmd "cd $PTXASM_SRC"
#    run_cmd "./build.sh"
#}

#function clean_ptxasm {
#    run_cmd "cd $PTXASM_SRC"
#    run_cmd "./build.sh clean"
#}

##### ptxas
#PTXAS_SRC=${SCRIPT_DIR}/ptxas
#PTXAS_BUILD=${BUILD_DIR}/ptxas

#function build_ptxas {
#    run_cmd "cd $PTXAS_SRC"
#    run_cmd "./build.sh"
#}

#function clean_ptxas {
#    run_cmd "cd $PTXASM_SRC"
#    run_cmd "./build.sh clean"
#}


##### opuas
#OPUAS_SRC=${SCRIPT_DIR}/opuas
#OPUAS_BUILD=${BUILD_DIR}/opuas
#
#function build_opuas {
#    run_cmd "cd $OPUAS_SRC"
#    run_cmd "rm -rf $OPUAS_BUILD; mkdir $OPUAS_BUILD; cd $OPUAS_BUILD; cmake -DCMAKE_INSTALL_PREFIX=$BUILD_DIR $OPUAS_SRC"
#    run_cmd "make"
#    run_cmd "make install"
#}
#
#function clean_opuas {
#    rm -rf ${OPUAS_BUILD}
#    rm -rf "$TARGET_DIR/opuas"
#}



###### main

main() {
    if [[ $TGT == "all" ]]; then
        build antlr4 3rdparty/antlr4
        build yamlcpp  3rdparty/yaml-cpp 
        build opuisa opuisa
        build ptxasm ptxasm
        build ptxas ptxas
        #build opuas opuas
    else
        build $TGT
    fi
}

main "$@"
