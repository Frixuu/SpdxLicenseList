// SPDX-License-Identifier: Zlib
package spdx;

import haxe.ValueException;
import haxe.ds.ReadOnlyArray;
import spdx.Expression.ExceptionExpr;
import spdx.Expression.LicenseExpr;

using StringTools;

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

    private static function toToken(name: String): Token {
        return switch name.toLowerCase() {
            case "and":
                Token.OpAnd;
            case "or":
                Token.OpOr;
            case "with":
                Token.OpWith;
            case _:
                Token.Identifier(name);
        }
    }

    private static function tokenize(source: String): Array<Token> {

        final tokens: Array<Token> = [];
        var identStart: Null<Int> = null;
        var index = 0;

        while (true) {

            if (index >= source.length) {
                if (identStart != null) {
                    tokens.push(Token.Identifier(source.substring(identStart)));
                }
                break;
            }

            final char = source.charCodeAt(index);
            if (identStart == null) {
                if (char == " ".code) {
                    // ignore whitespace
                } else if (char == "(".code) {
                    tokens.push(Token.OpenParen);
                } else if (char == ")".code) {
                    tokens.push(Token.CloseParen);
                } else {
                    identStart = index;
                }
            } else {
                if (char == " ".code) {
                    final name = source.substring(identStart, index);
                    tokens.push(toToken(name));
                    identStart = null;
                } else if (char == "+".code) {
                    tokens.push(Token.Identifier(source.substring(identStart, index)));
                    tokens.push(Token.OpPlus);
                    identStart = null;
                } else if (char == ")".code) {
                    tokens.push(Token.Identifier(source.substring(identStart, index)));
                    tokens.push(Token.CloseParen);
                    identStart = null;
                }
            }

            index += 1;
        }

        return tokens;
    }

    /**
        Parses an expression from a string.
        @param source The source string.
        @return The parsed expression, or `null` if the string is not a valid expression.
    **/
    public static function parse(source: String): Null<Expression> {
        final tokens = tokenize(source);
        try {
            return parseImpl(tokens);
        } catch (e: ValueException) {
            return null;
        }
    }

    /**
        Parses an expression from a string.
        @param source The source string.
        @return The parsed expression. Throws a `haxe.ValueException` if the string is not a valid expression.
    **/
    public static function mustParse(source: String): Expression {
        final tokens = tokenize(source);
        return parseImpl(tokens);
    }

    private static function isValidIdentifier(name: String): Bool {
        static final pattern = ~/^[a-zA-Z0-9\-\.]{1,}$/;
        return pattern.match(name);
    }

    private static function parseLicenseExpr(name: String, plus: Bool): Null<LicenseExpr> {
        if (name.contains("LicenseRef-")) {

            if (plus) {
                return null;
            }

            final parts = name.split(":");
            if (parts.length > 2) {
                return null;
            }

            var document: Null<String> = null;
            if (parts.length == 2) {
                document = parts[0];
                if (!document.startsWith("DocumentRef-")) {
                    return null;
                }
                document = document.substring("DocumentRef-".length);
                if (document.length == 0) {
                    return null;
                }
            }

            var license = if (parts.length == 2) {
                parts[1];
            } else {
                parts[0];
            };
            if (!license.startsWith("LicenseRef-")) {
                return null;
            }
            license = license.substring("LicenseRef-".length);
            if (license.length == 0) {
                return null;
            }

            return Ref(document, license);
        } else {
            final license = License.getById(name);
            if (license == null) {
                return null;
            } else {
                return Defined(license, plus);
            }
        }
    }

    private static function parseExceptionExpr(name: String): Null<ExceptionExpr> {
        if (name.contains("AdditionRef-")) {

            final parts = name.split(":");
            if (parts.length > 2) {
                return null;
            }

            var document: Null<String> = null;
            if (parts.length == 2) {
                document = parts[0];
                if (!document.startsWith("DocumentRef-")) {
                    return null;
                }
                document = document.substring("DocumentRef-".length);
                if (document.length == 0) {
                    return null;
                }
            }

            var exception = if (parts.length == 2) {
                parts[1];
            } else {
                parts[0];
            };
            if (!exception.startsWith("AdditionRef-")) {
                return null;
            }
            exception = exception.substring("AdditionRef-".length);
            if (exception.length == 0) {
                return null;
            }

            return Ref(document, exception);
        } else {
            final exception = Exception.getById(name);
            if (exception == null) {
                return null;
            } else {
                return Defined(exception);
            }
        }
    }

    @SuppressWarnings("checkstyle:CyclomaticComplexity", "checkstyle:NestedControlFlow")
    private static function parseImpl(tokens: ReadOnlyArray<Token>): Expression {

        var index = 0;
        final stack: Array<Expression> = [];

        while (index < tokens.length) {

            final token = tokens[index];
            index += 1;

            switch token {
                case Token.OpenParen:
                    var depth = 1;
                    var indexClose = index;
                    while (indexClose < tokens.length) {
                        final next = tokens[indexClose];
                        indexClose += 1;
                        switch next {
                            case Token.OpenParen:
                                depth += 1;
                            case Token.CloseParen:
                                depth -= 1;
                                if (depth == 0) {
                                    break;
                                }
                            case _:
                        }
                    }
                    if (depth != 0) {
                        throw "unclosed parenthesis";
                    } else {
                        final expr = parseImpl(tokens.slice(index, indexClose - 1));
                        index = indexClose;
                        if (stack.length == 0) {
                            stack.push(expr);
                        } else {
                            final last = stack.pop();
                            switch last {
                                case Simple(license):
                                    throw 'unexpected parenthesis: first ${stringifyLicenseExpr(license)}, then (${stringify(expr)})';
                                case And(left, null):
                                    stack.push(And(left, expr));
                                case Or(left, null):
                                    stack.push(Or(left, expr));
                                case _:
                                    throw 'unexpected parenthesis $expr';
                            }
                        }
                    }

                case Token.CloseParen:
                    throw "unexpected closing parenthesis";
                case Token.OpPlus:
                    throw "unexpected binop +";
                case Token.OpAnd:
                    if (stack.length >= 1) {
                        stack.push(And(stack.pop(), null));
                    } else {
                        throw "unexpected AND without left operand";
                    }
                case Token.OpOr:
                    if (stack.length >= 1) {
                        stack.push(Or(stack.pop(), null));
                    } else {
                        throw "unexpected OR without left operand";
                    }
                case Token.OpWith:
                    if (stack.length >= 1) {
                        final last = stack.pop();
                        switch last {
                            case Simple(license):
                                stack.push(With(license, null));
                            case _:
                                throw 'left operand of WITH was expected to be a license, got $last';
                        }
                    } else {
                        throw "unexpected WITH without left operand";
                    }
                case Token.Identifier(name):
                    final orLater = if (index < tokens.length && tokens[index] == Token.OpPlus) {
                        index += 1;
                        true;
                    } else {
                        false;
                    };

                    if (stack.length >= 1) {
                        final last = stack.pop();
                        switch last {
                            case Simple(license):
                                throw 'two identifiers in a row: first ${stringifyLicenseExpr(license)}, then "$name"';
                            case And(left, null):
                                final expr = parseLicenseExpr(
                                    name,
                                    orLater
                                ) ?? throw '"$name" is not a valid license';
                                stack.push(And(left, Simple(expr)));
                            case Or(left, null):
                                final expr = parseLicenseExpr(
                                    name,
                                    orLater
                                ) ?? throw '"$name" is not a valid license';
                                stack.push(Or(left, Simple(expr)));
                            case With(license, null):
                                if (orLater) {
                                    throw 'unexpected binop + after exception name "$name"';
                                }
                                final expr = parseExceptionExpr(
                                    name
                                ) ?? throw '$name is not a valid exception';
                                stack.push(With(license, expr));
                            case _:
                                throw 'unexpected identifier "$name"';
                        }
                    } else {
                        final expr = parseLicenseExpr(
                            name,
                            orLater
                        ) ?? throw '"$name" is not a valid license';
                        stack.push(Simple(expr));
                    }
            }
        }

        return if (stack.length == 1) {
            stack[0];
        } else {
            if (stack.length == 0) {
                throw "empty expression";
            } else {
                throw 'unexpected end of expression. stack (length ${stack.length}): ${stack.map(e -> Std.string(e)).join(", ")}';
            }
        };
    }
}

private enum Token {
    Identifier(name: String);
    OpPlus;
    OpAnd;
    OpOr;
    OpWith;
    OpenParen;
    CloseParen;
}
