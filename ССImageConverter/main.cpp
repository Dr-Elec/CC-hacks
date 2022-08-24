#include <bits/stdc++.h>
#define DEBUG
#ifdef DEBUG
#define deb(x,y) cout<<x<<y<<endl;
#define Fpos cout<<"--"<<fin.tellg()<<endl;
#define printUint32(x) cout<<x<<readUint32()<<endl;
#define printInt32(x) cout<<x<<readInt32()<<endl;
#define printUint16(x) cout<<x<<readUint16()<<endl;
#define printInt16(x) cout<<x<<readInt16()<<endl;
#else// DEBUG
#define deb(x,y)
#define Fpos
#define printUint32(x) fin.seekg(4,ios_base::cur);
#define printInt32(x) fin.seekg(4,ios_base::cur);
#define printUint16(x) fin.seekg(2,ios_base::cur);
#define printInt16(x) fin.seekg(2,ios_base::cur);
#endif // DEBUG
using namespace std;
ifstream fin;
ofstream fout("img.bpf",ios_base::out | ios_base::binary);
uint8_t buf[1000][1000];
struct colRGB{
    uint8_t r;
    uint8_t g;
    uint8_t b;
};

struct colXYZ{
    double x;
    double y;
    double z;
};
colRGB palette[16];
uint8_t ccChars[32] = {
       0b000000,
       0b100000,
       0b010000,
       0b110000,
       0b001000,
       0b101000,
       0b011000,
       0b111000,
       0b000100,
       0b100100,
       0b010100,
       0b110100,
       0b001100,
       0b101100,
       0b011100,
       0b111100,
       0b000010,
       0b100010,
       0b010010,
       0b110010,
       0b001010,
       0b101010,
       0b011010,
       0b111010,
       0b000110,
       0b100110,
       0b010110,
       0b110110,
       0b001110,
       0b101110,
       0b011110,
       0b111110
       };// '⠁','⠈','⠉','⠂','⠃','⠊','⠋','⠐','⠑','⠘','⠙','⠒','⠓','⠚','⠛','⠄','⠅','/'
