var draw = SVG('drawing').size(1000, 600);

var robot_1 = draw.image('../svg_files/dessin.svg').size(55, 30).cx(500).cy(300);
var robot_2 = draw.image('../svg_files/dessin.svg').size(55, 30).cx(500).cy(300);
robot_1.rotate(-45.0);
robot_2.rotate(-45.0);
robot_1.animate(1000).dx(70.71067811865476).once(1, function(){robot_1.rotate(-225.0);}, true);
robot_2.animate(1000).dx(1.4142135623730951).once(1, function(){robot_2.rotate(-67.49939460514882);}, true);
robot_1.animate(2000).dx(127.27922061357856).once(1, function(){robot_1.rotate(-22.380135051959574);}, true);
robot_2.animate(2000).dx(258.69286808878206).once(1, function(){robot_2.rotate(-325.00797980144137);}, true);
robot_1.animate(1000).dx(367.6955262170047).once(1, function(){robot_1.rotate(-145.00797980144134);}, true);
robot_2.animate(1000).dx(244.13111231467406).once(1, function(){robot_2.rotate(-202.38013505195957);}, true);
robot_1.animate(2000).dx(244.13111231467406).once(1, function(){robot_1.rotate(-247.3801350519596);}, true);
robot_2.animate(2000).dx(367.6955262170047).once(1, function(){robot_2.rotate(-45.0);}, true);
robot_1.animate(4000).dx(260.0);
robot_2.animate(4000).dx(127.27922061357856);
