include(MMOServerLibrary)

AddMMOServerLibrary(Common
    MMOSERVER_DEPS 
        Utils 
)

TARGET_LINK_LIBRARIES(Common "-ltbb -lrt -lpthread")
