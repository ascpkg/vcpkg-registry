# set options
set(VCPKG_POLICY_DLLS_IN_STATIC_LIBRARY enabled)

# Download required file
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/shinchiro/mpv-winbuild-cmake/releases/download/20241205/mpv-dev-x86_64-v3-20241205-git-91f1f4f.7z"
    FILENAME "mpv-dev-x86_64-v3-20241205-git-91f1f4f.7z"
    SHA512 AD3052E90A5531A4A4F636F6879525459D6E24FA75E8815021E22AAB27190203B129D1F4885ECF330D40B0A962667CEE9E1AADCF29B09DCD2A061E38D1B5D355
)

# Check 7z and extract
vcpkg_find_acquire_program(7Z)
set(ENV{PM_LIBMPV_PATH} "${CURRENT_BUILDTREES_DIR}/libmpv")
file(MAKE_DIRECTORY "$ENV{PM_LIBMPV_PATH}")
vcpkg_execute_required_process(
    COMMAND "${7Z}" x "${ARCHIVE}" "-o$ENV{PM_LIBMPV_PATH}" "-y"
    WORKING_DIRECTORY "$ENV{PM_LIBMPV_PATH}"
    LOGNAME "extract-libmpv"
)

# install lib files
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv-2.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv.dll.a" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
file(RENAME "${CURRENT_PACKAGES_DIR}/lib/libmpv.dll.a" "${CURRENT_PACKAGES_DIR}/lib/libmpv-2.lib")
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv-2.dll" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
file(INSTALL "$ENV{PM_LIBMPV_PATH}/libmpv.dll.a" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/libmpv.dll.a" "${CURRENT_PACKAGES_DIR}/debug/lib/libmpv-2.lib")

# install include dir
file(COPY "$ENV{PM_LIBMPV_PATH}/include/mpv" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

# install cmake config
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/libmpvConfig.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

# install copywrite
vcpkg_install_copyright(FILE_LIST "${CMAKE_CURRENT_LIST_DIR}/Copyright.txt")

# install usage
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")