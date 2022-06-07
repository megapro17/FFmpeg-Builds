#!/bin/bash

LIBSSH_REPO="https://git.libssh.org/projects/libssh.git/"
LIBSSH_COMMIT="100017982d4409def131a053c8879040084ac68b"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git clone "$LIBSSH_REPO" libssh
    cd libssh
    git checkout "$LIBSSH_COMMIT"

    echo "Requires.private: libssl libcrypto zlib" >> libssh.pc.cmake
    echo "Libs.private: -DLIBSSH_STATIC=1" >> libssh.pc.cmake
    echo "Cflags.private: -DLIBSSH_STATIC=1" >> libssh.pc.cmake
    # https://github.com/wader/static-ffmpeg/blob/6048294be4fb3dd75c97469eecbfa693ddb286a1/Dockerfile#L465

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIB=ON -DWITH_GSSAPI=OFF -DWITH_SERVER=OFF -DWITH_EXAMPLES=OFF -DPICKY_DEVELOPER=ON ..
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libssh
}

ffbuild_unconfigure() {
    echo --disable-libssh
}
