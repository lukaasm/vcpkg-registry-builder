if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/source")
    set( SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/source")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO modio/modio-sdk
        REF 28301978dfbf4c9c83a008a7d142360698f9943e
        SHA512 7092642149e06ca7a6863d2901f2d44363ce0f1c1a11add1644b2636d108491e1aac671959320f89b2189339a09a56976f989138db862bd4921868260613e87c
        HEAD_REF main
    )
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SLANG_RHI_BUILD_SHARED)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMODIO_PLATFORM=WIN
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
