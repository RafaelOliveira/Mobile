### Example
The example shows 4 boxes in the corners of the screen. The game uses all screen available, independent of the device. If you rotate the screen to landscape, it shows a picture "asking" the user to rotate the screen.

After create the html5 target, copy the index.html to build\html5. It contains some important changes.  
There is some meta tag to prevent the screen to be scaled by the user, and to be able to add to the home screen in android/ios without show the menu.  
In desktop browsers, the canvas size and position is controlled by the div game-container, this way is possible to put the game anywhere in a page. In mobile browsers, the div and the canvas is controlled by the lib, and always use all the available screen space. There is some code in the index file to show the div initially using all the height of the page.

On Android Studio, you need to put the orientation in portrait.

Links: [html5]

Box reference:  
https://openclipart.org/detail/29250/crate-front

[html5]:http://sudoestegames.com/exp/mobile-example/