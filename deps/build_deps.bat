@echo off
SETLOCAL EnableDelayedExpansion

set "DEPS_BASE=%~dp0"
set "DEPS_DRIVE=%~d0"

%PROJECT_DRIVE%
cd %DEPS_BASE%

rem Build the environment and bail out if it fails
if x%environment_built% == x (
    echo "Building environment"
    call :BUILD_DEPS_ENVIRONMENT
)

echo "Finished building environment"

if exist "src\boost" call :BUILD_BOOST
if exist "src\glog" call :BUILD_GLOG
if exist "src\gtest" call :BUILD_GTEST
if exist "src\lua" call :BUILD_LUA
if exist "src\mysql-connector-c" call :BUILD_MYSQL
if exist "src\mysql-connector-cpp" call :BUILD_MYSQLCONN
if exist "src\noise" call :BUILD_NOISE
if exist "src\tbb" call :BUILD_TBB
if exist "src\tolua++" call :BUILD_TOLUA
if exist "src\zlib" call :BUILD_ZLIB


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_DEPS_ENVIRONMENT ----------------------------------------
:BUILD_DEPS_ENVIRONMENT

if not exist "%VS120COMNTOOLS%" (
  set "VS120COMNTOOLS=%PROGRAMFILES(X86)%\Microsoft Visual Studio 12.0\Common7\Tools"
  if not exist "!VS120COMNTOOLS!" (
  	  set "VS120COMNTOOLS=%PROGRAMFILES%\Microsoft Visual Studio 12.0\Common7\Tools"
  	  if not exist "!VS120COMNTOOLS!" (
  		    rem TODO: Allow user to enter a path to their base visual Studio directory.

    	    echo ***** Microsoft Visual Studio 12.0 required *****
    	    exit /b 1
  	  )
  )
)

set "MSBUILD=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"

call "%VS120COMNTOOLS%\vsvars32.bat" >NUL

set environment_built=yes

goto :eof
rem --- End of BUILD_DEPS_ENVIRONMENT ------------------------------------------
rem ----------------------------------------------------------------------------


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_BOOST ---------------------------------------------------
rem --- Builds the boost library for use with this project.                  ---
:BUILD_BOOST

echo BUILDING: Boost - http://www.boost.org/

cd "%DEPS_BASE%src\boost"

