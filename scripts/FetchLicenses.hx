// SPDX-License-Identifier: Zlib
package scripts;

import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;
import sys.Http;
import sys.io.File;

function saveJsonToDataFile(url: String, fileName: String): Void {

    trace('Fetching data from $url...');
    
    var ok = false;
    var json = "";
    while (!ok) {
        json = Http.requestUrl(url);
        trace('Downloaded data. (length: ${json.length})');
        try {
            Json.parse(json);
            ok = true;
        } catch (_e: Any) {
            trace("Data downloaded, but seems to be corrupted. Retrying...");
            Sys.sleep(0.5);
        }
    }
    
    trace('Saving data to $fileName...');
    final dir = Path.join([Sys.getCwd(), "data"]);
    FileSystem.createDirectory(dir);
    File.saveContent(Path.join([dir, fileName]), json);
}

function main(): Void {

    final repo = "https://raw.githubusercontent.com/spdx/license-list-data";
    final ref = "refs/heads/main";
    saveJsonToDataFile('$repo/$ref/json/licenses.json', "licenses.json");
    saveJsonToDataFile('$repo/$ref/json/exceptions.json', "exceptions.json");
}
