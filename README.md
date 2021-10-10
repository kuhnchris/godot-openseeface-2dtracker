# Godot 2D OpenSeeFace-powered Face-Tracking and Puppeteering project

After taking a look at the PoC by `you-win` over at https://github.com/you-win/openseeface-gd - which focuses on 3D model representation, I decided to attempt to learn about the OpenSeeFace interface on my own and try to implement a crude 2D "rigging" software.

The goal of this project is not to make any bad blood with `you-win` or the guys over at the OpenSeeFace project - it just happens to be a very similar approach i was thinking about for the past couple of months regarding an implementation of an OSS face tracking and feature-detecting system.

Albeit my original goal was to use `tesseract` and some interpolation model, after taking a look at the OpenSeeFace project and seeing the progress they have made, I decided to give it at least a try before trying to attempt to teach myself the basics of writing models on my own. Especially since those guys seem to have far more experience than me in this field. The best I can say about myself regarding models and computer learning is that I managed to scan my own scanned documents with tesseract-ocr - and that's about it.

This project mainly acts as an entry point to using the OpenSeeFace library - you need to run a copy of OpenSeeFace in another instance and then you can run this Godot project receiving the data from OpenSeeFace's `facetracking.py/.exe`. There is a crude display of the received points in the `OpenSeeConnectionTest.tscn` - complete with a factor that scales the face points. 

An attempt to create a custom 2D Avatar Tracking will be done in `FaceAvatar2DTest.tscn` - the connection component itself has been broken out into the file `OSFHandler.gd` which is basically a copy of `OpenSeeConnectionTest.gd` without the UI-specific routines and a signal for receiving the parsed UDP data from OpenSeeFace. This part of the component could also be used as a stand-alone plugin - which may happen in the future if this is more suffisticated - as there are various transformations in the Unity code regarding the Euler Rotation part and the Quatrantion - which both are parts that go *far* over my head, but I refuse to implement something I have no idea why i'd need it - so it will be implemented on a "as needed" part.

---

## Notes:
---
## Point # map to features:
- #0 - 16 face form points (top left to top right)
- #17 - 21 eyebrow left (left to right)
- #22 - 26 eyebrow right (left to right)
- #27 nose top tip
- #31 nose bottom left
- #35 nose bottom right
- #36 left eye most-left
- #39 left eye most-right
- #42 right eye most-left
- #45 right eye most-right
- #58 mouth most-left
- #62 mouth most-right
- #60 mouth most-top
- #64 mouth most-bottom
