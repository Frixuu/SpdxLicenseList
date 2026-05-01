// SPDX-License-Identifier: Zlib
package spdx._internal;

typedef License = {
    reference: String,
    isDeprecatedLicenseId: Bool,
    detailsUrl: String,
    referenceNumber: Int,
    name: String,
    licenseId: String,
    seeAlso: Array<String>,
    isOsiApproved: Bool,
    isFsfLibre: Null<Bool>,
};

typedef LicenseData = {
    licenses: Array<License>,
    licenseListVersion: String,
    releaseDate: String,
}
