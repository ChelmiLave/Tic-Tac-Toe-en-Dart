import 'dart:io';

class TicTacToe {
  // Estado del juego
  bool winner = false;
  bool isXTurn = true;
  int movementCount = 0;

  // El tablero inicializado con números del 1 al 9
  List<String> board = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  // Combinaciones ganadoras basadas en los índices de la lista (0-8)
  final List<String> combinations = [
    '012', '345', '678', // Filas horizontales
    '036', '147', '258', // Columnas verticales
    '048', '246'         // Diagonales
  ];

  // Método principal para iniciar la partida
  void startGame() {
    clearScreen();
    generateBoard();
    playTurn();
  }

  // Maneja el ciclo principal de turnos
  void playTurn() {
    // El juego continúa mientras no haya ganador y haya movimientos disponibles
    while (!winner && movementCount < 9) {
      String currentPlayer = isXTurn ? 'X' : 'O';
      print('\nElige un número para el jugador $currentPlayer:');

      // Leemos la entrada del usuario
      String? input = stdin.readLineSync();

      // VALIDACIÓN 1: Revisamos que el usuario no haya escrito letras o dejado en blanco
      if (input == null || int.tryParse(input) == null) {
        print(' Por favor, ingresa un número válido.');
        continue; // Reinicia el ciclo para pedir el número de nuevo
      }

      // Convertimos a entero y restamos 1 porque las listas en Dart empiezan en 0
      int number = int.parse(input) - 1;

      // VALIDACIÓN 2: Revisamos que el número esté en el rango y la casilla no esté ocupada
      if (number < 0 || number > 8 || board[number] == 'X' || board[number] == 'O') {
        print(' Movimiento inválido. La casilla no existe o ya está ocupada.');
        continue; // Reinicia el ciclo
      }

      // Asignamos el movimiento al jugador actual ('X' o 'O')
      board[number] = currentPlayer;
      movementCount++;

      // Limpiamos pantalla y redibujamos el tablero actualizado
      clearScreen();
      generateBoard();

      // Verificamos si este último movimiento hizo ganar al jugador
      checkWinner(currentPlayer);

      // Verificamos si se acabaron los movimientos y nadie ganó
      if (!winner && movementCount == 9) {
        print('\n¡ES UN EMPATE!');
        return; // Termina la ejecución del método
      }

      // Cambiamos el turno para la siguiente iteración
      isXTurn = !isXTurn;
    }
  }

  // Comprueba si el jugador actual cumple con alguna combinación ganadora
  void checkWinner(String player) {
    for (final combination in combinations) {
      // .every() revisa si TODOS los elementos de la combinación pertenecen al jugador
      bool isMatch = combination.split('').every((indexChar) {
        int index = int.parse(indexChar);
        return board[index] == player;
      });

      // Si encuentra coincidencia, declara al ganador y detiene el ciclo
      if (isMatch) {
        print('\n🎉 ¡EL JUGADOR $player HA GANADO! 🎉');
        winner = true;
        break;
      }
    }
  }

  // Limpia la consola dependiendo del sistema operativo
  void clearScreen() {
    if (Platform.isWindows) {
      print(Process.runSync("cls", [], runInShell: true).stdout);
    } else {
      print(Process.runSync("clear", [], runInShell: true).stdout);
    }
  }

  // Dibuja la estructura visual del tablero en la consola
  void generateBoard() {
    print('     |     |  ');
    print('  ${board[0]}  |  ${board[1]}  |  ${board[2]} ');
    print('_____|_____|____');
    print('     |     |  ');
    print('  ${board[3]}  |  ${board[4]}  |  ${board[5]} ');
    print('_____|_____|____');
    print('     |     |   ');
    print('  ${board[6]}  |  ${board[7]}  |  ${board[8]} ');
    print('     |     |   ');
  }
}

// Punto de entrada de la aplicación
void main() {
  // Instanciamos el juego y lo arrancamos
  TicTacToe game = TicTacToe();
  game.startGame();
}