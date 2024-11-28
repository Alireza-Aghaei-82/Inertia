# Inertia
Inertia game developed using C++/QML/JS

Attention:

I tried to make my Inertia game application, behave and even, to some extent, look like Mr. Simon Tatham's Inertia game, but I've never looked at Mr. Tatham's source code for his implementation of Inertia game and honestly I don't even know yet if Mr. Tatham's Inertia project source files are available for the public to see through.

Guidelines:

This project comes with 3 other related projects, 2 of which, namely "InertiaModel" and "TextualFileIOPlugin", are QML extension plugins, developed using C++ and one, namely "InertiaGamesGenerator", is an application, via which you can generate games data for certain dimensions of your choice.

You can find the source code for all these three projects in my GitHub projects as well, at the following URL's:

https://github.com/Alireza-Aghaei-82/InertiaEngine

https://github.com/Alireza-Aghaei-82/TextualFileIOPlugin

https://github.com/Alireza-Aghaei-82/InertiaGamesGenerator

To use this application you first need to run "InertiaGamesGenerator" application and generate games data for certain game's dimensions of your choice. Since the game is still under development and at no way a finished product, temporarilly you can only play the game in 8x8, 10x10 and 12x12 dimensions, cause temporarilly I have only added options for these three game dimensions in the "Type" menu of the "Inertia" application; of course you can generate game for dimensions other than these three, but then you have to modify the QML source code of the "Inertia" project and either add the "Action" item sorresponding to that game dimensions to the application's "Type" menu or uncomment the "Type" menu's "Custom..." "Action" item's section in the "Main.qml" file of the "Inertia" project.

In order to be able to run the Inertia application you first have to build and install "InertiaModel" and "TextualFileIOPlugin" extension plugins and give the root path, where you have installed these plugins into, as the first command line argument, when you want to run the "Inertia" application; the second (which is the last) command line argument for executing the "Inertia" application is the path, where you have placed the "games-data-paths.txt" file. The "games-data-paths.txt" file includes textual information regarding, where in the file system, games data files (*.inrt files) for any game dimensions are to be found and is necessary for the application to work. The "games-data-paths.txt" file is included in this repository in the "games-data" directory.

You have to install both QML extension plugins in the same root path for the "Inertia" application to work. Open the "CMakeLists.txt" files of both QML extension plugins and change the argument in the command:

set(PLUGINS_PATH ...)

to whichever path you want, but be aware, that in "CMakeLists.txt" files of both QML extension plugins you have to assign the same value to the "PLUGINS_PATH" variable.

The path mentioned in the following "set" command, e.g. in the "InertiaModel" project's CMakeLists.txt, must correspond to the URI specified for the extension plugin's module in the "qt_add_qml_module" command in the corresponding "CMakeLists.txt" file:

set(PLUGINS_PATH_PREFIX "/MyModules/Inertia/Engine")

(the corresponding module's URI in this case is: "MyModules.Inertia.Engine"; dots in place of slashes)

Regarding project's image files:

You're already good, if you let the project's needed image files stay at the path, where they already are, namely "resources/images" relative to the project's main source directory path, after you have cloned the "Inertia" repository, but if for some reason you want to store them at a different path, then you need to edit the "Inertia" project's "images.qrc" file and correct the images paths.

Enjoy!
