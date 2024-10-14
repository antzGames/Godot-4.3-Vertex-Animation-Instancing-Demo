# Godot-VertexAnimation-Demo
An updated Vertex Animation Instancing Demo Project for Godot Engine v4.3+

## Preview
![mage](https://github.com/user-attachments/assets/e1b76d1f-f605-4f31-b8c4-99b317839de4)


## Description
This project demonstrates how to animate a 3D mesh using vertex data generated by the [Not Unreal Tools - Vertex Animation](https://github.com/yanorax/unreal_tools) Blender add-on, with a vertex shader inside [Godot Engine](https://godotengine.org).

## Blender Add-On Guide
1. Download the files from [Not Unreal Tools - Vertex Animation](https://github.com/yanorax/unreal_tools) and install **vertex_animation.py** in the Blender -> **Edit** -> **Preferences...** -> **Add-ons** -> **Install...** menu. In the **3D Viewport** side bar, you should now have a **Not Unreal Tools** menu and if selected it will show a **Vertex Animation** panel.
2. In **Object Mode** select the object you want to process, make sure the current animation you want is selected and playable in the **Timeline**.
3. Adjust the **Frame Start**, **End** and **Step** values as required. Changing these settings will update corresponding **Timeline** values.
4. Click the **Process Anim Meshes** button. This will create a new object named **export_mesh** in the **Outliner**, this is the special mesh that will be animated. In the source .blend file path there will be a newly created folder called **vaexport** and inside will be two files; **normals.png** and **offsets.exr**.
5. The **export_mesh** needs to be exported as a glTF file for importing into Godot. Select the **export_mesh** object in the **Outliner** and then from the Blender **File** menu, select **Export** -> **glTF 2.0 (.glb .gltf)**. Make the following changes to the export options and then click the **Export glTF 2.0** button:
	- Include -> Selected Objects (**enable**)
	- Geometry -> Materials (**disable**)
	- Animation -> Animation, Shape Keys, Skinning (**disable all**)
	- Filename -> can rename to anything

![install](https://github.com/user-attachments/assets/f57db7fe-6fbd-4889-96d4-7a500c547441)

![tool](https://github.com/user-attachments/assets/acfe4d8a-b7cb-43f4-82f9-7b4192cdd7fd)

## Godot Import Guide
1. You should now have 3 files generated from Blender: **normals.png**, **offsets.exr** and **export_mesh.glb** (whichever filename was chosen, this guide will refer to the default name).
2. Copy the files into the Godot project folder of your choice. Godot will run the import process as soon as it detects the new files. The import settings for each file still need more changes to ensure all of them work properly with the vertex shader.
3. In the Godot **FileSystem** dock, select the glTF file (**export_mesh.glb**) and then click the **Import** dock (default location is docked along side of the **Scene** tree). [Godot Docs - Importing 3D Scenes](https://docs.godotengine.org/en/stable/getting_started/workflow/assets/importing_scenes.html)
4. Make the following adjustments and then click the **Reimport** button. There should be a new file called **export_mesh.mesh** in the same folder as the glTF file (**export_mesh.glb**). 
	- Meshes:
	  - Compress -> (**disable**)
	  - Ensure Tangents -> (**disable**)
	  - Storage -> **Files (.res)**
	- Animation:
	  - Import -> (**disable**)
5. Add a MeshInstance or MultiMeshInstance node to the scene. Drag the **export_mesh.mesh** file into the Mesh parameter slot for a MeshInstance or the Mesh parameter slot inside the MultiMesh for a MultiMeshInstance node. This guide will not cover loading Mesh resources via script.
6. The import settings for **normals.png** and **offsets.exr** will need to be updated after they are added into the shader parameters since Godot will make changes based on what node the image was applied to (3D nodes apply import settings for images used in 3D).
7. Apply the custom vertex animation shader material to a MeshInstance/MultiMeshInstance. Recommend using the GeometryInstance -> Geometry -> Material Override slot.
8. Go to the **Shader Parameters** and click the drop-down arrow and select load for the following parameters:
	- Offset Map -> load **offsets.exr**
	- Normal Map -> load **normals.png**
9. Now find **normals.png** and **offsets.exr** in the **FileSystem** dock, go to Import settings, make the following changes for both files and click the **Reimport** button:
	- Compress:
	  - Mode -> **Lossless** for **normals.png**, **Uncompressed** for **offsets.exr** 
	- Flags:
	  - Repeat -> (**disable**) when changing the current frame using an AnimationPlayer or via script. (**enable**) when looping animations using shader TIME.
	  - Filter -> (**disable**)
	  - Mipmaps -> (**disable**)
10. If you are importing more image files such as albedo textures, refer to [Godot Docs - Importing Images](https://docs.godotengine.org/en/stable/getting_started/workflow/assets/importing_images.html). For palettes and texture masks, recommend using Lossless compression and disable Filter and Mipmaps, so there is no blending of the colours.

## Assets

[mage](https://kaylousberg.itch.io/kaykit-adventurers) by Kay Lousberg - [CC0 License](http://creativecommons.org/publicdomain/zero/1.0/)

[characterMedium](https://kenney.nl/assets/animated-characters-2) by Kenney - [CC0 License](http://creativecommons.org/publicdomain/zero/1.0/)
