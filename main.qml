import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQml 2.12
import com.wallboxcharger 1.0

Window {
    id: root
    width: 800
    height: 480
    visible: true
    title: qsTr("wallboxHMI")

    property bool ethernetStatus: false
    property bool isLanguageEnglish: false

    WallboxCharger {
        id: wallboxCharger
    }

    FontLoader {
        id: customFont
        source: "src/Ubuntu-B.ttf"
    }

    Loader {
        id: mainLoader
        anchors.fill: parent
        source: "Bootloader.qml"
    }

    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: {
            ethernetStatus = wallboxCharger.checkNetworkConnection()
            //console.log("Internet Status : ",ethernetStatus.toString())
        }
    }

}
