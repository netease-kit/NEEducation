import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.12
import NetEase.Meeting.Clipboard 1.0
import NetEase.Meeting.RunningStatus 1.0
import NetEase.Meeting.MeetingStatus 1.0
import "./"

Window {
    id: mainWindow
    visible: true
    width: 500+20
    height: 560+20
    color: 'transparent'
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    Material.theme: Material.Light
    Component.onCompleted: {
        pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/loading.qml'))
	    //put your appkey here!
        meetingManager.initialize("")
    }

    ToastManager {
        id: toast
    }

    Clipboard {
        id: clipboard
    }


    Rectangle {
        id:mainLayout
        anchors.margins: 10
        anchors.fill: parent
        radius: Qt.platform.os === 'windows' ? 10 : 0
        Caption {
            id: caption
            height: 30
            width: parent.width
        }
        Rectangle{
            width:400
            height: 400
            anchors.fill:parent
            anchors.margins: 50
            Loader {
                id: pageLoader
                anchors.fill: parent
            }
        }


    }


    DropShadow {
        anchors.fill: mainLayout
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        samples: 16
        source: mainLayout
        color: "#3217171A"
        spread: 0
        visible: Qt.platform.os === 'windows'
        Behavior on radius { PropertyAnimation { duration: 100 } }
    }


    Connections {
        target: mainWindow
        function onClosing(close) {
            meetingManager.unInitialize()
            close.accepted = false
        }
    }


    Connections{
        target: meetingManager
        function onInitializeSignal(errorCode, errorMessage){
            console.log("meetingManager onInitializeSignal : " + errorCode + " , msg : " + errorMessage)
            if (errorCode === MeetingStatus.ERROR_CODE_SUCCESS){
                meetingManager.loginAnonymous();
            }

        }

        function onStartSignal(errorCode, errorMessage) {
            switch (errorCode) {
            case MeetingStatus.ERROR_CODE_SUCCESS:
                mainWindow.hide()
                break
            case MeetingStatus.MEETING_ERROR_FAILED_MEETING_ALREADY_EXIST:
                break
            case MeetingStatus.ERROR_CODE_FAILED:
                toast.error(errorMessage !== '' ? errorMessage : qsTr('创建课堂失败'))
                break
            default:
                if(errorMessage === 'Failed to connect to server.'){
                    toast.error("网络错误请重试")
                }
                else{
                   toast.error(errorMessage)
                }


                break
            }

        }
        function onJoinSignal(errorCode, errorMessage) {
            switch (errorCode) {
            case MeetingStatus.ERROR_CODE_SUCCESS:
                mainWindow.hide()
                break
            case MeetingStatus.ERROR_CODE_FAILED:
            default:
                toast.error(errorMessage !== '' ? errorMessage : qsTr('加入课堂失败'))
                mainWindow.raiseOnTop()
                break
            }
        }

        function onLoginSignal(errorCode, errorMessage){
            if (errorCode === MeetingStatus.ERROR_CODE_SUCCESS)
                pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/homepage.qml'))
            else
                toast.show(errorCode + '(' + errorMessage + ')')
        }

        function onMeetingStatusChanged(meetingStatus, extCode) {
            console.log("meeting status : " + meetingStatus + ", extcode : "+ extCode);
            switch (meetingStatus) {
            case RunningStatus.MEETING_STATUS_CONNECTING:
                break;            
            case RunningStatus.MEETING_STATUS_DISCONNECTING:
                if (extCode === RunningStatus.MEETING_DISCONNECTING_REMOVED_BY_HOST)
                    toast.show(qsTr('您已被主讲人踢出课堂'))
                else if (extCode === RunningStatus.MEETING_DISCONNECTING_CLOSED_BY_HOST)
                    toast.show(qsTr('课堂已结束'))
                else if (extCode === RunningStatus.MEETING_DISCONNECTING_BY_SERVER)
                    toast.show(qsTr('与服务器断开连接'))
                else if (extCode === RunningStatus.MEETING_DISCONNECTING_AUTH_INFO_EXPIRED)
                    console.info('验证信息已过期')
                else if (extCode === RunningStatus.MEETING_DISCONNECTING_LOGIN_ON_OTHER_DEVICE) {
                    toast.show(qsTr('您的账号在其他位置登录'))

                }
                pageLoader.setSource(Qt.resolvedUrl('qrc:/qml/homepage.qml'))
                mainWindow.showNormal()
                mainWindow.raiseOnTop()

                break
            }
        }
    }

    function raiseOnTop() {
        mainWindow.show()
        mainWindow.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
        mainWindow.flags = Qt.Window | Qt.FramelessWindowHint
    }



}
