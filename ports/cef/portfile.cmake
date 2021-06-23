file (STRINGS "authtoken.txt" AUTH_TOKEN)

message("Auth token is: ${AUTH_TOKEN}")

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO serg06/vcpkg-cef-test-priv
	REF b8804f4eac16dd5cb0243a8f919d0775f7346e45
	SHA512 5ef788a2adc73d51fdfa1ab52432fc6ea8056289954db13bbe71065573a673acce67d48ca676461cb278390d4a329a18c07657359088ef84d0e61f68a0d2777e
	AUTHORIZATION_TOKEN "${AUTH_TOKEN}"
	HEAD_REF main
)

vcpkg_configure_cmake(
	SOURCE_PATH "${SOURCE_PATH}"
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# file(
# 	INSTALL "${SOURCE_PATH}/LICENSE"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
# 	RENAME copyright)
