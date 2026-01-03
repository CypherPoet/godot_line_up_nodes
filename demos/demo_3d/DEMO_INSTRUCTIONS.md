# Demo Scene Instructions

This demo scene (`demo_3d.tscn`) showcases the Line Up Nodes plugin with various 3D node configurations.

## Scene Structure

The scene contains four groups of 3D mesh instances, each demonstrating different alignment scenarios:

### 1. GridGroup (Left side, Boxes)
**Location**: X: -8, Z: 0
- 5 box meshes with irregular spacing and Y offsets
- **Demo Purpose**: Shows horizontal alignment of scattered objects
- **Try**: Select all boxes, use Horizontal mode with distance 2.0

### 2. VerticalGroup (Center-left, Spheres)
**Location**: X: 3, Z: -5
- 4 sphere meshes with uneven vertical spacing
- **Demo Purpose**: Shows vertical alignment correction
- **Try**: Select all spheres, use Vertical mode with distance 1.5

### 3. DiagonalGroup (Center-right, Cylinders)
**Location**: X: -3, Z: 5
- 4 cylinder meshes in a rough diagonal pattern
- **Demo Purpose**: Shows custom angle alignment
- **Try**: Select all cylinders, use Custom mode with X: 1.5, Y: 1.0

### 4. MixedGroup (Right side, Mixed shapes)
**Location**: X: 8, Z: 3
- Mix of capsule, box, sphere, and cylinder meshes
- **Demo Purpose**: Shows plugin works with different mesh types
- **Try**: Select all mixed objects, experiment with different modes

## How to Use the Demo

1. Open `demo_3d.tscn` in the Godot editor
2. Ensure the Line Up Nodes plugin is enabled
3. Open the "Line Up Nodes" dock panel (usually in the left dock area)
4. Select multiple objects from any group:
   - Click first object
   - Hold Ctrl/Cmd and click additional objects
5. Configure alignment settings in the dock:
   - Choose alignment mode (Horizontal, Vertical, or Custom)
   - Set distance values
   - Toggle "Preserve Selection Order" as needed
6. Click "Align Nodes" to see the results
7. Use Ctrl+Z to undo and try different settings

## Suggested Experiments

### Experiment 1: Perfect Grid
- Select all boxes in GridGroup
- Uncheck "Preserve Selection Order"
- Use Horizontal mode with distance 2.0
- Result: Evenly spaced boxes in a straight line

### Experiment 2: Vertical Stack
- Select all spheres in VerticalGroup
- Uncheck "Preserve Selection Order"
- Use Vertical mode with distance 1.5
- Result: Evenly spaced vertical column

### Experiment 3: Diagonal Line
- Select all cylinders in DiagonalGroup
- Check "Preserve Selection Order" (or don't, to see the difference)
- Use Custom mode with X: 1.2, Y: 0.8
- Result: Diagonal alignment at a custom angle

### Experiment 4: Selection Order Matters
- Select spheres in VerticalGroup in random order
- With "Preserve Selection Order" checked, align vertically
- Undo (Ctrl+Z)
- Uncheck "Preserve Selection Order" and align again
- Notice: Second alignment sorts by current Y position

## Camera Controls

The camera is positioned at:
- Position: (0, 8, 15)
- Looking down at an angle to see all groups
- Use mouse to orbit around the scene for better viewing

## Tips

- The plugin uses `global_position` for Node3D objects
- Z coordinates remain unchanged during alignment
- All alignment happens in the XY plane for 3D objects
- First selected object (or first in sorted order) becomes the anchor
- Anchor node never moves, others align relative to it
