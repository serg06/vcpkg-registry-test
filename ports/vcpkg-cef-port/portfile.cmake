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

# Required, or else libcef.lib gives the error "Could not find proper second linker member." Chromium does the same: https://github.com/microsoft/vcpkg/blob/030cfaa24de9ea1bbf0a4d9c615ce7312ba77af1/ports/chromium-base/portfile.cmake
set(VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK enabled)

# TODO: Consider moving this to vcpkg_configure_cmake as "OPTIONS -DBUILD_SHARED_LIBS=OFF"
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_configure_cmake(
	SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_build_cmake(
	TARGET libcef_dll_wrapper
)

set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

set(DEBUG_BUILD_DIR "${CURRENT_BUILDTREES_DIR}/${HOST_TRIPLET}-dbg")
set(CEF_DIR "${DEBUG_BUILD_DIR}/ChromiumEmbeddedFramework")


################################

# /lib release
file(
	COPY "${CEF_DIR}/build/libcef_dll_wrapper/Release/libcef_dll_wrapper.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
)

file(
	COPY "${CEF_DIR}/Release/libcef.dll"
	DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
)

file(
	COPY "${CEF_DIR}/Release/libcef.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
)


# file(
# 	COPY "${CEF_DIR}/Release/swiftshader"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
# )

# file(
# 	COPY "${CEF_DIR}/Release/swiftshader/libEGL.dll"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
# )

# file(
# 	COPY "${CEF_DIR}/Debug/swiftshader/libGLESv2.dll"
# 	DESTINATION "${Release}/bin"
# )



# file(
# 	GLOB
# 	MORE_LIBS
# 	"${CEF_DIR}/Release/*.lib"
# )

# file(
# 	COPY ${MORE_LIBS}
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
# )



# file(
# 	GLOB
# 	MORE_DLLS
# 	"${CEF_DIR}/Release/*.dll"
# )

# file(
# 	COPY ${MORE_DLLS}
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
# )


##########


# /lib debug
file(
	COPY "${CEF_DIR}/build/libcef_dll_wrapper/Debug/libcef_dll_wrapper.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
)

file(
	COPY "${CEF_DIR}/build/libcef_dll_wrapper/Debug/libcef_dll_wrapper.pdb"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
)

file(
	COPY "${CEF_DIR}/Debug/libcef.dll"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
)

file(
	COPY "${CEF_DIR}/Debug/libcef.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
)


# file(
# 	COPY "${CEF_DIR}/Debug/swiftshader"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
# )

# file(
# 	COPY "${CEF_DIR}/Debug/swiftshader/libEGL.dll"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
# )

# file(
# 	COPY "${CEF_DIR}/Debug/swiftshader/libGLESv2.dll"
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
# )



# file(
# 	GLOB
# 	MORE_LIBS_DEBUG
# 	"${CEF_DIR}/Debug/*.lib"
# )

# file(
# 	COPY ${MORE_LIBS_DEBUG}
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
# )



# file(
# 	GLOB
# 	MORE_DLLS_DEBUG
# 	"${CEF_DIR}/Debug/*.dll"
# )

# file(
# 	COPY ${MORE_DLLS_DEBUG}
# 	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
# )


########################

# /include
file(
	COPY "${CEF_DIR}/include"
	DESTINATION "${CURRENT_PACKAGES_DIR}"
)

# Another /include for cef's own imports
file(
	COPY "${CEF_DIR}/include"
	DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)

# /copyright
file(
	INSTALL "${CEF_DIR}/LICENSE.txt"
	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
	RENAME copyright)
