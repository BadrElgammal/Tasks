namespace Task_2_
{
    internal class Program
    {
        static void Main(string[] args)
        {
            BankAccount account1 = new BankAccount();
            BankAccount account2 = new BankAccount("8943852957","Badr Elgammal","37493028475839","012836485930","Menofia",15000);

            account1.ShowAccountDetails();
            Console.WriteLine("---------------------------------");
            account2.ShowAccountDetails();
        }
    }
}
