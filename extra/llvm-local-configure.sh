#!/bin/bash

# BUILD NOTES:
# You need binutils-dev installed for plugin-api.h, which is used by the
# gold-plugin.
#
# Dependency issues tend to make the compiler-rt stuff fail because it
# A) needs libc++ to build but libc++ is also part of the "runtimes" build,
# and B) caches the failure to build for x86_64.
#
# To work around this:
#  1. ninja cxx (this builds llvm, clang, lld, and finally libc++)
#  2. edit build/runtimes/runtimes-bins/CMakeCache.txt and delete the
#     lines for CAN_TARGET_x86_64
#  3. ninja runtimes-configure
#  4. check that CAN_TARGET_x86_64 is now TRUE
#  5. ninja install

bootstrap_prefix="/opt/llvm-bootstrap"
prefix="/opt/llvm"

case "$1" in
    --prefix=*)
        prefix="${1#--prefix=}"
        shift
        ;;
    --bootstrap-prefix=*)
        bootstrap_prefix="${1#--bootstrap-prefix=}"
        shift
        ;;
esac

opts_common=(
    -S../llvm
    -B.
    -GNinja

    -DCMAKE_BUILD_TYPE:STRING=Release
    -DCMAKE_SKIP_INSTALL_RPATH:BOOL=OFF
    -DCMAKE_SKIP_RPATH:BOOL=OFF

    -DLLVM_BINUTILS_INCDIR:PATH=/usr/include
    -DLLVM_BUILD_LLVM_DYLIB:BOOL=ON
    -DLLVM_ENABLE_NEW_PASS_MANAGER:BOOL=ON
    -DLLVM_ENABLE_BINDINGS:BOOL=OFF
    -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF
    -DLLVM_INCLUDE_DOCS:BOOL=OFF
    -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF
    -DLLVM_INCLUDE_TESTS:BOOL=OFF
    -DLLVM_INSTALL_UTILS:BOOL=ON
    -DLLVM_LINK_LLVM_DYLIB:BOOL=ON

    -DCLANG_DEFAULT_PIE_ON_LINUX:BOOL=ON
    -DCLANG_INCLUDE_DOCS:BOOL=OFF
    -DCLANG_INCLUDE_TESTS:BOOL=OFF
    -DCLANG_LINK_CLANG_DYLIB:BOOL=ON
    -DCLANG_VENDOR:STRING=awild
    -DLLD_VENDOR:STRING=awild

    -DPython3_EXECUTABLE=/usr/bin/python3
)

opts_bootstrap=(
    "${opts_common[@]}"
    -DCMAKE_INSTALL_PREFIX:PATH=${bootstrap_prefix}
    -DCMAKE_CXX_FLAGS_RELEASE:STRING='-O2 -DNDEBUG'
    -DCMAKE_C_FLAGS_RELEASE:STRING='-O2 -DNDEBUG'

    -DLLVM_ENABLE_PROJECTS:STRING='clang;lld'
    -DLLVM_TARGETS_TO_BUILD:STRING='X86'
)

opts_full=(
    "${opts_common[@]}"
    -DCMAKE_INSTALL_PREFIX:PATH=${prefix}
    -DCMAKE_CXX_FLAGS_RELEASE:STRING='-O3 -pipe -DNDEBUG'
    -DCMAKE_C_FLAGS_RELEASE:STRING='-O3 -pipe -DNDEBUG'

    -DLLVM_TARGETS_TO_BUILD:STRING='X86;AArch64'
    -DLLVM_ENABLE_PROJECTS:STRING='clang;lld'
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;compiler-rt"

    # static only, don't require rpath
    -DLIBCXX_ENABLE_SHARED:BOOL=OFF
    -DLIBCXX_ENABLE_STATIC:BOOL=ON
    -DLIBCXX_HERMETIC_STATIC_LIBRARY:BOOL=ON
    -DLIBCXX_CXX_ABI:STRING='libcxxabi'
    -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=ON

    # maximize use of compiler-rt, libc++, and libc++abi
    -DCOMPILER_RT_USE_LIBCXX:BOOL=ON
    -DCOMPILER_RT_CXX_LIBRARY:STRING='libcxx'
    -DLIBCXX_USE_COMPILER_RT:BOOL=ON
    -DLIBCXXABI_USE_COMPILER_RT:BOOL=ON

    # Make clang use libc++ and lld by default (but still glibc for C code)
    -DCLANG_DEFAULT_CXX_STDLIB='libc++'
    -DCLANG_DEFAULT_LINKER='lld'
)

opts_use_bootstrap=(
    -DCMAKE_ADDR2LINE:FILEPATH=${bootstrap_prefix}/bin/llvm-addr2line
    -DCMAKE_AR:FILEPATH=${bootstrap_prefix}/bin/llvm-ar
    -DCMAKE_ASM_COMPILER:STRING=${bootstrap_prefix}/bin/clang
    -DCMAKE_CXX_COMPILER:STRING=${bootstrap_prefix}/bin/clang++
    -DCMAKE_C_COMPILER:STRING=${bootstrap_prefix}/bin/clang
    -DCMAKE_DLLTOOL:FILEPATH=${bootstrap_prefix}/bin/llvm-dlltool
    -DCMAKE_LINKER:FILEPATH=${bootstrap_prefix}/bin/ld.lld
    -DCMAKE_NM:FILEPATH=${bootstrap_prefix}/bin/llvm-nm
    -DCMAKE_OBJCOPY:FILEPATH=${bootstrap_prefix}/bin/llvm-objcopy
    -DCMAKE_OBJDUMP:FILEPATH=${bootstrap_prefix}/bin/llvm-objdump
    -DCMAKE_RANLIB:FILEPATH=${bootstrap_prefix}/bin/llvm-ranlib
    -DCMAKE_READELF:FILEPATH=${bootstrap_prefix}/bin/llvm-readelf
    -DCMAKE_STRIP:FILEPATH=${bootstrap_prefix}/bin/llvm-strip
)

case "$1" in
    bootstrap) opts=("${opts_bootstrap[@]}") ;;
    full) opts=("${opts_full[@]}" "${opts_use_bootstrap[@]}") ;;
    normal) opts=("${opts_full[@]}") ;;
    *)
        echo >&2 "invalid option. Specify 'bootstrap', 'full', or 'normal'"
        echo >&2 "full builds with an installed bootstrap, normal builds with the system toolchain"
        exit 1
        ;;
esac
shift

set -x
cmake "${opts[@]}" "$@"
