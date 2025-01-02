import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml 2.12
import QtQuick.VirtualKeyboard 2.2
import QtQuick 2.0

Rectangle {
    id:window
    width: 800
    height: 480
    color: "#464646"

    Component.onCompleted: {
        parent.forceActiveFocus()
        wallboxCharger.getNetworkInfo()
        txtMACAddress.text = wallboxCharger.macAddress
        txtIPAddress.text = wallboxCharger.ipAddress
    }

    Image {
        id: rectBottom
        x: 0
        y: 425
        width: 800
        height: 55
        source: "src/rectBottom.png"
        sourceSize.height: 55
        sourceSize.width: 800
        fillMode: Image.Stretch
        opacity: 0.8
    }

    Image {
        id: rectTop
        x: 0
        y: 0
        width: 800
        height: 40
        source: "src/rectTop.png"
        fillMode: Image.PreserveAspectFit
        opacity: 0.8
    }

    Text {
        id: txtAdminPanelInfo
        x: 188
        y: 0
        width: 424
        height: 40
        color: "#ffffff"
        text: qsTr("Admin Settings")
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: customFont.name
        font.bold: true
    }

    Image {
        id: rectAdminSettings
        x: 144
        y: 73
        width: 640
        height: 320
        source: "src/rectAdminSettings.png"
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: lblMACAddress
        x: 170
        y: 189
        width: 102
        height: 33
        text: qsTr("MAC\n ADDRESS")
        font.family: customFont.name
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: "#FFFFFFFF"
    }

    Text {
        id: lblIPAddress
        x: 170
        y: 243
        width: 102
        height: 33
        text: qsTr("IP\n ADDRESS")
        font.family: customFont.name
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: "#FFFFFFFF"
    }

    Image {
        id: btnInformation
        x: 16
        y: 73
        width: 128
        height: 68
        source: "src/logoInfo_active.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "AdminSettings_Information.qml"
            }
        }
    }

    Image {
        id: btnHomepage
        x: 718
        y: 428
        width: 50
        height: 50
        source: "src/logoHomepage.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "HomePage.qml"
            }
        }
    }

    Image {
        id: fd_logo
        x: 373
        y: 425
        width: 55
        height: 55
        source: "src/fd_logo_bottom.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: btnConfigs
        x: 16
        y: 157
        width: 128
        height: 68
        source: "src/logoConfigs_passive.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "AdminSettings_Configs.qml"
            }
        }
    }

    Image {
        id: btnRFID
        x: 16
        y: 241
        width: 128
        height: 68
        source: "src/logoRFID_passive.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "AdminSettings_Configs.qml"
            }
        }
    }

    Image {
        id: btnAbout
        x: 16
        y: 324
        width: 128
        height: 68
        source: "src/logoAbout_passive.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "AdminSettings_About.qml"
            }
        }
    }

    Image {
        id: backMACAddress
        x: 289
        y: 189
        width: 469
        height: 33
        source: "src/backRO.png"
        fillMode: Image.PreserveAspectFit

        Text {
            id: txtMACAddress
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            color: "#211E1E"
        }
    }

    Image {
        id: backIPAddress
        x: 289
        y: 243

        width: 469
        height: 33
        source: "src/backRO.png"
        fillMode: Image.PreserveAspectFit

        Text {
            id: txtIPAddress
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            color: "#211E1E"
        }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/