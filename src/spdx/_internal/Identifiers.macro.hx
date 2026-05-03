// SPDX-License-Identifier: Zlib
package spdx._internal;

import spdx.Exception;
import spdx.License;

using StringTools;

function sanitizeName(name: String): String {
    final sb = new StringBuf();
    for (i in 0...name.length) {
        final c = name.charCodeAt(i);
        if (c != null
            && ((c >= "a".code && c <= "z".code) || (c >= "A".code && c <= "Z".code)
                || (c >= "0".code && c <= "9".code) || c == "-".code || c == "_".code
                || c == " ".code)) {
            sb.addChar(c);
        }
    }
    return sb.toString();
}

function toScreamingSnakeCase(name: String): String {
    final sb = new StringBuf();
    var i = 0;
    for (part in name.replace("-", " ").trim().split(" ")) {
        if (part.length >= 1) {
            if (i > 0) {
                sb.add("_");
            }
            i += 1;
            sb.add(part.toUpperCase());
        }
    }
    return sb.toString();
}

function makeLicenseIdentifier(license: License): String {
    var name = license.id;
    if (name.toLowerCase().endsWith("license")) {
        name = name.substr(0, name.length - "license".length);
    }
    return mangleName(name);
}

function makeExceptionIdentifier(exception: Exception): String {
    var name = exception.id;
    name = name.replace("exception", " ");
    return mangleName(name);
}

function mangleName(name: String): String {

    var name = sanitizeName(
        name.replace("\"", " ")
            .replace(".", "_")
            .replace("+", " plus ")
            .replace("é", "e")
            .replace("&", "and"));
            
    name = toScreamingSnakeCase(name);
    if (name.charCodeAt(0) >= "0".code && name.charCodeAt(0) <= "9".code) {
        name = "_" + name;
    }
    
    return name;
}
