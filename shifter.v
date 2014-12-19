module shifter (In, Cnt, Op, Out);
  input [15:0] In;
  input [3:0] Cnt;
  input [1:0] Op;
  output [15:0] Out;

// Shifter operations:
// 00 ROL
// 01 SLL
// 10 ROR
// 11 SRL

  assign Out =
  
    // rotate left
    Op == 0 ? (
      Cnt == 0 ? In :
      Cnt == 1 ? {In[14:0], In[15]} :
      Cnt == 2 ? {In[13:0], In[15:14]} :
      Cnt == 3 ? {In[12:0], In[15:13]} :
      Cnt == 4 ? {In[11:0], In[15:12]} :
      Cnt == 5 ? {In[10:0], In[15:11]} :
      Cnt == 6 ? {In[9:0], In[15:10]} :
      Cnt == 7 ? {In[8:0], In[15:9]} :
      Cnt == 8 ? {In[7:0], In[15:8]} :
      Cnt == 9 ? {In[6:0], In[15:7]} :
      Cnt == 10 ? {In[5:0], In[15:6]} :
      Cnt == 11 ? {In[4:0], In[15:5]} :
      Cnt == 12 ? {In[3:0], In[15:4]} :
      Cnt == 13 ? {In[2:0], In[15:3]} :
      Cnt == 14 ? {In[1:0], In[15:2]} :
      {In[0], In[15:1]}
    
    // shift left (logical)
    ) : Op == 1 ? (
      Cnt == 0 ? In :
      Cnt == 1 ? In << 1 :
      Cnt == 2 ? In << 2 :
      Cnt == 3 ? In << 3 :
      Cnt == 4 ? In << 4 :
      Cnt == 5 ? In << 5 :
      Cnt == 6 ? In << 6 :
      Cnt == 7 ? In << 7 :
      Cnt == 8 ? In << 8 :
      Cnt == 9 ? In << 9 :
      Cnt == 10 ? In << 10 :
      Cnt == 11 ? In << 11 :
      Cnt == 12 ? In << 12 :
      Cnt == 13 ? In << 13 :
      Cnt == 14 ? In << 14 :
      In << 15
    
    // rotate right
    ) : Op == 2 ? (
      Cnt == 0 ? In :
      Cnt == 1 ? {In[0], In[15:1]} :
      Cnt == 2 ? {In[1:0], In[15:2]} :
      Cnt == 3 ? {In[2:0], In[15:3]} :
      Cnt == 4 ? {In[3:0], In[15:4]} :
      Cnt == 5 ? {In[4:0], In[15:5]} :
      Cnt == 6 ? {In[5:0], In[15:6]} :
      Cnt == 7 ? {In[6:0], In[15:7]} :
      Cnt == 8 ? {In[7:0], In[15:8]} :
      Cnt == 9 ? {In[8:0], In[15:9]} :
      Cnt == 10 ? {In[9:0], In[15:10]} :
      Cnt == 11 ? {In[10:0], In[15:11]} :
      Cnt == 12 ? {In[11:0], In[15:12]} :
      Cnt == 13 ? {In[12:0], In[15:13]} :
      Cnt == 14 ? {In[13:0], In[15:14]} :
      {In[14:0], In[15]}
    
    // shift right (logical)
    ) : (
      Cnt == 0 ? In :
      Cnt == 1 ? In >> 1 :
      Cnt == 2 ? In >> 2 :
      Cnt == 3 ? In >> 3 :
      Cnt == 4 ? In >> 4 :
      Cnt == 5 ? In >> 5 :
      Cnt == 6 ? In >> 6 :
      Cnt == 7 ? In >> 7 :
      Cnt == 8 ? In >> 8 :
      Cnt == 9 ? In >> 9 :
      Cnt == 10 ? In >> 10 :
      Cnt == 11 ? In >> 11 :
      Cnt == 12 ? In >> 12 :
      Cnt == 13 ? In >> 13 :
      Cnt == 14 ? In >> 14 :
      In >> 15
    
    );
endmodule
