Cross compile [QuickJS](https://github.com/bellard/quickjs) interpreter & compiler statically. Resulting [QuickJS](https://github.com/bellard/quickjs) compiler also generates *static* binaries based on [musl libc](https://musl.libc.org/)

Following target architectures are supported

* x86_64
* i686
* armv7l

Cross compilation is performed using [musl.cc](https://musl.cc/) static compilers (which means you should be able to generate a portable package of *QuickJS* from any recent *x86_64* Linux distribution with *gcc*)

Final portable version should weight around 7MB (after decompression)

Static compiler should work with any Linux distribution with *gcc* >= `4.3.2`

**Table of content**
- [Generate a portable package without using Docker](#generate-a-portable-package-without-using-docker)
- [Generate a portable package using Docker](#generate-a-portable-package-using-docker)
- [Using the portable compiler](#using-the-portable-compiler)
- [Limitations](#limitations)

# Generate a portable package using *Docker*

<u>NB</u> : This is the recommended way

A portable package containing interpreter & compiler can be generated using `docker/build_and_export_qjs.sh` script

```
./docker/build_and_export_qjs.sh -h
Build a static version of QuickJS (interpreter & compiler)
Usage: ./docker/build_and_export_qjs.sh [-p|--packages-dir <arg>] [-a|--arch <type string>] [--(no-)force-build-image] [-v|--(no-)verbose] [-h|--help] [<qjs-version>]
        <qjs-version>: QuickJS version (ex: 2020-09-06) (default: '2020-09-06')
        -p, --packages-dir: directory where package will be exported (default: '/usr/local/src/quickjs-cross-compiler/docker/../packages')
        -a, --arch: target architecture. Can be one of: 'x86_64', 'i686' and 'armv7l' (default: 'x86_64')
        --force-build-image, --no-force-build-image: force rebuilding docker image (off by default)
        -v, --verbose, --no-verbose: enable verbose mode (off by default)
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
  * build *default* *QuickJS* version (`2020-09-06` as of 2020-10-04) for *default* architecture (`x86_64`)
  * export portable package to *default* location (`packages` directory at the root of the repository)

```
for arch in x86_64 i686 armv7l ; do ./docker/build_and_export_qjs.sh -va ${arch} ; done
```

Same as previous command but will build packages for multiple target architectures

# Generate a portable package without using *Docker*

A portable package containing interpreter & compiler can be generated using `builder/build_and_export_qjs.sh` script

```
./builder/build_and_export_qjs.sh -h
Build a static version of QuickJS (interpreter & compiler)
Usage: ./builder/build_and_export_qjs.sh [-p|--packages-dir <arg>] [--deps-dir <arg>] [-a|--arch <type string>] [--(no-)force-fetch-deps] [--(no-)force-build-deps] [--(no-)force-checkout-qjs] [--(no-)force-build-qjs] [-v|--(no-)verbose] [-h|--help] [<qjs-version>]
        <qjs-version>: QuickJS version (ex: 2020-09-06) (default: '2020-09-06')
        -p, --packages-dir: directory where package will be exported (default: '/usr/local/src/quickjs-cross-compiler/builder/../packages')
        --deps-dir: directory where dependencies should be stored/buil (default: '/usr/local/src/quickjs-cross-compiler/builder/../deps')
        -a, --arch: target architecture. Can be one of: 'x86_64', 'i686' and 'armv7l' (default: 'x86_64')
        --force-fetch-deps, --no-force-fetch-deps: force re-fetching dependencies (off by default)
        --force-build-deps, --no-force-build-deps: force rebuild of dependencies (off by default)
        --force-checkout-qjs, --no-force-checkout-qjs: clone repository even if it exists (off by default)
        --force-build-qjs, --no-force-build-qjs: force rebuild of QuickJS (off by default)
        -v, --verbose, --no-verbose: enable verbose mode (off by default)
        -h, --help: Prints help
```

<u>Examples</u>

```
./builder/build_and_export_qjs.sh
```

Above command will :

* download and build necessary dependencies under *default* location (`deps` directory at the root of the repository)
* build *default* *QuickJS* version (`2020-09-06` as of 2020-10-04) for *default* architecture (`x86_64`)
* export portable package to *default* location (`packages` directory at the root of the repository)

```
./builder/build_and_export_qjs.sh '2020-09-06' -a armv7l -p /usr/local/packages -d /usr/local/deps -v
```

Above command will :

* build *QuickJS* version `2020-09-06` for `armv7l` architecture
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

# Limitations

*QuickJS* is built without *LTO* support since `-flto` flag does not work when the host running `qjsc` is not using the same *gcc* bytecode version as the one used by the host where `qjsc` was compiled, resulting in a message such as below

```
lto1: fatal error: bytecode stream in file ‘/usr/local/bin/quickjs/libquickjs.lto.a’ generated with LTO version 7.1 instead of the expected 6.0
```
