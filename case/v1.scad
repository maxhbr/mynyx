part="switchPlate"; // ["switchPlate", "bottomPlate"]
mirror=false; // [true,false]

module pcb() {
    difference() {
        color("green", 0.2)
            translate([0,0,-1.6])
                linear_extrude(height = 1.6, convexity = 10)
                import (file = "./svgs/case-boundary.svg");
        translate([0,0,0])
            linear_extrude(height = 15, center = true, convexity = 10)
            import (file = "./svgs/holes.svg");
    }
}

module switchPlate() {
    difference() {
        union() {
            translate([0,0,2]) {
                difference() {
                    union() {
                        linear_extrude(height = 3, convexity = 10)
                            import (file = "./svgs/switch-boundary.svg");
                        linear_extrude(height = 3, convexity = 10)
                            import (file = "./svgs/case-boundary.svg");
                    }

                    linear_extrude(height = 3, convexity = 10)
                        import (file = "./svgs/mcu.svg");
                    minkowski() {
                        union() {
                            linear_extrude(height = 1.5, convexity = 10)
                                import (file = "./svgs/switches-small.svg");
                            hull() {
                                linear_extrude(height = 1.5, convexity = 10)
                                    import (file = "./svgs/stabs.svg");
                            }
                        }
                        translate([0,0,-1])
                            cylinder(r=1.7,h=1,$fn=20);
                    }
                }
            }
            minkowski() {
                translate([0,0,0])
                    linear_extrude(height = 4, convexity = 10)
                    import (file = "./svgs/holes-no-mcu.svg");
                translate([0,0,0])
                    cylinder(r=1.5,h=1,$fn=20);
            }
        }
        linear_extrude(height = 5, convexity = 10)
            import (file = "./svgs/holes-no-mcu.svg");
        linear_extrude(height = 5, convexity = 10)
            import (file = "./svgs/switches.svg");

    }
    difference() {
        coneH=4;
        minkowski() {
            translate([0,0,-coneH/2])
                linear_extrude(height = 10-coneH, center=true, convexity = 10)
                import (file = "./svgs/case-boundary.svg");
            cylinder(h=4, r1=2, r2=1);
        }
        linear_extrude(height = 10, center=true, convexity = 10)
            import (file = "./svgs/case-boundary.svg");
    }
}

module bottomPlate() {
    translate([0,0,-4 - 1.6]) {
        difference() {
            union() {
                difference() {
                    linear_extrude(height = 1.5, convexity = 10)
                        import (file = "./svgs/case-boundary.svg");
                    translate([0,0,1])
                        linear_extrude(height = 1, convexity = 10)
                        import (file = "./svgs/switches.svg");
                }
                minkowski() {
                    linear_extrude(height = 2, convexity = 10)
                        import (file = "./svgs/holes.svg");
                    cylinder(r1=3,r2=1.6,h=2,$fn=4);
                }
            }
            minkowski() {
                linear_extrude(height = 3, convexity = 10)
                    import (file = "./svgs/holes.svg");
                cylinder(r=0.4,h=1,$fn=20);
            }
            render(convexity = 2)
                minkowski() {
                    difference() {
                        minkowski() {
                            linear_extrude(height = 0.1, convexity = 10)
                                import (file = "./svgs/case-boundary.svg");
                            cylinder(r=1,h=0.1);
                        }
                        linear_extrude(height = 0.2, convexity = 10)
                            import (file = "./svgs/case-boundary.svg");
                    }
                    cylinder(r=0.3,h=4);
                }
        }
    }
}

mirror(mirror ? [1,0,0] : [0,0,0])
    if (part=="switchPlate") {
        rotate([180,0,180]) switchPlate();
    } else if (part=="bottomPlate") {
        mirror([1,0,0])
        bottomPlate();
    }

translate([50,50,0])
if ($preview) {
    intersection() {
    switchPlate();
    cube([200,200,100], center=true);
    }
    bottomPlate();
    /* pcb(); */
}

