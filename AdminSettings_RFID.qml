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
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            if(wallboxCharger.isRFIDTagSuccess() === true)
            {
                if(wallboxCharger.searchRFID(wallboxCharger.rfidUUID) === true)
                {
                    txtRFIDInfo.text = "INFO : UID " + wallboxCharger.rfidUUID + " registered."
                }
                else
                {
                    txtRFIDInfo.text = "INFO : UID " + wallboxCharger.rfidUUID + " not registered."
                }
            }
            else
            {
                txtRFIDInfo.text = ""
            }
        }
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
        source: "src/logoRFID_active.png"
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

    Image {
        id: logoRFID
        x: 364
        y: 93
        width: 200
        height: 120
        source: "src/rfid.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: btnAddRFID
        x: 193
        y: 324
        width: 180
        height: 50
        source: "src/btnAddRFID.png"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(wallboxCharger.isRFIDTagSuccess() === true)
                {
                    if(wallboxCharger.addRFID(wallboxCharger.rfidUUID) === true)
                    {
                        txtRFIDInfo.text = "INFO : RFID UID added succesfully."
                    }
                    else
                    {
                        txtRFIDInfo.text = "INFO : RFID UID not added. Please try again."
                    }
                }
                else
                {
                    txtRFIDInfo.text = "INFO : RFID UID not added. Please try again."
                }
            }
        }
    }

    Image {
        id: btnRemoveRFID
        x: 555
        y: 324
        width: 180
        height: 50
        source: "src/btnRemoveRFID.png"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(wallboxCharger.isRFIDTagSuccess() === true)
                {
                    if(wallboxCharger.deleteRFID(wallboxCharger.rfidUUID) === true)
                    {
                        txtRFIDInfo.text = "INFO : RFID UID removed succesfully."
                    }
                    else
                    {
                        txtRFIDInfo.text = "INFO : RFID UID not removed. Please try again."
                    }
                }
                else
                {
                    txtRFIDInfo.text = "INFO : RFID UID not removed. Please try again."
                }
            }
        }
    }

    Text {
        id: txtRFIDInfo
        x: 264
        y: 254
        width: 400
        height: 32
        color: "#d9d9d9"
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: customFont.name
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
