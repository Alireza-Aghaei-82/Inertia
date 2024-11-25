import QtQuick

Rectangle
{
    property bool isSmooth
    property bool antialiasingEnabled

    color: "#F2F2F2"
    border.width: 1
    border.color:  Qt.darker(color, 1.02)
    border.pixelAligned: false
    antialiasing: antialiasingEnabled
}
