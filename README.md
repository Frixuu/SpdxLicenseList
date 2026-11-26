# SPDX License List for Haxe

This library provides a **partial** view of the [SPDX License List](https://spdx.org/licenses/).
Notably, it aims to include canonical names and short identifiers
of all of the licenses on the list, but not their full text.

Current list version: 3.29.0 (2026-09-16).

## Usage

```haxe
import spdx.License;

var license1: License = License.MIT;
var license2: Null<License> = License.getById("GPL-3.0-or-later");
var license3: Null<License> = License.getByName("Mozilla Public License 2.0");

trace(license1.name);          // "MIT License"
trace(license1.id);            // "MIT"
trace(license1.isDeprecated);  // false
trace(license1.isOsiApproved); // true
trace(license1.isFsfLibre);    // true
```

```haxe
import spdx.Expression;
import spdx.ExpressionTools;

var expr1: Null<Expression> = ExpressionTools.parse("MIT OR Apache-2.0");
var expr2: Null<Expression> = ExpressionTools.parse("Beerware WITH Bootloader-exception");

function matches(expr: Null<Expression>): Bool {
    return switch expr {
        case null: false;
        case Simple(licenseExpr):
            switch (licenseExpr) {
                // Known, precise license in a curated set.
                case Defined(license, orAnyLater): license.isFsfLibre;
                // Custom license with a user-defined identifier.
                case Ref(documentName, licenseName): false;
            };
        case Or(left, right): matches(left) || matches(right);
        case And(left, right): matches(left) && matches(right);
        case With(licenseExpr, exceptionExpr):
            // The licensee may optionally apply the exception.
            matches(Expression.Simple(licenseExpr));
    };
}

trace(matches(expr1)); // true
trace(matches(expr2)); // false
```

## Notices

"SPDX®" is a registered trademark of the Linux Foundation in the United States.

SPDX specification is provided under ["Creative Commons Attribution License 3.0 Unported"](https://spdx.github.io/spdx-spec/v2.3/creative-commons-attribution-license-3.0-unported/) (SPDX: `CC-BY-3.0`).
