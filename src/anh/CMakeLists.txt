include(MMOServerLibrary)

AddMMOServerLibrary (libanh
    ADDITIONAL_INCLUDE_DIRS
        ${MYSQL_INCLUDE_DIR}
        ${MysqlConnectorCpp_INCLUDES}
   OPTIMIZED_LIBRARIES
        ${MYSQL_LIB}
        ${MysqlConnectorCpp_LIBRARY_RELEASE}
	DEBUG_LIBRARIES
		${MYSQL_LIB}
		${MysqlConnectorCpp_LIBRARY_DEBUG}
   
)
#TARGET_LINK_LIBRARIES(libanh "-lrt -lpthread")