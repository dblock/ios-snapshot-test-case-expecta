Releasing Expecta+Snapshots
===========================

There're no particular rules about when to release Expecta+Snapshots. Release bug fixes frequenty, features not so frequently and breaking API changes rarely.

### Release

Run tests, check that all tests succeed locally.

```
make all
```

Check that the last build succeeded in [Travis CI](https://travis-ci.org/dblock/ios-snapshot-test-case-expecta).

Increment the version, modify [Expecta+Snapshots.podspec](Expecta+Snapshots.podspec).

*  Increment the third number if the release has bug fixes and/or very minor features, only (eg. change `0.5.1` to `0.5.2`).
*  Increment the second number if the release contains major features or breaking API changes (eg. change `0.5.1` to `0.4.0`).

Change "Next Release" in [CHANGELOG.md](CHANGELOG.md) to the new version.

```
0.4.0 (2014-01-27)
==================
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Make sure the library is ready for release.

```
pod lib lint
```

Commit your changes.

```
git add CHANGELOG.md Expecta+Snapshots.podspec
git commit -m "Preparing for release, 0.4.0."
git push origin master
```

Tag a release.

```
git tag '0.4.0'
git push --tags
```

Push to CocoaPods trunk.

```
pod trunk push Expecta+Snapshots.podspec
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
Next Release
============

* Your contribution here.
```

Increment the minor version, modify [Expecta+Snapshots.podspec](Expecta+Snapshots.podspec).

Comit your changes.

```
git add CHANGELOG.md Expecta+Snapshots.podspec
git commit -m "Preparing for next release, 0.4.1."
git push origin master
```
