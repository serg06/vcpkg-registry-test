file (STRINGS "authtoken.txt" AUTH_TOKEN)

message("Auth token is: ${AUTH_TOKEN}")

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO serg06/vcpkg-cef-test-priv
	REF 17ba063fce2e166002a17fd62fbcd9bab1ff828e
	SHA512 9d952f2265c882c785c26ced4c3b162afdcb4d403829ce2db0a50b26951a70a0ef94c99a473fe23a9f9b5c0774406ff8175cc763fdaf2b88c27c5deb9f2822cd
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
