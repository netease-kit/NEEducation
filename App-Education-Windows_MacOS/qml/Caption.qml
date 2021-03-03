import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "./"

Item {
    property point  movePos     : "0,0"
    property bool   isDoubleClicked: false
    property int    lastWindowWidth: 0
    property int    lastWindowHeight: 0

    signal close()

    id: caption
    z: 999

    Component.onCompleted: {

    }

    function updateSize(width, height){
        lastWindowWidth = width
        lastWindowHeight = height
        mainWindow.width = lastWindowWidth
        mainWindow.height = lastWindowHeight
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onPressed: {
            movePos = Qt.point(mouse.x, mouse.y)
            isDoubleClicked = false
            lastWindowWidth = mainWindow.width
            lastWindowHeight = mainWindow.height
        }
        onPositionChanged: {
            if (!isDoubleClicked) {
                const delta = Qt.point(mouse.x - movePos.x, mouse.y - movePos.y)
                if (mainWindow.visibility !== Window.Maximized) {
                    mainWindow.x = mainWindow.x + delta.x
                    mainWindow.y = mainWindow.y + delta.y
                    mainWindow.width = lastWindowWidth
                    mainWindow.height = lastWindowHeight
                }
            }
        }
    }


    RowLayout {
        spacing: 8
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.topMargin: 8
        visible: Qt.platform.os === 'osx'

        ImageButton {
            id: macCloseButton
            Layout.preferredWidth: 12
            Layout.preferredHeight: 12
            normalImage: 'qrc:/images/public/caption/btn_close_normal.png'
            hoveredImage: 'qrc:/images/public/caption/btn_close_hovered.png'
            pushedImage: 'qrc:/images/public/caption/btn_close_pushed.png'
            onClicked: {
                closeWindow()
            }
        }

        ImageButton {
            id: macMinButton
            Layout.preferredWidth: 12
            Layout.preferredHeight: 12
            normalImage: 'qrc:/images/public/caption/btn_min_normal.png'
            hoveredImage: 'qrc:/images/public/caption/btn_min_hovered.png'
            pushedImage: 'qrc:/images/public/caption/btn_min_pushed.png'
            onClicked: {
                if(Qt.platform.os === 'osx'){
                    flags = Qt.Window | Qt.WindowFullscreenButtonHint | Qt.CustomizeWindowHint | Qt.WindowMinimizeButtonHint
                    visibility = Window.Minimized

                    flags = Qt.Window | Qt.FramelessWindowHint
                }
                else{
                    mainWindow.showMinimized();
                }
            }
        }
    }


    ImageButton {
        id: minButton
        width: 24
        height: 24
        visible: Qt.platform.os === 'windows'
        anchors.right: maxButton.visible ? maxButton.left : closeButton.left
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
        normalImage: 'qrc:/images/public/button/btn_wnd_white_min_hovered.png'
        hoveredImage: 'qrc:/images/public/button/btn_wnd_white_min_hovered.png'
        pushedImage: 'qrc:/images/public/button/btn_wnd_white_min_pushed.png'
        onClicked: {
            mainWindow.showMinimized()
        }
    }

    ImageButton {
        id: maxButton
        width: 24
        height: 24
        visible: false
        anchors.right: closeButton.left
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
        normalImage: mainWindow.visibility === Window.Maximized || mainWindow.visibility === Window.FullScreen
                     ? "qrc:/images/public/button/btn_wnd_white_restore_hovered.png"
                     : "qrc:/images/public/button/btn_wnd_white_max_hovered.png"
        hoveredImage: mainWindow.visibility === Window.Maximized || mainWindow.visibility === Window.FullScreen
                      ? "qrc:/images/public/button/btn_wnd_white_restore_hovered.png"
                      : "qrc:/images/public/button/btn_wnd_white_max_hovered.png"
        pushedImage: mainWindow.visibility === Window.Maximized || mainWindow.visibility === Window.FullScreen
                     ? "qrc:/images/public/button/btn_wnd_white_restore_pushed.png"
                     : "qrc:/images/public/button/btn_wnd_white_max_pushed.png"
        onClicked: {
            if (mainWindow.visibility === Window.Maximized) {
                mainWindow.showNormal()
            } else {
                mainWindow.showMaximized()
            }
        }
    }

    ImageButton {
        id: closeButton
        width: 24
        height: 24
        visible: Qt.platform.os === 'windows'
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
        normalImage: 'qrc:/images/public/button/btn_wnd_white_close_hovered.png'
        hoveredImage: 'qrc:/images/public/button/btn_wnd_white_close_hovered.png'
        pushedImage: 'qrc:/images/public/button/btn_wnd_white_close_pushed.png'
        onClicked: {
            closeWindow()
        }
    }

    function closeWindow() {
        mainWindow.close()
    }
}
