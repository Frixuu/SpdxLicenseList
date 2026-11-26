// SPDX-License-Identifier: Zlib
package spdx;

/**
    An expression describing a single license.
**/
enum LicenseExpr {

    /**
        A well-known license that is listed on the SPDX License list.
        @param license The license object.
        @param orAnyLater Use of any later version of this license is permitted (non-GNU only.)
    **/
    Defined(license: License, orAnyLater: Bool);
    
    /**
        A custom, user-defined license, not present on the SPDX License list.
        @param documentRef (Optional) A reference to a document.
        @param licenseRef A reference to a license.
    **/
    Ref(documentRef: Null<String>, licenseRef: String);
    // ------------------------
    // No license is present.
    // None; // part of proposed spec v3.1
    // ------------------------
    // The data creator either could not determine the license
    // or they intentionally did not provide it.
    // NoAssertion; // part of proposed spec v3.1
    // ------------------------
}

/**
    An expression describing a single license addition.
**/
enum ExceptionExpr {

    /**
        A well-known license exception listed on the SPDX Exceptions list.
        @param exception The exception object.
    **/
    Defined(exception: Exception);
    
    /**
        A custom, user-defined addition, not present on the SPDX Exceptions list.
        @param documentRef (Optional) A reference to a document.
        @param additionRef A reference to an addition.
    **/
    Ref(documentRef: Null<String>, additionRef: String);
}

/**
    A license expression describes the licensing terms of software.
**/
enum Expression {

    /**
        A simple license expression, such as a single license identifier.
    **/
    Simple(licenseExpr: LicenseExpr);
    
    /**
        Licensee may apply additional text.
    **/
    With(licenseExpr: LicenseExpr, exceptionExpr: ExceptionExpr);
    
    /**
        Licensee may choose between different licenses.
    **/
    Or(left: Expression, right: Expression);
    
    /**
        Licensee must simultaneously comply with multiple licenses.
    **/
    And(left: Expression, right: Expression);
}
