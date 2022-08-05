color Cltable[] = new color[16];
int pos = 0;
int bitmap[] = {
  0b000000, 0b100000, 0b010000, 0b110000,
  0b001000, 0b101000, 0b011000, 0b111000,
  0b000100, 0b100100, 0b010100, 0b110100,
  0b001100, 0b101100, 0b011100, 0b111100,
  0b000010, 0b100010, 0b010010, 0b110010,
  0b001010, 0b101010, 0b011010, 0b111010,
  0b000110, 0b100110, 0b010110, 0b110110,
  0b001110, 0b101110, 0b011110, 0b111110};

void drawPixel(int x, int y, color col) {
  fill(col);
  rect(x*3, y*3, 3, 3);
}
int curX =0,curY=0;
void printBitmap(int num, color bg, color fg) {
  int bmap = bitmap[(num - 0x80)];
  for (int i =2; i>=0; i--) {
    for (int j =1; j>=0; j--) {
      drawPixel(curX*2+j,curY*3+i,((bmap & 1) == 1? bg: fg));
      bmap = bmap>>1;
    }
  }
}


void setup() {
  size(858, 468);
  
  byte p[] = loadBytes("img.bpf");
  int dtLen = p.length;
  int Iwidth = ((int)p[pos+1]<<8)| ((int)p[pos]& 0xff);
  println(Iwidth);
  pos+=2;
  
  int Iheight = ((int)p[pos+1]<<8)| ((int)p[pos]& 0xff);
  println(Iheight);
  pos+=2;
  

  background(0);
  noStroke();
  
  int colAM = ((int)p[pos+1]<<8)| ((int)p[pos]& 0xff);
  println(colAM);
  pos+=2;
  for (int i =0; i<16; i++) {
    Cltable[i] = color(((int)p[pos+2]& 0xff), ((int)p[pos+1]& 0xff), ((int)p[pos]& 0xff));
    pos+=3;
  }
  curX = 0;curY = 0;
  for(curY = 0;curY<Iheight;curY++) {
    for (curX=0; curX<Iwidth; curX++) {
      if(pos+1 >= dtLen) break; 
      int pal = ((int)p[pos]& 0xff);
      int palA = pal & 0b1111;
      int palB = pal >>4;
      int bitmap = ((int)p[pos+1]& 0xff);
      pos+=2;
      printBitmap(bitmap, Cltable[palA], Cltable[palB]);
    }
  }
  println(dtLen-pos);
}
