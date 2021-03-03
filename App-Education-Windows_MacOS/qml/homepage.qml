import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0
import NetEase.Meeting.RunningStatus 1.0
import NetEase.Meeting.MeetingStatus 1.0

Rectangle {

    anchors.fill:parent
    //anchors.margins: 50
    //border.color: "green"
    Component.onCompleted: {
        listModel.append({ text: "用户服务协议", url: "http://yunxin.163.com/clauses" })
        listModel.append({ text: "隐私政策", url: "https://yunxin.163.com/clauses?serviceType=3" })
    }


    Rectangle{
        id:logoLayout
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.leftMargin: 140
        width: 120
        height:34
        //border.color: "red"
        Label{
            text: qsTr("智慧云课堂")
            font.pixelSize: 24
        }
    }


    Rectangle {
        id:btnsLayout
        width: 256
        height:127
        anchors.left: parent.left
        anchors.top: logoLayout.bottom
        anchors.leftMargin: 72
        anchors.rightMargin: 72
        anchors.topMargin: 49
        //border.color: "red" //设置边框的颜色
        RowLayout {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 50

            ColumnLayout {
                spacing: 0
                Image {
                    id: joinImage
                    Layout.preferredWidth: 117
                    Layout.preferredHeight: 117
                    Layout.alignment: Qt.AlignHCenter
                    source: "qrc:/images/front/join_meeting.png"
                    MouseArea {
                        id: joinButton
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            console.log("join a class")
                            pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/joinclass.qml'))
                        }
                    }
                }
                Label {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: 16
                    text: qsTr("加入课堂")
                }
            }

            ColumnLayout {
                spacing: 0
                Image {
                    id: createImage
                    Layout.preferredWidth: 117
                    Layout.preferredHeight: 117
                    Layout.alignment: Qt.AlignHCenter
                    source: "qrc:/images/front/create_meeting.png"
                    MouseArea {
                        id: createButton
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            console.log("create a class")
                            pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/Createclass.qml'))
                        }
                    }
                }
                Label {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: 16
                    text: qsTr("创建课堂")
                }
            }
        }
    }


    Rectangle {
        id: listviewLayout
        width: 340
        height: listModel.count * 56
        anchors.left: parent.left
        anchors.top: btnsLayout.bottom
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        anchors.topMargin: 48
        anchors.bottomMargin: 60


        ListView {
            id: listView
            height: parent.height
            width: parent.width
            anchors.fill:parent
            model: ListModel {
                id: listModel
            }
            delegate: Rectangle {
                height: 56
                width: listView.width
                Label {
                    color: "#222222"
                    font.pixelSize: 14
                    text: model.text
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    source: "qrc:/images/public/icons/arrow_right.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
                ToolSeparator {
                    width: parent.width
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalPadding: 0
                    horizontalPadding: 0
                    padding: 0
                    leftInset: 0
                    rightInset: 0
                    topInset: 0
                    bottomInset: 0
                    orientation: Qt.Horizontal
                    contentItem: Rectangle {
                        implicitWidth: parent.width
                        implicitHeight: 1
                        color: "#EBEDF0"
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    preventStealing: true
                    onEntered: parent.color = "#efefef"
                    onExited: parent.color = "#ffffff"
                    onReleased: parent.color = "#ffffff"
                    onClicked: {
                        Qt.openUrlExternally(model.url)
                    }
                }
            }
        }

        Rectangle {
            height: 1
            width: 340
            color: "#EBEDF0"
            opacity: .6
        }
    }

}


