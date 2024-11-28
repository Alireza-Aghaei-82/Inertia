import QtQuick
import QtQuick.Effects


Rectangle
{
    id: root

    property bool isSmooth
    property bool antialiasingEnabled

    color: "#F2F2F2"
    border.width: 1
    border.color: Qt.darker(color, 1.02)

    Image
    {
        anchors.fill: parent
        source: "qrc:/resources/images/wall.png"
        smooth: isSmooth
        antialiasing: antialiasingEnabled
    }

    /*MultiEffect
    {
        source: root
        anchors.fill: root
        shadowEnabled: true
        shadowColor: Qt.darker(root.mainColor, 1.1)
        shadowHorizontalOffset: 0.5
        shadowVerticalOffset: 0.5
        shadowScale: 1.05

        width: 1
        height: 1
        visible: true
    }*/
}

