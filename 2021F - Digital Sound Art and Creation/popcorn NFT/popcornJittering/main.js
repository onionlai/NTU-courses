///////////////////////////////
///////// VARIABLES ///////////
///////////////////////////////
let ctx;                    // canvas
let canvasSizeX;            // canvas
let canvasSizeY;            // canvas

let pressXBuf = -1;
let pressYBuf = -1;
let vol = 0.3;              // volume of poping & eating
let p = 0;                  // volume of stove = vol * p * fireAmp
let p1 = 0.04;              // p = 0 or p1
let p2 = 1.2;               // volume of bite = col * p2
let randomMode = false;
let getPopcorn = false;     // for background flick
let popEffectCountDown = 5; // for background flick
let fireAmp = 3;            // for fire amplitude -> frequency of poping pop-corn
let i = 0;

//--- COLOR ---//
let corn_i_h = 48;
let corn_i_s = 36;
let corn_i_b = 98;

let corn_f_h = 33;
let corn_f_s = 38;
let corn_f_b = 79;

let corn_heat_time = 100;
let corn_incr_h = (corn_f_h - corn_i_h ) / corn_heat_time;
let corn_incr_s = (corn_f_s - corn_i_s ) / corn_heat_time;
let corn_incr_b = (corn_f_b - corn_i_b ) / corn_heat_time;

//--- CORN ---//
let corns = [];
let cornsX = 160;
let cornsY = 80;
let cornsNum = 30;
let cornSizeX = 15;
let cornSizeXSpace = 0.9;
let cornSizeY = 8;
let cornSizeYSpace = 0.3;

// --- POPCORN --- //
let popcorns = [];
let popcornsNum = 300;
let noPopcorn = false; // check if out of popcorn
let eatSignal = false; // make sure every frame only trigger one sound

////////////////////////////
/////////// SETUP //////////
////////////////////////////
function setup() {
  // -- canvas -- //
  if(windowWidth > windowHeight){
    canvasSizeX = windowHeight;
  }
  else{
    canvasSizeX = windowWidth;
  }
  canvasSizeY = canvasSizeX;
  ctx = createCanvas(canvasSizeX, canvasSizeY).elt.getContext('2d');
  background(0);
  colorMode(HSB, 360, 100, 100);
  
  // -- corn -- //
  cornsX = (canvasSizeX / 2) - 2 * (cornSizeX) + 0.5 * cornSizeXSpace;
  cornsY = (canvasSizeY / 2) - cornsNum / 8 * (cornSizeY) + 0.5 * cornSizeYSpace;

  for(i = 0; i < cornsNum; i ++){
    corns.push(new Corn());
    corns[i].init();
  }
  
  // -- popcorn -- //
  for(i = 0; i < popcornsNum; i ++){
    popcorns.push(new Popcorn());
  }
}

////////////////////////////
/////////// DRAW ///////////
////////////////////////////
function draw() {
  // -- volume setup -- //
  if(frameCount == 1){
    Pd.send('v', [vol]);
    Pd.send('bite_v', [vol * p2]);
    Pd.send('vol', [vol * fireAmp * p]);
  }
  
  // -- draw background -- //
  background(25);
  if(randomMode && !noPopcorn){
    if(random(0, 1) < 0.1 * fireAmp){
      i = (int)(random(0, cornsNum));
      corns[i].onClick();
    }
  }
  if(getPopcorn) {
    background(30);
    popEffectCountDown -= 1;
    if(popEffectCountDown <= 0){
      getPopcorn = false;
      popEffectCountDown = 5;
    }
  }
  // -- draw hotpot -- //
  // push();
  // translate(canvasSizeX / 2, canvasSizeY / 2 + cornSizeY * cornsNum / 8);
  // scale(canvasSizeX / 500, canvasSizeY / 500);
  // drawPot();
  // pop();
  
  // -- corn update -- //
  for(i = 0; i < cornsNum; i++){
    if(pressXBuf != -1)
      corns[i].checkClick();
    corns[i].update();
  }
  // -- popcorn update -- //
  eatSignal = false;
  for(i = 0; i < popcornsNum; i++){
    if(pressXBuf != -1)
      popcorns[i].checkClick();
    popcorns[i].update();
  }
  pressXBuf = -1;
  pressYBuf = -1;
}
////////////////////////////
////////// CORN ////////////
////////////////////////////
class Corn {
  constructor(){
    this.x = random(0, canvasSizeX);
    this.y = random(0, canvasSizeY);
    this.deg = random(0, 360);
    this.sc = random(0.8, 1);
    this.type = (int)(random(1, 3));
  }
  
