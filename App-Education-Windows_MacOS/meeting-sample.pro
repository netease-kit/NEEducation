QT += quick quickcontrols2 svg

CONFIG      += c++11
TARGET      = NetEaseClassClient
DESTDIR     = $$PWD/bin

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    nemeeting_manager.h \
    singleton.h \
    utils/clipboard.h \
    version.h

SOURCES += main.cpp \
    nemeeting_manager.cpp \
    utils/clipboard.cpp

RESOURCES += qml.qrc

win32 {
    DEPENDPATH += $$PWD/bin
    INCLUDEPATH += $$PWD/include
    CONFIG(debug, debug|release) {
        LIBS += -L$$PWD/lib -lnem_hosting_moduled
    }else{
        LIBS += -L$$PWD/lib -lnem_hosting_module
    }
    QMAKE_CXXFLAGS += -wd4100 /utf-8
}

macx {
    INCLUDEPATH += $$PWD/bin/nem_hosting_module.framework/Headers
    LIBS += -F$$PWD/bin/ -framework nem_hosting_module
    DEPENDPATH += $$PWD/bin

    CONFIG(debug, debug|release) {
        QMAKE_POST_LINK += rm -rf $$PWD/bin/NetEaseClassClient.app/Contents/Frameworks &&
        QMAKE_POST_LINK += mkdir $$PWD/bin/NetEaseClassClient.app/Contents/Frameworks &&
        QMAKE_POST_LINK += ln -s -f $$PWD/bin/NetEaseMeetingClient.app $$PWD/bin/MeetingSample.app/Contents/Frameworks/NetEaseMeetingClient.app
        QMAKE_RPATHDIR += $$PWD/lib
    } else {
        IPC_SERVER_SDK_FRAMEWORK.files = $$PWD/bin/nem_hosting_module.framework
        IPC_SERVER_SDK_FRAMEWORK.path = /Contents/Frameworks

        NEM_UI_SDK_APP.files = $$PWD/bin/NetEaseMeetingClient.app
        NEM_UI_SDK_APP.path = /Contents/Frameworks

        QMAKE_BUNDLE_DATA += IPC_SERVER_SDK_FRAMEWORK \
                             NEM_UI_SDK_APP

        QMAKE_RPATHDIR += @executable_path/../Frameworks/NetEaseMeetingClient.app/Contents/Frameworks
    }

}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


# Version info
win32 {
    RC_ICONS                 = "elearning.ico"
    QMAKE_LFLAGS_RELEASE    += /MAP
    QMAKE_CFLAGS_RELEASE    += /Zi
    QMAKE_LFLAGS_RELEASE    += /debug /opt:ref
    QMAKE_CXXFLAGS_WARN_ON -= -w34100
    QMAKE_CXXFLAGS += -wd4100
    QMAKE_TARGET_COMPANY     = "NetEase"
    QMAKE_TARGET_DESCRIPTION = "NetEase Education solutions"
    QMAKE_TARGET_COPYRIGHT   = "Copyright (C) 2015~2021 NetEase. All rights reserved."
    QMAKE_TARGET_PRODUCT     = "NetEase Meeting"
    VERSION = 1.0.0.0
}


macx {
    ICON = macx.icns
    QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-parameter -Wno-unused-function
    QMAKE_TARGET_BUNDLE_PREFIX = com.netease.nmc
    QMAKE_BUNDLE = NetEaseClassClient
    QMAKE_DEVELOPMENT_TEAM = 569GNZ5392
    QMAKE_PROVISIONING_PROFILE = afe9bf95-033c-4592-abac-e0aab5328ce0
    QMAKE_INFO_PLIST = $$PWD/Info.plist
    DISTFILES += $$PWD/Info.plist
    VERSION = 1.0.0
}

