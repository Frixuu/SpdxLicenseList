package spdx._internal;

using StringTools;

function mangleName(name: String, deprecated: Bool): String {

    var name = name.replace("-", "")
        .replace("–", "")
        .replace(".", "_")
        .replace(",", "")
        .replace("'", "") // AMD's plpa_map.c License
        .replace(":", "")
        .replace("+", " plus ")
        .replace("/", "")
        .replace("(", " ")
        .replace(")", " ")
        .replace("!", "") // Yahoo! Public License
        .replace("*", "") // Do What The F*ck You Want To Public License
        .replace("é", "e") // Licence Libre du Québec
        .replace("&", "and")
        .replace("\"", " ");
        
    if (name.endsWith("License")) {
        name = name.substr(0, name.length - "License".length);
    }
    
    final nameBuf = new StringBuf();
    for (part in name.trim().split(" ")) {
        if (part.length >= 1) {
            nameBuf.add("_");
            nameBuf.add(part.toUpperCase());
        }
    }
    
    // To avoid specific collisions (e.g. GPL+ vs GPL-or-later),
    // rename all deprecated licenses
    if (deprecated) {
        nameBuf.add("_");
    }
    
    var name = nameBuf.toString();
    if (name.charCodeAt(1) < "0".code || name.charCodeAt(1) > "9".code) {
        name = name.substr(1);
    }
    
    return name;
}