uint8_t ccOffset = 0x80;
uint8_t pal=0;
int32_t Iwidth, Iheight;
uint32_t readUint32() {
    char buf[5];
    fin.read(buf, 4);
    return *((uint32_t*) buf);
}
int32_t readInt32() {
    return (int32_t) readUint32();
}
uint16_t readUint16() {
    char buf[3];
    fin.read(buf, 2);
    return *((uint16_t*) buf);
}
int16_t readInt16() {
    return (int16_t) readUint16();
}
uint8_t readUint8() {
    char buf[2];
    fin.read(buf, 1);
    return *buf;
}
bool isBMP() {
    char buf[3] ="";
    fin.read(buf, 2);
    return buf[0] == 'B' && buf[1] == 'M';
}
bool revCC(uint8_t ch) {
    for(uint8_t i =0;i<32;i++)
    {
        if(ccChars[i] == ch) {
            return false;
        }
    }
    ch = (~ch) & 0b111111;
    for(uint8_t i =0;i<32;i++)
    {
        if(ccChars[i] == ch) {
            return true;
        }
    }
    //cout<<"gavno"<<endl;
    return false;
}
uint8_t getCC(uint8_t ch) {
for(uint8_t i =0;i<32;i++)
    {
        if(ccChars[i] == ch) {
            return i;
        }
    }
    return 0x0;
}
uint8_t getSymbol(short x, short y) {
    uint8_t ch = 0,palA=0,palB=0;
    uint8_t freqPal[16];
    for(short g =0;g<16;g++) {
        freqPal[g] =0;
    }
    for(short j =0;j<3;j++) {
        for(short i = 0;i<2;i++)
        {
                freqPal[buf[y+j][x+i]]++;
        }
    }
    uint8_t ma=0,pos =0;
    for(short g =0;g<16;g++) {
        if(freqPal[g]> ma) {
            ma = freqPal[g];
            pos = g;
        }

    }
    palA = pos;
    freqPal[pos] = 0;
    ma=0;pos =0;
    for(short g =0;g<16;g++) {
        if(freqPal[g]> ma) {
            ma = freqPal[g];
            pos = g;
        }

    }
    palB = pos;
    for(short j =0;j<3;j++) {
        for(short i = 0;i<2;i++)
        {

            if(buf[y+j][x+i] == palA) {continue;}
            else {
                ch |= (1<<((2-j)*2+(1-i)));
                continue;
            }

        }
    }
    //cout<<dec<<(uint16_t)ch<<endl;
    if(revCC(ch)) {
        pal = (palB<<4) | palA;
        return getCC((~ch) &0b111111)+ccOffset;
    }
    else {
        pal = (palA<<4) | palB;
        return getCC(ch)+ccOffset;
    }
}
int main()
{
    ios_base::sync_with_stdio(false);
    //system("chcp 65001");
    //cout<< "Enter input filename: ";
    char filename[50] ="image.bmp";
    //cin.getline(filename,50);
    //cout<<endl;

    fin.open(filename,ios_base::in | ios_base::binary);
    if(!fin) {
        cout<<"File not found!\n";
        system("pause");
        return 0;
    }
    if(!isBMP()) {
        cout<<"File not support!\n";
        system("pause");
        return 0;
    }
    fin.seekg(10,ios_base::beg);
    readUint32();//skip pix pos


    //Exploring bitmap header
    uint32_t bitmapHeaderLen = readUint32();


    uint8_t BMPver = (bitmapHeaderLen>= 40 ? (bitmapHeaderLen>= 108 ? (bitmapHeaderLen == 124 ? 5 : 4) : 3) : 1 ); // 1 == CORE
    deb("!Bmp ver: ",(uint16_t)BMPver)
    if(BMPver == 1) {// if  BMP Core
        cout<<"File not support this BMP ver\n";
        system("pause");
        return 0;
    }
    Iwidth = readInt32();
    Iheight = readInt32();
    //cout<<"Image size: "<<Iwidth<<"x"<<Iheight<<endl;
    Iwidth/=2;Iheight/=3;
    fout.write((char *)&Iwidth, 2);
    fout.write((char *)&Iheight, 2);
    Iwidth*=2;Iheight*=3;
    fin.seekg(2,ios_base::cur); //skip bcPlanes

    uint16_t bitPerPixel = readUint16();
    deb("bitPerPixel: ", bitPerPixel)
    if(bitPerPixel == 0 ) {
        cout<<"File not support(bitPerPixel)!\n";
        system("pause");
        return 0;
    }
    uint32_t compression = readUint32();
    deb("Compression: ", compression)
    if(compression != 0 ){
        cout<<"File not support!(compression != 0)\n";
        system("pause");
        return 0;
    }
    printUint32("biSizeImage: ")
    printUint32("biXPelsPerMeter: ")
    printUint32("biYPelsPerMeter: ")
    uint32_t colAmount = readUint32();
    fout.write((char *)&colAmount, 2);
    if(colAmount != 16 ){
        cout<<"File not support!(colAmount != 16)\n";
        system("pause");
        return 0;
    }
    deb("Colors used: ",colAmount)
    printUint32("biClrImportant: ")

    //exploring color table
    switch(BMPver) { // go to color table
        case 1: fin.seekg(0x1A); break;
        case 3: fin.seekg(compression == 3? 0x42 :(compression == 6 ? 0x46 : 0x36)); break;
        case 4: fin.seekg(0x7A); break;
        case 5: fin.seekg(0x8A); break;
    }
    Fpos

    for(uint8_t i=0; i< colAmount;i++) {
        palette[i].b= readUint8();
        palette[i].g= readUint8();
        palette[i].r= readUint8();
        //cout<<"Color #"<<(uint16_t)i<<": R:"<<(uint16_t)palette[i].r<<" G:"<<(uint16_t)palette[i].g<<" B:"<<(uint16_t)palette[i].b<<"   Res: "<<(uint16_t)readUint8()<<endl;
        //cout<<hex<<"----- #"<<((uint32_t)(palette[i].r<<16)|(palette[i].g<<8)|(palette[i].b))<<dec<<endl;
        readUint8();
        fout.write((char *)&(palette[i].b), 1);
        fout.write((char *)&(palette[i].g), 1);
        fout.write((char *)&(palette[i].r), 1);
    }
    Fpos
    //system("pause");
    cout<<hex;
    for(short i=Iheight-1;i>=0;i--) {
        for(short j=0;j<Iwidth;j+=2) {
            if(fin.eof()) break;
            buf[i][j] = readUint8();
            buf[i][(j+1)] =  (buf[i][j] & 0xF);
            buf[i][j] = buf[i][j]>>4;
        }
        readUint8();
    }
    if(fin.eof()) cout<<"EOF! !!!!!!!!!!!!!!";
    //cout<<"Bitmap: "<<endl;-
    Fpos
    //uint8_t cnt=0, cnt_max=20;
//    for(short i=0;i<Iheight;i+=3) {
//        for(short j=0;j<Iwidth;j+=2) {
//            //cout<<(uint64_t)&buf[i][j]<<endl;
//            cout<<dec<<"XY:"<<j<<" "<<i<<" ";
//            uint8_t CCsymbol = getSymbol(&buf[i][j]);
//            cout<<hex<<(uint16_t)CCsymbol<<"-"<<(uint16_t)pal<<endl;
//            fout.write((char*)&pal,1);
//            fout.write((char*)&CCsymbol,1);
//            //if(++cnt > cnt_max) break;
//        }
//        cout<<endl;
//        //if(cnt > cnt_max) break;
//    }
    //cout<<hex;
    for(short i=0;i<Iheight;i+=3) {
        for(short j=0;j<Iwidth;j+=2) {
            //cout<<(uint64_t)&buf[i][j]<<endl;
            //cout<<dec<<"XY:"<<j<<" "<<i<<" ";
            uint8_t CCsymbol = getSymbol(j,i);
            //cout<<(uint16_t)buf[i][j]<<" ";
            //fout.write((char*)&buf[i][j],1);
            fout.write((char*)&pal,1);
            fout.write((char*)&CCsymbol,1);
            //if(++cnt > cnt_max) break;
        }
        //cout<<endl;
        //if(cnt > cnt_max) break;
    }
    //system("view.exe");
    return 0;
}
//
/*
RGB2XYZ(Pt3 x) {
            Pt3 srgb = x / 255.0;
            return new Pt3(  0.4124 * srgb.x    + 0.3576 * srgb.y  + 0.1805 * srgb.z,
                                0.2126 * srgb.x    + 0.7152 * srgb.y  + 0.0722 * srgb.z,
                                0.0193 * srgb.x    + 0.1192 * srgb.y  + 0.9505 * srgb.z);
        }
*/
