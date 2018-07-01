$fs = .3;
$fa = 6;

keyCutDim = 14;
keyGap = 5;
keyDist = keyCutDim + keyGap;
wallThickness = 2.5;
plateThickness = 1.5;
pcbWallSpace = 1.5;

pcbCircuitXDimension = 25;
outerRowKeyShift = 4.7625;

outerColumnShift = 4.7752;
innerColumnShift = 2.8702;
middleColumnsShift = 1.5977;

baseDimensionX = pcbCircuitXDimension + 5*keyDist + outerColumnShift + pcbWallSpace + wallThickness;
baseDimensionY = 7*keyDist + 2 * outerRowKeyShift + 2 * wallThickness + 2 * pcbWallSpace;
thumbDim = 3*keyDist + 2 * wallThickness + 2 * pcbWallSpace;

diameter = 3;
edgeDiameter = 9;

height = 7.5 + 2 * plateThickness;
circuitBumpHeight = 4.5;
portHeight = 7;

baseX = pcbCircuitXDimension + 2*keyDist + middleColumnsShift/2;
baseY = 3*keyDist + 2 * outerRowKeyShift + wallThickness + pcbWallSpace;

thumbOffsetX = baseX + 60.714092;
thumbOffsetY = baseY + 78.638974;

frontCoordinates = [[baseX, baseY], 
                   [baseX + 48.4631, baseY - 62.7380],
                   [baseX + 66.1671, baseY + 33.6050], 
                   [baseX + 74.2441, baseY + 85.1412], 
                   [baseX + 30.0736, baseY + 79.3754]];                    
backCoordinates = [[baseX - 54.4576, baseY + 20.828], 
                   [baseX - 54.4576, baseY + 71.6284], 
                   [baseX - 54.4576, baseY - 62.103]];
coordinates = concat(frontCoordinates, backCoordinates);
getX = 0;
getY = 1;

screwBindRadius = 0.85;
screwPassthroughRadius = 1.1;
screwHeadDiameter = 4.1;

bottomScrewPostHeight = 4;
topScrewPostHeight = 3.5;

trrsOffset = baseY + 52.5784;
usbOffset = baseY + 1.3975;

trrsNotchWidth = 17.5514 + 1;
usbNotchWidth = 11.887 + 1;

selector = 1;

if (selector == 1) {
    bottomRight();
} else if (selector == 2) {
    bottomLeft();
} else if (selector == 3) {
    topPlateRightPrint(); 
} else if (selector == 4) {
    topPlateLeftPrint();
} else if (selector == 5) {
    topCoverRightPrint();
} else if (selector == 6) {
    topCoverLeftPrint();
}

corners = [[baseX + 74.2441, baseY + 85.1412], [baseX - 54.4576, baseY + 71.6284], 
           [baseX - 54.4576, baseY - 62.103], [baseX + 48.4631, baseY - 62.7380]];
center = [baseX, baseY];

module topPlateRightPrint() {
    translate ([350, 0, height]) {
        rotate ([0, 180, 0]) {
            topPlateRight();
        }
    }
}

module topPlateLeftPrint() {
    translate ([350, 0, height]) {
        rotate ([0, 180, 0]) {
            topPlateLeft();
        }
    }
}

module topCoverRightPrint() {
    translate ([380, 0, height + circuitBumpHeight]) {
        rotate ([0, 180, 0]) {
            plateCoverRight();
        }
    }
}

module topCoverLeftPrint() {
    translate ([380, 0, height + circuitBumpHeight]) {
        rotate ([0, 180, 0]) {
            plateCoverLeft();
        }
    }
}
  
module assembledRight () {
    bottomRight();
    topPlateRight();
    plateCoverRight();
}

module explodedRight () {
    bottomRight();
    topPlateRightPrint();
    topCoverRightPrint();
}
    
module caseShell (height) {
    difference () {
        caseBase(height, 0, 0);
        caseBase(height, plateThickness, wallThickness);
    }
}    
    
module caseBase (height, heightShrinkAmount, edgeShrinkAmount) {
    union () {
        caseRectangle(height, heightShrinkAmount, edgeShrinkAmount);
        translate([thumbOffsetX, thumbOffsetY, heightShrinkAmount]){
            rotate(-25) {
                translate([-thumbDim/2 + edgeShrinkAmount, -1.5 * thumbDim + edgeShrinkAmount, 0]){
                    roundedCube(thumbDim - 2 * edgeShrinkAmount, 2*thumbDim - 2 * edgeShrinkAmount, height - 2 * heightShrinkAmount, edgeDiameter, diameter);
                }
            }
        }
    }
}

