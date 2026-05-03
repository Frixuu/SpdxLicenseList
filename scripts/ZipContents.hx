package scripts;

function main(): Void {

    Sys.command("zip", [
        "-r",
        DateTools.format(Date.now(), "spdx-%Y%m%d-%H%M%S.zip"),
        "data",
        "src",
        "extraParams.hxml",
        "haxelib.json",
        "README.md",
    ]);
}
