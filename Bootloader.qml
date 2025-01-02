import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml 2.12


Rectangle {
    width: 800
    height: 480
    color: "#211E1E"

    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: {
            progressBar.value = progressBar.value + 0.1
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: {
            mainLoader.source = "HomePage.qml"
        }
    }

    Image {
        id: boot_logo
        x: 0
        y: 0
        width: 800
        height: 480
        source: "src/Bootloader_withoutText.png"
        fillMode: Image.PreserveAspectFit

        Text {
            id: txtInitialize
            x: 160
            y: 396
            width: 480
            height: 48
            color: "#fee7e7"
            text: qsTr("System initializing.")
            font.pixelSize: 40
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.family: customFont.name
            minimumPixelSize: 12
            minimumPointSize: 12
        }

        ProgressBar {
            id: progressBar
            x: 4
            y: 458
            width: 792
            height: 14
            indeterminate: false
            value: 0.1
        }
    }
}
