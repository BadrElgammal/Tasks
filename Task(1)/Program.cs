using System;
namespace Task_1_
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello!");
            Console.Write("Input the first number: ");
            int num1 = int.Parse(Console.ReadLine());
            Console.WriteLine("Input the second number: ");
            int num2 = int.Parse(Console.ReadLine());
            Console.WriteLine("What do you want to do with those numbers?\n[A]dd\r\n[S]ubtract\r\n[M]ultiply");
            char option = char.parse(Console.ReadLine());
            switch (option)
            {
                case 'a':
                case 'A':
                    Console.WriteLine($"Resualt = num1 + num 2 = {num1 + num2}");
                    break;
                case 's':
                case 'S':
                    Console.WriteLine($"Resualt = num1 - num 2 = {num1 - num2}");
                    break;
                case 'm':
                case 'M':
                    Console.WriteLine($"Resualt = num1 * num 2 = {num1 * num2}");
                    break;
                default:
                    Console.WriteLine("Invalid Option");
                    break;
            }
            Console.WriteLine("Press any key to close");
            Console.ReadKey();
        }
    }
}
