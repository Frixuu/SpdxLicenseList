// SPDX-License-Identifier: Zlib
package spdx;

import spdx.Expression.ExceptionExpr;
import spdx.Expression.LicenseExpr;

final class ExpressionTools {

    private static function stringifyLicenseExpr(expr: LicenseExpr): String {
        return switch expr {
            case Defined(license, orAnyLater):
                '${license.id}${orAnyLater ? "+" : ""}';
            case Ref(document, license):
                '${document != null ? 'DocumentRef-$document:' : ""}LicenseRef-$license';
        };
    }

    private static function stringifyExceptionExpr(expr: ExceptionExpr): String {
        return switch expr {
            case Defined(exception):
                exception.id;
            case Ref(document, addition):
                '${document != null ? 'DocumentRef-$document:' : ""}AdditionRef-$addition';
        };
    }

    /**
        Converts an expression to a string.
        @param expr The expression to convert.
        @return The string representation of the expression.
    **/
    public static function stringify(expr: Expression): String {
        return switch expr {
            case Simple(license):
                stringifyLicenseExpr(license);
            case With(license, exception):
                '${stringifyLicenseExpr(license)} WITH ${stringifyExceptionExpr(exception)}';
            case Or(left, right):
                '${stringify(left)} OR ${stringify(right)}';
            case And(left, right):
                final a = if (left.match(Or(_, _))) '(${stringify(left)})' else stringify(left);
                final b = if (right.match(Or(_, _))) '(${stringify(right)})' else stringify(right);
                '$a AND $b';
        }
    }
}
