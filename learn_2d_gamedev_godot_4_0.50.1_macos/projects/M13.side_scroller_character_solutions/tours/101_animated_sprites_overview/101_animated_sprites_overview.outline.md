# Overview of the animated sprite editor

In this tour, you'll get an overview of Godot's built-in editor to set up flipbook animations for your 2D games.

We can access this editor through the [b]AnimatedSprite2D[/b] node. This node play frame-by-frame animations loaded from sequences of images.

It's the traditional way of making animations and it works well for pixel art games or when you have a traditional animator in your team.

The next two tours will guide you through the process of setting up animations step-by-step.

[b]Let's get started![/b]

## What is AnimatedSprite2D?

The [b]AnimatedSprite2D[/b] node is a slightly more powerful variant of the Sprite2D node that supports 2D flipbook style animations out of the box.

It comes with a dedicated editor to set up hand-drawn frame by frame animations easily.

It's perfect for character animations in pixel art games.

## See the finished result

[open scene res://tours/animatedsprite2d_overview/complete_scene.tscn]
[anchor bubble to bottom right of main control]
[Task select animated Sprite 2D node]

I've opened a scene with a completed animated character using the [b]AnimatedSprite2D[/b] node.

This character has multiple animations including "idle", "run", and "jump" that can be triggered during gameplay.

Select the animated Sprite 2D node to reveal its editor.

## The SpriteFrames editor

[Highlight the Sprite frames. Bottom panel]

Because this node already has animations set up, selecting it opens the corresponding bottom panel: the SpriteFrames editor.

## The animation list
[highlight the Animation list on the left side of the SpriteFrames panel]

On the left side of the SpriteFrames editor is the [b]Animation List[/b].

This area displays all animations for your sprite. You can add, remove, rename, and select animations here.

Each character or object can have multiple animations like "idle", "run", or "jump" and you can play any of them in the running game.
## The frames view
[highlight the frames view in the center of the SpriteFrames panel]

The center area is the [b]Frames View[/b], which displays all individual sprite frames in the currently selected animation.

Each frame represents one image in your flipbook animation sequence. When played in order at the specified speed, these frames create the illusion of movement.

## Animation toolbar controls
[highlight the animation controls at the top of the panel]

Above the animation list, you'll find controls to manage animations:

- The three icons on the left create, duplicate, or delete animations
- The [b]Autoplay on Load[/b] icon determines if the animation plays automatically when the game starts
- The [b]Loop[/b] toggle determines if animations repeat
- The [b]FPS[/b] field controls the selected animation's speed in frames per second

## Frames toolbar controls
[highlight the frame tools above the Frames View]

Above the frames view, you'll find:

- The animation playback controls
- Buttons to add frames to the animation
- Buttons to copy and paste frames
- Buttons to move and delete frames
- A field to change the duration of the selected frame relative to the others

## run the scene

[anchor bubble to top right of viewport]
[highlight the button Run Current Scene in the run toolbar]

Click the [b]Run Current Scene[/b] button to see the animations in action.

Use the arrow keys to move the character and space to jump. Watch how the animations change based on what the character is doing! The character is playing the animations defined in the Sprite frames editor.

When you're done exploring, close the game window to continue the tour. You'll create your own animated sprite in the next steps.

## Conclusion

That's a brief overview of the AnimatedSprite2D node's editor interface and tools. You've seen the different parts of the SpriteFrames editor. In summary:

- The Animation List lets you create and rename animations
- The Frames View shows all frames in the current animation
- The toolbars above the animation list and frames view let you edit animations and frames

In the next door, you'll create an animation step-by-step. You'll learn how to create a new animation, add frames, and adjust the playback speed of your animations. See you there!
