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
        wallboxCharger.jSON_ConfigRead()
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
            txtAdminPanelInfo.text = "Please enter the admin panel password."
        }
        else if(isLanguageEnglish === false)
        {
            txtAdminPanelInfo.text = "Lütfen admin paneli şifresini giriniz."
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
        id: btnCancel
        x: 523
        y: 427
        width: 185
        height: 50
        source: "src/btnClose.png"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "HomePage.qml"
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
                    txtAdminPanelInfo.text = "Please enter the admin panel password."
                }
                else if(isLanguageEnglish === false)
                {
                    txtAdminPanelInfo.text = "Lütfen admin paneli şifresini giriniz."
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

    Text {
        id: txtAdminPanelInfo
        x: 188
        y: 0
        width: 424
        height: 40
        color: "#ffffff"
        text: qsTr("Lütfen admin paneli şifresini giriniz.")
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: customFont.name
        font.bold: true
    }

    Image {
        id: rectAdminPassword
        x: 292
        y: 66
        width: 216
        height: 61
        source: "src/rectAdminPasswordInput.png"
        fillMode: Image.PreserveAspectFit

        TextField {
            id: textAdminPasword
            anchors.fill: parent
            font.family: customFont.name
            font.pixelSize: 30
            text: qsTr("")
            echoMode: TextField.Password
            verticalAlignment: TextField.AlignVCenter
            horizontalAlignment: TextField.AlignHCenter
            inputMethodHints: Qt.ImhDigitsOnly
            maximumLength: 4
            Keys.onReleased: {
                if(event.key === Qt.Key_Return)
                {
                    if(textAdminPasword.text === wallboxCharger.adminPasswd)
                    {
                        console.log("Password is correct");
                        mainLoader.source = "AdminSettings.qml"
                    }
                    else
                    {
                        console.log("Password is not correct");
                    }
                    textAdminPasword.text = ""
                }
            }
            background: Image {}
        }
    }

    InputPanel {
        width: window.width
        y: window.height - height
        visible: active
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.100000023841858}
}
##^##*/
