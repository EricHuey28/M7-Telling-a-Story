# Manipulating animation frames

In this tour, you'll learn how to manipulate individual frames in the [b]SpriteFrames[/b] editor.

You'll learn how to adjust the timing of individual frames, copy and paste frames, and use those tools to create an animation of a character blinking occasionally.

[b]Let's get started![/b]

## Creating a new animation

[highlight New Animation button at the top left of the SpriteFrames panel]

It's common in games to have an idle animation with the character mostly standing still with an occasional blink. That's what we'll create in this tour.

Click the [b]New Animation[/b] button (the plus icon) at the top left of the editor.

A new animation called [b]new_animation[/b] appears in the list.

## Renaming the new animation

[highlight the new_animation name in the Animation List]
[task rename new animation to "idle"]
Click on [b]new_animation[/b] in the animation list to rename it.

Type [b]idle[/b] and press Enter.

## Adding frames to idle animation
[highlight the FileSystem dock]

For the idle animation, we'll use two frames: one normal stance and one blinking frame.

In the [b]FileSystem[/b] dock, find and select the idle animation frames ([b]idle_000.png[/b] and [b]idle_001.png[/b]).

## Adding the idle frames

Drag the selected idle frames into the [b]Frames View[/b] of the SpriteFrames editor.

Then, play the animation to preview its timing. As both frames have the same duration, the result looks off: the characters blinks continuously.

Instead, we want the character to only blink occasionally, so we'll need to adjust the timing of these frames.


## Adjusting individual frame duration

[highlight the Frame Duration field in the bottom panel]
[highlight the first animation frame in the frames view]

Luckily, we can adjust the duration of individual frames! Click on the first frame (the non-blinking pose) to select it.

With the frame selected, find the [b]Frame Duration[/b] field at the top of the SpriteFrames editor.

Change the value from [b]1.0[/b] to [b]20.0[/b]. This makes this frame stay on screen 20 times longer than the default duration.

## Creating a blinking pattern
[highlight both frames in the Frames View]
[task select both animation frames]

Now let's make the character to blink twice in a row before returning to the long idle pose. It'll make the animation nicer and it'll teach you how to copy and paste frames.

Click on the first frame, then hold [b]Shift[/b] and click on the second frame to select both frames.

## Copying frames
[highlight the Copy Frames button above the Frames View]
[task press the copy frames button]

With both frames selected, click the [b]Copy Frames[/b] button above the frames view.

## Pasting frames
[highlight the Paste Frames button above the Frames View]
[task paste the animation frames]

Now click the [b]Paste Frames[/b] button. This adds the copied frames to the end of the animation.

This duplicates our animation, so the character waits for a long time, blinks, and repeats the pattern. Instead, the second blink should happen much sooner.

We can adjust the third frame's duration for that.

## Changing the second idle pose duration
[highlight the third frame and the frames duration field in the Frames View]
[task change the Frame Duration of the third frame to 2.0]
To change of frames, duration, you need to select it and then edit the frame duration field you'll find above the frames view in the toolbar.

Click on the third frame (the second non-blinking pose) to select it. Then, change the [b]Frame Duration[/b] of this frame from [b]20.0[/b] to [b]2.0[/b].

This creates a pattern where the character stays idle for a long time and blinks twice.

## Previewing the idle animation
[highlight the Play button above the Animation List]

Click the [b]Play[/b] button to preview the idle animation with the adjusted timing.

It looks much nicer, doesn't it?

## Congratulations!

You've successfully learned how to use the [b]AnimatedSprite2D[/b] node and [b]SpriteFrames[/b] editor to create frame-by-frame animations!

You now know how to:
- Create and rename animations
- Add frames from individual image files
- Adjust an animation's speed
- Modify individual frame durations
- Copy and paste frames

These are the most important features of the SpriteFrames editor. You'll use them for nearly every flipbook-style animation.
