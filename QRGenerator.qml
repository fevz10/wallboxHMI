import QtQuick 2.0
import QtQml 2.0
import "qrcode.min.js" as QrSvg

QtObject {
    id: qrRoot

    property string content
    property int padding: 4
    property int width: 256
    property int height: 256
    property string color: "black"
    property string background: "white"
    property string ecl: "M"
    property bool join: false
    property bool predefined: false
    property bool pretty: true
    property bool swap: false
    property bool xmlDeclaration: true
    property string container: "svg"

    property string svgString: ""

    function createSvgString() {
        qrRoot.svgString = new QrSvg.QRCode({
            content: qrRoot.content,
            padding: qrRoot.padding,
            width: qrRoot.width,
            height: qrRoot.height,
            color: qrRoot.color,
            background: qrRoot.background,
            ecl: qrRoot.ecl,
            join: qrRoot.join,
            predefined: qrRoot.predefined,
            pretty: qrRoot.pretty,
            swap: qrRoot.swap,
            xmlDeclaration: qrRoot.xmlDeclaration,
            container: qrRoot.container
        }).svg()
    }
    onContentChanged: createSvgString()
    Component.onCompleted: createSvgString()
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*//*! qrcode-svg v1.1.0 | https://github.com/papnkukn/qrcode-svg | MIT license */