  init() {
    this.heating = false;
    this.readyToPop = false;
    this.popCorn = false;
    this.heat_countdown = 100;
    this.h = corn_i_h;
    this.s = corn_i_s;
    this.v = corn_i_b;
    
    this.drawCorn();
    
  }
  
  update() {
    if(randomMode){
      if(random(0, 1) < 0.2){
        this.x += random(-0.2,0.2) * fireAmp;
        this.y += random(-0.2,0.2) * fireAmp;
      }
    }
    // -- check heating -- //
    if(this.heating == true){ // graduately change the color
      this.x += random(-0.5,0.5);
      this.y += random(-0.5,0.5);
      
      this.h += corn_incr_h;
      this.s += corn_incr_s;
      this.b += corn_incr_b;
      
      this.heat_countdown -= 1;
      if(this.heat_countdown <= 0){
        this.heat_countdown = corn_heat_time;
        this.heating = false;
        this.readyToPop = true;
      }
    }
    // -- decide to pop -- //
    else if (this.readyToPop == true && !noPopcorn){
      this.x += random(-0.6,0.6);
      this.y += random(-0.6,0.6);
      if(frameCount % 2 == 0){ // tempo
        let r = random(0, 1);
        if(r < 0.02 * fireAmp){ // randomly decide
          this.readyToPop = false;
          Pd.send('pop', ['bang']);
          getPopcorn = true;
          newPopcorn(this.x, this.y);
          this.init();
        }
      }
    }
    else{

    }
    this.drawCorn();
  }
  
  checkClick() {
    if(dist(this.x, this.y, pressXBuf, pressYBuf) < this.sc * 10){
      this.onClick();
    }
  }
  
  onClick() {
    if (this.heating == true || this.readyToPop) return;
    this.h = corn_i_h;
    this.s = corn_i_s;
    this.b = corn_i_b;
    this.heating = true;
  }
  
  drawCorn(){
    drawCorn(this.x, this.y, this.deg, this.sc, this.h, this.s, this.v);
  }
  
}
////////////////////////////
///////// POPCORN //////////
////////////////////////////
let j = 0;
function newPopcorn(x, y){
  for(j = 0; j < popcornsNum; j ++){
    if(popcorns[j].eaten == true){
      popcorns[j].init(x, y);
      return;
    }
  }
  noPopcorn = true;
  return;
}

class Popcorn {
  constructor(){
    this.eaten = true;    
  }
  
  init(x, y){
    this.x = x;
    this.y = y;
    this.vx = random(-15, 15);
    this.vy = random(-15, 15);
    this.ax = 0.9;
    this.ay = 0.9;
    
    this.type = (int)(random(1, 3));
    this.color = (int)(random(1, 6));
    this.deg = random(0, 360);
    this.sc = random(1, 1.5);
    this.eaten = false;
    this.settledown = false;
  }
  
  update(){
    if(this.eaten) return;
    
    if(!this.settledown){
      
      // -- update movement -- //
      this.x += this.vx;
      this.y += this.vy;
      this.vy *= this.ay;
      this.vx *= this.ax;
      
      if(abs(this.vx) < 0.001 || abs(this.vy) < 0.001){
        this.settledown = true;
      }
      
      if(this.x > canvasSizeX + 10 || this.x < -10){ // fall outside
        this.eaten = true;
        if(noPopcorn) noPopcorn = false;
      }
      else if(this.y > canvasSizeY + 10 || this.y < -10){ // fall outside
        this.eaten = true;
        if(noPopcorn) noPopcorn = false;
      }
      
      if((this.x > canvasSizeX - this.sc * 10 && this.vx > 0 )|| (this.x < this.sc * 10 && this.vx < 0)){ // bounce at left or right
        this.vx = - this.vx;
      }
      
      if((this.y > canvasSizeY - this.sc * 10 && this.vy > 0 )|| (this.y < this.sc * 10 && this.vy < 0)){ // bounce at ground or top
        this.vy = - this.vy;
      }
      
      if(this.ax != 0 && abs(this.vx) < 0.02){ // hor. movement should converge
        this.vx = 0;
        this.ax = 0;
      }
      if(this.ay != 0 && abs(this.vy) < 0.02){ // ver. movement should converge
        this.vy = 0;
        this.ay = 0;
      }
      
    }
    this.drawPopcorn();
    
  }
  
  checkClick(){
    if(this.eaten == true) return;
    if(dist(this.x, this.y, pressXBuf, pressYBuf) < this.sc * 30){
      // print("eat");
      this.onClick();
    }
  }
  
