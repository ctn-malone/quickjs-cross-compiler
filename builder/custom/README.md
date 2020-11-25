Cross compile [QuickJS](https://github.com/bellard/quickjs) interpreter & compiler statically. Resulting [QuickJS](https://github.com/bellard/quickjs) compiler also generates *static* binaries based on [musl libc](https://musl.libc.org/)

Following target architectures are supported

* x86_64
* i686
* armv7l

Cross compilation is performed using [musl.cc](https://musl.cc/) static compilers (which means you should be able to generate a portable package of *QuickJS* from any recent *x86_64* Linux distribution with *gcc*)

Final portable version should weight around 7MB (after decompression)

Static compiler should work with any Linux distribution with *gcc* >= `4.3.2`

See https://github.com/ctn-malone/quickjs-cross-compiler for more informations
