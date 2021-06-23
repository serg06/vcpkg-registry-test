file (STRINGS "authtoken.txt" AUTH_TOKEN)

message("Auth token is: ${AUTH_TOKEN}")

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO serg06/vcpkg-cef-test-priv
	REF 52a3cca9fdb2448e05fdb3c2d2739494bdae80d8
	SHA512 c771a0a6ff13e0896ed7036b15f6122070f4c96f75d8fa838bb22182f025d1d5a6f34c551371cbd6922a7a6e03bbef1c1432c44590505c712a548df2bebf89b7
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
