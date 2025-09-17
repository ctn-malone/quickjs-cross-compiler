Cross compile [QuickJS](https://bellard.org/quickjs/quickjs.html) interpreter & compiler statically. Resulting [QuickJS](https://github.com/ctn-malone/quickjs-cross-compiler) compiler also generates *static* binaries based on [musl libc](https://musl.libc.org/)

Following target architectures are supported

* x86_64
* i686
* armv7l
* aarch64

Cross compilation is performed using [musl.cc](https://github.com/ctn-malone/musl-cross-maker) static compilers (which means you should be able to generate a portable package of *QuickJS* from any recent *x86_64* Linux distribution with *gcc*)

Final portable version should weight around 7MB (after decompression)

Static compiler should work with any Linux distribution with *gcc* >= `4.3.2` and *binutils* >= `2.25`

By default, packages will be exported to `packages` directory, at the root of the repository

Don't forget to check the [qjs-ext-lib](https://github.com/ctn-malone/qjs-ext-lib) repo which provides some
wrappers around common unix tools to do HTTP requests or execute external programs (and more) 😊

**Table of content**
- [Extra functions](#extra-functions)
  - [os.flock](#osflock)
  - [os.mkstemp](#osmkstemp)
  - [os.mkdtemp](#osmkdtemp)
- [Other changes](#other-changes)
- [Generate a portable package using *Docker*](#generate-a-portable-package-using-docker)
- [Generate a portable package without using *Docker*](#generate-a-portable-package-without-using-docker)
- [Using the portable compiler](#using-the-portable-compiler)
- [Nix](#nix)
- [Embed custom javascript modules](#embed-custom-javascript-modules)
- [Embed QuickJS extension library](#embed-quickjs-extension-library)
- [Limitations](#limitations)

# Extra functions

Some extra functions not part of [vanilla QuickJS](https://bellard.org/quickjs/quickjs.html) have been added

## os.flock

`os.flock(fd, operation)`

See https://linux.die.net/man/2/flock

<u>Example</u>

```
const fd = os.open('/tmp/lock', os.O_RDWR | os.O_CREAT, 0o644);
// code will block until no other process is accessing the file
os.flock(fd, os.LOCK_EX);
```

## os.mkstemp

`os.mkstemp(template, outputObj)`

See https://man7.org/linux/man-pages/man3/mkstemp.3.html

<u>Example</u>

```
const outputObj = {};
// template MUST end with XXXXXX
const fd = os.mkstemp('/tmp/randomXXXXXX', outputObj);
std.puts(outputObj.filename)
```

## os.mkdtemp

`os.mkdtemp(template, errObj)`

See https://man7.org/linux/man-pages/man3/mkdtemp.3.html

<u>Example</u>

```
const errObj = {};
// template MUST end with XXXXXX
const dirname = os.mkdtemp('/tmp/randomXXXXXX', errObj);
std.puts(dirname)
```

# Other changes

- improve `js_os_exec` performances by computing `fd_max` using `/proc`

# Generate a portable package using *Docker*

<u>NB</u> : This is the recommended way

A portable package containing interpreter & compiler can be generated using `docker/build_and_export_qjs.sh` script

```
./docker/build_and_export_qjs.sh -h
Build a static version of QuickJS (interpreter & compiler)
Usage: ./docker/build_and_export_qjs.sh [-p|--packages-dir <arg>] [-a|--arch <type string>] [--(no-)ext-lib] [--ext-lib-version <arg>] [-e|--extra-dir <arg>] [--(no-)force-build-image] [-v|--(no-)verbose] [-u|--(no-)upx] [-h|--help] [<qjs-version>]
        <qjs-version>: QuickJS version (ex: 2020-09-06) (default: '2025-09-13')
        -p, --packages-dir: directory where package will be exported (default: './packages')
        -a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')
        --ext-lib, --no-ext-lib: add QuickJS extension library (off by default)
        --ext-lib-version: QuickJS extension library version (default: '0.15.3')
        -e, --extra-dir: extra directory to add into package (empty by default)
        --force-build-image, --no-force-build-image: force rebuilding docker image (off by default)
        -v, --verbose, --no-verbose: enable verbose mode (off by default)
        -u, --upx, --no-upx: compress binaries using upx (on by default)
        -h, --help: Prints help
```

<u>Examples</u>

```
./docker/build_and_export_qjs.sh -v
```

Above command will :

* build a *Docker* image (only if it does not already exist) which will download and build necessary dependencies
* run a temporary container and :
  * enable verbose mode inside the container
  * build *default* *QuickJS* version (`2025-09-13` as of 2025-09-13) for *default* architecture (`x86_64`)
  * export portable package to *default* location (`packages` directory at the root of the repository)

```
for arch in x86_64 i686 armv7l aarch64 ; do ./docker/build_and_export_qjs.sh -va ${arch} ; done
```

Same as previous command but will build packages for multiple target architectures

# Generate a portable package without using *Docker*

A portable package containing interpreter & compiler can be generated using `builder/build_and_export_qjs.sh` script

```
./builder/build_and_export_qjs.sh -h
Build a static version of QuickJS (interpreter & compiler)
Usage: ./builder/build_and_export_qjs.sh [-p|--packages-dir <arg>] [--deps-dir <arg>] [-a|--arch <type string>] [--(no-)ext-lib] [--ext-lib-version <arg>] [-e|--extra-dir <arg>] [--(no-)force-fetch-deps] [--(no-)force-build-deps] [--(no-)force-checkout-qjs] [--(no-)force-build-qjs] [-v|--(no-)verbose] [-u|--(no-)upx] [-h|--help] [<qjs-version>]
        <qjs-version>: QuickJS version (ex: 2020-09-06) (default: '2025-09-13')
        -p, --packages-dir: directory where package will be exported (default: './packages')
        --deps-dir: directory where dependencies should be stored/buil (default: './deps')
        -a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')
        --ext-lib, --no-ext-lib: add QuickJS extension library (off by default)
        --ext-lib-version: QuickJS extension library version (default: '0.15.3')
        -e, --extra-dir: extra directory to add into package (empty by default)
        --force-fetch-deps, --no-force-fetch-deps: force re-fetching dependencies (off by default)
        --force-build-deps, --no-force-build-deps: force rebuild of dependencies (off by default)
        --force-checkout-qjs, --no-force-checkout-qjs: clone repository even if it exists (off by default)
        --force-build-qjs, --no-force-build-qjs: force rebuild of QuickJS (off by default)
        -v, --verbose, --no-verbose: enable verbose mode (off by default)
        -u, --upx, --no-upx: compress binaries using upx (on by default)
        -h, --help: Prints help
```

<u>Examples</u>

```
./builder/build_and_export_qjs.sh
```

Above command will :

* download and build necessary dependencies under *default* location (`deps` directory at the root of the repository)
* build *default* *QuickJS* version (`2025-09-13` as of 2024-01-14) for *default* architecture (`x86_64`)
* export portable package to *default* location (`packages` directory at the root of the repository)

```
./builder/build_and_export_qjs.sh '2025-09-13' -a armv7l -p /usr/local/packages -d /usr/local/deps -v
```

Above command will :

* build *QuickJS* version `2025-09-13` for `armv7l` architecture
* download and build necessary dependencies under `/usr/local/deps`
* export portable package to `/usr/local/packages`
* enable verbose mode

# Using the portable compiler

Assuming [package](https://github.com/ctn-malone/quickjs-cross-compiler/releases) was decompressed under `/usr/local/quickjs`, just run `/usr/local/quickjs/qjsc.sh` to compile a `.js` file

<u>Example `hello.js` file</u>

```javascript
import * as std from "std";

let name = 'world';
if (undefined !== scriptArgs[1]) {
    name = scriptArgs[1];
}
console.log(`Hello ${name} !`);

while (true) {
    console.log(`Type 'exit' to exit script`);
    const str = std.in.getline();
    if ('exit' == str) {
        break;
    }
}   
console.log(`Goodbye ${name}!`);
```

File can be compiled using

```
/usr/local/quickjs/qjsc.sh -o hello hello.js
```

```
ls -l hello
-rwxrwxr-x 1 user user 899160 oct.  19 15:32 hello
```

```
file hello
hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, stripped
```

```
ldd hello
        not a dynamic executable
```

<u>NB</u> : if [upx](https://upx.github.io/) exists, resulting binary will be automatically compressed (unless `QJS_UPX` environment variable is set to `0`)

# Nix

In order to get a shell with interpreter (`qjs.sh`) and compiler (`qjsc.sh`), run following command

```
nix develop github:ctn-malone/quickjs-cross-compiler
```

Following commands can also be used to run `qjs.sh` or `qjsc.sh` using `nix run`

- run `qjs.sh`

```
nix run github:ctn-malone/quickjs-cross-compiler
```

- run `qjsc.sh`

```
nix run github:ctn-malone/quickjs-cross-compiler#qjsc
```

# Embed custom javascript modules

Starting from release `2020-11-08_2`, any javascript file placed alongside `qjs` & `qjsc` binaries can be referenced relatively from your main script.
This allows to bundle adhoc packages containing javascript modules (argument parsing, ...) which can be shared across various scripts

<u>Example</u>

For a package containing an `ext` directory alongside `qjs` & `qjsc` binaries, file `ext/myExt.js` can be imported from any script using `import * as myExt from 'ext/myExt.js';`

```
.
├── [4.0K]  examples
├── [4.0K]  ext
│   └── [ 335]  myExt.js
├── [1.2M]  libquickjs.a
├── [4.0K]  musl-x86_64
│   │   └...
│   └── [4.0K]  lib
│       └...
├── [938K]  qjs
├── [894K]  qjsc
├── [ 364]  qjsc.sh
├── [ 425]  qjs.sh
├── [ 40K]  quickjs.h
└── [2.5K]  quickjs-libc.h
```

*ext/myExt.js*
```javascript
const sayHello = (name) => {
    console.log(`Hello ${name}`);
}

const WEEKDAYS = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
const sayWeekday = () => {
    const date = new Date();
    const wday = WEEKDAYS[date.getDay()];
    console.log(`Today is ${wday}`);
}

export default {
    sayHello:sayHello,
    sayWeekday:sayWeekday
}
export { sayHello, sayWeekday };
```

*myScript.js*
```javascript
import {sayHello, sayWeekday} from 'ext/myExt.js';
sayHello('John Doe');
sayWeekday();
```

Both interpreter & compiler will first try to resolve import relatively to current directory and fallback to the directory containing `qjs` & `qjsc` binaries (or the directory defined using `QJS_LIB_DIR` environment variable)

<u>NB</u> : fallback will only work when calling `qjs` & `qjsc` using their **absolute path** or through their corresponding **`sh` wrappers**

Directories can be added to the package using argument `(--extra-dir, -e)` when calling `build_and_export_qjs.sh` script

<u>Examples</u>

```
./builder/build_and_export_qjs.sh -e /tmp/ext1 -e /tmp/ext2
```

Above command will copy `/tmp/ext1` & `/tmp/ext2` directories at the root of the package

```
./builder/build_and_export_qjs.sh -e /tmp/ext1:ext -e /tmp/ext2:ext
```

Above command will copy **the content** of `/tmp/ext1` & `/tmp/ext2` directories into an `ext` subdirectory at the root of the package

# Embed QuickJS extension library

When using flag `--ext-lib`, [QuickJS extension library](https://github.com/ctn-malone/qjs-ext-lib) will be added to the package under `ext` directory

This library contains a set of JS module to make creating static adhoc scripts easier

# Limitations

*QuickJS* is built without *LTO* support since `-flto` flag does not work when the host running `qjsc` is not using the same *gcc* bytecode version as the one used by the host where `qjsc` was compiled, resulting in a message such as below

```
lto1: fatal error: bytecode stream in file ‘/usr/local/bin/quickjs/libquickjs.lto.a’ generated with LTO version 7.1 instead of the expected 6.0
```
