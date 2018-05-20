include(MMOServerLibrary)

AddMMOServerLibrary(Utils)
TARGET_LINK_LIBRARIES(Utils "-ltbb -lrt -lpthread")
