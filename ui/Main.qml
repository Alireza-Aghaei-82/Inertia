import QtQuick
import QtQuick.Controls
import QtQml
import Qt.labs.platform as Labs

import Inertia
import MyModules.Inertia.Engine 1.0
import MyModules.IO.TextualFileIO 1.0

import "js/mainOperations.js" as MainOperations


ApplicationWindow
{
    id: root

    height: 1200
    width: height * columnsCount / rowsCount

    visible: true
    title: qsTr("Inertia")

    property color color : "#F2F2F2"
    property int rowsCount : 10
    property int columnsCount : 10

    property bool generateNewGame: false

    property alias ballPos: gameModel.ballPosition
    property point currentBallPos
    property point previousBallPos
    property int movementDir: InertiaDefinitions.InvalidDirection
    property bool undoInAction: false
    property bool redoInAction: false

    property var gameHistory :  {
                                    "rows": rowsCount,
                                    "columns": columnsCount,
                                    "time": 0,
                                    "ballPos": {"x": 0, "y": 0},
                                    "prevBallPos": {"x": 0, "y": 0},
                                    "movesIndex": -1,
                                    "moves": []
                                }


    property bool gameOver: false
    property bool gameCompleted: false
    property int elapsedTime: 0
    property bool enhancedVisuals : true




    menuBar: MenuBar
    {
        background: Rectangle
        {
            color: "whitesmoke"
        }

        Menu
        {
            title: qsTr("&Game")

            Action
            {
                text: qsTr("&New    Ctrl+N")
                shortcut: "Ctrl+N"

                onTriggered: MainOperations.newGame();
            }

            Action
            {
                text: qsTr("&Restart    Ctrl+R")
                shortcut: "Ctrl+R"

                onTriggered: MainOperations.restartGame();
            }

            MenuSeparator{}

            Action
            {
                text: qsTr("&Load    Ctrl+L")
                shortcut: "Ctrl+L"
                onTriggered: fileOpenDialog.open()
            }

            Action
            {
                text: qsTr("&Save    Ctrl+S")
                shortcut: "Ctrl+S"
                onTriggered: fileSavedialog.open()
            }

            MenuSeparator{}

            Action
            {
                text: qsTr("&Undo    U")
                shortcut: "U"
                onTriggered: MainOperations.undo()
            }

            Action
            {
                text: qsTr("&Redo    R")
                shortcut: "R"
                onTriggered: MainOperations.redo()
            }

            MenuSeparator{}

            Action
            {
                text: qsTr("&Hint    H")
                shortcut: "H"
                onTriggered: MainOperations.hint()
            }

            MenuSeparator{}

            Action
            {
                text: qsTr("&Exit")
                shortcut: StandardKey.Quit
                onTriggered: Qt.quit()
            }
        }

        Menu
        {
            title: qsTr("&Type")

            Action
            {
                text: qsTr("&8x8")

                onTriggered:
                {
                    root.rowsCount = 8;
                    root.columnsCount = 8;
                    MainOperations.newGame();
                }
            }

            Action
            {
                text: qsTr("&10x10")

                onTriggered:
                {
                    root.rowsCount = 10;
                    root.columnsCount = 10;
                    MainOperations.newGame();
                }
            }

            Action
            {
                text: qsTr("1&2x12")

                onTriggered:
                {
                    root.rowsCount = 12;
                    root.columnsCount = 12;
                    MainOperations.newGame();
                }
            }

            /*Action
            {
                text: qsTr("&20x20")

                onTriggered:
                {
                    root.rowsCount = 20;
                    root.columnsCount = 20;
                    MainOperations.newGame();
                }
            }

            Action
            {
                text: qsTr("&30x30")

                onTriggered:
                {
                    root.rowsCount = 30;
                    root.columnsCount = 30;
                    MainOperations.newGame();
                }
            }*/

            /*MenuSeparator{}

            Action
            {
                text: qsTr("&Custom...")
                onTriggered: customeDimsDialog.open()
            }*/
        }

        Menu
        {
            title: qsTr("&Help")

            Action
            {
                text: qsTr("&About")
                onTriggered: aboutDialog.open()
            }
        }
    }

    Labs.FileDialog
    {
        id: fileOpenDialog

        title: "Load game"

        nameFilters: [
                        "Inertia Game files (*.in)"
                     ]

        onAccepted: MainOperations.loadGame(fileOpenDialog.file)
    }

    Labs.FileDialog
    {
        id: fileSavedialog

        title: "Save game"
        fileMode: Labs.FileDialog.SaveFile

        nameFilters: [
                        "Inertia Game files (*.in)"
                     ]

        onAccepted:
        {
            MainOperations.saveGame(fileSavedialog.file)
        }
    }

    Labs.MessageDialog
    {
        id: aboutDialog

        title: "About Inertia"
        text: qsTr("A free Inertia game developed using C++/QML/JS by Alireza Aghaei")
        informativeText: "e-Mail: alireza.aghae.82@gmail.com"
        buttons: Labs.MessageDialog.Close
    }

    TableView
    {
        id: view

        anchors.fill: parent
        anchors.margins: 90
        /*anchors.topMargin: 5
        anchors.bottomMargin: 90
        anchors.leftMargin: 5
        anchors.rightMargin: 5*/
        rowSpacing: 0
        columnSpacing: 0
        editTriggers: TableView.NoEditTriggers
        selectionBehavior: TableView.SelectionDisabled
        interactive: false
        antialiasing: root.enhancedVisuals
        smooth: root.enhancedVisuals

        model: gameModel
        delegate: cellDelegate

        property alias vRootRef: root
        property point ballCell: MainOperations.cellIndex(ball.x, ball.y)

        MouseArea
        {
            anchors.fill: parent
            enabled: !(root.gameOver || root.gameCompleted)

            onPressed: MainOperations.onViewPressed(mouseX, mouseY)
        }

        Ball
        {
            id: ball

            property int cellWidth: view.width / columnsCount
            property int cellHeight: cellWidth
            property bool initialMove: true
            property int animDur: 0
            property bool xAnimCompleted: true
            property bool yAnimCompleted: true
            property bool animsCompleted: xAnimCompleted && yAnimCompleted

            property alias bRootRef: root

            function animationDuration()
            {
                if(ball.initialMove)
                    return 0;

                return Math.sqrt(Math.pow((root.ballPos.y - root.currentBallPos.y) * cellWidth, 2) +
                                 Math.pow((root.ballPos.x - root.currentBallPos.x) * cellWidth, 2)) / 1.6;
            }

            width: cellWidth - 26
            height: width
            x: root.ballPos.x * cellWidth + 13
            y: root.ballPos.y * cellWidth + 13
            z: 100000

            HintArrow
            {
                id: hintArrow

                anchors.fill: parent
                visible: false
                antialiasing: true
                smooth: true
            }

            Behavior on x
            {
                SequentialAnimation
                {
                    ScriptAction
                    {
                        script: ball.xAnimCompleted = false;
                    }

                    NumberAnimation
                    {
                        duration: ball.animDur
                    }

                    ScriptAction
                    {
                        script: ball.xAnimCompleted = true;
                    }
                }
            }

            Behavior on y
            {
                SequentialAnimation
                {
                    ScriptAction
                    {
                        script: ball.yAnimCompleted = false;
                    }

                    NumberAnimation
                    {
                        duration: ball.animDur
                    }

                    ScriptAction
                    {
                        script: ball.yAnimCompleted = true;
                    }
                }
            }

            onAnimsCompletedChanged:
            {
                if(ball.animsCompleted)       
                    root.currentBallPos = root.ballPos;

                else if(!ball.initialMove)
                {
                    if(!root.undoInAction)
                        root.previousBallPos = root.currentBallPos;

                    else
                    {
                        root.undoInAction = false;
                        let mvIndex = root.gameHistory.movesIndex;

                        if(mvIndex !== -1)
                            root.previousBallPos = root.gameHistory.moves[mvIndex].sourcePos;
                    }
                }
            }

            Component.onCompleted: root.currentBallPos = root.ballPos
        }

        onBallCellChanged:
        {
            if(!ball.initialMove)
                MainOperations.announceBallPos(view.ballCell)
        }
    }



    InertiaModel
    {
        id: gameModel

        property alias gRootRef: root

        onGameCompleted:
        {
            timer.running = false;
            root.gameCompleted = true;
            gameCompletionDialog.open();
        }

        onGameGenerationCompleted:
        {
            timer.running = true;
        }

        onBallPositionChanged:
        {
            ball.animDur = ball.animationDuration();

            if(!ball.visible)
                ball.visible = true
        }

        onStuck: stuckNotifDialog.open()

        onShowHint: function(direction)
        {
            hintArrow.x = ball.x + ball.width / 2;
            hintArrow.y = ball.y + ball.width / 2;
            hintArrow.rotation = MainOperations.directionToRotation(direction);
            hintArrow.visible = true;
        }
    }

    GameStateMaintainer
    {
        id: stateMaintainer
        model: gameModel
        gamesDataFilesPath: GamesDataPath.path
    }


    TextualFileIO
    {
        id: fileIO
    }

    Labs.MessageDialog
    {
        id: gameCompletionDialog

        title: "Game completed"
        text: "Congratulations! You completed the game."
        modality: Qt.ApplicationModal
        buttons: Labs.MessageDialog.Ok
    }

    Labs.MessageDialog
    {
        id: stuckNotifDialog

        title: "Attention!"
        text: "You got stuck!"
        modality: Qt.ApplicationModal
        buttons: Labs.MessageDialog.Ok
    }

    Component
    {
        id: cellDelegate

        Item
        {
            id: wrapper

            required property int display

            implicitWidth: Math.floor(view.width / root.columnsCount) - view.columnSpacing
            implicitHeight: implicitWidth

            state: "Clear"

            Loader
            {
                id: placeholder

                anchors.fill: parent

                onLoaded:
                {
                    item.isSmooth = root.enhancedVisuals;
                    item.antialiasingEnabled = root.enhancedVisuals;
                }
            }

            onDisplayChanged:
            {
                switch(wrapper.display)
                {
                    case InertiaDefinitions.Clear:
                        state = "Clear";
                        break;

                    case InertiaDefinitions.Wall:
                        state = "Wall";
                        break;

                    case InertiaDefinitions.Stop:
                        state = "Stop";
                        break;

                    case InertiaDefinitions.Gem:
                        state = "Gem";
                        break;

                    case InertiaDefinitions.Mine:
                        state = "Mined";
                        break;

                    case InertiaDefinitions.Exploded:
                    {
                        state = "Exploded";
                        break;
                    }
                }
            }

            states:
            [
                State
                {
                    name: "Clear"

                    PropertyChanges
                    {
                        target: placeholder
                        source: "ClearCell.qml"
                    }
                },

                State
                {
                    name: "Wall"

                    PropertyChanges
                    {
                        target: placeholder
                        source: "WallCell.qml"
                    }
                },

                State
                {
                    name: "Stop"

                    PropertyChanges
                    {
                        target: placeholder
                        source: "StopCell.qml"
                    }
                },

                State
                {
                    name: "Gem"

                    PropertyChanges
                    {
                        target: placeholder
                        source: "GemCell.qml"
                    }
                },

                State
                {
                    name: "Mined"

                    PropertyChanges
                    {
                        target: placeholder
                        source: "MinedCell.qml"
                    }
                },

                State
                {
                    name: "Exploded"

                    PropertyChanges
                    {
                        target: placeholder
                        source: "ExplodedCell.qml"
                    }

                    PropertyChanges
                    {
                        target: ball
                        visible: false
                    }

                    PropertyChanges
                    {
                        target: root
                        gameOver: true
                    }

                    StateChangeScript
                    {
                        script: timer.running = false
                    }
                }
            ]
        }
    }

    Timer
    {
        id: timer

        repeat: true
        onTriggered: ++root.elapsedTime
    }

    Component.onCompleted: MainOperations.newGame()
}
