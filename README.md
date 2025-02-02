# CS271: Computer Architecture and Assembly Language

CS271 provides a comprehensive introduction to the functional organization and operation of digital computers. This course focuses on understanding the inner workings of computer architecture and assembly language programming. Key concepts include memory addressing, stacks, argument passing, arithmetic operations, decision-making, macros, modularization, and the use of linkers and debuggers.

## Key Course Topics:
- **Assembly Language Programming**: Writing well-structured and modular programs using assembly language, including decision-making, repetition, and procedure structures.
- **Computer Architecture**: Understanding the major components of computer architecture and their interactions.
- **Instruction Set & Execution Cycle**: Exploring the relationships between hardware architecture and its instruction set, and understanding the instruction execution cycle.
- **Memory Representation**: Simulating data storage and access in memory, and examining system stack usage for procedure calls and parameter passing.
- **Parallelism**: Exploring mechanisms for implementing parallelism in both hardware and software.
- **Tools & Techniques**: Utilizing debuggers and understanding the role of editors, assemblers, linkers, and operating systems in enabling programming.

## Course Objectives:
By the end of this course, you should be able to:
- Identify the major components of computer architecture and explain their purposes and interactions.
- Simulate how data is represented internally and accessed in memory.
- Understand the relationships between hardware architecture, instruction sets, and microprogramming.
- Design and simplify circuits that produce specified outputs, such as adders and multiplexers.
- Explain the Instruction Execution Cycle and its implications on program execution.
- Differentiate between high-level, assembly, and machine languages.
- Develop modular assembly programs utilizing decision-making, repetition, and procedure structures.
- Effectively use a debugger to understand register contents and program behavior.
- Simulate the system stack for procedure calls and parameter passing.
- Understand the functions of editors, assemblers, linkers, and operating systems in computer programming.
- Recognize different mechanisms for implementing parallelism in both hardware and software.

## Repository Structure:
The repository is organized around several key projects that focus on different aspects of computer architecture and assembly language programming. 
```
cs271/ 
│── README.md 
│── .git/ 
└── projects/ 
    ├── final_project/ 
    ├── arrays_and_sorting/ 
    ├── int_float_arithmetic/ 
    ├── dog_years_calculator/
```

## Projects

### [Dog Years Calculator](./projects/dog_years_calculator/)
This project demonstrates how Assembly code translates to hardware execution in the IA32 architecture. The program calculates the user’s age in dog years (age x 7), and tracks register and memory changes during execution. The program prompts the user for their age, calculates their age in dog years, and outputs the result. The task involves tracking variable and register changes for each instruction. Extra credit: Modify the code to print a special message for ages under 5.

#### Objectives:
- Understand the relationship between Assembly code and digital circuits.
- Analyze how data moves between memory, registers, and cache.

#### Key Topics:
- Assembly Language Programming: Writing modular Assembly code.
- Memory Representation: Understanding how the program interacts with memory and registers.
- Instruction Set & Execution Cycle: Exploring how instructions are executed and how they alter data.
- Computer Architecture: Understanding memory and register interactions during program execution.

#### Course Objectives:
- Simulate Data Representation: Observe data changes in memory and registers.
- Develop Modular Assembly Programs: Design and structure Assembly code.
- Instruction Execution Cycle: Track instruction execution and its impact on registers.
- Use a Debugger: Monitor register contents and program flow.

---

### [Integer and Floating-Point Arithmetic (MASM)](./projects/int_float_arithmetic/)
This project provides practice with the floating-point unit and stack operations. The program calculates the sum and average of either integer or floating-point numbers, using the stack for data storage and performing operations with registers.

#### Objectives:
- Practice using the floating-point unit and stack.
- Gain experience with counted loops and managing user input dynamically.

#### Description:
The program prompts the user to choose between integer or floating-point arithmetic, takes five numbers based on the choice, stores them in the stack, and calculates the sum and average. The user can choose to perform additional calculations or exit. The program displays results and a farewell message when finished.

#### Key Topics:
- Assembly Language Programming: Writing modular programs using the stack and registers for arithmetic.
- Computer Architecture: Leveraging the floating-point unit and stack for data storage and calculations.
- Memory Representation: Using the stack instead of variables for data storage.
- Tools & Techniques: Implementing counted loops and handling user interaction with MASM functions.

#### Course Objectives Addressed:
- Develop Modular Assembly Programs: Dividing the main procedure into structured sections.
- Simulate Data Representation: Using the stack for storing and processing data.
- Instruction Execution Cycle: Performing arithmetic operations on numbers using registers.
- Use a Debugger: Ensuring correct data flow and program logic during user interaction.


---

### [Arrays and Sorting](./projects/arrays_and_sorting/)

This project focuses on implementing array manipulation and sorting algorithms, providing hands-on experience with sorting and statistical operations on data.

#### Objectives:
- Practice working with arrays and sorting algorithms.
- Develop skills in generating random numbers, sorting data, and calculating statistical values (median and average).

#### Description:
The program prompts the user for a number within a defined range, generates random integers, stores them in an array, and then performs several tasks:

1. Display the unsorted list.
2. Sort the list in descending order.
3. Calculate and display the median and average of the integers.
4. Display the sorted list.

#### Key Topics:
- **Arrays**: Storing and manipulating data in arrays.
- **Sorting Algorithms:** Implementing sorting algorithms (e.g., Selection Sort) to arrange data in descending order.
- **Statistical Calculations:** Calculating median and average of the array elements.
- **Procedural Programming:** Dividing the program into modular procedures to handle specific tasks.

#### Course Objectives Addressed:
- **Develop Modular Assembly Programs:** Organizing the program using procedures for clarity and functionality.
- **Simulate Data Representation:** Using arrays to represent and manipulate data.
- **Instruction Execution Cycle:** Implementing sorting and statistical calculations using efficient algorithms.

---

### [Final Project: OpenMP - CPU Parallel Programming](./projects/final_project/)
This project introduces parallel execution concepts, focusing on both multicore and multithreaded execution. It involves comparing sequential and parallel processing using C++ and OpenMP, and analyzing the performance differences under various conditions.

#### Objectives:
- Understand the fundamentals of parallel programming, including multicore and multithreaded execution.
- Implement parallel processing using OpenMP and compare performance with sequential processing.
- Explore parallel execution limitations and issues.

#### Description:
The project involves working with provided Visual Studio code that needs to be modified for parallel execution using OpenMP. You'll adjust thread numbers, data sizes, and perform memory manipulations to compare execution times between sequential and parallel processing. The goal is to analyze performance under different configurations.

#### Major Topics to Analyze:
1. Parallel Computers: Understanding the architecture and design of parallel systems.
2. Threads vs Process: Exploring the differences between threads and processes in parallel execution.
3. Multithreading vs Multicore: Analyzing the impact of multithreading and multicore systems on performance.
4. Flynn's Taxonomy: Classifying different parallel computing systems based on data and instruction streams.
5. Moore's, Amdahl's Laws, and Gustafson's Observations: Understanding these laws and how they affect parallel performance.
6. Issues in Parallel Programming: Identifying challenges such as synchronization, data races, and load balancing.
7. OpenMP: Using OpenMP for parallel programming, including directives and parallel loops.
8. Parallel Designs: Exploring different parallel architectures and design strategies.
9. Xeon-Phi: Understanding the Xeon-Phi architecture and its implications for parallel execution.
10. Examples/Exercises/Results: Performing experiments to analyze the effectiveness of parallelism.
