/**
 * @file main.h
 * @brief Define enumeraciones y constantes usadas globalmente.
 */

#ifndef MAIN_H
#define MAIN_H

/**
 * @brief Enumeracion booleana para proveer tipos semejantes a los de C++.
 */
typedef enum _bool {
    false,
    true
} bool;

#define MAX_BUFF_SIZE 256
#define MAX_VARIABLE_NAME_SIZE 15
#define NUMBER_OF_INSTRUCTION_TYPES 6

#define NUMBER_OF_OPERATORS 12
#define OPERATOR_LIST {"+", "-", "*", "/", "&", "|", "^", "<", "<=", "==", ">", ">="}

#define INCORRECT_INSTRUCTION "ERROR: One of the instructions is not valid."

#endif // MAIN_H
