WORKSPACE = FBSnapshotTestCaseDemo/FBSnapshotTestCaseDemo.xcworkspace
SCHEME = FBSnapshotTestCaseDemo
CONFIGURATION = Debug

.PHONY: all build ci clean pods test

all: ci

build:
	xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration $(CONFIGURATION) build

clean:
	xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration $(CONFIGURATION) clean

test:
	xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration $(CONFIGURATION) test -sdk iphonesimulator

ci: pods clean test

pods:
	bundle install
	rm -rf FBSnapshotTestCaseDemo/Pods
	cd FBSnapshotTestCaseDemo ; LC_ALL=en_US.UTF-8 pod install
