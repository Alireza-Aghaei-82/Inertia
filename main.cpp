#include <QApplication>
#include <QQmlApplicationEngine>


int main(int argc, char* argv[])
{
    if(argc < 2)
        throw std::invalid_argument{"Program executed without specifying the path to extension plugins. Terminating program ..."};

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.addImportPath(argv[1]);

    QObject::connect(&engine,
                     &QQmlApplicationEngine::objectCreationFailed,
                     &app,
                     []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);

    engine.loadFromModule("Inertia", "Main");

    return app.exec();
}
