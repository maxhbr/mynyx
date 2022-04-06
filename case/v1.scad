var_variant="shrouded"; // ["shrouded", "plate", "no-thumb-cluster", "bottomPlate","mcuCap"]
var_side="left"; // ["left","right"]
var_show_assembly=true; //[true,false]

module switchPlate(mirror=false,variant) {
    mirror(mirror ? [1,0,0] : [0,0,0]) {
        difference() {
            union() {
                translate([0,0,2]) {
                    difference() {
                        union() {
                            if(variant=="shrouded") {
                                linear_extrude(height = 3, convexity = 10)
                                    import (file = "./svgs/case-boundary.svg");
                                translate([0,0,-2])
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
                            } else if (variant=="plate") {
                                linear_extrude(height = 3, convexity = 10)
                                    import (file = "./svgs/switch-boundary.svg");
                                translate([0,0,-1.5])
                                    intersection() {
                                        minkowski() {
                                            circumference();
                                            cylinder(r2=5,r1=3,h=1.5);
                                        }
                                        linear_extrude(height = 5, convexity = 10)
                                            import (file = "./svgs/switch-boundary.svg");
                                    }
                            } else if (variant=="no-thumb-cluster") {
                                linear_extrude(height = 3, convexity = 10)
                                    import (file = "./svgs/switch-boundary-no-tc.svg");
                            }
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
                    linear_extrude(height = 4, convexity = 10)
                        import (file = "./svgs/holes-no-mcu.svg");
                    cylinder(r=1.5,h=1,$fn=20);
                }
            }
            linear_extrude(height = 5, convexity = 10)
                import (file = "./svgs/holes-no-mcu.svg");
            linear_extrude(height = 5, convexity = 10)
                import (file = "./svgs/switches.svg");
            hull() {
                for(t=[[-4,0,3],[4,0,3],[4,0,6],[-4,0,6]]) {
                    translate([151,143,1]+t)
                    rotate([90,0,0])
                    cylinder(h=10,r=4,$fn=20);
                }
            }
            if(variant=="shrouded") {
                color("red")
                    translate([75,31,2.3])
                    rotate([0,180,-45])
                    linear_extrude(0.31)
                    mirror(mirror? [1,0,0] : [0,0,0])
                    text("github.com/maxhbr",
                            font = "Roboto Condensed:style=bold",
                            size = 6.5,
                            halign = "center");
            }
        }
    }
}

module circumference() {
    render(convexity = 2)
        difference() {
            minkowski() {
                linear_extrude(height = 0.1, convexity = 10)
                    import (file = "./svgs/case-boundary.svg");
                cylinder(r=1,h=0.1);
            }
            linear_extrude(height = 0.2, convexity = 10)
                import (file = "./svgs/case-boundary.svg");
        }
}

module bottomPlate(mirror=false, height=4.5) {
    mirror(mirror ? [1,0,0] : [0,0,0])
    translate([0,0,-height - 1.6]) {
        intersection() {
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
                        cylinder(r1=3,r2=1.6,h=height-2,$fn=4);
                    }
                    minkowski() {
                        circumference();
                        cylinder(r1=5,r2=3,h=3);
                    }
                }
                minkowski() {
                    linear_extrude(height = 3, convexity = 10)
                        import (file = "./svgs/holes.svg");
                    cylinder(r=0.4,h=height-3,$fn=20);
                }
                color("red")
                    translate([148.5,94,1.2])
                    rotate([0,0,-90])
                    linear_extrude(0.31)
                    mirror(mirror? [1,0,0] : [0,0,0])
                    text("github.com/maxhbr",
                            font = "Roboto Condensed:style=bold",
                            size = 6.5,
                            halign = "center");
            }
            difference() {
                linear_extrude(height = 10, convexity = 10)
                    import (file = "./svgs/case-boundary.svg");
                render(convexity = 2)
                    minkowski() {
                        circumference();
                        cylinder(r=0.3,h=10);
                    }
                }
            }
        }
}

module mcuCap(mirror=false, h=7) {
        difference() {
            union() {
                minkowski() {
                    translate([0,0,h])
                        linear_extrude(height = 1, convexity = 10)
                        import (file = "./svgs/mcu.svg");
                    cylinder(r2=0.1,r1=1.1,h=1);
                }
                minkowski() {
                    linear_extrude(height = h, convexity = 10)
                        import (file = "./svgs/mcu-holes.svg");
                    cylinder(r=1.5,h=2);
                }
            }
            linear_extrude(height = h+2, convexity = 10)
                import (file = "./svgs/mcu-holes.svg");
        }
}

if(var_variant == "bottomPlate") {
    bottomPlate(var_side != "left");
} else if(var_variant == "mcuCap") {
    rotate($preview ? [0,0,0] : [180,0,0])
        mcuCap(var_side != "left");
} else {
    rotate($preview ? [0,0,0] : [180,0,0])
        switchPlate(var_side != "left", variant=var_variant);
}

/*
###############################################################################
###############################################################################
###############################################################################
*/

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


if ($preview && var_show_assembly) {
    translate([200,0,0]) {
        mirror(var_side != "left" ? [1,0,0] : [0,0,0])
            pcb();
        if(var_variant != "plate") {
            render(convexity = 2)
                switchPlate(var_side != "left", variant="shrouded");
        } else {
            render(convexity = 2)
                switchPlate(var_side != "left", variant="plate");
        }
        render(convexity = 2)
            bottomPlate(var_side != "left");
        render(convexity = 2)
            mcuCap(var_side != "left");
    }
}


