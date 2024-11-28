#include "games-data-path.hpp"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>


int main(int argc, char* argv[])
{
    if(argc < 3)
        throw std::invalid_argument
            {"Program executed without specifying the path to extension plugins and/or games data file. Terminating program ..."};

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.addImportPath(argv[1]);

    QObject::connect(&engine,
                     &QQmlApplicationEngine::objectCreationFailed,
                     &app,
                     []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);

    auto gamesDataPath {engine.singletonInstance<GamesDataPath*>("Inertia", "GamesDataPath")};
    gamesDataPath->setPath(argv[2]);

    engine.loadFromModule("Inertia", "Main");


    return app.exec();
}
