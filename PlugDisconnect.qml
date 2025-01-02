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
            txtHomepage.text = "Unplug the charging cable from the EV."
        }
        else if(isLanguageEnglish === false)
        {
            txtHomepage.text = "Şarj kablosunu araçtan çıkarınız."
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
            if( ((wallboxCharger.evPlugState !== 2) && (wallboxCharger.evPlugState !== 3)))
            {
                mainLoader.source = "HomePage.qml"
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

        Text {
            id: txtHomepage
            x: 90
            y: 8
            width: 620
            height: 40
            text: qsTr("Şarj kablosunu araçtan çıkarınız.")
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Bold"
            color: "#FFFFFF"
            font.family: customFont.name
        }
    }

    Image {
        id: btnCSS
        x: 250
        y: 48
        width: 300
        height: 370
        source: "src/btnCCS_withoutImg.png"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                mainLoader.source = "HomePage.qml"
            }
        }
    }

    AnimatedImage {
        id: plugGif
        x: 275
        y: 140
        width: 250
        height: 250
        source: "src/plug_out.gif"
        asynchronous: true
        playing: true
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
                    txtHomepage.text = "Unplug the charging cable from the EV."
                }
                else if(isLanguageEnglish === false)
                {
                    txtHomepage.text = "Şarj kablosunu araçtan çıkarınız."
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
        id: fd_logo
        x: 380
        y: 0
        width: 40
        height: 40
        source: "src/fd_logo.png"
        fillMode: Image.PreserveAspectFit
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
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}
}
##^##*/
