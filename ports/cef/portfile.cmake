file (STRINGS "authtoken.txt" AUTH_TOKEN)

message("Auth token is: ${AUTH_TOKEN}")

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO serg06/vcpkg-cef-test-priv
	REF 17ba063fce2e166002a17fd62fbcd9bab1ff828e
	SHA512 cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
	AUTHORIZATION_TOKEN "${AUTH_TOKEN}"
	HEAD_REF main
)

vcpkg_configure_cmake(
	SOURCE_PATH "${SOURCE_PATH}"
	PREFER_NINJA
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# file(
# 	INSTALL "${SOURCE_PATH}/LICENSE"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
# 	RENAME copyright)
