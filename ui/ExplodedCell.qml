import QtQuick

Rectangle
{
    color: "#F2F2F2"
    border.width: 1
    border.color: Qt.darker(color, 1.02)

    property bool isSmooth
    property bool antialiasingEnabled

    Image
    {
        anchors.fill: parent
        anchors.margins: 2
        source: "qrc:/resources/images/exploded.png"
        smooth: isSmooth
        antialiasing: antialiasingEnabled
    }
}

