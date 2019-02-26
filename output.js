import {Move} from './move.js';

var image = new Move('500' ,'300', 'compiler/test_files/dessin.svg', 1000, 600,
                    '55', '30');

image.moveToAndRotation(0, 0);
image.moveToAndRotation(10, 90);
image.moveToAndRotation(20, 180);
image.moveToAndRotation(30, 270);
image.moveToAndRotation(40, 360);
image.moveToAndRotation(50, 450);
image.moveToAndRotation(60, 540);
image.moveToAndRotation(70, 630);
image.moveToAndRotation(80, 720);
image.moveToAndRotation(90, 810);
