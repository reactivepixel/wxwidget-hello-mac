# wxWidgets-micro-sample #

This is a sample app to demonstrate use of wxWidgets as provided by [vcpkg](https://docs.microsoft.com/en-us/cpp/vcpkg).

## Requirements ##
* Windows
* Visual Studio 2017 (similar versions may work)
* x86, dynamically-linked wxWidgets installed by vcpkg (use `vcpkg install wxwidgets`)

## Instructions ##
* Make wxWidgets available with `vcpkg integrate install`
* Clone this repo
* Open the Visual Studio solution and hit F5 to build & run

## Things to note ##
* The project file contains no wxWidgets targeting information. No include paths, no library paths.
* This is very much not a "wxWidgets sample app". Try https://docs.wxwidgets.org/trunk/overview_helloworld.html for that.
* There were a couple of preprocessor definitions required to make this standard Visual Studio boilerplate project work with wxWidgets, see the commit history.
