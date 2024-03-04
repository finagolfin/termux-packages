TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.2
SWIFT_RELEASE="DEVELOPMENT-SNAPSHOT-2025-01-10-a"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/swift-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=1219fd794176f3e9d60c2d9beb31f58509cf378d1b9f1f2481a2edf1226a0a1f
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-execinfo, libandroid-glob, libandroid-posix-semaphore, libandroid-shmem, libandroid-spawn, libandroid-spawn-static, libandroid-sysv-semaphore, libcurl, libuuid, libxml2, libdispatch, llbuild, pkg-config, swift-sdk-${TERMUX_ARCH/_/-}"
TERMUX_PKG_BUILD_DEPENDS="rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
TERMUX_PKG_NO_STATICSPLIT=true
# Temporary hack only needed for arm and x86_64
TERMUX_PKG_UNDEF_SYMBOLS_FILES="
./opt/ndk-multilib/arm-linux-androideabi/lib/libFoundation.so
./opt/ndk-multilib/arm-linux-androideabi/lib/libFoundationNetworking.so
./opt/ndk-multilib/x86_64-linux-android/lib/libFoundation.so
./opt/ndk-multilib/x86_64-linux-android/lib/libFoundationNetworking.so
"
# Building swift uses CMake, but the standard
# termux_step_configure_cmake function is not used. Instead, we set
# TERMUX_PKG_FORCE_CMAKE to make the build system aware that CMake is
# needed.
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_CMAKE_BUILD=Ninja

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;license;sourcekit-inproc;static-mirror-lib;stdlib;sdk-overlay"
SWIFT_TOOLCHAIN_FLAGS="-RA --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_PKG_MAKE_PROCESSES --install-prefix=$TERMUX_PREFIX"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/"
SWIFT_BUILD_FLAGS="$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS"

SWIFT_ARCH=$TERMUX_ARCH
test $SWIFT_ARCH == 'arm' && SWIFT_ARCH='armv7'

termux_step_post_get_source() {
	# The Swift build-script requires a particular organization of source
	# directories, which the following downloads and sets up.
	mkdir .temp
	mv [a-zA-Z]* .temp/
	mv .temp swift

	declare -A library_checksums
	library_checksums[sourcekit-lsp]=3065554af62dbf2d1a62f82d076998372f5f43becd3f2d9795e8320f4cede0d2
	library_checksums[swift-corelibs-xctest]=8f45a09fb518589d826aacca16c588468a717469bcd7e3169d2239839b2d3ac2
	library_checksums[swift-corelibs-foundation]=a915255aba662363d82491db76df0d1a9e32ebdbd98d2d8ed7efdda8770a5109
	library_checksums[swift-lmdb]=fdd7d49ef815a4bb6193a9910108c7692b712db9e9341433b061f09c454565c7
	library_checksums[swift-collections]=7e5e48d0dc2350bed5919be5cf60c485e72a30bd1f2baf718a619317677b91db
	library_checksums[swift-driver]=4ae3db8fee22a2bbfa9441f7ec063b293567c0a7d89eb2bf1261f6b4b8ae18bd
	library_checksums[swift-foundation]=981752216eff72c162399078155617ac538e53adda954422f6f89ca7979ebb1e
	library_checksums[swift-toolchain-sqlite]=c8704e70c4847a8dbd47aafb25d293fbe1e1bafade16cfa64e04f751e33db0ca
	library_checksums[swift-argument-parser]=d5bad3a1da66d9f4ceb0a347a197b8fdd243a91ff6b2d72b78efb052b9d6dd33
	library_checksums[swift-syntax]=8b963b26fc51878be95cad8fa668cd57859867ab3048778175f7c15d0e3cd114
	library_checksums[swift-llbuild]=59b01224fad52a4f32dd181b0a8b990ddce96ca8c5cc14d63d70db4e78ae1ed9
	library_checksums[swift-corelibs-libdispatch]=0257e985723e17bf7cb943ae963a0e8bc6d15ab4929b84672131806582be6535
	library_checksums[swift-foundation-icu]=f0b4ec3c9014307700633cf955d4721cd1aec7a0a9db4550dfc8197c0bdd0796
	library_checksums[swift-system]=02e13a7f77887c387f5aa1de05f4d4b8b158c35145450e1d9557d6c42b06cd1f
	library_checksums[swift-asn1]=e0da995ae53e6fcf8251887f44d4030f6600e2f8f8451d9c92fcaf52b41b6c35
	library_checksums[swift-tools-support-core]=bf18632a5323458264eaf0317e4c27c07c2b71d87a924a68235be2c4772d36e1
	library_checksums[swift-package-manager]=8e0413d78c548462545d60dda419f5c49f582c142f8b3d4fb1f3b50b5fdda5b3
	library_checksums[swift-cmark]=fc34d3fba1a9e3ef0a930661c09ee91c56440b6320769b0ef22969a7feb4c304
	library_checksums[indexstore-db]=e8c90819f528e533eaeb2eac893631f461f940d2b705eded45d78a51c87b7bc2
	library_checksums[swift-certificates]=fcaca458aab45ee69b0f678b72c2194b15664cc5f6f5e48d0e3f62bc5d1202ca
	library_checksums[swift-crypto]=5c860c0306d0393ff06268f361aaf958656e1288353a0e23c3ad20de04319154
	library_checksums[llvm-project]=0afd7cf017633fbce49f96a61e6ae10fdcd29acf7dc35b0f2df80c21ec119fad
	library_checksums[swift-experimental-string-processing]=e3d875438b1457acacd29f0679e44bb1d3bfa2188c1c2fc5798ba6d2278785d3
	library_checksums[Yams]=d0f8eced7ef3462945bde1fe0e37288b7df6a50ca854df53b3aff43ce4d38e39

	for library in "${!library_checksums[@]}"; do \
		GH_ORG="apple"
		if [ "$library" = "swift-argument-parser" ]; then
			SRC_VERSION="1.4.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-asn1" ]; then
			SRC_VERSION="1.0.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-certificates" ]; then
			SRC_VERSION="1.0.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-collections" ]; then
			SRC_VERSION="1.1.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			SRC_VERSION="3.0.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.3.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-toolchain-sqlite" ]; then
			GH_ORG="swiftlang"
			SRC_VERSION="1.0.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "Yams" ]; then
			GH_ORG="jpsim"
			SRC_VERSION="5.1.3"
			TAR_NAME=$SRC_VERSION
		else
			GH_ORG="swiftlang"
			SRC_VERSION=$SWIFT_RELEASE
			TAR_NAME=swift-$SWIFT_RELEASE
		fi

		termux_download \
			https://github.com/$GH_ORG/$library/archive/$TAR_NAME.tar.gz \
			$TERMUX_PKG_CACHEDIR/$library-$SRC_VERSION.tar.gz \
			${library_checksums[$library]}
		tar xf $TERMUX_PKG_CACHEDIR/$library-$SRC_VERSION.tar.gz
		mv $library-$TAR_NAME $library
	done

	mv swift-cmark cmark
	mv swift-llbuild llbuild
	mv Yams yams
	mv swift-package-manager swiftpm
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_cmake
		termux_setup_ninja

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu CI may not have clang/clang++ in its path so explicitly set it
		# to clang-17 instead.
		if [ -z "$CLANG" ]; then
			CLANG=$(command -v clang-17)
			CLANGXX=$(command -v clang++-17)
		fi

		# Natively compile llvm-tblgen and some other files needed later.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_HOSTBUILD_DIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_PKG_MAKE_PROCESSES $SWIFT_PATH_FLAGS \
		--skip-build-cmark --skip-build-llvm --skip-build-swift --skip-early-swift-driver \
		--skip-early-swiftsyntax --build-toolchain-only --host-cc=$CLANG --host-cxx=$CLANGXX
	fi
}

