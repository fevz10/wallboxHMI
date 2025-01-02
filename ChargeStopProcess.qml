import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml 2.12

Rectangle {
    width: 800
    height: 480
    color: "#464646"
    focus: true

    property string qrText: wallboxCharger.qrCodeText
    property string rfid_uuid: ""

    Component.onCompleted: {
        txtDateTime.text = getCurrentDateTime()
        parent.forceActiveFocus()
        if(ethernetStatus === true)
        {
            statusETH.source = "src/imgETH_on.png"
        }
        else if(ethernetStatus === false)
        {
            statusETH.source = "src/imgETH_off.png"
        }
        if(isLanguageEnglish === true)
        {
            txtChargeConnected.text = "To terminate charging:"
            txtQR.text = "Scan the QR code."
            txtNFC.text = "Scan your membership card."
        }
        else if(isLanguageEnglish === false)
        {
            txtChargeConnected.text = "Şarjı sonlandırmak için:"
            txtQR.text = "QR kodu okutunuz."
            txtNFC.text = "Üyelik kartınızı okutunuz."
        }
        if(wallboxCharger.isOCPPProcessRunning() === true)
        {
            statusOCPP.source = "src/imgOCPP_on.png"
        }
        else
        {
            statusOCPP.source = "src/imgOCPP_off.png"
        }
    }

    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: {
            if(wallboxCharger.isRemoteStop === 1)
            {
                wallboxCharger.resetRemoteOperations()
                mainLoader.source = "PlugDisconnect.qml"
            }
        }
    }

    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: {
            if(wallboxCharger.isRFIDTagSuccess() === true)
            {
                if(wallboxCharger.searchRFID(wallboxCharger.rfidUUID) === true)
                {
                    wallboxCharger.trueRFID()
                    mainLoader.source = "PlugDisconnect.qml"
                }
                else
                {
                    wallboxCharger.wrongRFID()
                }
            }
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            txtDateTime.text = getCurrentDateTime()
        }
    }

    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: {
            if(ethernetStatus === true)
            {
                statusETH.source = "src/imgETH_on.png"
            }
            else if(ethernetStatus === false)
            {
                statusETH.source = "src/imgETH_off.png"
            }
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: {
            if(wallboxCharger.isOCPPProcessRunning() === true)
            {
                statusOCPP.source = "src/imgOCPP_on.png"
            }
            else
            {
                statusOCPP.source = "src/imgOCPP_off.png"
            }
        }
    }

    Keys.onPressed: {
        if(event.key === 16777220)
        {
            console.info("RFID UUID : ", rfid_uuid);
            if(rfid_uuid === "FEVZI")
            {
                console.log("RFID Entry Success...")
                mainLoader.source = "PlugDisconnect.qml"
            }
            else
            {
                console.log("RFID Entry Error!")
            }

            rfid_uuid = ""
        }
        else
        {
            rfid_uuid = rfid_uuid + event.text
        }
    }

    Image {
        id: imgCharger
        x: 233
        y: 40
        width: 341
        height: 440
        source: "src/imgCharger.png"
        fillMode: Image.PreserveAspectFit
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
        id: btnLanguage
        x: 31
        y: 428
        width: 50
        height: 50
        source: "src/btnLanguage.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                isLanguageEnglish ^= true
                if(isLanguageEnglish === true)
                {
                    txtChargeConnected.text = "To terminate charging:"
                    txtQR.text = "Scan the QR code."
                    txtNFC.text = "Scan your membership card."
                }
                else if(isLanguageEnglish === false)
                {
                    txtChargeConnected.text = "Şarjı sonlandırmak için:"
                    txtQR.text = "QR kodu okutunuz."
                    txtNFC.text = "Üyelik kartınızı okutunuz."
                }
            }
        }
    }

    Image {
        id: btnInfo
        x: 718
        y: 428
        width: 50
        height: 50
        source: "src/btnInfo.png"
        fillMode: Image.PreserveAspectFit
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

        Text {
            id: txtDateTime
            x: 6
            y: 0
            width: 176
            height: 40
            color: "#FFFFFF"
            //text: qsTr("29/10/2024 18:47")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.DemiBold
            font.family: customFont.name
        }
    }

    Image {
        id: statusETH
        x: 668
        y: 0
        width: 40
        height: 40
        source: "src/imgETH_off.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: statusOCPP
        x: 720
        y: 6
        width: 74
        height: 28
        source: "src/imgOCPP_off.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: rectQR
        x: 51
        y: 52
        width: 316
        height: 357
        source: "src/rectQRCode.png"
        fillMode: Image.PreserveAspectFit
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
        id: rectNFC
        x: 433
        y: 52
        width: 316
        height: 357
        source: "src/rectNFC.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "ChargePreparing.qml"
            }
        }
    }

    Text {
        id: txtNFC
        x: 440
        y: 55
        width: 302
        height: 30
        color: "#ffffff"
        text: qsTr("Üyelik kartını okutunuz.")
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: customFont.name
    }

    Text {
        id: txtQR
        x: 59
        y: 55
        width: 302
        height: 30
        color: "#ffffff"
        text: qsTr("QR kodu okutunuz.")
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: customFont.name
        font.bold: true
    }

    Text {
        id: txtChargeConnected
        x: 188
        y: 0
        width: 404
        height: 40
        color: "#ffffff"
        text: qsTr("Şarjı sonlandırmak için:")
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: customFont.name
        font.bold: true
    }

    Image {
        id: btnCancel
        x: 523
        y: 427
        width: 185
        height: 50
        source: "src/btnCancel.png"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "Charging.qml"
            }
        }
    }

    QRGenerator {
        id: qrObj
        content: qrText
        join: true
    }

    Image {
        id: qrImg
        x: 81
        y: 125
        width: 256
        height: 256
        fillMode: Image.PreserveAspectFit
        source: (qrObj.svgString === "") ? "" : ("data:image/svg+xml;utf8," + qrObj.svgString)
        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "PlugDisconnect.qml"
            }
        }
    }


    function getCurrentDateTime() {
        var now = new Date();
        var year = now.getFullYear();
        var month = padZero(now.getMonth() + 1);
        var day = padZero(now.getDate());
        var hours = padZero(now.getHours());
        var minutes = padZero(now.getMinutes());
        return day + "/" + month + "/" + year + " " + hours + ":" + minutes;
    }

    function padZero(number) {
        return (number < 10 ? '0' : '') + number;
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}
}
##^##*/
