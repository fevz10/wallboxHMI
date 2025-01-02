import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml 2.12

Rectangle {
    width: 800
    height: 480
    color: "#464646"

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
            txtCharging.text = "Charging."
            txtPower.text = "POWER"
            txtEnergy.text = "ENERGY"
        }
        else if(isLanguageEnglish === false)
        {
            txtCharging.text = "Şarj oluyor."
            txtPower.text = "GÜÇ"
            txtEnergy.text = "ENERJİ"
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
            if( wallboxCharger.evChargeState !== 14 )
            {
                //canSendVal = 2
                mainLoader.source = "PlugDisconnect.qml"
            }
        }
    }

    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: {
            progress.value = wallboxCharger.evSoc
            valPower.text = wallboxCharger.evPower + " kW"
            valEnergy.text = wallboxCharger.evDeliveredEnergy + " kWh"
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
        id: fd_logo
        x: 373
        y: 425
        width: 55
        height: 55
        source: "src/fd_logo_bottom.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: btnCSS
        x: 250
        y: 48
        width: 300
        height: 370
        source: "src/rectHomepageCharging.png"
        fillMode: Image.PreserveAspectFit
        opacity: 0.8

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "Charging.qml"
            }
        }
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
                    txtCharging.text = "Charging."
                    txtPower.text = "POWER"
                    txtEnergy.text = "ENERGY"
                }
                else if(isLanguageEnglish === false)
                {
                    txtCharging.text = "Şarj oluyor."
                    txtPower.text = "GÜÇ"
                    txtEnergy.text = "ENERJİ"
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

    Text {
        id: txtPower
        x: 262
        y: 315
        width: 118
        height: 36
        color: "#ffffff"
        text: qsTr("GÜÇ")
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: customFont.name
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
    CircularProgressBar {
        id: progress
        x: 302
        y: 111
        lineWidth: 18
        value: 50
        size: 200
        secondaryColor: "#BBBBBB"
        primaryColor: "#F5A535"

        Text {
            text: parseInt(progress.value) + "%"
            font.pixelSize: 50
            font.bold: true
            anchors.centerIn: parent
            color: progress.currentColor
            font.family: customFont.name
        }
    }

    Text {
        id: txtEnergy
        x: 411
        y: 315
        width: 118
        height: 36
        color: "#ffffff"
        text: qsTr("ENERJİ")
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: customFont.name
        font.bold: true
    }

    Text {
        id: valPower
        x: 262
        y: 364
        width: 118
        height: 36
        color: "#ffffff"
        text: qsTr("39 kW")
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.italic: false
        font.family: customFont.name
        font.bold: false
        opacity: 0.7
    }

    Text {
        id: valEnergy
        x: 411
        y: 364
        width: 118
        height: 36
        color: "#ffffff"
        text: qsTr("12.44 kWh")
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.italic: false
        font.family: customFont.name
        font.bold: false
        opacity: 0.7
    }
    Text {
        id: txtCharging
        x: 188
        y: 0
        width: 424
        height: 40
        color: "#ffffff"
        text: qsTr("Şarj oluyor.")
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: customFont.name
        font.bold: true
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