termux_step_make() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_swift
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64
		ln -sf $NDK/source.properties $TERMUX_STANDALONE_TOOLCHAIN
		for header in execinfo.h glob.h iconv.h spawn.h sys/sem.h sys/shm.h; do
			ln -sf $TERMUX_PREFIX/include/$header $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$header
		done
		unset ANDROID_NDK_ROOT

		SWIFT_BUILD_FLAGS="$SWIFT_BUILD_FLAGS --android
		--android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $SWIFT_ARCH
		--build-toolchain-only --skip-local-build --skip-local-host-install
		--cross-compile-hosts=android-$SWIFT_ARCH
		--cross-compile-deps-path=$(dirname $TERMUX_PREFIX)
		--native-swift-tools-path=$SWIFT_BINDIR
		--native-clang-tools-path=$SWIFT_BINDIR
		--cross-compile-append-host-target-to-destdir=False"
	fi

	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
	$SWIFT_BUILD_FLAGS --xctest -b -p --swift-driver --sourcekit-lsp \
	--android-api-level $TERMUX_PKG_API_LEVEL --build-swift-static-stdlib \
	--swift-install-components=$SWIFT_COMPONENTS --llvm-install-components=IndexStore \
	--install-llvm --install-swift --install-libdispatch --install-foundation \
	--install-xctest --install-llbuild --install-swiftpm --install-swift-driver --install-sourcekit-lsp

	rm $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/{execinfo.h,glob.h,iconv.h,spawn.h,sys/sem.h,sys/shm.h}
	rm $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/swift
}

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/lib/swift{,_static}/{Block,os}
	rm $TERMUX_PREFIX/lib/swift{,_static}/dispatch/*.h
	rm $TERMUX_PREFIX/lib/swift/android/lib{dispatch,BlocksRuntime}.so
	mv $TERMUX_PREFIX/lib/swift/android/lib[^_]*.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib_FoundationICU.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib*.a $TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH
	mv $TERMUX_PREFIX/lib/swift_static/android/lib*.a $TERMUX_PREFIX/lib/swift_static/android/$SWIFT_ARCH

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		rm $TERMUX_PREFIX/swiftpm-android-$SWIFT_ARCH.json
	fi
}
