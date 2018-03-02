# EffectMkr_iOS

<b>Test/Adjust your frame animation on iOS</b></br></br>
You can create different animation off the same spritesheet file.
Pick your animation frames count and order according to your needs.
Set different colors, duration, etc for different animations created from the same spritesheet.

Frame order rules:
  Separate your frames by commas: 1,2,3,4
  Set a group of frames in square brackets: [1-4],[6,10]  (Will run an animation consisting on frames 1,2,3,4,6,7,8,9,10)
  Move backword in the frame order: [7-3],5,1 (Will run an animation consisting on frames 7,6,5,4,3,5,1)
  

Steps
1. Create your animation properties with https://github.com/tawashi/Excel_TO_Json_Converter

2. Move your json file and spritesheets into the project

3. Run the project and test your animation
