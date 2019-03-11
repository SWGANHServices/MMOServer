# MMOServer - Visual Studio 2017 #

This build has been tested on and run on windows only.

## Building/Installing ##

**Pre-Requisits**
*	MySQL server 5.7 (32bit) - [Download][7]

*	CMake 3.12.3 - [8]

*	Visual Studio 2017 Community - [Download][9]

*	Git hub Desktop (Optional) - [Download][10]


### Windows Builds ###

To build the server download and install the pre-requisits, clone the project.
Download the *	Dependencies - [Download][11] and extract them into the root of your project folder
	(IE: C:\MMOServer_Legacy) 
Browse into the deps folder and execute the build_deps batch file
	
Double click the build_server.bat and sit back, relax and await the errors*...
	until we repair the Cmake build instructions out goal here is to generate the .sln file.
	If the force is with you, you'll get no errors.
	
	*The errors you have will more than likely be Cmake unable to find some of the dependencies,
	open up the mmoserver.sln here you'll be able to add any missing Deps for each project. (most likely it'll be tbb) 
	
	Under: Properties -> C/C++ -> General -> Additional Include Directories 
	add 
	
	* ChatServer*
	* Common
	* Common_tests*
	* ConnectionServer*
	* DataBaseManager
	* libanh
	* libanh_tests*
	* LoginServer*
	* MessageLib
	* NetworkManager
	* PingServer*
	* ScriptEngine
	* SwgProtocol
	* Utils
	* Utils_tests*
	* ZoneServer*
	
	*you may also have to link the appropriate deps 
		Properties -> Linker -> Additional Library Directories
		
some limited support can be found on our [discord][12] or [forum][6]		

------------------------- ## Legacy Markdown ## -------------------------

## MMOServer ##

The MMOServer is the flagship project for the [SWG:ANH Team][1]. It is a cross platform massively multiplayer game server intended to emulate the [Star Wars Galaxies][2] Pre-Combat Upgrade experience. The base of the server is written in C++ with some LUA sprinkled in.


### Building/Installing ###

**Pre-Requisits**

*   CMake 2.8 or higher

    [Download][3] the latest version of CMake for your OS.

*   C++0x Compatible Compiler

    Windows: Visual Studio 2013 or higher is required
    Unix: GCC 4.6 or higher is required
    
#### Windows Builds ####

To build the server on Windows simply double-click the BuildServer.bat file in the project root. This will download and build all the dependencies and sources and then generate a /bin directory with the server executables.

#### Unix Builds ####

To build the server on Unix platforms run the build_server.sh script in the project root. This will download and build all the dependencies and sources. Once the script has completed you can issue further builds from within the "build" directory:

    ./build_server.sh
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=/opt/local ..
    make install
    
You can use the -DCMAKE\_INSTALL\_PREFIX flag to specify a custom output directory for the make install command. 

### Useful Links ###

*   [Bugtracker][4]
*   [Wiki][5]
*   [Forum][6]

	[1]: http://swganh.com/
	[2]: http://starwarsgalaxies.com/
	[3]: http://cmake.org/cmake/resources/software.html
	[4]: http://wiki2.swganh.org/
	[5]: http://wiki.swganh.org/
	[6]: http://www.swganh.com/anh_community/
	[7]: https://dev.mysql.com/downloads/windows/installer/5.7.html
	[8]: https://cmake.org/download/
	[9]: https://visualstudio.microsoft.com/downloads/
	[10]: https://desktop.github.com/
	[11]: https://www.dropbox.com/s/v78uh1sv1pipigf/mmoserver-deps-0.6.150.7z?dl=0
	[12]: https://discord.gg/7GThTY
