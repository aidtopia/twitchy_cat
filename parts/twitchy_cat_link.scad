// Twitchy Cat Link
// Adrian McCarthy 2024-04-13
//
// Manually fabricating the necessary link for the Twitchy Cat Halloween
// prop was too error prone.  This design constrains some of the unwanted
// degrees of freedom and makes the mechanism work reliably.  It also
// gives a nearly ideal place to anchor the spring for the return action.

module twitchy_cat_link(l=25, th=3, nozzle_d=0.4) {
    no6_free_d = 0.1495 * 25.4 + nozzle_d;
    no6_head_d = 0.270 * 25.4 + nozzle_d;
    no6_head_h = 0.097 * 25.4 - nozzle_d;
    no6_nut_d = (5/16 * 25.4 + nozzle_d) / cos(30);
    no6_nut_h = 7/64 * 25.4 - nozzle_d;
    nose_w = 5;
    nose_d = 12;
    zip_w = 5 + 3*nozzle_d;
    zip_th = 2 + 3*nozzle_d;
    notch_w = nose_w + nozzle_d;
    notch_d = nose_d + 2;
    w    = max(th + notch_w + th, no6_head_h + 1.2 + notch_w + 1.2 + no6_nut_h);
    base = min(no6_nut_d + 4*nozzle_d, notch_d);
    translate([0, 0, base/2]) rotate([90, 0, 0]) {
        difference() {
            linear_extrude(w, convexity=8, center=true) {
                difference() {
                    hull() {
                        translate([l, 0]) circle(d=base, $fs=nozzle_d/2);
                        square([0.1, base], center=true);
                    }
                    translate([l, 0]) circle(d=no6_free_d, $fs=nozzle_d/2);
                }
            }
            translate([l, 0, 0]) {
                translate([0, 0, w/2-no6_head_h])
                    cylinder(h=no6_head_h+0.1, d=no6_head_d, $fs=nozzle_d/2);
                cylinder(h=notch_w, d=notch_d, center=true, $fs=nozzle_d/2);
                translate([0, 0, -(w/2+0.1)]) rotate([0, 0, 30])
                    cylinder(h=no6_nut_h+0.1, d=no6_nut_d, $fn=6);
            }
            translate([-(25-th)/2, 0, 0]) rotate([90, 0, 0])
                cylinder(h=base+0.1, d=25, center=true);
            translate([-(25-th)/2, 0, 0]) rotate([90, 0, 0]) {
                linear_extrude(zip_w, convexity=8, center=true) {
                    difference() {
                        // High $fn because the cable tie needs a smooth
                        // channel.
                        circle(d=25+th+zip_th, $fn=180);
                        circle(d=25+th, $fn=180);
                    }
                }
            }
        }
    }
    spring_d = 10;
    spring_offset = 30-22/2;
    wing_w = base;
    linear_extrude(th, convexity=8) {
        translate([l/2, 0, 0])
            polygon([
                [0, spring_offset],
                [-wing_w/2, base/2-0.1],
                [ wing_w/2, base/2-0.1],
                [ th, spring_offset+0.5*th],
                [-th, spring_offset+1.5*th],
                [-1.5*th, spring_offset+th]
            ]);
    }
}

twitchy_cat_link();
