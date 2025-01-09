#!/bin/sh


for cliff in Cliff_*.blend; do

    name=${cliff%.blend}
    blender -b $cliff \
    --python-expr "import bpy; bpy.ops.export_scene.gltf(filepath='../World/Cliffs/Exported/$name.glb')"
    done