module topCoverRectangle(heightShrinkAmount, edgeShrinkAmount, xOffset) {
    translate ([edgeShrinkAmount, edgeShrinkAmount, heightShrinkAmount]) {
        roundedCube(pcbCircuitXDimension - edgeShrinkAmount - xOffset, baseDimensionY - 2 * edgeShrinkAmount, height + circuitBumpHeight - 2 * heightShrinkAmount, edgeDiameter, diameter);
    }
}

module caseRectangle(height, heightShrinkAmount, edgeShrinkAmount) {
     translate ([edgeShrinkAmount, edgeShrinkAmount, heightShrinkAmount]) {
        roundedCube(baseDimensionX - 2 * edgeShrinkAmount, baseDimensionY - 2 * edgeShrinkAmount, height - 2 * heightShrinkAmount, edgeDiameter, diameter, true);
    }
}

module caseSkirt(outerOffset, innerOffset, height) {
    difference() {
        translate([0, 0, 0]){
            linear_extrude(height = height) {
                projection(cut = false) {
                    caseBase(height, 0, outerOffset);
                }
            }
        }
        translate([0, 0, -0.001]){
            linear_extrude(height = height + 0.002) {
                projection(cut = false) {
                    caseBase(height, 0, innerOffset);
                }
            }
        }
    }    
}

module bottomLeft() {
    difference() {
        union () {
            difference() {
                caseShell(15);
                translate ([-1, -1, portHeight]) {
                    cube ([500, 500, 10]); 
                }
                translate ([0, 0, bottomScrewPostHeight + plateThickness + 0.001]) {
                    caseSkirt(wallThickness/2, wallThickness + 0.001, 10);
                }                         
            }
            bottomScrewPosts();
        }
        bottomScrewHoles();
        translate([0, trrsOffset, portHeight]) {
            rotate([0,90,0]){
                cylinder(r=3, h=10, center=true);
            }
        }
        translate([wallThickness, trrsOffset, portHeight]) {
            cube([wallThickness, trrsNotchWidth, portHeight], center=true);
        }
        translate([wallThickness, usbOffset, portHeight]) {
            cube([wallThickness, usbNotchWidth, portHeight], center=true);
        }
    }   
}

module bottomRight() {
    mirror ([0, 1, 0]) {
        difference () {
            bottomLeft();
            translate([0, usbOffset, 7]) {
                usbCutout();
            }
        }
    }
}

module topPlateLeft() {
    union () {
        difference() {
            union () {
                caseShell(height);
                difference () {
                    topScrewPosts();
                    translate ([0, 0, portHeight - topScrewPostHeight + wallThickness/2]) {
                        caseSkirt(-2 * wallThickness, wallThickness - 0.001, topScrewPostHeight);
                    }
                }
                translate([pcbCircuitXDimension, wallThickness, height - topScrewPostHeight - plateThickness]) {
                    cube ([1, baseDimensionY - 2*wallThickness, topScrewPostHeight]);
                }
            }
            translate ([-1, -1, height - topScrewPostHeight - plateThickness - 10 - 0.001]) {
                cube ([500, 500, 10]); 
            }
            translate ([0, 0, portHeight - wallThickness/2 - 1]) {
                caseSkirt(- 0.001,  wallThickness/2, wallThickness/2 + 1);
            }
            translate ([-1, -1, 0]) {
                cube ([pcbCircuitXDimension + 1.001, baseDimensionY + 2, 20]); 
            }  
            screwHoles(frontCoordinates, height - 1);
            keyCutouts();    
        }                   
        translate([pcbCircuitXDimension - 1, diameter/2 + 4, height - 1.001]) {
            cube ([1, baseDimensionY - diameter - 8, 1]);
        }
        topBackScrewPosts();      
    }
}



module topPlateRight() {
    mirror ([0, 1, 0]) {
        topPlateLeft();
    }
}

