import QtQuick
import QtQuick.Shapes


Rectangle
{
    id: root

    property bool isSmooth
    property bool antialiasingEnabled

    color: "#F2F2F2"
    border.width: 1
    border.color: Qt.darker(color, 1.02)
    border.pixelAligned: false
    antialiasing: antialiasingEnabled

    Shape
    {
        id: shape

        anchors.fill: parent
        anchors.margins: 7
        antialiasing: antialiasingEnabled
        smooth: isSmooth

        ShapePath
        {
            strokeWidth: 2
            strokeColor: Qt.darker(root.color, 1.07)
            fillColor: root.color

            startX: 0; startY: shape.height/2

            PathArc { x: shape.width; y: shape.height/2; radiusX: shape.width/2; radiusY: shape.height/2; useLargeArc: true }
            PathArc { x: 0; y: shape.height/2; radiusX: shape.width/2; radiusY: shape.height/2; useLargeArc: true }
        }
    }
}
