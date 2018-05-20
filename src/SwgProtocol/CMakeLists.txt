include(MMOServerLibrary)

AddMMOServerLibrary(SwgProtocol
    MMOSERVER_DEPS 
        Utils
        Common
)
TARGET_LINK_LIBRARIES(SwgProtocol "-ltbb -lrt -lpthread")
