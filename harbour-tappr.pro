# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-tappr

CONFIG += sailfishapp

SOURCES += src/harbour-tappr.cpp

OTHER_FILES += qml/harbour-tappr.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-tappr.spec \
    rpm/harbour-tappr.yaml \
    harbour-tappr.desktop \
    qml/pages/about.qml \
    qml/data.js \
    qml/hash.js \
    qml/key.js

