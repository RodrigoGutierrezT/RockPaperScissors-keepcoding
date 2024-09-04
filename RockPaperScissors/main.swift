//
//  main.swift
//  RockPaperScissors
//
//  Created by Rodrigo on 03-09-24.
//

import Foundation

/*
 ____  _          _               ____                  _
|  _ \(_) ___  __| |_ __ __ _    |  _ \ __ _ _ __   ___| |
| |_) | |/ _ \/ _` | '__/ _` |   | |_) / _` | '_ \ / _ \ |
|  __/| |  __/ (_| | | | (_| |_  |  __/ (_| | |_) |  __/ |_
|_|   |_|\___|\__,_|_|  \__,_( ) |_|   \__,_| .__/ \___|_( )
                             |/             |_|          |/
 _____ _  _
|_   _(_)(_) ___ _ __ __ _
  | | | || |/ _ \ '__/ _` |
  | | | || |  __/ | | (_| |
  |_| |_|/ |\___|_|  \__,_|
       |__/

 */
/// Vamos a estudiar cositas básicas del lenguaje Swift creando el juego de piedra papel y tijera.

/// 1. Repasa las reglas de juego (si hace falta :-))
/// 2. Vamos a crear una app de linea de comandos macOS (vamos a jugar directamente en la consola)
/// 3. Implementa un enum GameChoice con los casos posibles
/// 4. Crea las funciones`gameLoop`, `readUserChoice`, `isExit`,
///  `generateComputerChoice`, `evaluateMove` y
///  `printResult` vacías, si acaso con un valor de retorno cualquiera para
///  que el compilador se calle.
/// 5.¿Cómo arranca?
/// 6. La función principal del juego va a ser `gameLoop`
/// 7. Repasa las funciones y su declaración.
/// - ¿Qué información necesitas para trabajar dentro de cada función?
/// - ¿Qué debería devolver cada función para ser útil?,¿algo, nada?
/// - Ten en cuenta que una de las ideas por detrás del tipado de Swift es que te aporte más información a ti, el programador.
/// 8. Crea la función `gameLoop` en la que tendrás que ir llamando a las demás funciones.
/// 8.1 Ver bucles en playground para planificar el 8.
/// 9. Crea la función `readUserChoice`
/// 9.1. Implementación ingenua de `readUserChoice`.
/// 9.2 Vete a `readLine  y Opcionales`, leélo y piensa cómo podría usarse en readUserChoice.
/// 9.3. Comienza a implementar la función `readUserChoice`. Si necesitas tratar un valor opcional, ¡llámame!
/// Después de la explicación para tratar valores opcionales, deberías ser capaz de continuar la implementación de `readUserChoice`.
/// Impleméntala, puede que necesites convertir tipos para hacerlo (si lo necesitas, `conversión de tipos`)
/// 10. Implementar `isExit`.
/// 11. Implementar `generateComputerChoice`. Vamos a necesitar números aleatorios`
/// 12. Implementa `evaluateMove`
/// 13. Implementa `printResult`
///
///
/// FIN DEL EJERCICIO
///

enum GameError: Error {
    case invalidInput
    case invalidChoice
}

enum GameChoice: String, CaseIterable {
    case rock = "1"
    case paper = "2"
    case scissors = "3"
    case exit = "4"
}

func readUserChoice() throws -> GameChoice {
    
    guard let userInput = readLine() else {
        throw GameError.invalidInput
    }
    guard let choice = GameChoice(rawValue: userInput.trimmingCharacters(in: .whitespacesAndNewlines)) else {
        throw GameError.invalidChoice
    }
    
    return choice
}

func generateComputerChoice() -> GameChoice {
    
    var computerChoice = GameChoice.allCases.randomElement()
    while computerChoice == GameChoice.exit {
        computerChoice = GameChoice.allCases.randomElement()
    }
    
    return computerChoice!
}

func evaluateMove(userChoice: GameChoice, computerChoice: GameChoice) -> String {
    if userChoice == computerChoice {
        return "Draw"
    }
    
    if userChoice == .rock && computerChoice == .scissors {
        return "User wins"
    }
    
    if userChoice == .paper && computerChoice == .rock {
        return "User wins"
    }
    
    if userChoice == .scissors && computerChoice == .paper {
        return "User wins"
    }
    
    return "Computer wins"
}

func choiceToEmoji(choice: GameChoice) -> String {
    switch choice {
    case .rock:
        return "👊"
    case .paper:
        return "🤚"
    case .scissors:
        return "✂️"
    case .exit:
        return ""
    }
}

func printMenu() {
    print("---- Rock, Paper, Scissors ----")
    print("Pick your Move (1, 2, 3 or 4):")
    print("1 - Rock")
    print("2 - Paper")
    print("3 - Scissors")
    print("4 - Exit")
    print()
    print(">", terminator: "")
}

func printResult(userChoice: GameChoice, computerChice: GameChoice, result: String) {
    print()
    print("Game on!")
    print("User choice:")
    print(choiceToEmoji(choice: userChoice))
    print("-----vs-----")
    print("Computer choice:")
    print(choiceToEmoji(choice: computerChice))
    print("---------")
    print()
    print("Result: \(result)!!")
}

func PlayAgainMenu() throws -> Bool {
    print()
    print("Play Again??? (Y,N)")
    print()
    print(">", terminator: "")
    
    guard let userInput = readLine() else {
        throw GameError.invalidInput
    }
    
    let cleanInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    
    if cleanInput != "y" && cleanInput != "n"{
        throw GameError.invalidChoice
    }

    return cleanInput == "y"
}

func gameLoop() {
    
    printMenu()

    do {
        let userChoice = try readUserChoice()
        
        // MARK: logica de aqui para abajo quería dejarla fuera del bloque "do" pero no tenia acceso a userChoice
        if userChoice == .exit {
            print()
            print("Thanks for playing, comeback again!")
            return
        }
        
        let computerChoice = generateComputerChoice()
        let result = evaluateMove(userChoice: userChoice, computerChoice: computerChoice)
        printResult(userChoice: userChoice, computerChice: computerChoice, result: result)
        
        //
        
    } catch GameError.invalidInput {
        print("Invalid input!")
        print("Valid values are: 1, 2, 3 or 4")
        print()
        gameLoop()
    } catch GameError.invalidChoice {
        print("Invalid choice!")
        print("Valid values are: 1, 2, 3 or 4")
        print()
        gameLoop()
    } catch {
        print("Unknow error 🥲")
        print("Please run the game again")
    }
    
    //MARK: play again section
    do {
        let playAgain = try PlayAgainMenu()
        
        if playAgain {
            gameLoop()
        } else {
            print()
            print("Thanks for playing!")
            return
        }
    } catch {
        //TODO: handle invalid input and choice to prompt again
        print("Error getting the user choice")
        print("Shuting down...")
        return
    }
}

gameLoop()