  onClick(){
    if(this.eaten == false){
      if(!eatSignal) {
        Pd.send('bang', ['bang']);
        eatSignal = true;
      }
      this.eaten = true;
      if(noPopcorn) noPopcorn = false;
    }
  }
  
  drawPopcorn(){
    push();
    translate(this.x, this.y);
    rotate(this.deg);
    scale(this.sc, this.sc);
    
    switch(this.type) {
      case 1:
        drawPopcorn1(this.color);
        break;
      case 2:
        drawPopcorn2(this.color);
        break;
    }
    pop();
  }
}

////////////////////////////////
///////// INPUT SYSTEM /////////
////////////////////////////////
function mousePressed(){
  // -- mouse clicking -- //
  pressXBuf = mouseX;
  pressYBuf = mouseY;
}

function keyPressed() {
  // -- volume control -- //
  if (keyCode === RIGHT_ARROW) {
    if(vol < 1){
      vol += 0.02;
      Pd.send('vol', [vol * fireAmp * p]);
      Pd.send('v', [vol]);
      Pd.send('bite_v', [vol * p2]);
    }
  } 
  else if (keyCode === LEFT_ARROW) {
    if(vol > 0){
      vol -= 0.02;
      Pd.send('vol', [vol * fireAmp * p]);
      Pd.send('v', [vol]);
      Pd.send('bite_v', [vol * p2]);
    }
  }
  // -- fire(randomMode) on/off -- //
  else if(keyCode === 32){
    if(randomMode) p = 0;
    else p = p1;
    Pd.send('vol', [vol * fireAmp * p]);
    randomMode = !randomMode;
  }
  // -- fire increase/decrease -- //
  else if (keyCode === UP_ARROW && fireAmp < 6 && randomMode){
    if(vol < 1){
      Pd.send('vol', [vol * fireAmp * p]);
    }
    
    fireAmp ++;
  } 
  else if (keyCode === DOWN_ARROW && fireAmp > 1 && randomMode){
    if(vol > 0){
      Pd.send('vol', [vol * fireAmp * p]);
    }
    fireAmp --;
  }
}

///////////////////////////
//////// DRAW SHAPE ///////
///////////////////////////
function drawPopcorn1(colorType){
  switch(colorType) {
    case 1:
      fill(33, 38, 79);
      break;
    case 2:
      fill(38, 9, 100);
      break;
    case 3:
      fill(48, 23, 98);
      break;
    case 4:
      fill(37, 39, 93);
      break;
    case 5:
      fill(32, 6, 100);
  }
  stroke(0, 0, 5);
  strokeWeight(1);
  
  
  ctx.beginPath();
  ctx.moveTo(-6.68,13.73);
  ctx.bezierCurveTo(-10.14,14.32,-13.61,13.19,-15.52,10.7);
  ctx.bezierCurveTo(-18.22,7.19,-17.58,1.34,-13.34,-2.26);
  ctx.bezierCurveTo(-15.2,-9,-11.45,-15.95,-5.22,-18.01);
  ctx.bezierCurveTo(0.41,-19.87,8.23,-18.61,9.92,-11.83);
  ctx.bezierCurveTo(10.35,-11.61,16.34,-8.46,17.07,-1.65);
  ctx.bezierCurveTo(17.6,3.29,15.13,8.17,10.77,10.83);
  ctx.bezierCurveTo(10.22,14.66,7.36,17.76,3.62,18.58);
  ctx.bezierCurveTo(0.06,19.36,-3.66,17.93,-5.83,14.95);
  ctx.lineTo(-5.83,14.95);
  ctx.lineTo(-6.68,13.73);
  ctx.closePath();
  
  
  // if(getPopcorn == true)
    ctx.stroke();
  // else
    ctx.fill();
  
  
  switch(colorType) {
    case 1:
      fill(33, 38, 60);
      break;
    case 2:
      fill(38, 9, 70);
      break;
    case 3:
      fill(48, 23, 70);
      break;
    case 4:
      fill(37, 39, 70);
      break;
    case 5:
      fill(32, 6, 70);
  }
  
  ctx.beginPath();
  ctx.moveTo(-9.61,-2.96);
  ctx.bezierCurveTo(-9.61,-2.96,-3.07,0.76,-1.71,-3.6);
  ctx.bezierCurveTo(-0.41,-7.76,0,-8.32,0,-8.32);
  ctx.bezierCurveTo(0,-8.32,-3.16,4.58,4.29,2.58);
  ctx.bezierCurveTo(4.29,2.58,-0.89,2.58,-3.16,8.39);
  ctx.bezierCurveTo(-3.16,8.4,-1.8,-0.59,-9.61,-2.96);
  ctx.closePath();
  
  // if(getPopcorn == true)
    // ctx.stroke();
  // else
    ctx.fill();
}
function drawPopcorn2(colorType){
  switch(colorType) {
    case 1:
      fill(33, 38, 79);
      break;
    case 2:
      fill(38, 9, 100);
      break;
    case 3:
      fill(48, 23, 98);
      break;
    case 4:
      fill(37, 39, 93);
      break;
    case 5:
      fill(32, 6, 100);
  }
  stroke(0, 0, 5);
  strokeWeight(1);
  
  ctx.beginPath();
  ctx.moveTo(-9.07,-4.41);
  ctx.bezierCurveTo(-9.07,-4.41,-9.49,-11.18,-3.6,-12.12);
  ctx.bezierCurveTo(2.29,-13.06,4.63,-8.63,4.63,-8.47);
  ctx.bezierCurveTo(4.63,-8.31,9.01,-8.94,10.93,-5.19);
  ctx.bezierCurveTo(12.85,-1.44,10.57,1.43,10.57,1.43);
  ctx.bezierCurveTo(10.57,1.43,14.06,5.34,9.22,10.18);
  ctx.bezierCurveTo(4.38,15.02,0.05,9.86,0.05,9.86);
  ctx.bezierCurveTo(0.05,9.86,-3.44,11.74,-6.2,9.76);
  ctx.bezierCurveTo(-8.96,7.78,-8.86,4.91,-8.86,4.91);
  ctx.bezierCurveTo(-8.86,4.91,-11.94,3.37,-11.78,0);
  ctx.bezierCurveTo(-11.62,-3.37,-9.07,-4.41,-9.07,-4.41);
  ctx.closePath();
  // if(getPopcorn == true)
    ctx.stroke();
  // else
    ctx.fill();
}

