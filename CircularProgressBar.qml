import QtQuick 2.0

Item {
    id: root
    property variant colors: ["#ff0000", "#ff2600", "#fe3900", "#fd4900", "#fb5600", "#f96200", "#f66d00", "#f27800", "#ee8200", "#e98b00", "#e39500", "#dd9e00", "#d7a700", "#cfaf00", "#c7b700", "#bfbf00", "#b6c700", "#accf00",
     "#a0d600", "#94dd00", "#86e400", "#76eb00", "#61f200", "#46f900", "#00ff00"]
    property int size: 330
    property int lineWidth: 5
    property real value: 0

    property color primaryColor: "#29b6f6"
    property color secondaryColor: "#e0e0e0"
    property color currentColor
    property int animationDuration: 1000
    property int idxMod
    width: size
    height: size

    onValueChanged: {
        canvas.degree = value / 100 * 360;
    }

    Canvas {
        id: canvas

        property real degree: 0

        anchors.fill: parent
        antialiasing: true

        onDegreeChanged: {
            requestPaint();
        }

        onPaint: {
            var ctx = getContext("2d");

            var x = root.width/2;
            var y = root.height/2;

            var radius = root.size/2 - root.lineWidth
            var startAngle = (Math.PI/180) * 270;
            var fullAngle = (Math.PI/180) * (270 + 360);
            var progressAngle = (Math.PI/180) * (270 + degree);

            ctx.reset()

            ctx.lineCap = 'round';
            ctx.lineWidth = root.lineWidth;

            ctx.beginPath();
            ctx.arc(x, y, radius, startAngle, fullAngle);
            ctx.strokeStyle = root.secondaryColor;
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(x, y, radius, startAngle, progressAngle);
            /*
            if(value <= 20)
            {
                // red
                ctx.strokeStyle = "#C40C0C";
            }
            else if(value > 20 && value <= 50)
            {
                // abbax orange dark
                ctx.strokeStyle = "#DD761C";
            }
            else if(value > 50 && value < 80)
            {
                // blue
                ctx.strokeStyle = "#03AED2";
            }
            else if(value >= 80 && value <= 100)
            {
                // green
                ctx.strokeStyle = "#9BCF53";
            }
            */
            idxMod = value / 4;
            if(idxMod == 25)
            {
                idxMod = 24;
            }

            ctx.strokeStyle = colors[idxMod]
            currentColor = ctx.strokeStyle;
            //ctx.strokeStyle = root.primaryColor;
            ctx.stroke();
        }

        Behavior on degree {
            NumberAnimation {
                duration: root.animationDuration
            }
        }
    }
}
