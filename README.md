PROJECT: RUBY FINAL PROJECT: Chess
https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project#assignment

Assignment:

1. Build a command line Chess game where two players can play against each other.

2. The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.

3. Make it so you can save the board at any time (remember how to serialize?)

4. Write tests for the important parts. You don’t need to TDD it (unless you want to), but be sure to use RSpec tests for anything that you find yourself typing into the command line repeatedly.

5. Do your best to keep your classes modular and clean and your methods doing only one thing each. This is the largest program that you’ve written, so you’ll definitely start to see the benefits of good organization (and testing) when you start running into bugs.

6. Have fun! Check out the unicode characters for a little spice for your gameboard.

7. (Optional extension) Build a very simple AI computer player (perhaps who does a random legal move)


Last updated: 22/05/2019

Tasks:
1. multiplayer chess game: done
2. idiot proofing: done
3. save game: done
4. rsepc testing (optional): not done
5. organiszed code: done
6. unicode + had fun: done
7. ai (optional): not done

Things to still implement:

1. generate chess board + actual pieces: done
2. process inputs (commands/ moves): done
3. idiot proofing (user input): done
4. move pieces legally (user input): done
5. execute commands (user input): done
6. check (moving into check + being put in check): done
7. checkmate (determine winner + end game): done
8. castling (long + short side): done
9. promotion (changes pawn to additional Queen): done
10. en passant (weird pawn move): not done
11. saving (YAML): done
12. loading  (YAML): done
13. stalemate (maybe): not done

Extras to possibly implement:

14. coloured console text (black pieces/ invalid moves/ check etc.): not done

15. match replays (turn for turn playback with sleep): not done

Known bugs:
1. occasional false checkmate
2. able to castle into check
3. pawns able to move diagonally even if no piece is avalable for capture


To run:
cd into 'chess'
then run
> ruby chess.rb
