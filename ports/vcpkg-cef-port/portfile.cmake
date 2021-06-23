file (STRINGS "authtoken.txt" AUTH_TOKEN)

message("Auth token is: ${AUTH_TOKEN}")

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO serg06/vcpkg-cef-test-priv
	REF 51e0f4f342fd7d420c37950dd1f50c1c90700e36
	SHA512 ac4a7c4e3544de32d1b2bfda3785e851c1f60007172653f95953e36e165b9593ccd8d9ed1e58cd58241f1f4fe7a02b7cb1ffc59d96270d48d5271a2577a2a98a
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
