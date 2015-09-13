# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-collision

CONFIG += sailfishapp

SOURCES += src/harbour-collision.cpp

OTHER_FILES += qml/harbour-collision.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-collision.changes.in \
    rpm/harbour-collision.spec \
    rpm/harbour-collision.yaml \
    translations/*.ts \
    harbour-collision.desktop \
    qml/pages/MainPage.qml \
    qml/images/fighter_collision.png \
    qml/pages/Enemy.qml \
    qml/images/enemy_collision_2.png \
    qml/images/enemy_collision.png \
    qml/images/ball_1.png \
    qml/images/ball_2.png \
    qml/images/inmate_control_circle.png \
    qml/images/inmate_control_small_circle.png

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-collision-de.ts

