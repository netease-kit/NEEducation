import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle
{
    id:rect
    anchors.fill: parent

    Rectangle{
        id:logoLayout
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.leftMargin: 140
        width:120
        height:34
        //border.color: "red"
        Label{
            anchors.centerIn: parent
            text: qsTr("智慧云课堂")
            font.pixelSize: 27
        }
    }

    ColumnLayout{
        anchors.centerIn: parent
        spacing: 16

        Rectangle{
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 48
            Image{
                id:loadingId
                width:48
                height: 48
                anchors.centerIn: parent
                source: 'qrc:/images/public/icons/loading.png'
                RotationAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 1500
                    loops: Animation.Infinite
                }

            }
        }



        Label{
            text: qsTr("正在进入智慧云课堂")
            font.pixelSize: 17
        }
    }

}
