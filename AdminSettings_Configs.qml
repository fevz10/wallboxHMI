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
        wallboxCharger.jSON_ConfigRead()
        textDomain.text = wallboxCharger.ocppServerHost
        textPort.text = wallboxCharger.ocppServerPort
        textPath.text = wallboxCharger.ocppServerPath
        textCPid.text = wallboxCharger.cpID
        textQRText.text = wallboxCharger.qrCodeText
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
        id: btnInformation
        x: 16
        y: 73
        width: 128
        height: 68
        source: "src/logoInfo_passive.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "AdminSettings_Information.qml"
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
        source: "src/logoConfigs_active.png"
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
                mainLoader.source = "AdminSettings_RFID.qml"
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

    Text {
        id: lblDomain
        x: 170
        y: 83
        width: 102
        height: 33
        text: qsTr("DOMAIN")
        font.family: customFont.name
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: "#FFFFFFFF"
    }

    Text {
        id: lblPort
        x: 170
        y: 137
        width: 102
        height: 33
        text: qsTr("PORT")
        font.family: customFont.name
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: "#FFFFFFFF"
    }

    Text {
        id: lblPath
        x: 170
        y: 191
        width: 102
        height: 33
        text: qsTr("PATH")
        font.family: customFont.name
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: "#FFFFFFFF"
    }

    Text {
        id: lblCPid
        x: 170
        y: 245
        width: 102
        height: 33
        text: qsTr("CP ID")
        font.family: customFont.name
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: "#FFFFFFFF"
    }

    Text {
        id: lblQRText
        x: 170
        y: 299
        width: 102
        height: 33
        text: qsTr("QR TEXT")
        font.family: customFont.name
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: "#FFFFFFFF"
    }

    Image {
        id: rectDomain
        x: 289
        y: 83
        width: 469
        height: 33
        source: "src/rectInput.png"
        fillMode: Image.PreserveAspectFit

        TextField {
            id: textDomain
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 16
            text: qsTr("")
            verticalAlignment: TextField.AlignVCenter
            horizontalAlignment: TextField.AlignHCenter
            font.bold: true
            color: "#211E1E"
            background: Image {}
        }
    }

    Image {
        id: rectPort
        x: 289
        y: 137
        width: 469
        height: 33
        source: "src/rectInput.png"
        fillMode: Image.PreserveAspectFit

        TextField {
            id: textPort
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 16
            text: qsTr("")
            verticalAlignment: TextField.AlignVCenter
            horizontalAlignment: TextField.AlignHCenter
            font.bold: true
            color: "#211E1E"
            background: Image {}
            inputMethodHints: Qt.ImhDigitsOnly
        }
    }

    Image {
        id: rectPath
        x: 289
        y: 191
        width: 469
        height: 33
        source: "src/rectInput.png"
        fillMode: Image.PreserveAspectFit

        TextField {
            id: textPath
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 16
            text: qsTr("")
            verticalAlignment: TextField.AlignVCenter
            horizontalAlignment: TextField.AlignHCenter
            font.bold: true
            color: "#211E1E"
            background: Image {}
        }
    }

    Image {
        id: rectCPid
        x: 289
        y: 245
        width: 469
        height: 33
        source: "src/rectInput.png"
        fillMode: Image.PreserveAspectFit

        TextField {
            id: textCPid
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 16
            text: qsTr("")
            verticalAlignment: TextField.AlignVCenter
            horizontalAlignment: TextField.AlignHCenter
            font.bold: true
            color: "#211E1E"
            background: Image {}
        }
    }

    Image {
        id: rectQRtext
        x: 289
        y: 299
        width: 469
        height: 33
        source: "src/rectInput.png"
        fillMode: Image.PreserveAspectFit

        TextField {
            id: textQRText
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 16
            text: qsTr("")
            verticalAlignment: TextField.AlignVCenter
            horizontalAlignment: TextField.AlignHCenter
            font.bold: true
            color: "#211E1E"
            background: Image {}
        }
    }

    InputPanel {
        width: window.width
        y: window.height - height
        visible: active
    }

    Image {
        id: btnWriteCfg
        x: 368
        y: 347
        width: 192
        height: 36
        source: "src/btnWriteCfg.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                wallboxCharger.jSON_ConfigUpdate(textDomain.text, textPort.text, textPath.text, textCPid.text, textQRText.text)
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
