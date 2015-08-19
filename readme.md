#### Features:

**Screen resolution**  
If you use the same resolution in all devices, you can end with a game that don't use all the screen available in the device. That is because you game can have a resolution that has a different aspect ratio of the screen device. The lib calculates a new resolution based on your default resolution that have the right aspect ratio.

**Orientation changes**  
Native games locks the screen orientation, but mobile browsers don't (for html5 games). The lib checks for orientation changes and provide a callback where you can adapt your game. Generally sponsors asks to show a message asking the player to rotate the device to right orientation, so there is a example that shows how to do that.

**HTML buttons**  
Create and remove links that act as buttons that stay in top of the canvas, and respect the scaling of the game.

#### TODO:
- HTML5 Fullscreen API
