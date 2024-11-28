import QtQuick
import QtQuick.Effects


Rectangle
{
    id: root

    color: "#F2F2F2"
    border.width: 1
    border.color:  Qt.darker(color, 1.02)

    property bool isSmooth
    property bool antialiasingEnabled

    Image
    {
        id: image

        anchors.fill: parent
        anchors.margins: 5
        source: "qrc:/resources/images/mine.png"
        smooth: isSmooth
        antialiasing: antialiasingEnabled
    }

    MultiEffect
    {
        source: image
        anchors.fill: image
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
