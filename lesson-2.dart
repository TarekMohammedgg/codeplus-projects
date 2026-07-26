void execute(Function action) {
  action();
}

int square(int number) => number * number;

String greet(String name) => "Hello $name";

bool is_even(int number) => number % 2 == 0;

void calculate(
  int firstNumber,
  int secondNumber,
  int Function(int, int) operation,
) {
  int result = operation(firstNumber, secondNumber);
  print("Result: $result");
}

void anonymous_function_task() {
  print("Task 1 - Anonymous Function");
  print("--------------------------");

  execute(() {
    print("Hello Dart!");
  });

}

void arrow_function_task() {
  print("Task 2 - Arrow Functions");
  print("------------------------");

  print("Square of 5 = ${square(5)}");
  print(greet("Tarek"));
  print("Is 8 even? ${is_even(8)}");

}

void higher_order_function_task() {
  print("Task 3 - Higher Order Function");
  print("------------------------------");

  print("Addition");
  calculate(10, 5, (a, b) => a + b);

  print("Subtraction");
  calculate(10, 5, (a, b) => a - b);

  print("Multiplication");
  calculate(10, 5, (a, b) => a * b);

}

void main() {
  anonymous_function_task();

  arrow_function_task();

  higher_order_function_task();
}