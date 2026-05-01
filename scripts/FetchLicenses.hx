// SPDX-License-Identifier: Zlib
package scripts;

import haxe.io.Path;
import sys.FileSystem;
import sys.Http;
import sys.io.File;

final class FetchLicenses {

    static final URL = "https://raw.githubusercontent.com/spdx/license-list-data/refs/heads/main/json/licenses.json";

    private static function main(): Void {

        trace("Fetching data from " + URL + "...");
        final json = Http.requestUrl(URL);
        trace("Downloaded data. Length: " + json.length);

        trace("Saving data...");
        final dir = Path.join([Sys.getCwd(), "data"]);
        FileSystem.createDirectory(dir);
        File.saveContent(Path.join([dir, "licenses.json"]), json);
    }
}
