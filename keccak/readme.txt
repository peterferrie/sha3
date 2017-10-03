** Theta

Renders the internal state into a 5-by-5 array of 64-bit elements.
Computes the parity of each column and combines them with an exclusive-or (XOR) operator.
Then it XORs the resulting parity to each state bit as follows.

** Rho

the rho module rotates each 64-bit element by a triangular number.

0,1,3,6,10,15...

** Pi

The pi module permutes the 64-bit elements. Permutation follows the fixed pattern assignment shown below:

    S[j][2*i + 3*j] = S[i][j]
    
** Chi

The chi module adds a non-linear aspect to the permutation round. It combines the row elements using only three bitwise operators: AND, NOT, and XOR.
Then it writes the result back to the state array as follows:

  S[i][j][k] ^= ~S[i][j+1][k] & S[i][j+2][k]
  
** Iota

The iota modules breaks up any symmetry caused by the other modules.This is done by XORing one of the array elements to a round constant. The module has 24 round constants to choose from. These constants are defined internally by Keccak. Without iota, the round mapping would be symmtric. Without iota, all rounds would be the same.

susceptible to slide attacks
defective cycle structure

/* Compute the rotation constant r = (t+1)(t+2)/2 */
unsigned int r = ((t+1)*(t+2)/2)%64;
                
/* Compute ((0 1)(2 3)) * (x y) */
unsigned int Y = (2*x+3*y)%5; x = y; y = Y;  
    
    
* - River for River Keyak, using a single Keccak-p[800,12]
* - KetjeMn for Ketje Minor, using Keccak-p[800]    