#!/bin/bash -e
. ../../../blfs.comm

build_src() {
srcfil=URI-1.65.tar.gz
srcdir=URI-1.65
build_standard_perl_module
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Uniform Resource Identifiers (absolute and relative)
 This module implements the URI class. Objects of this class represent
 "Uniform Resource Identifier references" as specified in RFC 2396 (and
 updated by RFC 2732). A Uniform Resource Identifier is a compact string of
 characters that identifies an abstract or physical resource. A Uniform
 Resource Identifier can be further classified as either a Uniform Resource
 Locator (URL) or a Uniform Resource Name (URN). The distinction between URL
 and URN does not matter to the URI class interface. A "URI-reference" is a
 URI that may have additional information attached in the form of a fragment
 identifier.
EOF
}

build
