#define NEWPIECEARRAYSIZE      4
#define MOVEARRAYSIZE 15

//MOVE TYPES
#define SLIDE 0
#define ROTATE 1

//move directions
#define LEFT 0
#define RIGHT 1
#define CNTRCLKWISE 0
#define CLKWISE 1

//orientations
#define HORIZ 0
#define VERT 1
#define BL 0 //corner in bottom left
#define BR 1 //corner in bottom right
#define TR 2 //corner in top right
#define TL 3  //corner in top left

/*orientations

 0    1     2     3
*      *    **   **
**    **     *   *

 0    1
***   *
      *
      *

 */
struct newPiece
{
    int id;
    int orientation;
    int type;
    int column;
};

struct move
{
  int pieceID;
  int moveType; //slide or rotate
  int direction; //left/right, cntrclkwise/clkwise
};
