set(orig_VCPKG_LIBRARY_LINKAGE ${VCPKG_LIBRARY_LINKAGE})

set(CEF_VERSION "81.3.8")
set(CHROMIUM_VERSION "81.0.4044.138")
set(PLATFORM_NAME "windows64")
set(COMMIT_SHORTHASH "g1a0137c")
set(ARCHIVE_HASH "7626bcf8bb7ec98575dd91ea6a726eb35567c6939b6387bd5c8c400bc4918dc4a4575d9879ad40cc51c1627c0fcfaf2448d2d4259e2a3748ba7aa183cb1400cc")

set(FOLDER_NAME "cef_binary_${CEF_VERSION}+${COMMIT_SHORTHASH}+chromium-${CHROMIUM_VERSION}_${PLATFORM_NAME}")
set(ARCHIVE_NAME "${FOLDER_NAME}.tar.bz2")

vcpkg_download_distfile(
	ARCHIVE
	URLS "https://cef-builds.spotifycdn.com/${ARCHIVE_NAME}"
	FILENAME "${ARCHIVE_NAME}"
	SHA512 ${ARCHIVE_HASH}
)

vcpkg_extract_source_archive_ex(
	OUT_SOURCE_PATH SOURCE_PATH
	ARCHIVE "${ARCHIVE}"
	REF "${CEF_VERSION}"
)

# Required, or else libcef.lib gives the error "Could not find proper second linker member." Chromium does the same: https://github.com/microsoft/vcpkg/blob/030cfaa24de9ea1bbf0a4d9c615ce7312ba77af1/ports/chromium-base/portfile.cmake
set(VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK enabled)

# Required, or else you get linker errors
set(VCPKG_LIBRARY_LINKAGE static)

# Disable PREFER_NINJA because it changes the output directories slightly
vcpkg_configure_cmake(
	SOURCE_PATH "${SOURCE_PATH}"
	OPTIONS
		-DCEF_RUNTIME_LIBRARY_FLAG=/MD
)

set(VCPKG_LIBRARY_LINKAGE ${orig_VCPKG_LIBRARY_LINKAGE})

vcpkg_build_cmake(
	TARGET libcef_dll_wrapper
)

set(RELEASE_BUILD_DIR "${CURRENT_BUILDTREES_DIR}/${HOST_TRIPLET}-rel")
set(DEBUG_BUILD_DIR "${CURRENT_BUILDTREES_DIR}/${HOST_TRIPLET}-dbg")

#########################################

# /lib release
file(
	COPY
		"${RELEASE_BUILD_DIR}/libcef_dll_wrapper/Release/libcef_dll_wrapper.lib"
		"${RELEASE_BUILD_DIR}/libcef_dll_wrapper/Release/libcef_dll_wrapper.pdb"
		"${SOURCE_PATH}/Release/cef_sandbox.lib"
		"${SOURCE_PATH}/Release/libcef.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
)

# /bin release
file(
	COPY
		"${SOURCE_PATH}/Release/chrome_elf.dll"
		"${SOURCE_PATH}/Release/d3dcompiler_47.dll"
		"${SOURCE_PATH}/Release/libcef.dll"
		"${SOURCE_PATH}/Release/libEGL.dll"
		"${SOURCE_PATH}/Release/libGLESv2.dll"
		"${SOURCE_PATH}/Release/snapshot_blob.bin"
		"${SOURCE_PATH}/Release/v8_context_snapshot.bin"
	DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
)

file(
	COPY
		"${SOURCE_PATH}/Release/swiftshader/libEGL.dll"
		"${SOURCE_PATH}/Release/swiftshader/libGLESv2.dll"
	DESTINATION "${CURRENT_PACKAGES_DIR}/bin/swiftshader"
)

# /lib debug
file(
	COPY
		"${DEBUG_BUILD_DIR}/libcef_dll_wrapper/Debug/libcef_dll_wrapper.lib"
		"${DEBUG_BUILD_DIR}/libcef_dll_wrapper/Debug/libcef_dll_wrapper.pdb"
		"${SOURCE_PATH}/Debug/cef_sandbox.lib"
		"${SOURCE_PATH}/Debug/libcef.lib"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
)

# /bin debug
file(
	COPY
		"${SOURCE_PATH}/Debug/chrome_elf.dll"
		"${SOURCE_PATH}/Debug/d3dcompiler_47.dll"
		"${SOURCE_PATH}/Debug/libcef.dll"
		"${SOURCE_PATH}/Debug/libEGL.dll"
		"${SOURCE_PATH}/Debug/libGLESv2.dll"
		"${SOURCE_PATH}/Debug/snapshot_blob.bin"
		"${SOURCE_PATH}/Debug/v8_context_snapshot.bin"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
)

file(
	COPY
		"${SOURCE_PATH}/Debug/swiftshader/libEGL.dll"
		"${SOURCE_PATH}/Debug/swiftshader/libGLESv2.dll"
	DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin/swiftshader"
)

# /include
file(
	COPY "${SOURCE_PATH}/include"
	DESTINATION "${CURRENT_PACKAGES_DIR}"
)

# Another /include for cef's own imports
file(
	COPY "${SOURCE_PATH}/include"
	DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)

# /copyright
file(
	INSTALL "${SOURCE_PATH}/LICENSE.txt"
	DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
	RENAME copyright)
