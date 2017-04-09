[ RELEASE ] 
GameVision SDK Build #402

The GameVision SDK is feature complete and can easily create 
any type of 2D game with D3D for rendering. GameVision 1.x 
powered our game FreeStrike (http://www.jdsgames.com/freestrike) 

GV was designed to be easy to use, robust and feature rich 
and should be easy to use in your projects. 

[ KNoWN ISSUES ]
* Partial documentation in the form of a .CHM file. I will keep
  working on this until its complete. Ask questions/get help 
  via email, forums

[ REQUIREMENTS ] 
* Delphi 4 or higher
* DirectX 8.1b runtime 
* Direct3D compliant 3D video card 
* DirectSound compliant audio card (optional) 

[ INSTALLATION ] 
* Put the DLL in your system path and the /source folder in the Delphi path. 
  During develoment add [your_drive_letter]:\gvsdk to windows search path so
  the dll can be found and add [your_drive_letter]:\gvsdk\sources to delphi's
  search path.
* Create a new project 
* Add the GameVision units to your uses section
* You need to build the projects and make the sample rezfile before use. You
  can use the mkrez.bat which calls the command-line version of winzip to 
  build the sample.rez file used by the samples and demos. Make sure wzzip
  is in your path or modify mkrez.bat to point to the full path of wzzip.
* See the [docs] and [samples] folders for more info on how to use. 

[ FEATURES ] 
* DirectX8.1 for 2D rendering 
* Delphi 4 or higher
* Interfaces: LogFile, Error, CmdLine, Color, Timer, RezFile, App, AppWindow,
              Input, RenderDevice, Points, Font, Sprite, Image, Polygon,
              Entity, Audio, Math, Dialog, GZFile, Misc
* Much more

[ DOWNLOAD ] 
ftp://ftp.jarroddavis.com/gamevision/gvsdk4.zip (~3.0MB) - Build #400 series
ftp://ftp.jarroddavis.com/gamevision/gvsdk3.zip (~3.0MB) - Build #300 series


[ SUPPORT ] 
* http://www.jarroddavis.com
* support@jarroddavis.com - support email
* join the GameVision mail list to stay current on the lastest info. 
  Send an email to listserver@jarroddavis.com with the following
  in the subject line:

    JOIN gamevision.mailist@jarroddavis.com, your_email_addr, your_name

You are free to you GV for your own projects. In exchange, help us to 
make it better with your feedback, suggestions and bug reports. 

If you would like to contribute a demo and/or tutorial, contact us. We 
encourage you to use the GameVision forum at our website for community 
support. 

[ LICENSE ] 
You are hereby granted the right to use GameVision and it's
tools to produce your own applications without paying us any
money, subject to the following restrictions:

1. You may not reverse engineer, or claim GameVision or it's tools
   as your own work.

2. We require that you acknowledge us in your application's credits
   and/or documentation. An acceptable statement can be such as:

   Created with the GameVision SDK developed by
     Jarrod Davis Software.
     http://www.jarroddavis.com

3. You may not create a library that uses this library as a main part
   of the program and sell that library.

4. You may redistribute GameVision, provided that the archive remain
   intact. All files of the original distribution must be present!

5. Media used in the demos, tutorials and tools are copyright
   Jarrod Davis Software and may not be used for any purpose.

6. This notice may not be removed or altered from any distribution.

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

If you have further legal questions, please mail legal@jarroddavis.com


[ SPECIAL THANKS ]
GameVision SDK was created with these fine development tools:

* Borland Delphi 7
  Copyright (c) Borland Software
  http://www.borland.com
* DirectX 8.1 Headers
  Copyright (c) Tim Baumgarten
  http://www.crazyentertainment.net
* PasZLib
  Copyright (C) Jacques Nomssi Nzali
  http://www.nomssi.de
* PNGImage
  Copyright (c) Gustavo Huffenbacher Daud
  http://pngdelphi.sourceforge.net
* Pixel Conversion Routines
  Copyright (c) Yuriy Kotsarenko (aka "Life Power")
  http://turbo.gamedev.net/powerdraw.asp


Jarrod Davis Software
http://www.jarroddavis.com
jarroddavis@jarroddavis.com