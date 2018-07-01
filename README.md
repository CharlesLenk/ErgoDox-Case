# ErgoDox-Case
ErgoDox keyboard case designed for FDM 3D printing

The stl directory contains the generated keyboard case files.

The source code for the design is in keyboard_case.scad. The distance numbers in the code may look awful, this is because the ErgoDox PCB used a mix of fractional inches, decimal inches, and millimeters, which were all normalized to millimeters in this design.

export.sh generates each part of the case from the source file if you're using MacOS and have OpenSCAD installed to the default Applications directory.
