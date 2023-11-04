# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

_binaryen_revision=ee738ac1f838a090cac74ba8981e2104b6c02d44
_llvm_project_revision=004bf170c6cbaa049601bcf92f86a9459aec2dc2

DESCRIPTION="Compile C and C++ into highly-optimizable JavaScript for the web"
HOMEPAGE="https://emscripten.org"
SRC_URI="git+https://github.com/kripken/emscripten#tag=$PV
         git+https://github.com/llvm/llvm-project.git#commit=$_llvm_project_revision
         git+https://github.com/WebAssembly/binaryen.git#commit=$_binaryen_revision
         files/emscripten.sh
         files/emscripten-config
"

LICENSE="custom"
SLOT="0"
KEYWORDS="amd64 ~amd64 x86 ~x86"
IUSE="nodejs python"

DEPEND="
    nodejs? ( net-libs/nodejs )
    python? ( dev-lang/python )
    sys-apps/which
"
#    acorn


BDEPEND="
    dev-util/cmake
    dev-libs/libxml2
    dev-vcs/git
    dev-util/ninja
"
#    npm


#BEGIN ARCH PKGBUILD#
# Maintainer: Sven-Hendrik Haase <svenstaro@archlinux.org>
# Contributor: carstene1ns <arch carsten-teibes de> - http://git.io/ctPKG
# Contributor: Stefan Husmann <stefan-husmann@t-online.de>
# Contributor: Vlad Kolotvin <vlad.kolotvin@gmail.com>

#pkgname=emscripten
# NOTE: You need to run ./get-compatible-versions.sh after changing the pkgver!
#_binaryen_revision=ee738ac1f838a090cac74ba8981e2104b6c02d44
#_llvm_project_revision=004bf170c6cbaa049601bcf92f86a9459aec2dc2
# Sadly, upstream currently suggests bundling a binaryen version for the time being:
# https://github.com/emscripten-core/emscripten/issues/12252
# I'm obviously unhappy about that but it appears to be the only practical solution for the time being.
#pkgver=3.1.38
#pkgrel=1
#pkgdesc="Compile C and C++ into highly-optimizable JavaScript for the web"
#arch=('x86_64')
#url="https://emscripten.org"
#license=('custom')
#depends=('nodejs' 'python' 'which' 'acorn')
#makedepends=('cmake' 'libxml2' 'git' 'ninja' 'npm')
#optdepends=('java-environment: for using clojure'
#            'ruby: for using websockify addon'
#            'cmake: for emcc --show-ports')
#install=emscripten.install
#options=('!lto' '!debug')
#conflicts=('binaryen')
#provides=('binaryen')
#source=("git+https://github.com/kripken/emscripten#tag=$pkgver"
#        git+https://github.com/llvm/llvm-project.git#commit=$_llvm_project_revision
#        git+https://github.com/WebAssembly/binaryen.git#commit=$_binaryen_revision
#        "emscripten.sh"
#        emscripten-config)
#sha512sums=('SKIP'
#            'SKIP'
#            'SKIP'
#            'fbe9b95b8d18e7d0c6ec5fded6f11b72fbe4ddd0391e5704b281ba79c479f3563e82423b790ddf3f0554a23d659193ca898a81fe3db509f16c30c7188b790e4d'
#            '8b5951493f69631045f44736917144b7679beb2bf087fca8a8ba887224cfc598fe8c76c5a4e7aa4a09fbb8f1b7b42556b68f4aa9e5b93fb130fd8bdab79053d9')
#ARCH PKGBUILD CONTINUES VERBATIM, but with stage names switched from Arch to Gentoo

src_compile() {
  cd binaryen
  cmake \
      -Bbuild \
      -GNinja \
      -DBUILD_TESTS=OFF \
      -DCMAKE_INSTALL_PREFIX=/usr
  ninja -C build

  # Inspired from https://github.com/WebAssembly/waterfall/blob/db2ea5eeb11b74cce9b9459be0cc88807744b1b5/src/build.py#L868
  cd "$srcdir"/llvm-project/llvm
  cmake \
    -Bbuild \
    -GNinja \
    -DLLVM_ENABLE_LIBXML2=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DCOMPILER_RT_BUILD_XRAY=OFF \
    -DCOMPILER_RT_INCLUDE_TESTS=OFF \
    -DCOMPILER_RT_ENABLE_IOS=OFF \
    -DCMAKE_INSTALL_PREFIX=/opt/emscripten-llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SKIP_RPATH=ON \
    -DLLVM_BUILD_RUNTIME=OFF \
    -DLLVM_TOOL_LTO_BUILD=ON \
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TARGETS_TO_BUILD="X86;WebAssembly" \
    -DLLVM_ENABLE_PROJECTS="lld;clang" \
    -DCLANG_INCLUDE_TESTS=OFF
  ninja -C build
}

src_install() {
  DESTDIR="$pkgdir" ninja -C binaryen/build install

  # Install LLVM stuff according to
  # https://github.com/emscripten-core/emscripten/blob/master/docs/packaging.md
  # and
  # https://github.com/WebAssembly/waterfall/blob/d4a504ffee488a68d09b336897c00d404544601d/src/build.py#L915
  DESTDIR="$pkgdir" ninja -C llvm-project/llvm/build install
  cd "$pkgdir"/opt/emscripten-llvm/bin

  # Clean up some unnecessary bins and libs
  rm clang-check clang-cl clang-cpp clang-extdef-mapping clang-format \
      clang-offload-bundler clang-refactor clang-rename clang-scan-deps \
      lld-link ld.lld llvm-lib
  cd ../lib
  rm libclang.so
  cd ..
  rm -r share

  # Copy some stuff that we need but that wasn't installed by default
  for bin in llvm-as llvm-dis FileCheck llc llvm-link llvm-mc llvm-readobj opt llvm-dwarfdump; do
      install -Dm755 "$srcdir"/llvm-project/llvm/build/bin/$bin "$pkgdir"/opt/emscripten-llvm/bin/$bin
  done

  # Install emscripten
  cd "$srcdir"/emscripten
  DESTDIR="$pkgdir"/usr/lib/emscripten make install

  # Fix permissions messed up by npm
  find "${pkgdir}"/usr/lib/emscripten -type d -exec chmod 755 {} +
  chown -R root:root "${pkgdir}"/usr/lib/emscripten/

  install -Dm644 "$srcdir"/emscripten-config "$pkgdir"/usr/lib/emscripten/.emscripten

  install -d "$pkgdir"/usr/share/doc
  ln -s /usr/lib/emscripten/site/source/docs "$pkgdir"/usr/share/doc/$pkgname
  install -Dm755 "$srcdir"/emscripten.sh "$pkgdir"/etc/profile.d/emscripten.sh
  install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}

#optfeature( )
#optdepends=('java-environment: for using clojure'
#            'ruby: for using websockify addon'
#            'cmake: for emcc --show-ports')

