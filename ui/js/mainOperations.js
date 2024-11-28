var rootRef = root;

function newGame()
{
    resetParams();
    resetGameHistory(true);

    if(root.generateNewGame)
    {
        gameModel.setRowsCount(root.rowsCount);
        gameModel.setColumnsCount(root.columnsCount);
        gameModel.initializeModel();
    }

    else
        gameModel.newGameFromFile(root.rowsCount, root.columnsCount);
}

function restartGame()
{
    resetParams();
    resetGameHistory(false);

    gameModel.restartGame();
}

function cellIndex(x, y)
{
   let columnIndex = Math.floor(x * root.columnsCount / view.width);
   let rowIndex = Math.floor(y * root.rowsCount / view.height);
   return Qt.point(columnIndex, rowIndex)
}

function movementDirection(startPoint, targetPoint)
{
    if(targetPoint.x === startPoint.x)
    {
        if(targetPoint.y < startPoint.y)
            return InertiaDefinitions.Up;

        else
            return InertiaDefinitions.Down;
    }

    let slope = (startPoint.y - targetPoint.y)/(targetPoint.x - startPoint.x);

    switch(slope)
    {
        case 0:
        {
            if(targetPoint.x > startPoint.x)
                return InertiaDefinitions.Right;

            else
                return InertiaDefinitions.Left;
        }

        case 1:
        {
            if(targetPoint.x >startPoint.x)
                return InertiaDefinitions.UpRight;

            else
                return InertiaDefinitions.DownLeft;
        }

        case -1:
        {
            if(targetPoint.x > startPoint.x)
                return InertiaDefinitions.DownRight;

            else
                return InertiaDefinitions.UpLeft;
        }

        default:
            return InertiaDefinitions.InvalidDirection;
    }
}

function onViewPressed(mouseX, mouseY)
{
    root.movementDir = movementDirection(root.ballPos, cellIndex(mouseX, mouseY))

    if(root.movementDir !== InertiaDefinitions.InvalidDirection)
    {
        if(ball.initialMove)
            ball.initialMove = false;

        let previousBallPosX = root.ballPos.x;
        let previousBallPosY = root.ballPos.y;

        let result = gameModel.moveBall(root.movementDir);

        if(result.finalDestination.x === root.currentBallPos.x && result.finalDestination.y === root.currentBallPos.y)
            return;

        hintArrow.visible = false;

        if(!root.redoInAction)
        {
            if(root.gameHistory.movesIndex !== root.gameHistory.moves.length - 1)
                root.gameHistory.moves.splice(root.gameHistory.movesIndex + 1, root.gameHistory.moves.length - root.gameHistory.movesIndex - 1);

            let prevBPos = Object.assign({}, root.previousBallPos);
            root.gameHistory.moves.push({sourcePos: prevBPos, direction: root.movementDir, pickedGems: result.collectedGems});
        }

        ++root.gameHistory.movesIndex;
    }
}

function undo()
{
    if(root.gameHistory.movesIndex === -1)
        return;

    root.undoInAction = true;

    if(ball.initialMove)
        ball.initialMove = false;


    root.gameHistory.movesIndex -= 1;
    let move = root.gameHistory.moves[root.gameHistory.movesIndex + 1];

    if(root.gameHistory.movesIndex !== -1)
        {
            let prevMove = root.gameHistory.moves[root.gameHistory.movesIndex];
            root.movementDir = prevMove.direction;
        }

        else
            root.movementDir = InertiaDefinitions.InvalidDirection;

    if(hintArrow.visible)
        hintArrow.visible = false;

    gameModel.undo(move.sourcePos, move.pickedGems);
}

function redo()
{
    if(root.gameHistory.movesIndex === root.gameHistory.moves.length - 1)
        return;

    root.redoInAction = true;

    if(ball.initialMove)
        ball.initialMove = false;

    let move = root.gameHistory.moves[++root.gameHistory.movesIndex];
    root.movementDir = move.direction;

    if(hintArrow.visible)
        hintArrow.visible = false;

    gameModel.moveBall(move.direction);
}

function saveGame(filePath)
{
    root.gameHistory.time = root.elapsedTime;
    root.gameHistory.ballPos.x = root.ballPos.x;
    root.gameHistory.ballPos.y = root.ballPos.y;
    root.gameHistory.prevBallPos.x = root.previousBallPos.x;
    root.gameHistory.prevBallPos.y = root.previousBallPos.y;

    fileIO.filePath = filePath;

    let content = JSON.stringify(root.gameHistory);
    content += "#";
    content += gameModel.stuckAreaToWrite();
    content += "#";
    content += gameModel.stuckAreaGemsToWrite();
    content += "#";
    content += gameModel.initialCellValuesToWrite();
    content += "#";
    content += gameModel.cellValuesToWrite();

    fileIO.setFileContent(content);
    fileIO.writeToFile(true);
}

function loadGame(filePath)
{
    fileIO.setFilePath(filePath);
    fileIO.readFile();

    let parts = fileIO.fileContent.split("#");

    root.gameHistory = JSON.parse(parts[0]);

    setParams();

    gameModel.loadSavedGame(root.rowsCount,
                            root.columnsCount,
                            root.ballPos,
                            parts[1],
                            parts[2],
                            parts[3],
                            parts[4]);
}

function setParams()
{
    root.rowsCount = root.gameHistory.rows;
    root.columnsCount = root.gameHistory.columns;
    root.ballPos.x = root.gameHistory.ballPos.x;
    root.ballPos.y = root.gameHistory.ballPos.y;
    root.currentBallPos.x = root.ballPos.x;
    root.currentBallPos.y = root.ballPos.y;
    root.previousBallPos.x = root.gameHistory.prevBallPos.x;
    root.previousBallPos.y = root.gameHistory.prevBallPos.y;
}

function resetGameHistory(setDims)
{
    if(setDims)
    {
        root.gameHistory.rows = root.rowsCount;
        root.gameHistory.columns = root.columnsCount;
    }

    root.gameHistory.time = 0;
    root.gameHistory.movesIndex = -1;
    root.gameHistory.moves = [];
}

function resetParams()
{
    root.elapsedTime = 0;
    root.gameOver = false;
    root.gameCompleted = false;
    ball.initialMove = true;
    hintArrow.visible = false;
}

function announceBallPos(ballPosition)
{
    if(movementDirection(root.currentBallPos, ballPosition) === root.movementDir)
        gameModel.announceBallPosition(ballPosition);
}

function hint()
{
    gameModel.hint();
}

function directionToRotation(direction)
{
    switch(direction)
    {
        case InertiaDefinitions.Up:
            return 270;

        case InertiaDefinitions.Down:
            return 90;

        case InertiaDefinitions.Right:
            return 0;

        case InertiaDefinitions.Left:
            return 180;

        case InertiaDefinitions.UpRight:
            return 315;

        case InertiaDefinitions.DownRight:
            return 45;

        case InertiaDefinitions.DownLeft:
            return 135;

        case InertiaDefinitions.UpLeft:
            return 225;

        default:
            console.log("directionToRotation(direction): Invalid given direction is: " + direction)
    }
}
