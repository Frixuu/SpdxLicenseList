package spdx._internal;

import haxe.macro.Expr.MetadataEntry;
import haxe.macro.Expr.Position;

function deprecated(position: Position): MetadataEntry {
    return {
        pos: position,
        name: ":deprecated",
        params: [],
    };
}

function suppressDeprecated(position: Position): MetadataEntry {
    return {
        pos: position,
        name: ":haxe.warning",
        params: [
            {expr: EConst(CString("-WDeprecated")), pos: position}
        ],
    };
}