module plateCoverLeft () {
    difference() {
        union () {
            difference() {
                union () {
                    topCoverRectangle(0, 0, 0);
                    caseRectangle(height, 0, 0);
                }
                topCoverRectangle(plateThickness, wallThickness, 1);
                translate ([-1, -1, height - topScrewPostHeight - plateThickness - 10 - 0.001]) {
                    cube ([500, 500, 10]); 
                }
                translate ([pcbCircuitXDimension, -1, height + 0.001 - 10]) {
                    cube ([500, 500, 10]); 
                }
                hull () {
                    translate ([pcbCircuitXDimension - 6, wallThickness + 1.5, height - 10]) {
                        cube ([10, baseDimensionY - 2 * wallThickness - 3, 10]); 
                    }
                    translate ([pcbCircuitXDimension - 6, wallThickness, height - plateThickness - topScrewPostHeight]) {
                        cube ([10, baseDimensionY - 2 * wallThickness, topScrewPostHeight]); 
                    }
                }
                translate ([0, 0, portHeight - wallThickness/2 - 1.001]) {
                    caseSkirt(-0.001,  wallThickness/2, wallThickness/2 + 1);
                }                                 
            }
            for (coordinate = backCoordinates) {
                topCoverScrewPost(coordinate);
            }
        }
        translate([0, trrsOffset, 7]) {
            rotate([0,90,0]){
                cylinder(r=3, h=10, center=true);
            }
        }
        screwHoles(backCoordinates, height + circuitBumpHeight - 1);
        translate([wallThickness - 0.001, trrsOffset, 7]) {
            cube([wallThickness, 10.3, 7], center=true);
        }
    }
}

module screwHoles (coordinates, height) {
    for (coordinate = coordinates) {
        translate ([coordinate[getX], coordinate[getY], 0]) {
            cylinder(r=screwBindRadius,h=height);
        }
    }  
}

module plateCoverRight() {
    mirror ([0, 1, 0]) {
        difference () {
            plateCoverLeft();
            translate([0, usbOffset, 7]) {
                hull () {
                    usbCutout();
                    translate([0, 0, -5]) {
                        usbCutout();
                    }
                }
            }
        }
    }
}

module keyCutouts() {
    translate([baseX + middleColumnsShift, baseY + keyGap/2, 0]) {    
        keyCutout(2*keyDist + outerColumnShift, - 3 * keyDist);
        for (i = [-2 : 2]) {
            if (i < 2) {
                keyCutout(i * keyDist + outerColumnShift, -outerRowKeyShift - 3 * keyDist);
                keyCutout(i * keyDist + innerColumnShift, 2 * keyDist);
            }
            keyCutout(i * keyDist + outerColumnShift, -2 * keyDist);
            keyCutout(i * keyDist + middleColumnsShift, -keyDist);
            keyCutout(i * keyDist, 0);
            keyCutout(i * keyDist + middleColumnsShift, keyDist);        
        }              
        innerDownShift1 = 4.7625;
        innerDownShift2 = innerDownShift1 + 9.5278;
        translate([innerColumnShift, 0, 0]) {        
            keyCutout(-2 * keyDist, 3 * keyDist);
            keyCutout(-keyDist + innerDownShift1, 3 * keyDist);
            keyCutout(innerDownShift2, 3 * keyDist);
        }
    }
    translate([thumbOffsetX, thumbOffsetY, 0]){
        rotate(-25) {
            translate([-keyCutDim/2 , -keyCutDim/2 , 0]) {
                for (i = [-1 : 1]) {
                    keyCutout(i * keyDist, keyDist);
                }
                keyCutout(-keyDist, 0);
                keyCutout(keyDist/2, 0);
                keyCutout(keyDist/2, -keyDist);
            }
        }
    }
}

module keyCutout(x, y) {
    translate ([x, y, 0]) {
        cube([keyCutDim, keyCutDim, 2* height]);
    }
}

module usbCutout() {
    topWidth = 7.7;
    bottomWidth = 6.7;
    zDim = 3.9;
    circleRad = 0.7;
    rotate([0,-90,0]){  
        hull() {
            translate([zDim/2-circleRad,topWidth/2 - circleRad,0]) {
                cylinder(r=circleRad, h=10, center=true);
            }
            translate([zDim/2-circleRad,-topWidth/2 + circleRad,0]) {
                cylinder(r=circleRad, h=10, center=true);
            }
            translate([0,topWidth/2 - circleRad,0]) {
                cylinder(r=circleRad, h=10, center=true);
            }
            translate([0,-topWidth/2 + circleRad,0]) {
                cylinder(r=circleRad, h=10, center=true);
            }
            translate([-zDim/2+circleRad,bottomWidth/2 - circleRad,0]) {
                cylinder(r=circleRad, h=10, center=true);
            }
            translate([-zDim/2+circleRad,-bottomWidth/2 + circleRad,0]) {
                cylinder(r=circleRad, h=10, center=true);
            }
        }
       
    }
}

