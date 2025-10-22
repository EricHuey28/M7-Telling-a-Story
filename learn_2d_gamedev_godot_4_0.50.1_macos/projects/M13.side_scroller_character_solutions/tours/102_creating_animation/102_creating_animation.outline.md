# Creating an animation

Now that you know the SpriteFrames editor's interface, let's create a new animation from the ground up.

In this tour, you'll learn the workflow for setting up looping character animations that you can use in your own games.

[b]Let's get started![/b]

## Creating a new scene
[highlight New Scene button in the Scene dock]
[task create a new scene]

Let's create our own animated sprite from scratch!

Create a new scene by going to the Scene menu and selecting [b]New Scene[/b].

## Adding an AnimatedSprite2D node
[task create an AnimatedSprite2D node]
[highlight "Other Node" button in the Scene dock]

Now click the [b]Other Node[/b] button in the Scene dock to open the node creation dialog and create an [b]AnimatedSprite2D[/b] node.

When the [b]Create New Node[/b] dialog appears, search for [b]AnimatedSprite2D[/b] and double-click it to add it to your scene.

## Creating a SpriteFrames resource
[highlight the animation category in the Inspector]

The [b]AnimatedSprite2D[/b] node needs a [b]SpriteFrames[/b] resource to hold all its animations and frames.

In the [b]Inspector[/b], expand the [b]Animation[/b] category and look at the [b]Sprite Frames[/b] property, which is currently empty.

Click the dropdown arrow next to the empty field and select [b]New SpriteFrames[/b] to create the resource.

## Opening the SpriteFrames editor
[highlight the "SpriteFrames" resource in the Inspector]
[highlight the SpriteFrames editor (bottom panel)]
[task open the SpriteFrames editor]

Click on the newly created [b]SpriteFrames[/b] resource in the Inspector. This will open the SpriteFrames editor panel at the bottom of the screen.


## Renaming the default animation

[highlight the default animation name in the Animation List]

You'll notice a "default" animation has already been created for you. Let's rename it to something useful.

Click on [b]default[/b] in the animation list to rename it. Type [b]run[/b] and press Enter.

It's important to give animations meaningful names because those are the names you'll use to play them in your GDScript code.

## Adding frames to an animation
[highlight the FileSystem dock]


There are multiple ways to add frames to an animation. The easiest method is to drag and drop images from the FileSystem dock.

Navigate to your project's image folder in the [b]FileSystem[/b] dock where your sprite frames are stored.

## Selecting multiple frames

[highlight the frame files in the FileSystem dock]

To add multiple frames at once:
1. Click on the first frame (e.g., [b]run_000.png[/b])
2. Hold [b]Shift[/b] and click on the last frame (e.g., [b]run_005.png[/b])

This selects all frames in between.

## Drag and drop frames

With the frames selected, drag them into the [b]Frames View[/b] in the center of the SpriteFrames editor.

All the selected frames will be added to your [b]run[/b] animation in sequence.

## Looping animations
[highlight the Loop icon above the Animation List]

By default, animations are set to loop, meaning they'll play continuously rather than stopping after one cycle.

You can toggle animation looping by clicking the [b]Loop[/b] icon above the animation list. For a run animation, we want looping enabled (icon highlighted blue).

## Previewing your animation
[highlight the Play button above the Animation List]

Let's see how the animation looks!

Click the [b]Play[/b] button to preview your animation. Click the [b]Stop[/b] button when you're done.

## Adjusting animation speed

[highlight the FPS value field above the Animation List]

An animation may look too slow or too fast by default.

Our run animation currently is too slow. We can adjust this by changing its frame rate using the [b]FPS[/b] (Frames Per Second) field above the animation list.

Change the FPS value from [b]5.0[/b] to [b]10.0[/b].

Think of this like a flipbook: higher FPS means flipping through the frames faster. It also makes the animation more fluid.

## Previewing the adjusted animation

[highlight the Play button above the Animation List]

Click the [b]Play[/b] button again to see how the animation looks with the new speed.

For a running animation, 10-12 FPS usually gives a good result for pixel art characters.

## Conclusion

Congratulations! You've mastered the basics of using the [b]AnimatedSprite2D[/b] node to create flipbook-style animations in Godot.

You now know how to:

- Create and rename animations
- Change animation playback settings like speed and looping
- Add frames by dragging image files into the editor
- Preview your animations directly in the editor

In the next tour, we'll explore more tools to adjust the timing of individual frames, copy and paste frames, and create more complex animation patterns.