rem Only build boost if it hasn't been built already.
if exist "%DEPS_BASE%src\boost\stage\lib\libboost_*-mt-gd.lib" (
	if exist "%DEPS_BASE%src\boost\stage\lib\libboost_*-mt.lib" (
		echo Boost libraries already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build BJAM which is needed to build boost
if not exist "bjam.exe" (
	cmd /q /c bootstrap.bat
)

rem Build the boost libraries
cmd /c "bjam.exe" --toolset=msvc-12.0 --with-log --with-program_options --with-date_time --with-thread --with-regex --with-system variant=debug,release link=static runtime-link=shared threading=multi define=_SCL_SECURE_NO_WARNINGS=0

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_BOOST -----------------------------------------------------
rem ----------------------------------------------------------------------------

rem ----------------------------------------------------------------------------
rem --- Start of BUILD_GTEST ---------------------------------------------------
rem --- Builds all googletest library used for unit testing.                 ---
:BUILD_GTEST

echo BUILDING: Google Test - http://code.google.com/p/googletest/

cd "%DEPS_BASE%src\gtest\msvc"

rem Only build gtest if it hasn't been built already.
if exist "%DEPS_BASE%gtest\lib\libboost_*-mt-gd.lib" (
	if exist "%DEPS_BASE%boost\lib\libboost_*-mt.lib" (
		echo Boost libraries already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)
rem Only build gtest if it hasn't been built already.
if exist "gtest-md\Debug\gtest-mdd.lib" (
	if exist "gtest-md\Release\gtest-md.lib" (
		echo Google Test library already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the gtest libraries
"%MSBUILD%" "gtest-md.sln" /t:build /p:Platform=Win32,Configuration=Debug,VCBuildAdditionalOptions="/useenv"
"%MSBUILD%" "gtest-md.sln" /t:build /p:Platform=Win32,Configuration=Release,VCBuildAdditionalOptions="/useenv"

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_GTEST -----------------------------------------------------
rem ----------------------------------------------------------------------------


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_LUA -----------------------------------------------------
rem --- Builds the lua library for use with this project.                    ---
:BUILD_LUA

echo BUILDING: Lua - http://www.lua.org/

cd "%DEPS_BASE%src\lua"

rem Only build lua if it hasn't been built already.
if exist "lib\lua5.1d.lib" (
	if exist "lib\lua5.1.lib" (
		echo Lua already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the lua libraries
call :COMPILE_LUA debug >NUL
call :COMPILE_LUA release >NUL

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_LUA -------------------------------------------------------
rem ----------------------------------------------------------------------------


rem ----------------------------------------------------------------------------
rem --- Start of COMPILE_LUA ---------------------------------------------------
rem --- Compiles the lua library.                                            ---
:COMPILE_LUA

if "%1" == "debug" (
	set buildcmd=cl /nologo /MDd /O2 /W3 /c /D_CRT_SECURE_NO_DEPRECATE
	set libname=lua5.1d.lib
)

if "%1" == "release" (
	set buildcmd=cl /nologo /MD /O2 /W3 /c /D_CRT_SECURE_NO_DEPRECATE
	set libname=lua5.1.lib
)

rem Create the output directory if it does not yet exist.
if not exist "lib" (
	mkdir "lib"
)

cd src

%buildcmd% *.c

del lua.obj luac.obj

lib /out:../lib/%libname% *.obj

del *.obj

cd ..

goto :eof
rem --- End of COMPILE_LUA -----------------------------------------------------
rem ----------------------------------------------------------------------------


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_MYSQL ---------------------------------------------------
rem --- Builds the mysql c connector library for use with this project.      ---
:BUILD_MYSQL

echo BUILDING: Mysql Connector/C

cd "%DEPS_BASE%src\mysql-connector-c"

rem Only build mysql if it hasn't been built already.
if exist "libmysql\Debug\libmysql.lib" (
	if exist "libmysql\Release\libmysql.lib" (
		echo Mysql Connector/C already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the mysql-connector-c libraries
cmake -G "Visual Studio 12 2013" .
"%MSBUILD%" "libmysql.sln" /t:build /p:Platform=Win32,Configuration=Debug,VCBuildAdditionalOptions="/useenv"
"%MSBUILD%" "libmysql.sln" /t:build /p:Platform=Win32,Configuration=Release,VCBuildAdditionalOptions="/useenv"

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_MYSQL -----------------------------------------------------
rem ----------------------------------------------------------------------------


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_MYSQLCONN -----------------------------------------------
rem --- Builds the mysql c++ connector library for use with this project.    ---
:BUILD_MYSQLCONN

echo BUILDING: Mysql Connector/C++ 

cd "%DEPS_BASE%src\mysql-connector-cpp"

rem Only build mysql-connector-cpp if it hasn't been built already.
if exist "driver\Debug\mysqlcppconn.lib" (
	if exist "driver\Release\mysqlcppconn.lib" (
		echo Mysql Connector/C++ already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the mysql-connector-cpp libraries
set "MYSQL_DIR=%DEPS_BASE%src/mysql-connector-c"
cmake -G "Visual Studio 12 2013" -DBOOST_INCLUDEDIR=%DEPS_BASE%src/boost -DBOOST_LIBRARYDIR=%DEPS_BASE%src/boost/stage/lib .
"%MSBUILD%" "MYSQLCPPCONN.sln" /t:build /p:Platform=Win32,Configuration=Debug,VCBuildAdditionalOptions="/useenv"
"%MSBUILD%" "MYSQLCPPCONN.sln" /t:build /p:Platform=Win32,Configuration=Release,VCBuildAdditionalOptions="/useenv"

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_MYSQLCONN -------------------------------------------------
rem ----------------------------------------------------------------------------


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_NOISE ---------------------------------------------------
rem --- Builds the noise library for use with this project.                  ---
:BUILD_NOISE

echo BUILDING: Noise - http://libnoise.sourceforge.net/

cd "%DEPS_BASE%src\noise"

rem Only build noise if it hasn't been built already.
if exist "win32\Debug\libnoise.lib" (
	if exist "win32\Release\libnoise.lib" (
		echo Noise already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the libnoise libraries
"%MSBUILD%" "libnoise.sln" /t:build /p:Platform=Win32,Configuration=Debug,VCBuildAdditionalOptions="/useenv"
"%MSBUILD%" "libnoise.sln" /t:build /p:Platform=Win32,Configuration=Release,VCBuildAdditionalOptions="/useenv"

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_NOISE -----------------------------------------------------
rem ----------------------------------------------------------------------------yea


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_TBB -----------------------------------------------------
rem --- Builds the tbb library for use with this project.                    ---
:BUILD_TBB

echo BUILDING: tbb - http://www.threadingbuildingblocks.org/

cd "%DEPS_BASE%src\tbb\build\vc12"

rem Only build tbb if it hasn't been built already.
if exist "ia32\Debug\tbb_debug.lib" (
	if exist "ia32\Release\tbb.lib" (
		echo tbb already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the tbb libraries
"%MSBUILD%" "makefile.sln" /t:build /p:Platform=Win32,Configuration=Debug,VCBuildAdditionalOptions="/useenv"
"%MSBUILD%" "makefile.sln" /t:build /p:Platform=Win32,Configuration=Release,VCBuildAdditionalOptions="/useenv"

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_TBB -------------------------------------------------------
rem ----------------------------------------------------------------------------


rem ----------------------------------------------------------------------------
rem --- Start of BUILD_TOLUA ---------------------------------------------------
rem --- Builds the tolua++ library for use with this project.                ---
:BUILD_TOLUA

echo BUILDING: tolua++ - http://www.codenix.com/~tolua/

cd "%DEPS_BASE%src\tolua++\win32\vc10"

rem Only build tolua++ if it hasn't been built already.
if exist "withLua51_Debug\toluapp.lib" (
	if exist "withLua51_Release\toluapp.lib" (
		echo tolua++ already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the tolua++ libraries
"%MSBUILD%" "toluapp.sln" /t:build /p:Platform=Win32,Configuration=withLua51_Debug,VCBuildAdditionalOptions="/useenv"
"%MSBUILD%" "toluapp.sln" /t:build /p:Platform=Win32,Configuration=withLua51_Release,VCBuildAdditionalOptions="/useenv"

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_TOLUA -----------------------------------------------------
rem ----------------------------------------------------------------------------



rem ----------------------------------------------------------------------------
rem --- Start of BUILD_ZLIB ----------------------------------------------------
rem --- Builds the zlib library for use with this project.                   ---
:BUILD_ZLIB

echo BUILDING: zlib - http://www.zlib.net/

cd "%DEPS_BASE%src\zlib"

rem Only build zlib if it hasn't been built already.
if exist "Debug\zlibd.lib" (
	if exist "Release\zlib.lib" (
		echo zlib library already built ... skipping
		echo.
		cd "%DEPS_BASE%"
		goto :eof
	)
)

rem Build the zlib libraries
cmake -G "Visual Studio 12" .
"%MSBUILD%" "zlib.sln" /t:build /p:Platform=Win32,Configuration=Debug,VCBuildAdditionalOptions="/useenv"
"%MSBUILD%" "zlib.sln" /t:build /p:Platform=Win32,Configuration=Release,VCBuildAdditionalOptions="/useenv"

cd "%DEPS_BASE%"

goto :eof
rem --- End of BUILD_ZLIB ------------------------------------------------------
rem ----------------------------------------------------------------------------
