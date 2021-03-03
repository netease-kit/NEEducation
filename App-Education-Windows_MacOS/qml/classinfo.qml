import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "./"
Rectangle {
    anchors.fill:parent

    property var classname : qsTr("英语课")
    property var classid : qsTr("课堂号")
    property var classtype : qsTr("课堂类别")
    property var nickname: ""

    Component.onCompleted: {

    }

    Label{
        id:textmeasure
        text: classname
        font.pixelSize: 17
        visible: false
    }

    Rectangle{
        id:resultlogoLayout
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.leftMargin: 152
        width: 96
        height:34
        //border.color: "red"
        Label{
            text: "创建成功"
            font.pixelSize: 24
        }
    }

    Rectangle{
        id:classInfo
        anchors.left: parent.left
        anchors.leftMargin: 72
        anchors.top: resultlogoLayout.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 34
        width:185
        height: 150
        //border.color: "green"
        RowLayout{
            id:classInfoLayout
            spacing: 24
            anchors.fill: parent
            ColumnLayout{
                id:classtypeLayout
                spacing: 42
                Label{
                    text:qsTr("课堂名")
                    font.pixelSize: 17
                    color: "#B0B6BE"
                }
                Label{
                    text:qsTr("课堂号")
                    font.pixelSize: 17
                    color: "#B0B6BE"
                }
                Label{
                    text:qsTr("课堂类型")
                    font.pixelSize: 17
                    color: "#B0B6BE"
                }
            }
            ColumnLayout{
                id:classDetailLayout
                width: 94
                spacing: 42
                Label{
                    id:idClassname
                    text:{
                        if(textmeasure.implicitWidth > 90){
                            return classname.substring(0,10)+"..."
                        }
                        return classname
                    }

                    font.pixelSize: 17
                    color: "#333333"
                    ToolTip{
                        delay: 500
                        timeout: -1
                        text: classname
                        y:idClassname.y
                        background: Rectangle {
                            border.color: "black"
                        }
                        contentItem: Text {
                            text: classname
                            font: idClassname.font
                            color: "black"
                        }
                        visible: labelClassnameMa.containsMouse
                    }

                    MouseArea {
                        id:labelClassnameMa
                        anchors.fill: parent
                        hoverEnabled:true

                    }
                }

                RowLayout{
                    spacing: 20
                    Label{
                        text:classid
                        font.pixelSize: 17
                        color: "#333333"
                    }
                    Label {
                        text: qsTr("复制")
                        font.pixelSize: 17
                        color: "#337EFF"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                toast.info(qsTr("课堂号已复制"))
                                clipboard.setText(classid)
                            }
                        }
                    }
                }


                Label{
                    text:{

                        if(classtype === 'education-1-to-1'){
                            return '1对1课堂'
                        }
                        else{
                            return '小班课'
                        }

                    }

                    font.pixelSize: 17
                    color: "#333333"
                }
            }
        }


    }



    Rectangle{
        id:btnsLayout
        anchors.left: parent.left
        anchors.top: classInfo.bottom
        anchors.topMargin: 51
        anchors.leftMargin: 40
        anchors.bottomMargin: 45
        ColumnLayout{
            spacing: 16
            CustomButton {
                id: buttonSubmit
                Layout.preferredHeight: 50
                Layout.preferredWidth: 320

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                highlighted: true
                enabled: true
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
    }



    Connections{
        target: buttonSubmit
        function onClicked(){
            console.log("teacher join a class")
            meetingManager.invokeJoin(classid, nickname, true, true, true)
        }
    }

    Connections{
        target: buttonReturn
        function onClicked(){
           pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/homepage.qml'))
        }
    }

}
