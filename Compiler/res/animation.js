import {Move} from './move.js';

var draw = SVG('drawing').size(1000, 600);

var robot_1  = new Move(draw,'C:/Users/HuseyinK/RubymineProjects/Animo/Compiler/code_generator/../test_files/dessin.svg', 1000, 600, 55, 30);
var robot_2  = new Move(draw,'C:/Users/HuseyinK/RubymineProjects/Animo/Compiler/code_generator/../test_files/dessin.svg', 1000, 600, 55, 30);
robot_1 .rotate(45.0);
robot_2 .rotate(45.0);
robot_1 .moveToAndRotation(70.71067811865476, 225.0, 1000);
robot_2 .moveToAndRotation(1.4142135623730951, 73.72032679786949, 1000);
robot_1 .moveToAndRotation(127.27922061357856, 22.380135051959574, 2000);
robot_2 .moveToAndRotation(353.1600203873592, 309.8055710922652, 2000);
robot_1 .moveToAndRotation(367.6955262170047, 129.80557109226518, 1000);
robot_2 .moveToAndRotation(312.40998703626616, 202.38013505195957, 1000);
robot_1 .moveToAndRotation(312.40998703626616, 253.6104596659652, 2000);
robot_2 .moveToAndRotation(367.6955262170047, 45.0, 2000);
robot_1 .moveToAndRotation(354.400902933387, 0, 4000);
robot_2 .moveToAndRotation(127.27922061357856, 0, 4000);
