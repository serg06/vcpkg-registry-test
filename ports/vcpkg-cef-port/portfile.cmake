file (STRINGS "authtoken.txt" AUTH_TOKEN)

message("Auth token is: ${AUTH_TOKEN}")
message("VCPKG_CRT_LINKAGE is: ${VCPKG_CRT_LINKAGE}")
message("VCPKG_LIBRARY_LINKAGE is: ${VCPKG_LIBRARY_LINKAGE}")

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO serg06/vcpkg-cef-test-priv
	REF ab15d09028d4b978ce4082e1d8d0e5444b98ed5b
	SHA512 36e83291cd8a968e7b173c2c543c1f57e3ed1936436a883baed8ef4aefd045b5e2bb7e8dea94c27b8911d54a7b12b36a4a5e6887b8bf653eeac8bfd43b64958c
	AUTHORIZATION_TOKEN "${AUTH_TOKEN}"
	HEAD_REF main
)

# set(VCPKG_CRT_LINKAGE static)
# set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_configure_cmake(
	SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_build_cmake(
	TARGET libcef_dll_wrapper
)

vcpkg_fixup_cmake_targets()

# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# file(
# 	INSTALL "${SOURCE_PATH}/LICENSE"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
# 	RENAME copyright)