function drawPot(){
  fill(0, 0, 19);
  ctx.beginPath();
  ctx.moveTo(-69.46,0);
  ctx.lineTo(69.46,0);
  ctx.bezierCurveTo(69.46,0,68.99,20.24,58.52,22.8);
  ctx.bezierCurveTo(48.05,25.36,-56.37,22.88,-56.37,22.88);
  ctx.bezierCurveTo(-56.37,22.88,-68.53,23.27,-69.46,0);
  ctx.closePath();
  ctx.fill();
  
  ctx.beginPath();
  ctx.moveTo(-67.32,5.02);
  ctx.bezierCurveTo(-67.32,5.02,-150.38,-11.34,-156.94,-12.9);
  ctx.bezierCurveTo(-165.24001,-14.87,-153.95,-3.36,-148.24001,-1.11);
  ctx.bezierCurveTo(-128.25,6.77,-75.95,11.11,-66.66,11.28);
  ctx.lineTo(-66.66,11.28);
  ctx.lineTo(-67.32,5.02);
  ctx.closePath();
  ctx.fill();
  
  
  fill(16, 49, 92);
  if(randomMode){
    for(i = -fireAmp; i <= fireAmp; i ++){
      push();
      
      translate(i * 6 + random(-0.6, 0.6), 0);
      ctx.beginPath();
      ctx.moveTo(0,23.96);
      ctx.bezierCurveTo(0,23.96,-5.12,30.64,0,30.64);
      ctx.bezierCurveTo(5.12,30.64,0,23.96,0,23.96);
      ctx.closePath();
      ctx.fill();
      pop();
    }
  }
}
function drawPopcorn(x, y, deg, sc, type){
  push();
  translate(x, y);
  rotate(deg);
  scale(sc, sc);
  
  if(type == 1)
    drawPopcorn1();
  else if(type == 2)
    drawPopcorn2();
  
  pop();
}

function drawCorn(x, y, deg, sc, h, s, v){
  push();
  translate(x, y);
  rotate(deg);
  scale(sc * 0.9, sc * 0.9);
  fill(h,s,v);
  // noStroke();
  
  ctx.beginPath();
  ctx.moveTo(-11.47,-9.93);
  ctx.bezierCurveTo(-11.68,-9.48,-12.56,-4.34,-11.29,-1.43);
  ctx.bezierCurveTo(-10.17,1.15,-7.66,7.18,-5.48,9.21);
  ctx.bezierCurveTo(-3.52,11.04,1.61,14.97,7.67,8.93);
  ctx.bezierCurveTo(13.73,2.88,13.08,-4.49,7.59,-6.96);
  ctx.bezierCurveTo(2.1,-9.43,1.09,-11.27,-3.53,-12.04);
  ctx.bezierCurveTo(-7.63,-12.72,-11.28,-10.36,-11.47,-9.93);
  ctx.closePath();
  ctx.fill();
  // ctx.stroke();
  pop();
}