import QtQuick
import QtQuick.Shapes
import QtQuick.Effects


Rectangle
{
    id: root

    property bool isSmooth
    property bool antialiasingEnabled

    color: "#F2F2F2"
    border.width: 1
    border.color:  Qt.darker(color, 1.02)
    border.pixelAligned: false
    antialiasing: antialiasingEnabled

    Shape
    {
        id: shape

        anchors.fill: parent
        anchors.margins: 13
        antialiasing: antialiasingEnabled
        smooth: isSmooth

        ShapePath
        {
            strokeWidth: 0.7
            strokeColor: "dimgray"
            fillColor: "#9FFCFD"
            pathHints: ShapePath.PathLinear

            PathPolyline
            {
                path:
                [
                    Qt.point(0, shape.height /2),
                    Qt.point(shape.width /2, 0),
                    Qt.point(shape.width, shape.height /2),
                    Qt.point(shape.width /2, shape.height),
                    Qt.point(0, shape.height /2)
                ]
            }
        }
    }

    MultiEffect
    {
        source: shape
        anchors.fill: shape
        shadowEnabled: true
        shadowColor: Qt.darker(root.color, 1.2)
        shadowHorizontalOffset: 0.5
        shadowVerticalOffset: 0.5
        shadowScale: 1.15

        width: 1
        height: 1
        visible: true
    }
}
