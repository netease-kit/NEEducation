import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "./"
Rectangle {
    anchors.fill:parent


    Component.onCompleted: {
        combobox.currentIndex = -1
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
            text: "创建课堂"
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
            placeholderText: "请输入课堂名"
            selectByMouse: true
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            validator: RegExpValidator {
                regExp: /\w{1,20}/
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
       ComboBox {
            id: combobox
            editable: false
            Layout.preferredHeight: 44
            Layout.fillWidth: true
            flat:true
            background: Rectangle {
                implicitWidth: 320
                implicitHeight: 44
                border.width: 0
                anchors.leftMargin: -5
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
                        color: "#9F9F9F"
                    }
                }
            }
            contentItem: TextField {
                placeholderText: qsTr("请选择课堂类型")
                text: combobox.currentText
                font: textNickname.font
                verticalAlignment: Text.AlignVCenter
                readOnly:true
                background: Rectangle{
                    height: 0
                }
            }

            popup: Popup {
                  y: combobox.height - 1
                  width: combobox.width
                  implicitHeight: contentItem.implicitHeight
                  padding: 1

                  contentItem: ListView {
                      clip: true
                      implicitHeight: contentHeight
                      model: combobox.popup.visible ? combobox.delegateModel : null
                      currentIndex: combobox.highlightedIndex
                      ScrollIndicator.vertical: ScrollIndicator { }
                  }


                  background: Rectangle {
                      border.color: "#9F9F9F"
                      radius: 2
                  }
            }

            model: ListModel {
                id: model
                ListElement { text: "1对1课堂" }
                ListElement { text: "小班课堂" }
            }

        }


    }

    ColumnLayout{
        id:btnsLayout
        anchors.left: parent.left
        anchors.top: classInfoLayout.bottom
        anchors.topMargin: 40
        anchors.leftMargin: 40
        anchors.bottomMargin: 45
        spacing: 16
        CustomButton {
            id: buttonSubmit
            Layout.preferredHeight: 50
            Layout.preferredWidth: 320

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            highlighted: true
            enabled: textNickname.length && textClassName.length && combobox.currentText.length
            text: "创建课堂"
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
            text: "返回"
            highTextColor: "#337EFF"
            font.pixelSize: 16

        }
    }

    Connections{
        target: buttonSubmit
        function onClicked(){
            var starttime = (new Date()).getTime() + 30*60*1000
            var endtime = starttime + 24*60*60*1000
            meetingManager.scheduleMeeting(textClassName.text, starttime, endtime, "", false, combobox.currentIndex);

        }
    }

    Connections{
        target: buttonReturn
        function onClicked(){
           pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/homepage.qml'))
        }
    }

    Connections{
        target: meetingManager
        function onScheduleSuccessSignal(object){
            object.nickname = textNickname.text
            pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/classinfo.qml'),object)
        }

        function onScheduleSignal(errorCode, errorMessage){
            if(errorCode === 7){
                toast.error("网络错误请重试")
            }
            else{
                toast.error(errorMessage)
            }
        }
    }


}
