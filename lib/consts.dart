// Estas constantes son utilizadas en todo el proyecto para evitar errores de tipeo y mantener un código más limpio y ordenado

// ignore: non_constant_identifier_names
final RegExp EMAIL_VALIDATION_REGEX =
    RegExp(r"^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,4}$");

// ignore: non_constant_identifier_names
final RegExp PASSWORD_VALIDATION_REGEX =
    RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

// ignore: non_constant_identifier_names
final RegExp NAME_VALIDATION_REGEX = 
    RegExp(r"\b([A-ZÀ-ÿ][-,a-z. ']+[]*)+");

// ignore: non_constant_identifier_names
final String PLACEHOLDER_PFP = 
    "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEEELoTuERO4SsWV.jpg";