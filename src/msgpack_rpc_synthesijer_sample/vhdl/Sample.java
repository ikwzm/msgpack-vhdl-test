public class Sample {

    public int        ivar;
    public int[]      imem = new int[1024];

    public byte       bvar;
    public byte[]     bmem = new byte[1024];

    public short      svar;
    public short[]    smem = new short[1024];
    
    public long       lvar;
    public long[]     lmem = new long[1024];

    public boolean    tvar;
    public boolean[]  tmem = new boolean[1024];

    public void m0() {
    }
    
    public boolean m1(boolean p) {
        return p & tvar;
    }
    
    public byte  m2(byte b, int i) {
        return (byte)(b + bvar + bmem[i]);
    }
    
    public short m3(short s, int i) {
        return (short)(s + svar + smem[i]);
    }
    
    public long  m4(byte a3, short a2, int a1, long a0) {
        return (long)(a3 + a2 + a1 + a0);
    }
    
}
