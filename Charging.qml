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
            txtVoltageVal.text = "Voltage : 400 V"
            txtCurrentVal.text = "Current : 100 A"
            txtEnergyVal.text = "Energy : 12.25 kWh"
            txtChargeTimeVal.text = "Charge Time : 00:10:44"
            txtPowerVal.text = "Instant Power : 40 kW"
        }
        else if(isLanguageEnglish === false)
        {
            txtCharging.text = "Şarj oluyor."
            txtVoltageVal.text = "Gerilim : 400 V"
            txtCurrentVal.text = "Akım : 100 A"
            txtEnergyVal.text = "Enerji : 12.25 kWh"
            txtChargeTimeVal.text = "Şarj Süresi : 00:10:44"
            txtPowerVal.text = "Anlık Güç : 40 kW"
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
        interval: 50; running: true; repeat: true
        onTriggered: {
            if( wallboxCharger.evChargeState !== 14 )
            {
                mainLoader.source = "PlugDisconnect.qml"
            }
        }
    }

    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: {
            progress.value = wallboxCharger.evSoc
            txtVoltageVal.text = "Voltage : " + wallboxCharger.evVoltage + " V"
            txtCurrentVal.text = "Current : " + wallboxCharger.evCurrent + " A"
            txtEnergyVal.text = "Energy : " + wallboxCharger.evDeliveredEnergy + " kWh"
            txtChargeTimeVal.text = "Elapsed Time : " + wallboxCharger.evChargeTime
            txtPowerVal.text = "Power : " + wallboxCharger.evPower + " kW"
        }
    }

    Timer {
        interval: 15000; running: true; repeat: true
        onTriggered: {
            mainLoader.source = "HomePageCharging.qml"
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

    CircularProgressBar {
        id: progress
        x: 16
        y: 61
        lineWidth: 25
        value: 0
        size: 330
        secondaryColor: "#BBBBBB"
        primaryColor: "#F5A535"

        Text {
            text: parseInt(progress.value) + "%"
            font.pixelSize: 90
            font.bold: true
            anchors.centerIn: parent
            color: progress.currentColor
            font.family: customFont.name
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
                    txtCharging.text = "Charging."
                    txtVoltageVal.text = "Voltage : 400 V"
                    txtCurrentVal.text = "Current : 100 A"
                    txtEnergyVal.text = "Energy : 12.25 kWh"
                    txtChargeTimeVal.text = "Charge Time : 00:10:44"
                    txtPowerVal.text = "Instant Power : 40 kW"
                }
                else if(isLanguageEnglish === false)
                {
                    txtCharging.text = "Şarj oluyor."
                    txtVoltageVal.text = "Gerilim : 400 V"
                    txtCurrentVal.text = "Akım : 100 A"
                    txtEnergyVal.text = "Enerji : 12.25 kWh"
                    txtChargeTimeVal.text = "Şarj Süresi : 00:10:44"
                    txtPowerVal.text = "Anlık Güç : 40 kW"
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
        id: fd_logo
        x: 373
        y: 425
        width: 55
        height: 55
        source: "src/fd_logo_bottom.png"
        fillMode: Image.PreserveAspectFit
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

    Image {
        id: btnCancel
        x: 523
        y: 427
        width: 185
        height: 50
        source: "src/btnStopCharge.png"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "ChargeStopProcess.qml"
            }
        }
    }

    Image {
        id: rectVoltage
        x: 380
        y: 49
        width: 400
        height: 64
        source: "src/rectChargeVal.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: txtVoltageVal
            anchors.fill: parent
            width: 400
            height: 40
            color: "#ffffff"
            text: qsTr("Gerilim : 400 V")
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: customFont.name
            font.bold: true
        }
    }

    Image {
        id: rectCurrent
        x: 380
        y: 124
        width: 400
        height: 64
        source: "src/rectChargeVal.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: txtCurrentVal
            anchors.fill: parent
            width: 400
            height: 40
            color: "#ffffff"
            text: qsTr("Akım : 100 A")
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: customFont.name
            font.bold: true
        }
    }

    Image {
        id: rectEnergy
        x: 380
        y: 199
        width: 400
        height: 64
        source: "src/rectChargeVal.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: txtEnergyVal
            anchors.fill: parent
            width: 400
            height: 40
            color: "#ffffff"
            text: qsTr("Enerji : 12.25 kWh")
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: customFont.name
            font.bold: true
        }
    }

    Image {
        id: rectChargeTime
        x: 380
        y: 274
        width: 400
        height: 64
        source: "src/rectChargeVal.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: txtChargeTimeVal
            anchors.fill: parent
            width: 400
            height: 40
            color: "#ffffff"
            text: qsTr("Şarj Süresi : 00:10:44")
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: customFont.name
            font.bold: true
        }
    }

    Image {
        id: rectPower
        x: 380
        y: 349
        width: 400
        height: 64
        source: "src/rectChargeVal.png"
        fillMode: Image.PreserveAspectFit
        Text {
            id: txtPowerVal
            anchors.fill: parent
            width: 400
            height: 40
            color: "#ffffff"
            text: qsTr("Anlık Güç : 40 kW")
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: customFont.name
            font.bold: true
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
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
