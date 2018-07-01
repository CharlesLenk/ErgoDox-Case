# ErgoDox-Case
ErgoDox keyboard case designed for FDM 3D printing


The original 3D print ErgoDox case had many overhangs that made it very difficult to print on a consumer grade printer. It was also impossible to repair/replace any of the ports without fully desoldering the key switches.

This is a simplified case that’s possible to print at home. It’s in three parts, including a back cover that can be removed to access the ports without desoldering the whole board.


The stl directory contains the generated keyboard case files.

The source code for the design is in keyboard_case.scad. The distance numbers in the code may look awful, this is because the ErgoDox PCB used a mix of fractional inches, decimal inches, and millimeters, which were all normalized to millimeters in this design.

export.sh generates each part of the case from the source file if you're using MacOS and have OpenSCAD installed to the default Applications directory.
