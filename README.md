# SPDX License List for Haxe

This library provides a **partial** view of the [SPDX License List](https://spdx.org/licenses/). Notably, it aims to include canonical names and short identifiers of all of the licenses on the list, but not their full text.

Current list version: 3.28.0 (2026-02-20).

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

## Notices

"SPDX®" is a registered trademark of the Linux Foundation in the United States.

SPDX specification is provided under ["Creative Commons Attribution License 3.0 Unported"](https://spdx.github.io/spdx-spec/v2.3/creative-commons-attribution-license-3.0-unported/) (SPDX: `CC-BY-3.0`).
