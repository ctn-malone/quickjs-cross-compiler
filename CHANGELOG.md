# Change Log

## [2025-09-13_2]

* chore: QuickJS release `2025-09-13`
* fix: commit de4d3927b8edff5fbfee1f69cfeef840844259e9

## [2025-09-13_1]

* chore: QuickJS release `2025-09-13`

## [2025-04-26_1]

* chore: QuickJS release `2025-04-26`

## [2024-01-13_3]

* refactor: refactor: use `type -p` instead of `which` in `qjsc.sh`

## [2024-01-13_2]

* feat: improve `js_os_exec` performances by computing `fd_max` using `/proc`

## [2024-01-13_1]

* chore: QuickJS release `2024-01-13`

## [2023-12-09_1]

* chore: QuickJS release `2023-12-09`

## [2021-03-27_4]

* feat: expose `mkdtemp` function to javascript

## [2021-03-27_3]

* feat: expose `flock` function to javascript
* feat: expose `mkstemp` function to javascript
* fix: don't call [upx](https://upx.github.io/) if compilation failed

## [2021-03-27_2]

* refactor: built [using](https://github.com/ctn-malone/musl-cross-maker/releases/tag/gcc-6.5.0_binutils-2.25.1_musl-1.2.2)
  * gcc : 6.5.0
  * binutils : 2.25.1
  * musl : 1.2.2
* feat: QuickJS binaries are compressed using [upx](https://upx.github.io/) by default
* feat: compiled files are compressed using [upx](https://upx.github.io/) by default (if possible)
* feat: support for `QJS_LIB_DIR` environment variable
* feat: expose `getpid` function to javascript

## [2021-03-27_1]

* QuickJS release `2021-03-27`

## [2020-11-08_3]

* Possibility to embed https://github.com/ctn-malone/qjs-ext-lib when building packages

## [2020-11-08_2]

* Possibility to embed custom javascript modules when building packages
* Fallback to the directory containing `qjs` & `qjsc` binaries when resolving imports

## [2020-11-08_1]

* *QuickJS* release `2020-11-08`

## [2020-09-06_1]

* *QuickJS* release `2020-09-06`
