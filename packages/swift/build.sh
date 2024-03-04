TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.2
SWIFT_RELEASE="DEVELOPMENT-SNAPSHOT-2024-12-22-a"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/swift-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=7de71bc811893dc318fa9bb41f44133c1d1c65c92e5a25c9cc75ca0dd80ecb4f
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
	library_checksums[sourcekit-lsp]=143bbcbb421b223e031f900dba8f02139900f40683b55e19d6267ddf5c86a262
	library_checksums[swift-lmdb]=530459b8be08c28f6384bfa0a0461432a615537d6fb0ab9059c0ad283fbbcb0d
	library_checksums[swift-corelibs-xctest]=413b2a88e5c35ef8b65519a56863a1f1373dfaff2a23fcec5a1953be622d4745
	library_checksums[swift-corelibs-foundation]=99e8bc1b69bb19c0f9fd05074beb6589fc17b9b3a9b1e3657cebba83f064eb69
	library_checksums[swift-collections]=7e5e48d0dc2350bed5919be5cf60c485e72a30bd1f2baf718a619317677b91db
	library_checksums[swift-driver]=23ea0c630c623c8344a5aa5493449c735d9ccf2f584f69cbcab1173901531a7e
	library_checksums[swift-foundation]=787d2e7f4e3235da0075540f6802689a89af6e6a40f7eb19e188513820d20992
	library_checksums[swift-toolchain-sqlite]=c8704e70c4847a8dbd47aafb25d293fbe1e1bafade16cfa64e04f751e33db0ca
	library_checksums[swift-argument-parser]=d5bad3a1da66d9f4ceb0a347a197b8fdd243a91ff6b2d72b78efb052b9d6dd33
	library_checksums[swift-syntax]=d9606c8ae6e2f5565ba30baa0f3b6d4314f9729288adfa697bffd78fd43b28c6
	library_checksums[swift-llbuild]=3da1f3d02e76f950cce093c0f595d4da109112908e4b80a79058b470f7c6ffa3
	library_checksums[swift-corelibs-libdispatch]=43ae198cd698ff33342f1f42db21510fb88f953d36b5fe4ffbee173fb366ce92
	library_checksums[swift-foundation-icu]=dccd80254f1b068a979b16d58eebcf16c1e3bc0139842664a718cfd6296819a5
	library_checksums[swift-system]=02e13a7f77887c387f5aa1de05f4d4b8b158c35145450e1d9557d6c42b06cd1f
	library_checksums[swift-asn1]=e0da995ae53e6fcf8251887f44d4030f6600e2f8f8451d9c92fcaf52b41b6c35
	library_checksums[swift-tools-support-core]=0ddded36c8c46d2fc5a5303ba6f452a1d7c98c8bca90035aa5f48b5483a976b9
	library_checksums[swift-package-manager]=f4e5697e0461aa3fb25253f036149def74844fe9bea71f94edd3377e152dd203
	library_checksums[swift-cmark]=9d33f46013048524969d82ab74367dbd79ccd66edc3d8995c0b7c399a76e9858
	library_checksums[indexstore-db]=9b5122c8fe08bbc343eaa6baf704eed8c9a9bf3a24506d74c04e9baef1ea5d6c
	library_checksums[swift-certificates]=fcaca458aab45ee69b0f678b72c2194b15664cc5f6f5e48d0e3f62bc5d1202ca
	library_checksums[swift-crypto]=5c860c0306d0393ff06268f361aaf958656e1288353a0e23c3ad20de04319154
	library_checksums[llvm-project]=38e4361fba6032af7ccd3e78f9292061dab444f77afdd549163bce6365cdb60c
	library_checksums[swift-experimental-string-processing]=7063cf61f7b7c14784a812e8ae9c46dbeef2c8a2e65eff02c9ab2e482d7f28c5
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
