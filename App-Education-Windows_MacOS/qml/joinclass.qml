import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import NetEase.Meeting.RunningStatus 1.0
import NetEase.Meeting.MeetingStatus 1.0
import "./"
Rectangle {
    anchors.fill:parent

    anchors.bottomMargin: 110
    Component.onCompleted: {

    }

    Rectangle{
        id:createlogoLayout
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.leftMargin: 152
        width: 96
        height:34
        //border.color: "red"
        Label{
            text: "加入课堂"
            font.pixelSize: 24
        }
    }

    ColumnLayout{
        id:classInfoLayout
        width: 320
        anchors.left: parent.left
        anchors.top: createlogoLayout.bottom
        anchors.topMargin: 23
        anchors.leftMargin: 36
        spacing: 20

        TextField {
            id: textClassName
            font.pixelSize: 17
            placeholderText: qsTr("请输入您要加入的课堂号")
            selectByMouse: true
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            validator: RegExpValidator {
                 regExp: /^[0-9-]{15}$/
            }
            ToolButton {
                width: 44
                height: 44
                anchors.right: textClassName.right
                anchors.rightMargin: -12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                visible: textClassName.length && textClassName.enabled && textClassName.hovered
                onClicked: {
                    textClassName.clear()
                }
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/images/public/button/btn_clear.svg"
                }
            }
       }

        TextField {
            id: textNickname
            font.pixelSize: 17
            placeholderText: qsTr("请输入昵称")
            selectByMouse: true
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            validator: RegExpValidator {
                regExp: /^(?!\s)(?!.*\s$)[\w_\.\s]{1,20}$/
            }
            ToolButton {
                width: 44
                height: 44
                anchors.right: textNickname.right
                anchors.rightMargin: -12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                visible: textNickname.length && textNickname.enabled && textNickname.hovered
                onClicked: {
                    textNickname.clear()
                }
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/images/public/button/btn_clear.svg"
                }
            }


       }

    }


    ColumnLayout{
        id:btnsLayout
        anchors.left: parent.left
        anchors.top: classInfoLayout.bottom
        anchors.topMargin: 49
        anchors.leftMargin: 40
        anchors.bottomMargin: 100
        spacing: 16
        CustomButton {
            id: buttonSubmit
            Layout.preferredHeight: 50
            Layout.preferredWidth: 320
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            highlighted: true
            enabled: textNickname.length && textClassName.length
            text: qsTr("加入课堂")
            font.pixelSize: 16

        }

        CustomButton {
            id: buttonReturn
            Layout.preferredHeight: 50
            Layout.preferredWidth: 320
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            highlighted: true
            highNormalBkColor:"#FFFFFF"
            enabled: true
            text: qsTr("返回")
            highTextColor: "#337EFF"
            font.pixelSize: 16

        }
    }

    Connections{
        target: buttonSubmit
        function onClicked() {
            meetingManager.invokeJoin(textClassName.text, textNickname.text, true, true, false)
        }
    }

    Connections{
        target: buttonReturn
        function onClicked(){
           pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/homepage.qml'))
        }
    }

    Connections {
        target: meetingManager
        function onJoinSignal(errorCode, errorMessage) {
            return
            console.log("onJoinSignal")
            switch (errorCode) {
            case MeetingStatus.ERROR_CODE_SUCCESS:
                mainWindow.hide()
                break
            case MeetingStatus.MEETING_ERROR_LOCKED_BY_HOST:
                toast.show(qsTr('会议被锁定'))
                break
            case MeetingStatus.MEETING_ERROR_INVALID_ID:
                toast.show(qsTr('会议不存在'))
                break
            case MeetingStatus.MEETING_ERROR_LIMITED:
                toast.show(qsTr('超出限制'))
                break
            case MeetingStatus.ERROR_CODE_FAILED:
                toast.show(qsTr('加入会议失败'))
                break
            default:
                toast.show(errorCode + '(' + errorMessage + ')')
                break
            }
        }
    }
}
