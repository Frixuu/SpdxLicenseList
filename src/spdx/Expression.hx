// SPDX-License-Identifier: Zlib
package spdx;

enum LicenseExpr {
    Defined(license: License, orAnyLater: Bool);
    Ref(document: Null<String>, license: String);
}

enum ExceptionExpr {
    Defined(exception: Exception);
    Ref(document: Null<String>, addition: String);
}

enum Expression {
    Simple(license: LicenseExpr);
    With(license: LicenseExpr, exception: ExceptionExpr);
    Or(left: Expression, right: Expression);
    And(left: Expression, right: Expression);
}
