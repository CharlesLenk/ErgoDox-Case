# ErgoDox Case

ErgoDox keyboard case designed for FDM 3D printing

The original 3D print ErgoDox case had many overhangs that made it very difficult to print on a consumer grade printer.
It was also impossible to repair/replace any of the ports without fully desoldering the key switches.

This is a simplified case that’s possible to print at home. It’s in three parts, including a back cover that can be
removed to access the ports without desoldering the whole board.

The case is designed for m2 screws. Five 6mm screws and three 10mm screws are needed per hand.

## Printing

This model is designed to be printed on a standard consumer grade FDM printer. A a 0.4mm nozzle with a 0.2mm layer
height. Using PLA filament is recommended because it's low
cost and handles overhangs well. All parts can be printed without supports.

## Files in this repository

The stl directory contains the generated keyboard case files.

The source code for the design is in keyboard_case.scad. The distance numbers in the code may look awful, this is because the ErgoDox PCB used a mix of fractional inches, decimal inches, and millimeters, which were all normalized to millimeters in this design.

# Project Setup for Local Editing

Everything below this point is only relevant if you want to download this project and make edits.

## Cloning this Repository

This project uses a submodule for common SCAD code. If the submodule is not initialized, the `openscad-utilities`
directory will be empty, and the project won't render.

To get the submodule code when cloning, add the `--recurse-submodules` option to the clone command. For example:
> `git clone [Project URL] --recurse-submodules`

If you've already cloned the project, run this command in the project root to pull down the submodule:
> `git submodule update --init`

## Exporting Model Files

There are two options for exporting the models:

1. Manually through the [OpenSCAD](https://openscad.org/) UI.
2. Through the provided export script.

As of 2024, the OpenSCAD development preview uses a new rendering engine called Manifold. Using the development preview
with Manifold will render the models many times faster, regardless of how you export this project.

### 1. Exporting Manually

The `export map.scad` file contains an `if/else` condition where the call to generate each part can be seen. You can
either write OpenSCAD code using these calls to build up a print plate, or the part "name" can be manually edited to
select each part, which can then be rendered and exported through the OpenSCAD UI like any other project.

### 2. Exporting using the Script

The export script, `export.py`, depends on the [SCAD Export](https://github.com/CharlesLenk/scad_export) library. To use
this script follow the instructions in the SCAD Export documentation.