module bottomScrewHoles() {
    for (coordinate = coordinates) {
        arcSegments = 25;
        translate ([coordinate[getX], coordinate[getY], -.01]) {
            union () {                
                cylinder(d=screwHeadDiameter,h=1.5,$fn=arcSegments);
                translate([0, 0, 1.5 - 0.001]) {
                    cylinder(r1=screwHeadDiameter/2, r2=screwPassthroughRadius, h=2.5-screwPassthroughRadius, $fn=arcSegments);
                }
                cylinder(r=screwPassthroughRadius,h=height,$fn=arcSegments); 
            }      
        }
    }
}

module bottomScrewPosts() {
    for (coordinate = coordinates) {
        translate ([coordinate[getX], coordinate[getY], plateThickness]) {
            union() {
                cylinder(r=3,h=bottomScrewPostHeight);
                cylinder(r=4,h=2);
            }  
        }
    }
}

module topScrewPosts() {
    for (coordinate = coordinates) {
        translate ([coordinate[getX], coordinate[getY], height - plateThickness - topScrewPostHeight]) {
            difference() {
                union () {
                    translate ([0, 0, -topScrewPostHeight + topScrewPostHeight]) {
                        cylinder(r=3,h=topScrewPostHeight);
                    }
                    translate ([0, 0, 0]) {
                        cylinder(r=3.5,h=topScrewPostHeight);
                    }
                }
            }      
        }
    }
}

module topBackScrewPosts() {
    postRadius = 3.5;
    for (coordinate = backCoordinates) {
        translate ([coordinate[getX], coordinate[getY], 0]) {
            difference() {
                union () {
                    hull () {
                        translate ([0, 0, height - topScrewPostHeight - plateThickness]) {
                            cylinder(r=postRadius,h=topScrewPostHeight + plateThickness);
                        }
                        translate ([15.75, -postRadius, height - topScrewPostHeight - plateThickness]) {
                            cube([1, 2 * postRadius, topScrewPostHeight]);
                        }
                        translate ([18.5, -postRadius, height - 1]) {
                            cube([1, 2 * postRadius, 1]);
                        }
                    }
                    translate ([0, 0, height - plateThickness -topScrewPostHeight]) {
                        cylinder(r=3,h=topScrewPostHeight);
                    }
                }
                union() {
                    cylinder(r=screwPassthroughRadius,h=height + 0.001);
                    translate ([3, -postRadius + 1, height/2 - 1]) {
                        cube([20, 2 * postRadius - 2, height/2]);
                    }
                }
            }
        }
    }
}

module topCoverScrewPost(coordinate) {
    translate ([coordinate[getX], coordinate[getY], height]) {
        cylinder(r=3,h=circuitBumpHeight - plateThickness);
    }
}

module roundedCylinder(height, diameter, surfaceDiameter, fa = $fa) {
    translate([0, 0, surfaceDiameter/2]) {
        hull () {
            rotate_extrude($fa = fa) {
                translate([diameter/2 - surfaceDiameter/2, 0, 0]) {
                    circle(d=surfaceDiameter);
                }
            }
            translate([0, 0, height - surfaceDiameter]) {
                rotate_extrude($fa = fa) {
                    translate([diameter/2 - surfaceDiameter/2, 0, 0]) {
                        circle(d=surfaceDiameter);
                    }
                }
            }
        }
    }
}

module roundedCube(x, y, z, eDia = 0.001, sDia = 0.001, useSpecialCorner = false) {
    hull() {
        translate([x - eDia/2, y - eDia/2, 0]) {
            roundedCylinder(z, eDia, sDia);
        }
        translate([eDia/2, y - eDia/2, 0]) {
            roundedCylinder(z, eDia, sDia);
        }
        if (useSpecialCorner) {
            specialCornerDia = 27;
            translate([x - specialCornerDia/2, specialCornerDia/2, 0]) {
                roundedCylinder(z, specialCornerDia, sDia, fa = $fa/2);
            }
        }
        else {
            translate([x - eDia/2, eDia/2, 0]) {
                roundedCylinder(z, eDia, sDia);
            }
        }
        translate([eDia/2, eDia/2, 0]) {
            roundedCylinder(z, eDia, sDia);
        }
    }
}
