/**
 * fifteen.c
 *
 * Implements Game of Fifteen (generalized to d x d).
 *
 * Usage: fifteen d
 *
 * whereby the board's dimensions are to be d x d,
 * where d must be in [DIM_MIN,DIM_MAX]
 *
 * Note that usleep is obsolete, but it offers more granularity than
 * sleep and is simpler to use than nanosleep; `man usleep` for more.
 */

#define _XOPEN_SOURCE 500

#include <cs50.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// constants
#define DIM_MIN 3
#define DIM_MAX 9

// board
int board[DIM_MAX][DIM_MAX];

// dimensions
int d;

// search integers
int x;
int y;

// prototypes
void clear(void);
void greet(void);
void init(void);
void draw(void);
bool move(int tile);
bool won(void);
void search(int tile);

int main(int argc, string argv[])
{
    // ensure proper usage
    if (argc != 2)
    {
        printf("Usage: fifteen d\n");
        return 1;
    }

    // ensure valid dimensions
    d = atoi(argv[1]);
    if (d < DIM_MIN || d > DIM_MAX)
    {
        printf("Board must be between %i x %i and %i x %i, inclusive.\n",
            DIM_MIN, DIM_MIN, DIM_MAX, DIM_MAX);
        return 2;
    }

    // open log
    FILE *file = fopen("log.txt", "w");
    if (file == NULL)
    {
        return 3;
    }

    // greet user with instructions
    greet();

    // initialize the board
    init();

    // accept moves until game is won
    while (true)
    {
        // clear the screen
        clear();

        // draw the current state of the board
        draw();

        // log the current state of the board (for testing)
        for (int i = 0; i < d; i++)
        {
            for (int j = 0; j < d; j++)
            {
                fprintf(file, "%i", board[i][j]);
                if (j < d - 1)
                {
                    fprintf(file, "|");
                }
            }
            fprintf(file, "\n");
        }
        fflush(file);

        // check for win
        if (won())
        {
            printf("ftw!\n");
            break;
        }

        // prompt for move
        printf("Tile to move: ");
        int tile = get_int();

        // quit if user inputs 0 (for testing)
        if (tile == 0)
        {
            break;
        }

        // log move (for testing)
        fprintf(file, "%i\n", tile);
        fflush(file);

        // move if possible, else report illegality
        if (!move(tile))
        {
            printf("\nIllegal move.\n");
            usleep(500000);
        }

        // sleep thread for animation's sake
        usleep(500000);
    }

    // close log
    fclose(file);

    // success
    return 0;
}

/**
 * Clears screen using ANSI escape sequences.
 */
void clear(void)
{
    printf("\033[2J");
    printf("\033[%d;%dH", 0, 0);
}

/**
 * Greets player.
 */
void greet(void)
{
    clear();
    printf("WELCOME TO GAME OF FIFTEEN\n");
    usleep(2000000);
}

/**
 * Initializes the game's board with tiles numbered 1 through d*d - 1
 * (i.e., fills 2D array with values but does not actually print them).
 */
void init(void)
{
    // get max number
    int number = d * d;
    // go through arrays
    for(int i = 0; i < d; i++)
    {
        for(int j = 0; j < d; j++)
        {
            // set last character to empty space
            if(i == d - 1 && j == d -1)
            {
                board[i][j] = '_';
            }
            // set coordinates to a number starting at max number - 1 and counting down
            else
            {
            board[i][j] = number - 1;
            number = number - 1;
            }
        }
    }
    // if dimensions are even swap 2nd last and 3rd last character
    if(d % 2 == 0)
    {
        int temp = board[d - 1][d - 2];
        board[d - 1][d - 2] = board[d - 1][d - 3];
        board[d - 1][d - 3] = temp;
    }
}

/**
 * Prints the board in its current state.
 */
void draw(void)
{
    // go through arrays
    for(int i = 0; i < d; i++)
    {
        for(int j = 0; j < d; j++)
        {
            // check character or empty space, print character with right amount of space
            if(board[i][j] < 10)
            {
            // print number
                printf(" %i  ", board[i][j]);
            }
            // print underscore (empty space)
            else if(board[i][j] == 95)
            {
                printf(" %c  ", board[i][j]);
            }
            // print number
            else
            {
            printf("%i  ", board[i][j]);
            }
        }
        // next line
        printf("\n");
    }
}

/**
 * If tile borders empty space, moves tile and returns true, else
 * returns false.
 */
bool move(int tile)
{
    // get coordinates of tile
    search(tile);
    // check character below
    if(board[y + 1][x] == '_')
    {
        // swap character and empty space
        int temp = board[y][x];
        board[y][x] = board[y + 1][x];
        board[y + 1][x] = temp;
        return true;
    }
    // check character above
    if(board[y - 1][x] == '_')
    {
        // swap character and empty space
        int temp = board[y][x];
        board[y][x] = board[y - 1][x];
        board[y - 1][x] = temp;
        return true;
    }
    // check character to the right
    if(board[y][x + 1] == '_')
    {
        // swap character and empty space
        int temp = board[y][x];
        board[y][x] = board[y][x + 1];
        board[y][x + 1] = temp;
        return true;
    }
    // check character to the left
    if(board[y][x - 1] == '_')
    {
        // swap character and empty space
        int temp = board[y][x];
        board[y][x] = board[y][x - 1];
        board[y][x - 1] = temp;
        return true;
    }
    // return false if no adjacent characters is empty space
    return false;
}

/**
 * Returns true if game is won (i.e., board is in winning configuration),
 * else false.
 */
bool won(void)
{
    // if wincondition is met return true
    int k = 1;
    // go through arrays
    for(int i = 0; i < d; i++)
    {
        for(int j = 0; j < d; j++)
        {
            // check if any coordinate does not match wincondition
            if(board[i][j] != k && board[i][j] != '_')
            {
                return false;
            }
            k = k + 1;
        }
    }
    return true;
}
// search cooridnates of tile
void search(int tile)
{
    // go through arrays
    for(int i = 0; i < d; i++)
    {
        for(int j = 0; j < d; j++)
        {
            if(board[i][j] == tile)
            {
                // remember x and y coordinates
                y = i;
                x = j;
                return;
            }
        }
    }
}
