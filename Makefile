TARGET = LazyMan-iOS
INFO_PLIST = ./build/$(TARGET).app/Info.plist
BUILD_VERSION = $(shell /usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$(INFO_PLIST)")
BUILD_NUMER = $(shell /usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$(INFO_PLIST)")
NAME = $(TARGET)_$(BUILD_VERSION)-$(BUILD_NUMER)

all: ipa deb

archive ./build/$(TARGET).xcarchive:
	xcodebuild clean archive -workspace LazyMan.xcworkspace/ -scheme "$(TARGET)" -archivePath ./build/$(TARGET).xcarchive CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

app ./build/$(TARGET).app: ./build/$(TARGET).xcarchive
	cp -r ./build/$(TARGET).xcarchive/Products/Applications/$(TARGET).app ./build/
	ldid -S ./build/$(TARGET).app/$(TARGET)
	find ./build/$(TARGET).app/Frameworks -perm +111 -type f -exec ldid -S {} ';'

ipa ./build/$(TARGET).ipa: app
	rm -rf ./build/Payload/ ./build/$(NAME).ipa
	mkdir -p ./build/Payload/
	ln -sf ../$(TARGET).app ./build/Payload/$(TARGET).app
	cd ./build/ && zip -r9 $(NAME).ipa Payload/$(TARGET).app
	rm -rf ./build/Payload/

deb: app
	rm -rf ./build/Deb/ ./build/$(NAME).deb
	mkdir -p ./build/Deb/DEBIAN/
	mkdir -p ./build/Deb/Applications/
	sed 's/$$VERSION/$(BUILD_VERSION)-$(BUILD_NUMER)/' control > ./build/Deb/DEBIAN/control
	cp -r ./build/$(TARGET).app ./build/Deb/Applications/$(TARGET).app
	find . -name ".DS_Store" -delete
	cd ./build/ && dpkg-deb -Zgzip -b "Deb" "$(NAME).deb"
	rm -rf ./build/Deb/

clean:
	rm -rf ./build/$(TARGET).app ./build/Payload ./build/Deb ./build/*.deb ./build/*.ipa
		
cleanbuild:
	rm -rf ./build/$(TARGET).xcarchive
