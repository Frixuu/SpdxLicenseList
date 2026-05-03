// SPDX-License-Identifier: Zlib
package spdx._internal;

typedef Item = {
    reference: String,
    name: String,
    detailsUrl: String,
    referenceNumber: Int,
    isDeprecatedLicenseId: Bool,
    seeAlso: Array<String>,
}

typedef Collection = {
    licenseListVersion: String,
    releaseDate: String,
}

typedef License = {
    > Item,
    licenseId: String,
    isOsiApproved: Bool,
    isFsfLibre: Null<Bool>,
}

typedef LicenseData = {
    > Collection,
    licenses: Array<License>,
}

typedef Exception = {
    > Item,
    licenseExceptionId: String,
}

typedef ExceptionData = {
    > Collection,
    exceptions: Array<Exception>,
}
