configHelp() {
    # Print help
    echo;
    echo "This script builds the rpm for a given Debian release"
    echo "It expects \$CHPL_RELEASE to be defined and \$DEBIAN_RELEASE to be"
    echo "defined or provided as command line argument"
    echo;
    echo "   ./<script> <release>"
    echo;
}


configSetup() {
    # Setup all the common variables and confirm inputs are defined

    # This variable is always read as an environment variable
    if [ -z ${CHPL_RELEASE} ]; then
        echo "\$CHPL_RELEASE is not defined"
        echo "Define via command line argument or environment variable"
        exit 1
    fi

    # This variable can be read as env var or passed as argument
    if [ -z ${DEBIAN_RELEASE} ]; then
        echo "\$DEBIAN_RELEASE is not defined as an environment variable"
        DEBIAN_RELEASE=`lsb_release -a | grep Codename | awk '{print $2}'`
        echo "Defining \$DEBIAN_RELEASE as:"
        echo "${DEBIAN_RELEASE}"
        export DEBIAN_RELEASE
    fi

    # Package specific
    PKG=chapel
    BINARY=chpl
    VERSION=1.13.0

    # Machine specific (generated dynamically)
    DEBIAN=1
    ARCH=amd64

    TARBALL=${PKG}-${VERSION}.tar.gz
    ORIG_TARBALL=${PKG}_${VERSION}.orig.tar.gz

    # Directories
    SRC=${CHPL_RELEASE}
    SRC_BASENAME=$(basename ${CHPL_RELEASE})
    SRC_DIRNAME=$(dirname ${CHPL_RELEASE})
    DEB_SRC=debian

    # Package Files
    BASENAME=${PKG}_${VERSION}-${DEBIAN}

    CHANGES=${BASENAME}_${ARCH}.changes
    DEB=${BASENAME}_${ARCH}.deb
    DEB_TAR=${BASENAME}.debian.tar.gz
    DSC=${BASENAME}.dsc
}

configClean() {
    # Clean up files generated by scripts

    # Create gzipped tarball from source
    safeClean ${TARBALL}

    # Generate template via bzr
    safeClean ${ORIG_TARBALL}
    safeClean ${PKG}

    ### debian files ###
    safeClean ${PKG}/debian

    # Clean package files
    safeClean ${CHANGES}
    safeClean ${DEB}
    safeClean ${DEB_TAR}
    safeClean ${DSC}
    safeClean build-area
}

safeClean() {
    # Safely cleanup directories and files
    if [ -z ${1} ]; then
        echo "Critical Error: internal variable undefined"
        exit 1
    else
        rm -rf ${1}
    fi
}
