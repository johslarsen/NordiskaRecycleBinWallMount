bracket = [65, 100, 2];

track = [73, 56, 4];
radius = 2;
support = [bracket[0], track[1] - 10, 8];

// WARN: too steep, and box will jam the bracket (box_back below)
angle = 2; // 12L
//angle = 4; // 7L

$fn = 50;

/* align simulated box backs below so that the top is around the top of the
 * tracks. then the bottom of the box will rest on the wall. too high, and the
 * bottom pushes into wall, jamming the slide mechanism. or too low and it
 * hangs midair, stressing the bracket attachment (glue) more. */
//color("red") box_back(310); // 12L
//color("green") box_back(175); // 7L
module box_back(height) {
	translate([track[0] / 2, track[1]-bracket[1]/2 - height, 0])
		rotate([angle, 0, 0])
		cube([1,height,1]);
}


cube(bracket, center=true);
translate(bracket * -0.5)  {
    rbox(support + [0,0,track[2]], [0.01,0.01,radius,radius]);
    translate([(bracket[0]-track[0])/2, 0, support[2]])
		rotate([angle, 0, 0])
		rcube(track, [0.01, 0.01, radius, radius], [0.01, 0.01, radius, radius], 0.01);
}


module rbox(size = [1,1,1], zr = 0.01) {
    size = (size[0] == undef) ? [size, size, size] : size;
    zr = (zr[0] == undef) ? [zr, zr, zr, zr] : zr;
    hull() {
        translate([zr[0], zr[0], 0])
			cylinder(r=zr[0], h=size[2]); // bottom-left
        translate([size[0]-zr[1], zr[1], 0])
			cylinder(r=zr[1], h=size[2]); // bottom-right
        translate([size[0]-zr[2], size[1]-zr[2], 0])
			cylinder(r=zr[2], h=size[2]); // top-right
        translate([zr[3], size[1]-zr[3], 0])
			cylinder(r=zr[3], h=size[2]); // top-left
    }
}
module rcube(size = [1,1,1], zr = 0.01, yr = 0.01, xr = 0.01) {
    size = (size[0] == undef) ? [size, size, size] : size;
    intersection() {
        rbox(size, zr); // z-corners on xy-plane
        translate([0, 0, size[2]]) rotate([0, 90, 0])
			rbox([size[2], size[1], size[0]], yr); // y-corners on zx-plane
        translate([0, size[1], 0]) rotate([90, 0, 0])
			rbox([size[0], size[2], size[1]], xr); // x-corners on yz-plane
    }
}
