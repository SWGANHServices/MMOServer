#!/bin/sh

basedir=$(cd $(dirname $0) && pwd)

# build and install boost
cd $basedir/src/boost

if [ ! -f "bjam" ]; then
  echo "Building bjam from source"
  ./bootstrap.sh --with-toolset=gcc
fi

./bjam --toolset=gcc --prefix=$basedir/boost --with-log --with-date_time --with-program_options --with-thread --with-regex --with-system threading=multi variant=debug install
./bjam --toolset=gcc --prefix=$basedir/boost --with-log --with-date_time --with-program_options --with-thread --with-regex --with-system threading=multi variant=release install
cd $basedir

# build and install glm
cd $basedir/src/glm

if [ ! -d "$basedir/src/glm/build" ]; then
    mkdir $basedir/src/glm/build
fi
cd $basedir/src/glm/build

cmake -DCMAKE_INSTALL_PREFIX=$basedir/glm ..
make install
cd $basedir

# build and install glog
cd $basedir/src/gtest

if [ ! -d "$basedir/src/gtest/build" ]; then
    mkdir $basedir/src/gtest/build
fi
cd $basedir/src/gtest/build

../configure --prefix=$basedir/gtest
make install
cd $basedir

# build and install lua
cd $basedir/src/lua
INSTALL_TOP_PREFIX=$basedir/lua make posix
INSTALL_TOP_PREFIX=$basedir/lua make install
cd $basedir

# build and install mysql connector/c
cd $basedir/src/mysql-connector-c

cmake -DCMAKE_INSTALL_PREFIX=$basedir/mysql-connector-c .
make install
cd $basedir

# build and install mysql connector/c++
cd $basedir/src/mysql-connector-cpp

MYSQL_DIR=$basedir/mysql-connector-c cmake -DBOOST_ROOT=$basedir/src/boost -DMYSQL_CONFIG_EXECUTABLE=$basedir/mysql-connector-c/bin/mysql_config -DCMAKE_INSTALL_PREFIX=$basedir/mysql-connector-cpp .
make install
cd $basedir

# build and install noise
cd $basedir/src/noise

if [ ! -d "$basedir/src/noise/build" ]; then
    mkdir $basedir/src/noise/build
fi
cd $basedir/src/noise/build

../configure --prefix=$basedir/noise
make install
cd $basedir

# build and install tbb
cd $basedir/src/tbb
 
make tbb_root=$basedir/src/tbb tbb_build_dir=$basedir/src/tbb/lib tbb_build_prefix=gcc

if [ ! -d "$basedir/tbb" ]; then
    mkdir -p $basedir/tbb/lib
fi

cp -R ./include $basedir/tbb/include
cp ./lib/gcc_debug/lib* $basedir/tbb/lib/
cp ./lib/gcc_release/lib* $basedir/tbb/lib/

cd $basedir

# build and install tolua++
cd $basedir/src/tolua++

scons prefix=$basedir/tolua++ install
cd $basedir

# build and install zlib
cd $basedir/src/zlib

./configure --prefix=$basedir/zlib
make install
cd $basedir
